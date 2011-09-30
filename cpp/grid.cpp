#include "grid.h"

#include <QString>

#include <QDebug>


static const Grid idealGrid(3,3);

Grid::Grid() :
	n_(0),
	m_(0)
{
	data_ = NULL;
}

Grid::Grid(int n, int m) :
	n_(n),
	m_(m)
{
	data_ = new Tile[n*m];
	setIdeal();
}

Grid::Grid(int n, int m, QList<Tile> data) :
	n_(n),
	m_(m)
{
	data_ = new Tile[n*m];

	for(int i = 0; i < data.length(); ++i) {
		data_[i] = data[i];
	}
}

Grid::Grid(const Grid& rhs)
{
	n_ = rhs.n_;
	m_ = rhs.m_;

	data_ = new Tile[n_*m_];

	for(int i = 0; i < n_*m_; ++i) {
		data_[i] = rhs.data_[i];
	}
}

Grid::~Grid()
{
	delete data_;
}

void Grid::setIdeal() {
	for(int i = 0; i < n_ * m_; ++i) {
		data_[i] = make_tile(i+1, true);
	}
}

Grid Grid::permutated(const Spin& spin) const {
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

	return g;
}

Spin Grid::boundingBoxOfMisplacedElements() const
{
	QRect r;

	for(int y = 0; y < n_; ++y) {
		for(int x = 0; x < m_; ++x) {
			if( !isTileCorrect(x,y) ) {
				r = r.united(Spin(x, y, 1, 1));
			}
		}
	}

	return r;

}

bool Grid::containsCorrectElements(const Spin& spin) const
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

bool Grid::isTileCorrect(int x, int y) const
{
	int i = indexFromPoint(QPoint(x, y));
	return data_[i] == idealGrid.data_[i];
}


bool Grid::operator ==(const Grid& rhs) const {
	for(int i = 0; i < n_*m_; ++i) {
		if( data_[i] != rhs.data_[i] ) {
			return false;
		}
	}

	return true;
}

bool Grid::operator <(const Grid& rhs) const {
	for(int i = 0; i < n_*m_; ++i) {
		if( data_[i] < rhs.data_[i] ) {
			return true;
		}
		if( data_[i] > rhs.data_[i] ) {
			return false;
		}
	}

	return false;
}

Grid& Grid::operator =(const Grid& rhs) {
	n_ = rhs.n_;
	m_ = rhs.m_;

	for(int i = 0; i < n_*m_; ++i) {
		data_[i] = rhs.data_[i];
	}

	return *this;
}

void Grid::debugPrint() {
	int i = 0;
	for(int y = 0; y < n_; ++y) {
		QString s;
		for(int x = 0; x < m_; ++x, ++i) {
//			if(x > 0 )
//				s += data_[i].number_ < 0 ? QString(" ") : QString("  ");
			s += QString::number(data_[i]) + " ";
		}
		qDebug() << s;
	}
}

int Grid::indexFromPoint(const QPoint& point) const {
	return point.y() * m_ + point.x();
}

QPoint Grid::pointFromIndex(int index) const {
	return QPoint(index % m_, index / n_);
}

void Grid::swap(int i1, int i2) {
	Tile t = data_[i1];
	data_[i1] = data_[i2];
	data_[i2] = t;
}

void Grid::flip(int i) {
	data_[i] = -data_[i];
}

Grid Grid::random() const
{
	Grid g(n_, m_);

	for(int i = 0; i < n_ * m_; ++i) {
		int rnd = rand() % (n_ * m_);
		g.swap(i, rnd);
	}

	for(int i = 0; i < n_ * m_; ++i) {
		bool rnd = rand() % 2;
		if ( rnd )
			g.data_[i] = -g.data_[i];
	}

	return g;
}
