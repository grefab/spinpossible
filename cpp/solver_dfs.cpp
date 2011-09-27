#include "solver_dfs.h"

bool Solver_DFS::traverse(const Grid& g, int depth, int maxDepth)
{
	if ( g == idealGrid ) {
		qDebug() << "Found at level" << depth;
		return true;
	}

	if( depth < maxDepth ) {
		foreach(Spin spin, allSpins) {
			bool found = traverse(g.permutated(spin), depth +1, maxDepth);
			if ( found ) {
				result << spin;
				return true;
			}
		}
	}

	return false;
}



QList<Spin> Solver_DFS::findSolution(const Grid &problemGrid)
{
	/* DFS (iterative deeping) */
	int maxDepth = 1;
	bool found = false;
	while(!found) {
		qDebug() << "max depth" << maxDepth;
		found = traverse(problemGrid, 0, maxDepth);
		++maxDepth;
	}

	return result;
}
