#include <FastLED.h>
FASTLED_USING_NAMESPACE

#include "movingrainbow.hpp"
#include "Arduino.h"

MovingRainbow::MovingRainbow(CRGB* leds_, size_t ledCount_, size_t height_, size_t width_)
{
    leds = leds_;
    ledCount = ledCount_;
    color = CRGB::Red;
    height = height_;
    width = width_;

    currentSliceStartIndex = 0;
    currentRainbowSlice = new CRGB[width];
    
    rainbowSize = width * 5;
    fullRainbow = calculateRainbow();
}

CRGB* MovingRainbow::calculateRainbow()
{
    CRGB* rainbow = new CRGB[rainbowSize]();
    CRGB currentColor = CRGB::Red;
    size_t stepsize = (255*6) / rainbowSize;

    for(size_t i = 0; i < rainbowSize; ++i)
    {
        if (currentColor.red == 255 and currentColor.green == 0 and currentColor.blue < 255)
        {
            currentColor.blue = ensureWithinBounds(currentColor.blue + stepsize);
        }
    
        if (currentColor.red > 0 and currentColor.green == 0 and currentColor.blue == 255)
        {
            currentColor.red = ensureWithinBounds(currentColor.red - stepsize);
        }
    
        if (currentColor.red == 0 and currentColor.green < 255 and currentColor.blue == 255)
        {
            currentColor.green = ensureWithinBounds(currentColor.green + stepsize);
        }
    
        if (currentColor.red == 0 and currentColor.green == 255 and currentColor.blue > 0)
        {
            currentColor.blue = ensureWithinBounds(currentColor.blue - stepsize);
        }
    
        if (currentColor.red < 255 and currentColor.green == 255 and currentColor.blue == 0)
        {
            currentColor.red = ensureWithinBounds(currentColor.red + stepsize);
        }
    
        if (currentColor.red == 255 and currentColor.green > 0 and currentColor.blue == 0)
        {
            currentColor.green = ensureWithinBounds(currentColor.green - stepsize);
        }
        rainbow[i] = currentColor;
    }
    return rainbow;
}

uint8_t MovingRainbow::ensureWithinBounds(int value)
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

void MovingRainbow::drawFrame()
{
    if((currentSliceStartIndex + width) < (rainbowSize - 1))
    {
        memcpy(currentRainbowSlice, &(fullRainbow[currentSliceStartIndex]), sizeof(CRGB) * width);
    }
    else
    {
        size_t remainingAtEnd = rainbowSize - currentSliceStartIndex - 1;
        if(remainingAtEnd > 0)
        {
            memcpy(currentRainbowSlice, &(fullRainbow[currentSliceStartIndex]), sizeof(CRGB) * remainingAtEnd);
        }
        memcpy(currentRainbowSlice + remainingAtEnd, &(fullRainbow[width - remainingAtEnd]), sizeof(CRGB) * (width - remainingAtEnd));
    }

    size_t rowSizeInBytes = sizeof(CRGB) * width;
    for(size_t row = 0; row < height; ++row)
    {
        if(row % 2 == 1)
        {
            for(size_t i = 0; i < width; ++i)
            {
                leds[(width * row) + i] = currentRainbowSlice[width - i - 1];    
            }
        }
        else
        {
            memcpy(leds + (width * row), currentRainbowSlice, rowSizeInBytes);
        }
    }
    currentSliceStartIndex++;
    if(currentSliceStartIndex > (rainbowSize - 1))
    {
        currentSliceStartIndex = 0;
    }
}
