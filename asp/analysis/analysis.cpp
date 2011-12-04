#include <iostream>
#include <cmath>
#include <sstream>
#include <stdio.h>
#include <list>
#include <time.h>
#include <boost/functional/hash.hpp>
#include "analysis.h"

Grasp::Grasp() {
    _solved.reset();
    for(uint i = 0; i < MAX_STEP; i++) {
        _bit[i].reset();
    }
    _bit[0][0] = 1; 
}

void Grasp::search() {
    time_t total;
    time(&total);
    for(uint step = 0; step < MAX_STEP; step++) {
        time_t start;
        time(&start);
        for(uint hash = 0; hash < SIZE && ( !step == 0 || hash == 0); hash++) {
            if (_solved[hash]) { 
                _bit[step][hash] = 0;
                continue;
            } else if (_bit[step][hash]) {
                _solved[hash] = 1; 
                int board1[X][Y]; 
                hash_to_board(hash,board1); 
                for (uint x = 0; x < X; x++) {
                    for (uint y = 0; y < Y; y++) {
                        for (uint xx = x; xx < X; xx++) {
                            for (uint yy = y; yy < Y; yy++) {
                                int board2[X][Y]; 
                                Co c1(x,y); 
                                Co c2(xx,yy); 
                                Move move(c1,c2);
                                update(move,board1,board2); 
                                _bit[step+1][board_to_hash(board2)] = 1; 
                            }
                        }
                    }
                }
            } 
        }
        cout << step << "\t" << _bit[step].count() << "\t";
        cout.precision(2);
        cout << (int) difftime(time(NULL),start) << " sec." << endl;
    }
    cout << "total\t" << _solved.count() << "\t";
    cout << (int) difftime(time(NULL),total) << " sec." << endl;
}


int main() {
    run();
    //test();
    return 0;
}


int run() {
    Grasp g; 
    g.search();
    return 0; 
}

void update(Move move, int board[][Y], int result[][Y]) {
    uint dx = move.first.first + move.second.first;
    uint dy = move.first.second + move.second.second;
    //cout << "dx,dy: " << dx << "," << dy << endl;

    for (uint x = 0; x < X; x++) {
        for (uint y = 0; y < Y; y++) {
            if(x >= move.first.first && x <= move.second.first &&
               y >= move.first.second && y <= move.second.second) {
               result[dx-x][dy-y] = -board[x][y]; 
            } else {
               result[x][y] = board[x][y]; 
            }
        }
    }
}

void print(int board[][Y]) {
    for(uint x=0; x < X; x++) {
        for(uint y=0; y < Y; y++) {
            cout << " "; 
            if (board[x][y] > 0) cout << " "; 
            cout << board[x][y];
        }
        cout << endl; 
    }
}


void hash_to_board(uint hash, int board[][Y]) {
    
    int numbers[X*Y];
    uint remain = X*Y; 
    for (uint i = 0; i < X*Y; i++) {
        numbers[i] = i+1;
        if (i > 0) remain += ceil(log2(i+1));
    }

    list<int> list_num(numbers,numbers+X*Y);

    for (uint x = 0; x < X; x++) {
        for (uint y = 0; y < Y; y++) {
            if( x == X-1 && y == Y-1) {
                board[x][y] = list_num.front();
            }
            unsigned int size = list_num.size();
            unsigned int shift = ceil(log2(size)); // r will be lg(v)
            uint mask = pow(2,shift)-1; 
            remain -= shift;
            mask = mask << remain;
            uint pos = (mask & hash) >> remain;

            //bitset<30> pr;
            //pr = mask;
            //cout << "mask\t: " << pr.to_string() << endl; 
            //cout << "pos\t: " << pos << endl; 
            uint i = 0; 
            for (list<int>::iterator it=list_num.begin(); it!=list_num.end(); ++it) {
                if (pos == i) {
                    board[x][y] = *it;
                    break;
                }
                i++;
            }
            list_num.remove(board[x][y]); 
            //cout << "element\t" << board[x][y] << endl; 
        }
    }
    uint mask = pow(2,X*Y)-1; 
    bitset<X*Y> parity = hash & mask;
    //cout << "parity\t" << parity.to_string() << endl; 
    for (uint x = 0; x < X; x++) {
        for (uint y = 0; y < Y; y++) {
            if (parity[X*Y-1-(x*X+y)]) {
                board[x][y] = -board[x][y];
            } 
        }
    }    

}


unsigned int board_to_hash(int board[][Y]) {

    unsigned long r = 0;
    
    int numbers[X*Y];
    for (uint i = 0; i < X*Y; i++) {
        numbers[i] = i+1;
    }
    list<int> poslist(numbers,numbers+X*Y);

    for (uint x = 0; x < X; x++) {
        for (uint y = 0; y < Y; y++) {
            if( x == X-1 && y == Y-1) break;
            //cout << "==============================" << endl; 
            //cout << "cell position\t: " << x << "," << y << endl; 
            int pos = 0; 
            for (list<int>::iterator it=poslist.begin(); it!=poslist.end(); ++it) {
                if(abs(board[x][y]) == *it) {
                    //cout << "element\t: " << board[x][y] << endl; 
                    //cout << "position in remainging table\t: " << pos << endl; 
                    unsigned int size = poslist.size();
                    unsigned int shift = ceil(log2(size)); // r will be lg(v)
                    //cout << "size\t: " << size << endl; 
                    //cout << "left shift << steps\t: " << shift << endl; 
                    poslist.remove(abs(board[x][y]));
                    r = r << shift; 
                    r = r + pos;
                    //cout << "do\t: r << " << shift << "; r + pos; r = " << r << endl;
                    break;
                }
                pos++;
            }
        }
   
    }
    unsigned int parity = 0;

    for (uint x = 0; x < X; x++) {
        for (uint y = 0; y < Y; y++) {
            parity = parity << 1;
            if (board[x][y] < 0) {
                parity = parity + 1;
            } 
        }
    }    
    //cout << "convert \t: bitset to string " << parity << endl;
    r = r << X*Y; 
    r += parity; 

    if ( r > pow(2,31) ) {
        cout << "ERROR overflow\t: hash value with " << r << endl;
    }
    //cout << r << endl; 
    return r;
}

int test() 
{

    //int result[3][3] = {{0}};
    ////cout << "size of " << sizeof(solved) << endl;
    //int board[3][3] = {{-9,4,-7},{-6,-5,8},{-3,-2,-1}};
    //print(board); 
    //uint hash = board_to_hash(board);
    //bitset<30> bits(hash); 
    //cout << "bits of board " << bits.to_string() << endl;
    //hash_to_board(hash,result);
    //print(result);

    //int board1[3][3] = {{-1,2,3},{4,-5,6},{7,8,9}};
    //int board2[3][3] = {{0}}; 

    //Co c1(1,1); 
    //Co c2(1,2); 
    //Move move1(c1,c2);

    //update(move1,board1,board2); 
    //cout << endl;
    //hash_to_board(board_to_hash(board),result);
    //print(result);
    //cout << endl;
    //hash_to_board(board_to_hash(board1),result);
    //print(result);
    //cout << endl;
    //hash_to_board(board_to_hash(board2),result);
    //print(result);
    //cout << endl;
    ////cout << "board 1" << endl; 
    ////print(board1);
    ////bits = board_to_hash(board1);
    ////cout << "bits of board1 " << bits.to_string() << endl;


    ////print(board2);
    ////cout << "board 2" << endl; 
    ////bits = board_to_hash(board2);
    ////cout << "bits of board2 " << bits.to_string() << endl;

    return 0;
} 
