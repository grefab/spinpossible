#ifndef SOLVER_DFS_H
#define SOLVER_DFS_H

#include "solver.h"


template < int N, int M >
class Solver_DFS : public Solver<N,M>
{
public:
	virtual QList<Spin> findSolution(const Grid<N,M> &problemGrid)
	{
		/* DFS (iterative deeping) */
		int maxDepth = 1;
		bool found = false;
		while(!found) {
	//		qDebug() << "already visited" << beenThere.size();
			beenThere.clear();

	//		qDebug() << "max depth" << maxDepth;
			found = traverse(problemGrid, Spin(), 0, maxDepth);

			++maxDepth;
		}

		qDebug() << "visited" << beenThere.size() << "nodes";

		return result;
	}

private:
	QList<Spin> randomized(const QList<Spin>& list) const
	{
		QList<Spin> result = list;

		for( int i = 0; i < list.length(); ++i ) {
			int j = rand() % list.length();
			result.swap(i, j);
		}

		return result;
	}

	bool traverse(const Grid<N,M>& originalGrid, const Spin& spinToPerform, int depth, int maxDepth)
	{
		Grid<N,M> permutatedGrid = originalGrid.permutated(spinToPerform);

		if ( permutatedGrid == Grid<N,M>::idealGrid ) {
			qDebug() << "Found at level" << depth;
			return true;
		}

		if ( beenThere.contains(permutatedGrid.getHash()) ) {
			int foundAtLevel = beenThere[permutatedGrid.getHash()];

			if ( foundAtLevel <= depth ) {
				return false;
			}
		}

		beenThere[permutatedGrid.getHash()] = depth;

		if( depth < maxDepth ) {
			QList<Spin> availableSpins = getAvailableSpins(permutatedGrid, depth, maxDepth);

			foreach(const Spin& nextSpin, availableSpins) {
				if ( nextSpin.contains(spinToPerform) ) {
					/* omit spins that contain ourselves. we will get to this point somewhere else in the tree. */
					continue;
				}

				bool found = traverse(permutatedGrid, nextSpin, depth +1, maxDepth);
				if ( found ) {
					result << nextSpin;
					return true;
				}
			}
		}

		return false;
	}

	QList<Spin> getAvailableSpins(const Grid<N,M>& g, int depth, int maxDepth) const
	{
		if ( depth == maxDepth -1 ) {
			/* only return bounding box of broken spins */
			QList<Spin> result;
			result.append(g.boundingBoxOfMisplacedElements());

			return result;
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
	//	return randomized(allSpins);
		return allSpins;
	}

	QList<Spin> result;
	QHash<Tile, int> beenThere;
};

#endif // SOLVER_DFS_H
