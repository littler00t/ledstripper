#ifndef SPARKLE_HPP
#define SPARKLE_HPP

#include "animation.hpp"

class Sparkle: public Animation
{
public:
    Sparkle(CRGB* leds, uint32_t ledCount);
    virtual void drawFrame();
    virtual const char* getName()
    {
        return "sparkle";
    }

private:
    CRGB* leds;
    uint32_t ledCount;
    uint8_t glitterChance;
};

#endif
