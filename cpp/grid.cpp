#include "grid.h"

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
		data_[i] = Tile(i+1, true);
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

bool Grid::operator ==(const Grid& rhs) const {
	for(int i = 0; i < n_*m_; ++i) {
		if( data_[i] != rhs.data_[i] ) {
			return false;
		}
	}

	return true;
}

bool Grid::operator =(const Grid& rhs) {
	n_ = rhs.n_;
	m_ = rhs.m_;

	for(int i = 0; i < n_*m_; ++i) {
		data_[i] = rhs.data_[i];
	}
}

void Grid::debugPrint() {
	int i = 0;
	for(int y = 0; y < n_; ++y) {
		for(int x = 0; x < m_; ++x, ++i) {
			printf("%d", data_[i].number_);
			if(data_[i].number_ < 0) {
				printf("! ");
			} else {
				printf("  ");
			}
		}

		printf("\n");
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
	data_[i].number_ = -data_[i].number_;
}

