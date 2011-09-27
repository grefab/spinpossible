#ifndef GRID_H
#define GRID_H

#include <QList>
#include "tile.h"
#include "spin.h"


class Grid
{

public:
        Grid(int n, int m);
	Grid(int n, int m, QList<Tile> data);
	Grid(const Grid& rhs);
	~Grid();

        void setIdeal();
        Grid permutated(const Spin& spin) const;
        bool operator ==(const Grid& rhs) const;
	bool operator =(const Grid& rhs);

        void debugPrint();

private:
        int indexFromPoint(const QPoint& point) const;
        QPoint pointFromIndex(int index) const;
        void swap(int i1, int i2);
        void flip(int i);

        int n_;
        int m_;
	Tile* data_;
};

#endif // GRID_H
