#ifndef SPARKLE_HPP
#define SPARKLE_HPP

#include "animation.hpp"

class Sparkle: public Animation
{
public:
    Sparkle(CRGB* leds, uint32_t ledCount, CRGB& color);
    virtual void drawFrame();
    virtual const char* getName()
    {
        return "sparkle";
    }

private:
    CRGB* leds;
    uint32_t ledCount;
    CRGB& color;
    uint8_t glitterChance;
};

#endif
