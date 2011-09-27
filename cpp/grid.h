#ifndef GRID_H
#define GRID_H

#include <QList>
#include "tile.h"
#include "spin.h"


class Grid
{
public:
	Grid();
	Grid(int n, int m);
	Grid(int n, int m, QList<Tile> data);
	Grid(const Grid& rhs);
	~Grid();

        Grid permutated(const Spin& spin) const;
	Spin boundingBoxOfMisplacedElements() const;
	bool containsCorrectElements(const Spin& spin) const;

	bool operator ==(const Grid& rhs) const;
	bool operator <(const Grid& rhs) const;
	Grid& operator =(const Grid& rhs);

        void debugPrint();

private:
	void setIdeal();

	int indexFromPoint(const QPoint& point) const;
        QPoint pointFromIndex(int index) const;
        void swap(int i1, int i2);
        void flip(int i);

	bool isTileCorrect(int x, int y) const;

        int n_;
        int m_;
	Tile* data_;
};

#endif // GRID_H
