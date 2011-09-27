#ifndef SPIN_H
#define SPIN_H

#include <QRect>
#include <QList>

typedef QRect Spin;

template < int N, int M >
QList<Spin> getAllSpins() {
        const int n = N;
        const int m = M;
        QList<Spin> result;

        for(int sy = 0; sy < n; ++sy) {
                for(int sx = 0; sx < m; ++sx) {
                        for(int ty = sy +1; ty <= n; ++ty) {
                                for(int tx = sx +1; tx <= m; ++tx) {
                                        result.append(Spin(sx, sy, tx-sx, ty-sy));
                                }
                        }
                }
        }

        return result;
}


#endif // SPIN_H
