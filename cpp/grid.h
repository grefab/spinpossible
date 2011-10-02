#ifndef GRID_H
#define GRID_H

#include <QList>
#include <QString>
#include "tile.h"
#include "spin.h"

#include <QDebug>


template < int N, int M >
class Grid
{
public:
	static const Grid<N,M> idealGrid;

	Grid()
	{
		setIdeal();
		updateHash();
	}

	Grid(QList<Tile> data)
	{
		for(int i = 0; i < N*M; ++i) {
			data_[i] = data[i];
		}

		updateHash();
	}

	Grid(const Grid<N,M>& rhs)
	{
		hash_ = rhs.hash_;

		for(int i = 0; i < N*M; ++i) {
			data_[i] = rhs.data_[i];
		}
	}

	Grid permutated(const Spin& spin) const
	{
		Grid g = *this;

		QList<int> indexes;
		for(int y = spin.y(); y < spin.y() + spin.height(); ++y) {
			for(int x = spin.x(); x < spin.x() + spin.width(); ++x) {
				indexes.append(indexFromPoint(QPoint(x, y)));
			}
		}

		int i = 0;
		int j = indexes.size() -1;

		while(i <= j) {
			int a = indexes[i];
			int b = indexes[j];

			if(a != b) g.swap(a, b);
			g.flip(a); if(a != b) g.flip(b);

			++i;
			--j;
		}

		g.updateHash();
		return g;
	}

	Grid random() const
	{
		Grid<N,M> g();

		for(int i = 0; i < N*M; ++i) {
			int rnd = rand() % (N*M);
			g.swap(i, rnd);
		}

		for(int i = 0; i < N*M; ++i) {
			bool rnd = rand() % 2;
			if ( rnd )
				g.flip(i);
		}

		g.updateHash();
		return g;
	}


	Spin boundingBoxOfMisplacedElements() const
	{
		QRect r;

		for(int y = 0; y < N; ++y) {
			for(int x = 0; x < M; ++x) {
				if( !isTileCorrect(x,y) ) {
					r = r.united(Spin(x, y, 1, 1));
				}
			}
		}

		return r;

	}

	bool containsCorrectElements(const Spin& spin) const
	{
		for(int y = spin.y(); y < spin.y() + spin.height(); ++y) {
			for(int x = spin.x(); x < spin.x() + spin.width(); ++x) {
				if ( isTileCorrect(x, y) ) {
					return true;
				}
			}
		}

		return false;
	}


	uint getHash() const
	{
		return hash_;
	}

	bool operator ==(const Grid& rhs) const
	{
		for(int i = 0; i < N*M; ++i) {
			if( data_[i] != rhs.data_[i] ) {
				return false;
			}
		}

		return true;
	}

	bool operator <(const Grid& rhs) const
	{
		for(int i = 0; i < N*M; ++i) {
			if( data_[i] < rhs.data_[i] ) {
				return true;
			}
			if( data_[i] > rhs.data_[i] ) {
				return false;
			}
		}

		return false;
	}


	void debugPrint() const
	{
		int i = 0;
		for(int y = 0; y < N; ++y) {
			QString s;
			for(int x = 0; x < M; ++x, ++i) {
				s += QString::number(data_[i]) + " ";
			}
			qDebug() << s;
		}
		qDebug() << "hash:" << hash_;
	}


private:
	Grid& operator=(const Grid& rhs)
	{
		hash_ = rhs.hash_;

		for(int i = 0; i < N*M; ++i) {
			data_[i] = rhs.data_[i];
		}

		return *this;
	}


	void setIdeal()
	{
		for(int i = 0; i < N*M; ++i) {
			data_[i] = make_tile(i+1, true);
		}
	}


	int indexFromPoint(const QPoint& point) const
	{
		return point.y() * M + point.x();
	}

	QPoint pointFromIndex(int index) const
	{
		return QPoint(index % M, index / N);
	}

	void swap(int i1, int i2)
	{
		Tile t = data_[i1];
		data_[i1] = data_[i2];
		data_[i2] = t;
	}

	void flip(int i)
	{
		data_[i] = -data_[i];
	}


	bool isTileCorrect(int x, int y) const
	{
		int i = indexFromPoint(QPoint(x, y));
		return data_[i] == idealGrid.data_[i];
	}


	void updateHash()
	{
		/* create a list of all tiles we need to consider */
		QList<Tile> tiles;
		for( int i = -N*M; i < N*M; ++i ) {
			if ( i != 0 ) {
				tiles.append(i+1);
			}
		}

		uint remainingPositions = N*M;
		uint hash = 0;

		for( int i = 0; i < N*M; ++i ) {
			Tile current = data_[i];

			/* update our hash */
			hash += tiles.indexOf(current);

			/* shl according to remaining positions */
			hash *= remainingPositions * 2;
			--remainingPositions;

			tiles.removeOne(current);
			tiles.removeOne(-current);
		}

		hash_ = hash;
	}


	Tile data_[N*M];
	uint hash_;
};

template <int N, int M> const Grid<N,M> Grid<N,M>::idealGrid = Grid<N,M>();

#endif // GRID_H
