#include "spin.h"

bool isBefore(const Spin& a, const Spin& b)
{
	if ( a.y() < b.y() )
		return true;

	if ( a.y() > b.y() )
		return false;

	if ( a.x() < b.x() )
		return true;

	if ( a.x() > b.x() )
		return false;

	if ( a.height() < b.height() )
		return true;

	if ( a.height() > b.height() )
		return false;

	if ( a.width() < b.width() )
		return true;

	if ( a.width() > b.width() )
		return false;

	/* equal, so not before. */
	return false;
}
