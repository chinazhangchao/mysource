#include "framebuffer.h"

FrameBuffer::FrameBuffer():m_fd(-1), m_pFB(NULL), m_bInitSuccess(false)
{
    memset(&m_fbFinfo, 0, sizeof(m_fbFinfo));
    memset(&m_fbVinfo, 0, sizeof(m_fbVinfo));
    init();
}

FrameBuffer::~FrameBuffer()
{
    if (MAP_FAILED != m_pFB)
        munmap(m_pFB, m_fbFinfo.smem_len);
    if (-1 != m_fd)
        close(m_fd);
}

void FrameBuffer::init()
{
    m_fd = open("/dev/fb0", O_RDWR);
    if (m_fd < 0)
    {
        printf ("can not open /dev/fb0 device!\n");
        return;
    }

    if (ioctl(m_fd, FBIOGET_FSCREENINFO, &m_fbFinfo)) {
        printf ("get FBIOGET_FSCREENINFO failed !\n");
        return;
    }

    if (ioctl(m_fd, FBIOGET_VSCREENINFO, &m_fbVinfo)) {
        printf ("get FBIOGET_VSCREENINFO failed !\n");
        return;
    }

    if ((m_pFB = mmap(0, m_fbFinfo.smem_len, PROT_READ | PROT_WRITE, MAP_SHARED, m_fd, 0)) == MAP_FAILED)
    {
        printf ("map framebuffer memory failed !\n");
        return;
    }

    m_bInitSuccess = true;
}
