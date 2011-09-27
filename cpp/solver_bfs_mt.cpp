#include "solver_bfs_mt.h"

#include <QThreadPool>


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

QList<Spin> Solver_BFS_MT::findSolution(const Grid &problemGrid)
{
	RunnableNode* node = new RunnableNode(0, problemGrid);
//	QThreadPool::globalInstance()->setMaxThreadCount(5);
	QThreadPool::globalInstance()->start(node);
	QThreadPool::globalInstance()->waitForDone();
}
