#ifndef SOLVER_DFS_RANDOM_H
#define SOLVER_DFS_RANDOM_H

#include "solver.h"

class Solver_DFS_Random : public Solver
{
public:
    virtual QList<Spin> findSolution(const Grid &problemGrid);
};

#endif // SOLVER_DFS_RANDOM_H
