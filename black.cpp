#include <FastLED.h>
FASTLED_USING_NAMESPACE

#include "black.hpp"

Black::Black(CRGB* leds_, uint32_t ledCount_)
{
    leds = leds_;
    ledCount = ledCount_;
}

void Black::drawFrame()
{
    fill_solid(leds, ledCount, CRGB::Black);
}
