#include <FastLED.h>
FASTLED_USING_NAMESPACE

#include "white.hpp"

White::White(CRGB* leds_, uint32_t ledCount_)
{
    leds = leds_;
    ledCount = ledCount_;
}

void White::drawFrame()
{
    fill_solid(leds, ledCount, CRGB::White);
}
