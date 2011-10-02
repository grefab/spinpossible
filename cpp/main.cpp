#include "spin.h"
#include "grid.h"
#include "tile.h"

#include "solver_dfs.h"

#include <QTime>

#include <QDebug>

#define _N 3
#define _M 3

Grid<_N,_M> getGrid()
{
	QList<Tile> tiles;
	/* gregors problem */
	tiles.clear();
	tiles.append(make_tile(5, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(6, true));
	tiles.append(make_tile(1, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(9, true));
	Grid<_N,_M> grid_advanced_swaps_2(tiles);

	tiles.clear();
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(5, true));
	tiles.append(make_tile(6, true));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(1, true));
	tiles.append(make_tile(9, true));
	Grid<_N,_M> grid_advanced_swaps_3(tiles);

	tiles.clear();
	tiles.append(make_tile(5, true));
	tiles.append(make_tile(6, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(1, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(9, true));
	Grid<_N,_M> grid_advanced_swaps_4(tiles);

	tiles.clear();
	tiles.append(make_tile(9, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(5, true));
	tiles.append(make_tile(8, false));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(6, false));
	tiles.append(make_tile(1, true));
	Grid<_N,_M> grid_advanced_swaps_5(tiles);

	tiles.clear();
	tiles.append(make_tile(1, true));
	tiles.append(make_tile(6, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(9, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(5, true));
	Grid<_N,_M> grid_advanced_swaps_6(tiles);

	tiles.clear();
	tiles.append(make_tile(1, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(5, true));
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(6, true));
	tiles.append(make_tile(9, true));
	Grid<_N,_M> grid_advanced_swaps_7(tiles);

	/* mareikes problem */
	tiles.clear();
	tiles.append(make_tile(1, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(5, true));
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(6, true));
	tiles.append(make_tile(9, true));
	Grid<_N,_M> grid_mareike(tiles);

	/* level 6 problem */
	tiles.clear();
	tiles.append(make_tile(1, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(5, true));
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(6, false));
	tiles.append(make_tile(9, true));
	Grid<_N,_M> grid_l6_1(tiles);

	tiles.clear();
	tiles.append(make_tile(1, true));
	tiles.append(make_tile(2, false));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(5, false));
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(3, true));
	tiles.append(make_tile(6, false));
	tiles.append(make_tile(9, true));
	Grid<_N,_M> grid_l6_2(tiles);


	tiles.clear();
	tiles.append(make_tile(5, true));
	tiles.append(make_tile(8, true));
	tiles.append(make_tile(3, false));
	tiles.append(make_tile(7, true));
	tiles.append(make_tile(2, true));
	tiles.append(make_tile(4, true));
	tiles.append(make_tile(6, false));
	tiles.append(make_tile(9, false));
	tiles.append(make_tile(1, false));
	Grid<_N,_M> grid_vale(tiles);


//	return Grid(3,3).random();
	return grid_vale;
}

double run(const Grid<_N,_M>& grid);

int main(int argc, char *argv[])
{
	srand ( time(NULL) );

	QList<double> times;
	double timeSum = 0.0f;
	int i;
	for(i = 0; i < 1; ++i) {
		Grid<_N,_M> grid = getGrid();
		qDebug() << "solving this grid:";
		grid.debugPrint();

		double lastTime = run(grid);
		timeSum += lastTime;
		times << lastTime;
	}

	qDebug() << "avg. time:" << timeSum / i << "s;" << "final times:" << times;

	return 0;
}

double run(const Grid<_N,_M>& grid)
{
	qDebug() << "started...";
	QTime time;
	time.start();

	Solver_DFS<_N,_M> solver;
	QList<Spin> result = solver.findSolution(grid);
	qDebug() << result;

	int elapsedMs = time.elapsed();
	double duration = (double)elapsedMs / 1000.0;
	qDebug() << "done. took" << duration << "s";

	return duration;
}
