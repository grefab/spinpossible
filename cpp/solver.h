#ifndef SOLVER_H
#define SOLVER_H

#include <QList>
#include "spin.h"
#include "grid.h"

#include <QDebug>

static const QList<Spin> allSpins = getAllSpins<3, 3>();
static const Grid idealGrid(3,3);

class Solver
{
public:
    virtual QList<Spin> findSolution(const Grid& problemGrid) =0;

};

#endif // SOLVER_H
