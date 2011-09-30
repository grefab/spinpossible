#ifndef SOLVER_DFS_H
#define SOLVER_DFS_H

#include "solver.h"


class Solver_DFS : public Solver
{
public:
	virtual QList<Spin> findSolution(const Grid &problemGrid);

private:
	bool traverse(const Grid& g, const Spin& spinToPerform, int depth, int maxDepth);
	QList<Spin> getAvailableSpins(const Grid& g, int depth, int maxDepth) const;

	QList<Spin> result;
	QHash<Tile, int> beenThere;
};

#endif // SOLVER_DFS_H
