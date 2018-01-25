#ifndef MOVINGRAINBOW_HPP
#define MOVINGRAINBOW_HPP

#include "animation.hpp"

class MovingRainbow: public Animation
{
public:
    MovingRainbow(CRGB* leds, size_t ledCount);
    virtual void drawFrame();
    virtual const char* getName()
    {
        return "moving_rainbow";
    }
    
private:
    CRGB* leds;
    size_t ledCount;
    uint8_t baseColor;
    uint8_t frameCounter;
};

#endif
