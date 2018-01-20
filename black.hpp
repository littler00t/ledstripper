#ifndef BLACK_HPP
#define BLACK_HPP

#include "animation.hpp"

class Black: public Animation
{
public:
    Black(CRGB* leds, uint32_t ledCount);
    virtual void drawFrame();
    virtual const char* getName()
    {
        return "black";
    }

private:
    CRGB* leds;
    uint32_t ledCount;
};

#endif
