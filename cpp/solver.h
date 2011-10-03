#ifndef SOLVER_H
#define SOLVER_H

#include <QList>
#include "spin.h"
#include "grid.h"

#include <QDebug>

template < int N, int M >
class Solver
{
public:
	virtual QList<Spin> findSolution(const Grid<N,M>& problemGrid) =0;

};

#endif // SOLVER_H
