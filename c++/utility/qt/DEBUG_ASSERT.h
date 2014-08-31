#ifndef QT_DEBUG
#define DEBUG_ASSERT(X) X;
#else
#define DEBUG_ASSERT(X) Q_ASSERT(X);
#endif
