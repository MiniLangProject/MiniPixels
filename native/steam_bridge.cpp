// SPDX-License-Identifier: Apache-2.0
// Game-thread-only Steamworks adapter. SDK headers are supplied by the developer.
#include <cstdint>
#include <cstring>
#include <string>
#include <algorithm>
#ifdef _WIN32
#define NOMINMAX
#include <windows.h>
#define EXPORT __declspec(dllexport)
#else
#include <dlfcn.h>
#define EXPORT __attribute__((visibility("default")))
#endif

extern "C" EXPORT int64_t mpSteamCall(int32_t, const char*, int64_t, uint8_t*, int32_t);

static int64_t copyString(const std::string& value, uint8_t* out, int32_t capacity) {
    if (!out || capacity < 1) return 0;
    const auto size = std::min(value.size(), static_cast<size_t>(capacity - 1));
    std::memcpy(out, value.data(), size);
    out[size] = 0;
    return static_cast<int64_t>(size);
}

#ifdef MP_STEAM_STUB
// Explicit test-only build. The exporter never accepts it.
extern "C" EXPORT int64_t mpSteamCall(int32_t op, const char*, int64_t, uint8_t* out, int32_t size) {
    if (op == 17) return copyString("Test stub: Steamworks SDK/backend not included", out, size);
    if (op == 14) return -2147483649LL;
    if (op == 12) return -1;
    return 0;
}
#else
#include <steam/steam_api.h>

namespace {
struct Api {
    ESteamAPIInitResult (*init)(SteamErrMsg*) = nullptr;
    bool (*restart)(uint32) = nullptr;
    void (*shutdown)() = nullptr;
    HSteamUser (*user)() = nullptr;
    HSteamPipe (*pipe)() = nullptr;
    void* (*interfaceFor)(HSteamUser, const char*) = nullptr;
    void (*dispatchInit)() = nullptr;
    void (*runFrame)(HSteamPipe) = nullptr;
    bool (*next)(HSteamPipe, CallbackMsg_t*) = nullptr;
    void (*freeCallback)(HSteamPipe) = nullptr;
} api;
void* library = nullptr;
bool loaded = false, initialized = false, available = false, overlay = false;
uint32 appId = 0;
int storeStatus = 0;
std::string lastError;
ISteamUser* user = nullptr;
ISteamFriends* friends = nullptr;
ISteamUtils* utils = nullptr;
ISteamApps* apps = nullptr;
ISteamUserStats* stats = nullptr;

void* symbol(const char* name) {
#ifdef _WIN32
    return reinterpret_cast<void*>(GetProcAddress(static_cast<HMODULE>(library), name));
#else
    return dlsym(library, name);
#endif
}

bool load() {
    if (loaded) return true;
    // Load only a sibling runtime, never a DLL from the working directory/PATH.
    if (!library) {
#ifdef _WIN32
        HMODULE module = nullptr;
        wchar_t path[32768];
        if (!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                reinterpret_cast<LPCWSTR>(&mpSteamCall), &module)) return false;
        DWORD count = GetModuleFileNameW(module, path, 32768);
        if (!count || count >= 32768) return false;
        std::wstring full(path, count);
        full = full.substr(0, full.find_last_of(L"\\/") + 1) + L"steam_api64.dll";
        library = LoadLibraryExW(full.c_str(), nullptr, LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR | LOAD_LIBRARY_SEARCH_DEFAULT_DIRS);
#else
        Dl_info info{};
        if (!dladdr(reinterpret_cast<void*>(&mpSteamCall), &info) || !info.dli_fname) return false;
        std::string full(info.dli_fname);
        full = full.substr(0, full.find_last_of('/') + 1) + "libsteam_api.so";
        library = dlopen(full.c_str(), RTLD_NOW | RTLD_LOCAL);
#endif
    }
    if (!library) { lastError = "Steam runtime missing beside the MiniPixels bridge"; return false; }
#define LOAD(field, name) api.field = reinterpret_cast<decltype(api.field)>(symbol(name)); \
    if (!api.field) { lastError = "Steam runtime missing export: " name; return false; }
    // SteamAPI_Init is an inline C++ wrapper in current SDKs, not a DLL export.
    LOAD(init, "SteamAPI_InitFlat")
    LOAD(restart, "SteamAPI_RestartAppIfNecessary")
    LOAD(shutdown, "SteamAPI_Shutdown")
    LOAD(user, "SteamAPI_GetHSteamUser")
    LOAD(pipe, "SteamAPI_GetHSteamPipe")
    LOAD(interfaceFor, "SteamInternal_FindOrCreateUserInterface")
    LOAD(dispatchInit, "SteamAPI_ManualDispatch_Init")
    LOAD(runFrame, "SteamAPI_ManualDispatch_RunFrame")
    LOAD(next, "SteamAPI_ManualDispatch_GetNextCallback")
    LOAD(freeCallback, "SteamAPI_ManualDispatch_FreeLastCallback")
#undef LOAD
    loaded = true;
    return true;
}

void stop() {
    if (initialized) api.shutdown();
    initialized = available = overlay = false;
    user = nullptr; friends = nullptr; utils = nullptr; apps = nullptr; stats = nullptr;
    storeStatus = 0;
    // Do not unload: the Steam overlay may still own graphics hooks.
}

bool start(uint32 id) {
    if (initialized) { lastError = "Only one Steam session is supported"; return false; }
    if (!load()) return false;
    SteamErrMsg initError{};
    if (api.init(&initError) != k_ESteamAPIInitResult_OK) {
        lastError = std::string("SteamAPI_InitFlat failed: ") + initError;
        return false;
    }
    initialized = true;
    auto handle = api.user();
    user = static_cast<ISteamUser*>(api.interfaceFor(handle, STEAMUSER_INTERFACE_VERSION));
    friends = static_cast<ISteamFriends*>(api.interfaceFor(handle, STEAMFRIENDS_INTERFACE_VERSION));
    // ISteamUtils is pipe-scoped; match the SDK's SteamUtils() accessor.
    utils = static_cast<ISteamUtils*>(api.interfaceFor(0, STEAMUTILS_INTERFACE_VERSION));
    apps = static_cast<ISteamApps*>(api.interfaceFor(handle, STEAMAPPS_INTERFACE_VERSION));
    stats = static_cast<ISteamUserStats*>(api.interfaceFor(handle, STEAMUSERSTATS_INTERFACE_VERSION));
    if (!user || !friends || !utils || !apps || !stats || utils->GetAppID() != id) {
        lastError = "Steam interface unavailable or AppID mismatch";
        stop(); return false;
    }
    appId = id;
    api.dispatchInit();
    available = true;
    lastError.clear();
    return true;
}

void pump() {
    if (!available) return;
    auto pipe = api.pipe();
    api.runFrame(pipe);
    CallbackMsg_t msg{};
    // Bound callback work per rendered frame; leave the remainder queued.
    for (int count = 0; count < 256 && api.next(pipe, &msg); ++count) {
        if (msg.m_iCallback == GameOverlayActivated_t::k_iCallback && msg.m_cubParam >= sizeof(GameOverlayActivated_t))
            overlay = reinterpret_cast<GameOverlayActivated_t*>(msg.m_pubParam)->m_bActive != 0;
        if (msg.m_iCallback == UserStatsStored_t::k_iCallback && msg.m_cubParam >= sizeof(UserStatsStored_t)) {
            const auto* event = reinterpret_cast<UserStatsStored_t*>(msg.m_pubParam);
            if (event->m_nGameID == appId && storeStatus == 1) {
                storeStatus = event->m_eResult == k_EResultOK ? 2 : -1;
                if (storeStatus < 0) lastError = "Steam rejected StoreStats (EResult " + std::to_string(event->m_eResult) + ")";
            }
        }
        if (msg.m_iCallback == SteamShutdown_t::k_iCallback) available = overlay = false;
        api.freeCallback(pipe);
    }
}
} // namespace

extern "C" EXPORT int64_t mpSteamCall(int32_t op, const char* text, int64_t value, uint8_t* out, int32_t size) {
    // Never propagate C++ exceptions through MiniLang's C ABI.
    try {
        if (!text) text = "";
        if (op == 17) return copyString(lastError, out, size);
        if (op == 1) return value > 0 && value <= UINT32_MAX && start(static_cast<uint32>(value));
        if (op == 2) return value > 0 && value <= UINT32_MAX && load() && api.restart(static_cast<uint32>(value));
        if (op == 4) { stop(); return 1; }
        if (op == 6) return available;
        if (!available) return op == 14 ? -2147483649LL : (op == 12 ? -1 : 0);
        switch (op) {
        case 3: pump(); return 1;
        case 5: return overlay;
        case 7: return copyString(friends->GetPersonaName(), out, size);
        case 8: return copyString(std::to_string(user->GetSteamID().ConvertToUint64()), out, size);
        case 9: return copyString(apps->GetCurrentGameLanguage(), out, size);
        case 10:
            if (!utils->IsOverlayEnabled()) return 0;
            if (std::strcmp(text, "friends") && std::strcmp(text, "achievements") && std::strcmp(text, "stats") &&
                std::strcmp(text, "community") && std::strcmp(text, "players") && std::strcmp(text, "settings")) return 0;
            friends->ActivateGameOverlay(text); return 1;
        case 11: return stats->SetAchievement(text);
        case 12: { bool unlocked = false; return stats->GetAchievement(text, &unlocked) ? (unlocked ? 1 : 0) : -1; }
        case 13: return value >= INT32_MIN && value <= INT32_MAX && stats->SetStat(text, static_cast<int32>(value));
        case 14: { int32 result = 0; return stats->GetStat(text, &result) ? result : -2147483649LL; }
        case 15:
            if (storeStatus == 1) return 0;
            if (!stats->StoreStats()) { lastError = "StoreStats not accepted; check published stat definitions"; return 0; }
            storeStatus = 1; return 1;
        case 16: return storeStatus;
        default: return 0;
        }
    } catch (...) { return 0; }
}
#endif
