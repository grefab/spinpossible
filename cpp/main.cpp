#include "spin.h"
#include "grid.h"
#include "tile.h"

#include "solver_bfs.h"
#include "solver_bfs_mt.h"
#include "solver_dfs.h"
#include "solver_dfs_random.h"

#include <QTime>

#include <QDebug>






int main(int argc, char *argv[])
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



	qDebug() << "started...";
	QTime time;
	time.start();

	Solver* solver = new Solver_DFS();
	QList<Spin> result = solver->findSolution(grid_mareike);
	qDebug() << result;
	delete solver;

	int elapsedMs = time.elapsed();
	qDebug() << "done. took" << (double)elapsedMs / 1000.0 << "s";

	return 0;
}
