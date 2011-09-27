#include <QtCore/QCoreApplication>
#include <QThreadPool>
#include <QRect>
#include <QList>
#include <QQueue>
#include <QStack>
#include <QTime>

#include <QDebug>
#include <stdio.h>


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

static const QList<Spin> allSpins = getAllSpins<3, 3>();

struct Tile {
	Tile(int number, bool up) :
		number_(number),
		up_(up)
	{}

	bool operator ==(const Tile& rhs) {
		return number_ == rhs.number_ && up_ == rhs.up_;
	}


	int number_;
	bool up_;
};

class Grid
{

public:
	Grid(int n, int m) :
		n_(n),
		m_(m)
	{
		setIdeal();
	}

	Grid(int n, int m, QList<Tile> data) :
		n_(n),
		m_(m),
		data_(data)
	{}

	void setIdeal() {
		data_.clear();
		for(int i = 0; i < n_ * m_; ++i) {
			data_.append(Tile(i+1, true));
		}
	}

	Grid permutated(const Spin& spin) const {
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

	bool operator ==(const Grid& rhs) const {
		return data_ == rhs.data_;
	}

	void debugPrint() {
		int i = 0;
		for(int y = 0; y < n_; ++y) {
			for(int x = 0; x < m_; ++x, ++i) {
				printf("%d", data_[i].number_);
				if(!data_[i].up_) {
					printf("! ");
				} else {
					printf("  ");
				}
			}

			printf("\n");
		}
	}

private:
	int indexFromPoint(const QPoint& point) const {
		return point.y() * m_ + point.x();
	}

	QPoint pointFromIndex(int index) const {
		return QPoint(index % m_, index / n_);
	}

	void swap(int i1, int i2) {
		data_.swap(i1, i2);
	}

	void flip(int i) {
		data_[i].up_ = !data_[i].up_;
	}

	int n_;
	int m_;
	QList<Tile> data_;
};

static const Grid idealGrid(3,3);


class RunnableNode : public QRunnable
{
public:
	RunnableNode(int depth, const Grid& grid) :
		depth_(depth),
		grid_(grid)
	{}

protected:
	void run() {
		if(grid_ == idealGrid) {
			qDebug() << "FOUND!";
			return;
		}

		if(depth_ >= 4) {
			return;
		}

		foreach(Spin spin, allSpins) {
			RunnableNode* node = new RunnableNode(depth_ +1, grid_.permutated(spin));

			QThreadPool::globalInstance()->start(node);
		}
	}

private:
	int depth_;
	Grid grid_;
};


bool traverse(const Grid& g, int depth, int maxDepth)
{
	if ( g == idealGrid ) {
		qDebug() << "Found at level" << depth;
		return true;
	}

	if( depth < maxDepth ) {
		foreach(Spin spin, allSpins) {
			bool found = traverse(g.permutated(spin), depth +1, maxDepth);
			if ( found ) {
				qDebug() << "spin" << depth << spin;
				return true;
			}
		}
	}

	return false;
}

Spin getRandomSpin()
{
	int i = rand() % allSpins.size();
	return allSpins[i];
}

bool randomTraverse(const Grid& g, int depth, int maxDepth)
{
	if ( g == idealGrid ) {
		qDebug() << "Found at level" << depth;
		return true;
	}

	if( depth < maxDepth ) {
		Spin spin = getRandomSpin();
		bool found = randomTraverse(g.permutated(spin), depth +1, maxDepth);
		if ( found ) {
			qDebug() << "spin" << depth << spin;
			return true;
		}
	}

	return false;
}

int main(int argc, char *argv[])
{
//	QCoreApplication a(argc, argv);

	QList<Tile> tiles;
	/* gregors problem */
	tiles.clear();
	tiles.append(Tile(5, true));
	tiles.append(Tile(2, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(6, true));
	tiles.append(Tile(1, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(7, true));
	tiles.append(Tile(8, true));
	tiles.append(Tile(9, true));
	Grid grid_gregor(3, 3, tiles);

	/* mareikes problem */
	tiles.clear();
	tiles.append(Tile(1, true));
	tiles.append(Tile(2, true));
	tiles.append(Tile(7, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(5, true));
	tiles.append(Tile(8, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(6, true));
	tiles.append(Tile(9, true));
	Grid grid_mareike(3, 3, tiles);


//        Grid gp = grid_gregor;
        Grid gp = grid_mareike;

	qDebug() << "started...";
	QTime time;
	time.start();

	/* multithreaded */
//	RunnableNode* node = new RunnableNode(0, gp);
//	QThreadPool::globalInstance()->setMaxThreadCount(5);
//	QThreadPool::globalInstance()->start(node);
//	QThreadPool::globalInstance()->waitForDone();

	/* BFS */
//	QQueue<Grid> openList;
//	openList.enqueue(gp);
//	while(!openList.empty()) {
//		Grid g = openList.dequeue();
//		if( g == idealGrid ) {
//			qDebug() << "found!";
//			qDebug() << "List size:" << openList.size();
//			break;
//		}
//		if ( openList.size() > 1727605 ) {
//			continue;
//		}
//		foreach(Spin spin, allSpins) {
//			openList.enqueue(g.permutated(spin));
//		}
//	}

	/* DFS */
        int maxDepth = 1;
        bool found = false;
        while(!found) {
                qDebug() << "max depth" << maxDepth;
                found = traverse(gp, 0, maxDepth);
                ++maxDepth;
        }

	/* random search */
//	while(true) {
//		bool found = randomTraverse(gp, 0, 5);
//		if ( found ) {
//			break;
//		}
//	}

	int elapsedMs = time.elapsed();
	qDebug() << "done. took" << (double)elapsedMs / 1000.0 << "s";


	return 0;
}
