#include "grid.h"

Grid::Grid(int n, int m) :
    n_(n),
    m_(m)
{
    setIdeal();
}

Grid::Grid(int n, int m, QList<Tile> data) :
    n_(n),
    m_(m),
    data_(data)
{}

void Grid::setIdeal() {
    data_.clear();
    for(int i = 0; i < n_ * m_; ++i) {
        data_.append(Tile(i+1, true));
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
    return data_ == rhs.data_;
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
    data_.swap(i1, i2);
}

void Grid::flip(int i) {
    data_[i].number_ = -data_[i].number_;
}

