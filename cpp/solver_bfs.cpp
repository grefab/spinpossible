#include "solver_bfs.h"

#include <QQueue>


QList<Spin> Solver_BFS::findSolution(const Grid &problemGrid)
{
	QQueue<Grid> openList;
	openList.enqueue(problemGrid);
	while(!openList.empty()) {
		Grid g = openList.dequeue();
		if( g == idealGrid ) {
			qDebug() << "found!";
			qDebug() << "List size:" << openList.size();
			break;
		}
		if ( openList.size() > 1727605 ) {
			continue;
		}
		foreach(Spin spin, allSpins) {
			openList.enqueue(g.permutated(spin));
		}
	}
}
