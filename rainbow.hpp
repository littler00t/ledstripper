#ifndef RAINBOW_HPP
#define RAINBOW_HPP

#include "animation.hpp"

class Rainbow: public Animation
{
public:
    Rainbow(CRGB* leds, uint32_t ledCount);
    virtual void drawFrame();
    virtual const char* getName()
    {
        return "rainbow";
    }
    
private:
    CRGB* leds;
    uint32_t ledCount;
    CRGB color;
    int stepsize;
    
    uint8_t ensureWithinBounds(int value);
};

#endif
