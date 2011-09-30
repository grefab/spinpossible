#include "tile.h"

Tile make_tile(int number, bool up)
{
	return up ? number : -number;
}
