#ifndef WHITE_HPP
#define WHITE_HPP

#include "animation.hpp"

class White: public Animation
{
public:
    White(CRGB* leds, uint32_t ledCount);
    virtual void drawFrame();
    virtual const char* getName()
    {
        return "white";
    }

private:
    CRGB* leds;
    uint32_t ledCount;
};

#endif
