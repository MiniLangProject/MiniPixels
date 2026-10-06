// Isolated ALSA replacement used only in the mixer regression subprocess.
#include <stdint.h>
#include <stddef.h>
static long available;
static uint64_t total;
static int mode, calls, pointer_ok;
static const unsigned char *first_pointer;
void mpTestConfigure(int value) {
    mode = value; calls = 0; total = 0; available = value ? 1024 : 0;
    pointer_ok = 1; first_pointer = NULL;
}
void mpTestTick(void) { available += 1470; } // 44.1 kHz / 30 FPS
uint64_t mpTestTotal(void) { return total; }
int mpTestPointerOK(void) { return pointer_ok; }
int mpTestCalls(void) { return calls; }
long snd_pcm_avail_update(void *handle) { (void)handle; return available; }
long snd_pcm_writei(void *handle, const void *buffer, uint64_t frames) {
    (void)handle;
    ++calls;
    if (!first_pointer) first_pointer = buffer;
    if (mode == 1 && calls == 2) return -11; // EAGAIN, not an underrun
    if (mode == 2 && calls == 1) return -32; // recoverable underrun
    if (mode == 3 && calls == 1) return 0;
    if (mode == 1 && calls >= 2 && buffer != first_pointer + total * 4) pointer_ok = 0;
    if (mode == 1 && calls == 1 && frames > 257) frames = 257;
    if ((long)frames > available) return -22;
    available -= (long)frames;
    total += frames;
    return (long)frames;
}
int snd_pcm_recover(void *handle, int error, int silent) { (void)handle; (void)error; (void)silent; return 0; }
int snd_pcm_drop(void *handle) { (void)handle; available = 0; return 0; }
int snd_pcm_prepare(void *handle) { (void)handle; return 0; }
int snd_pcm_close(void *handle) { (void)handle; return 0; }
