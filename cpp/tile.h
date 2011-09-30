#ifndef TILE_H
#define TILE_H

typedef int Tile;

Tile make_tile(int number, bool up);

//struct Tile {
//	Tile() :
//		number_(0)
//	{}

//	Tile(int number, bool up)
//	{
//		number_ = up ? number : -number;
//	}

//	bool operator ==(const Tile& rhs) const {
//		return number_ == rhs.number_;
//	}

//	bool operator !=(const Tile& rhs) const {
//		return number_ != rhs.number_;
//	}

//	bool operator <(const Tile& rhs) const {
//		return number_ < rhs.number_;
//	}

//	bool operator >(const Tile& rhs) const {
//		return number_ > rhs.number_;
//	}

//	int number_;
//};

#endif // TILE_H
