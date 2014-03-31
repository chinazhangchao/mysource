#ifndef FRAMEBUFFER_H
#define FRAMEBUFFER_H
#include <unistd.h>
#include <stdio.h>
#include <memory.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <linux/fb.h>

class FrameBuffer
{
public:
    static FrameBuffer& getFrameBuffer()
    {
        static FrameBuffer fb;
        return fb;
    }

    bool initSuccessed() const
    {
        return m_bInitSuccess;
    }

    void* getFB() const
    {
        return m_pFB;
    }

    fb_fix_screeninfo& getFinfo()
    {
        return m_fbFinfo;
    }

    fb_var_screeninfo& getVinfo()
    {
        return m_fbVinfo;
    }

private:
    FrameBuffer();
    ~FrameBuffer();
    void init();

    int                 m_fd;
    void                *m_pFB;
    bool                m_bInitSuccess;
    fb_fix_screeninfo   m_fbFinfo;
    fb_var_screeninfo   m_fbVinfo;
};

#endif // FRAMEBUFFER_H
