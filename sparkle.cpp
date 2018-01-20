#include <FastLED.h>
FASTLED_USING_NAMESPACE

#include "sparkle.hpp"

Sparkle::Sparkle(CRGB* leds_, uint32_t ledCount_, CRGB& color_)
    : leds(leds_), ledCount(ledCount_), color(color_), glitterChance(25)
{
}

void Sparkle::drawFrame()
{
    fadeToBlackBy(leds, ledCount, 10);

    if(random8() < glitterChance) {
        leds[random16(ledCount)] += color;
    }
}
