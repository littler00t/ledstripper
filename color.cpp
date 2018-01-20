#include <FastLED.h>
FASTLED_USING_NAMESPACE

#include "color.hpp"

Color::Color(CRGB* leds_, uint32_t ledCount_, CRGB& color_)
    : leds(leds_), ledCount(ledCount_), color(color_)
{
}

void Color::drawFrame()
{
    fill_solid(leds, ledCount, color);
}
