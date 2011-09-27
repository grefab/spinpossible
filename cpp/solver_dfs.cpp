#include "solver_dfs.h"


bool Solver_DFS::traverse(const Grid& g, int depth, int maxDepth)
{
	if ( g == idealGrid ) {
		qDebug() << "Found at level" << depth;
		return true;
	}

	if( depth < maxDepth ) {
		QList<Spin> availableSpins = getAvailableSpins(g, depth, maxDepth);

		foreach(const Spin& spin, availableSpins) {
			Grid permutatedGrid = g.permutated(spin);

			bool found = traverse(permutatedGrid, depth +1, maxDepth);
			if ( found ) {
				result << spin;
				return true;
			}
		}
	}

	return false;
}

QList<Spin> Solver_DFS::getAvailableSpins(const Grid& g, int depth, int maxDepth) const
{
	if ( depth == maxDepth -1 ) {
		/* only return bounding box of broken spins */
		QList<Spin> result;
		result.append(g.boundingBoxOfMisplacedElements());
	}

	if ( depth == maxDepth -2 ) {
		/* only allow spins that do not change already in-place tiles */
		QList<Spin> result;

		foreach(Spin s, allSpins) {
			if ( !g.containsCorrectElements(s) ) {
				result.append(s);
			}
		}

		return result;
	}

	/* no optimization possibility fond; try everything. */
	return allSpins;
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
