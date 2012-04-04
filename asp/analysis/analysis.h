#ifndef imp_h
#define imp_h

#include <boost/functional/hash.hpp>
#include <cstdlib>
#include <bitset>
#include <queue>

// max board {-9,-8,-7,-6,-5,-4,-3,-2,-1}
#define SIZE 602618880 

#define X 3
#define Y 3

#define MAX_STEP 10

using namespace std;

typedef pair<uint,uint> Co; // coordinate
typedef pair<Co,Co> Move;

void update(Move move, int board[][Y], int result[][Y]);
void print(int board[][Y]);
unsigned int board_to_hash(int[][Y]);
void hash_to_board(uint,int[][Y]);
bool is_valid_move(Move move, int board[][Y]);


int run();

class Grasp {

    public:

        Grasp();

        void search();
        void search2();
        void search3();

    private:

        bitset<SIZE> _solved_bit;
        bitset<SIZE> _solved_normal;
        bitset<SIZE> _unique;
        bitset<SIZE> _bit[MAX_STEP];
        bitset<SIZE> _normal[MAX_STEP];
};

#endif
