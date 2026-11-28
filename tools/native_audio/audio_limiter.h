// SPDX-License-Identifier: Apache-2.0
// Optional smooth peak limiting shared by the offline and autonomous mixers.
// Unity slope at the knee; no block lookahead, envelope reset or added latency.
#ifndef MINIPIXELS_AUDIO_LIMITER_H
#define MINIPIXELS_AUDIO_LIMITER_H
#include <math.h>
static double mp_audio_soft_limit(double value)
{
    double magnitude = fabs(value);
    if (magnitude <= 24000.0) return value;
    magnitude = 24000.0 + 8000.0 * (1.0 - exp(-(magnitude - 24000.0) / 8000.0));
    return value < 0.0 ? -magnitude : magnitude;
}
#endif
