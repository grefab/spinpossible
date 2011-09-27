#ifndef SOLVER_BFS_MT_H
#define SOLVER_BFS_MT_H

#include "solver.h"

class Solver_BFS_MT : public Solver
{
public:
	virtual QList<Spin> findSolution(const Grid &problemGrid);
};

#endif // SOLVER_BFS_MT_H
