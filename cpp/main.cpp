#include "spin.h"
#include "grid.h"
#include "tile.h"

#include "solver_dfs.h"

#include <QTime>

#include <QDebug>

Grid getGrid()
{
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
	Grid grid_advanced_swaps_2(3, 3, tiles);

	tiles.clear();
	tiles.append(Tile(8, true));
	tiles.append(Tile(2, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(5, true));
	tiles.append(Tile(6, true));
	tiles.append(Tile(7, true));
	tiles.append(Tile(1, true));
	tiles.append(Tile(9, true));
	Grid grid_advanced_swaps_3(3, 3, tiles);

	tiles.clear();
	tiles.append(Tile(5, true));
	tiles.append(Tile(6, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(1, true));
	tiles.append(Tile(2, true));
	tiles.append(Tile(7, true));
	tiles.append(Tile(8, true));
	tiles.append(Tile(9, true));
	Grid grid_advanced_swaps_4(3, 3, tiles);

	tiles.clear();
	tiles.append(Tile(9, true));
	tiles.append(Tile(2, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(5, true));
	tiles.append(Tile(8, false));
	tiles.append(Tile(7, true));
	tiles.append(Tile(6, false));
	tiles.append(Tile(1, true));
	Grid grid_advanced_swaps_5(3, 3, tiles);

	tiles.clear();
	tiles.append(Tile(1, true));
	tiles.append(Tile(6, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(9, true));
	tiles.append(Tile(2, true));
	tiles.append(Tile(7, true));
	tiles.append(Tile(8, true));
	tiles.append(Tile(5, true));
	Grid grid_advanced_swaps_6(3, 3, tiles);

	tiles.clear();
	tiles.append(Tile(1, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(2, true));
	tiles.append(Tile(5, true));
	tiles.append(Tile(8, true));
	tiles.append(Tile(7, true));
	tiles.append(Tile(6, true));
	tiles.append(Tile(9, true));
	Grid grid_advanced_swaps_7(3, 3, tiles);

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

	/* level 6 problem */
	tiles.clear();
	tiles.append(Tile(1, true));
	tiles.append(Tile(2, true));
	tiles.append(Tile(7, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(5, true));
	tiles.append(Tile(8, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(6, false));
	tiles.append(Tile(9, true));
	Grid grid_l6_1(3, 3, tiles);

	tiles.clear();
	tiles.append(Tile(1, true));
	tiles.append(Tile(2, false));
	tiles.append(Tile(7, true));
	tiles.append(Tile(4, true));
	tiles.append(Tile(5, false));
	tiles.append(Tile(8, true));
	tiles.append(Tile(3, true));
	tiles.append(Tile(6, false));
	tiles.append(Tile(9, true));
	Grid grid_l6_2(3, 3, tiles);


	return Grid(3,3).random();
}

double run(const Grid& grid);

int main(int argc, char *argv[])
{
	srand ( time(NULL) );

	QList<double> times;
	double timeSum = 0.0f;
	int i;
	for(i = 0; i < 1000; ++i) {
		Grid grid = getGrid();
		qDebug() << "solving this grid:";
		grid.debugPrint();

		double lastTime = run(grid);
		timeSum += lastTime;
		times << lastTime;
	}

	qDebug() << "avg. time:" << timeSum / i << "s;" << "final times:" << times;

	return 0;
}

double run(const Grid& grid)
{
	qDebug() << "started...";
	QTime time;
	time.start();

	Solver_DFS solver;
	QList<Spin> result = solver.findSolution(grid);
	qDebug() << result;

	int elapsedMs = time.elapsed();
	double duration = (double)elapsedMs / 1000.0;
	qDebug() << "done. took" << duration << "s";

	return duration;
}
