#ifndef ANIMATION_H
#define ANIMATION_H

class Animation
{
public:
    virtual void drawFrame() = 0;
    virtual const char* getName() = 0;
};

#endif