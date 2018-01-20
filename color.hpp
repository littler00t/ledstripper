#ifndef COLOR_HPP
#define COLOR_HPP

#include "animation.hpp"

class Color: public Animation
{
public:
    Color(CRGB* leds, uint32_t ledCount, CRGB& color);
    virtual void drawFrame();
    virtual const char* getName()
    {
        return "color";
    }

private:
    CRGB* leds;
    CRGB& color;
    uint32_t ledCount;
};

#endif
