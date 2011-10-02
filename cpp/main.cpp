#include "spin.h"
#include "grid.h"
#include "tile.h"

#include "solver_dfs.h"
#include "external/qjson/src/parser.h"

#include <QFile>
#include <QVariant>
#include <QTime>

#include <QDebug>

#define _N 3
#define _M 3

double run(const Grid<_N,_M>& grid);
Grid<_N,_M> gridFromFile(QString filename);

int main(int argc, char *argv[])
{
	qDebug() << argc;

	Grid<_N,_M> problemGrid;
	if ( argc >= 2 ) {
		problemGrid = gridFromFile(argv[1]);
	}

	srand ( time(NULL) );

	QList<double> times;
	double timeSum = 0.0f;
	int i;
	for(i = 0; i < 1; ++i) {
		Grid<_N,_M> grid = problemGrid;
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

Grid<_N,_M> gridFromFile(QString filename)
{
	/* we expect a filename as parameter */
	QFile file(filename);

	if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
		qDebug() << "Could not open file:" << filename;
		return Grid<_N,_M>();
	}

	QJson::Parser parser;
	bool ok = false;
	QVariantMap problemGridVariant = parser.parse(&file, &ok).toMap();

	if (!ok) {
		qDebug() << "Could not parse file contents of" << filename << "(expected plain JSON)";
		return Grid<_N,_M>();
	}

	QString type = problemGridVariant["type"].toString();
	QVariantList dimension = problemGridVariant["dimension"].toList();
	QVariantList gridData = problemGridVariant["grid"].toList();

	if ( type != "application/spinpossible" ) {
		qDebug() << "Did not find expected JSON content (type == application/spinpossible).";
		return Grid<_N,_M>();
	}

	int w = dimension[0].toInt();
	int h = dimension[1].toInt();

	if( w != 3 || h != 3 ) {
		qDebug() << "Only able to solve" << _N << "x" << _M << "puzzles.";
		return Grid<_N,_M>();
	}

	QList<Tile> gridTiles;
	foreach(QVariant tv, gridData) {
		gridTiles.append(tv.toInt());
	}

	Grid<_N,_M> grid(gridTiles);

	return grid;
}
