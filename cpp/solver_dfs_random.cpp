#include "solver_dfs_random.h"



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

QList<Spin> Solver_DFS_Random::findSolution(const Grid &problemGrid)
{
	while(true) {
		bool found = randomTraverse(problemGrid, 0, 5);
		if ( found ) {
			break;
		}
	}
}
