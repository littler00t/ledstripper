#ifndef MOVINGRAINBOW_HPP
#define MOVINGRAINBOW_HPP

#include "animation.hpp"

class MovingRainbow: public Animation
{
public:
    MovingRainbow(CRGB* leds, size_t ledCount, size_t height, size_t width);
    virtual void drawFrame();
    virtual const char* getName()
    {
        return "movingrainbow";
    }
    
private:
    CRGB* leds;
    size_t ledCount;
    CRGB color;
    int stepsize;
    size_t height;
    size_t width;
    CRGB* fullRainbow;
    size_t rainbowSize;
    size_t currentSliceStartIndex;
    CRGB* currentRainbowSlice;

    uint8_t ensureWithinBounds(int value);
    CRGB* calculateRainbow();
};

#endif
