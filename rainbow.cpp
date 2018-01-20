#include <FastLED.h>
FASTLED_USING_NAMESPACE

#include "rainbow.hpp"

Rainbow::Rainbow(CRGB* leds_, uint32_t ledCount_)
{
    leds = leds_;
    ledCount = ledCount_;
    color = CRGB::Red;
    stepsize = 10;
}

uint8_t Rainbow::ensureWithinBounds(int value)
{
    if(value < 0)
    {
        return 0;
    }
    else if (value > 255)
    {
        return 255;
    }
    else
    {
        return (uint8_t)value;
    }
}

void Rainbow::drawFrame()
{
    fill_solid(leds, ledCount, color);
    if (color.red == 255 and color.green == 0 and color.blue < 255)
    {
        color.blue = ensureWithinBounds(color.blue + stepsize);
    }

    if (color.red > 0 and color.green == 0 and color.blue == 255)
    {
        color.red = ensureWithinBounds(color.red - stepsize);
    }

    if (color.red == 0 and color.green < 255 and color.blue == 255)
    {
        color.green = ensureWithinBounds(color.green + stepsize);
    }

    if (color.red == 0 and color.green == 255 and color.blue > 0)
    {
        color.blue = ensureWithinBounds(color.blue - stepsize);
    }

    if (color.red < 255 and color.green == 255 and color.blue == 0)
    {
        color.red = ensureWithinBounds(color.red + stepsize);
    }

    if (color.red == 255 and color.green > 0 and color.blue == 0)
    {
        color.green = ensureWithinBounds(color.green - stepsize);
    }
}
