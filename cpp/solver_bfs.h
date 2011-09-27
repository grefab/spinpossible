#ifndef SOLVER_BFS_H
#define SOLVER_BFS_H

#include "solver.h"

class Solver_BFS : public Solver
{
public:
	virtual QList<Spin> findSolution(const Grid &problemGrid);
};

#endif // SOLVER_BFS_H
