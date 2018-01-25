#include <FastLED.h>
FASTLED_USING_NAMESPACE

#include "movingrainbow.hpp"
#include "Arduino.h"

MovingRainbow::MovingRainbow(CRGB* leds_, size_t ledCount_)
    : leds(leds_), ledCount(ledCount_), baseColor(0), frameCounter(0)
{
}

void MovingRainbow::drawFrame()
{
    fill_rainbow(leds, ledCount, baseColor);
    frameCounter++;
    if(frameCounter == 1)
    {
        baseColor++;
        frameCounter = 0;
    }
}
