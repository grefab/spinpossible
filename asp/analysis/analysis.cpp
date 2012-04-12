#include <iostream>
#include <cmath>
#include <sstream>
#include <stdio.h>
#include <list>
#include <utility>
#include <set>
#include <time.h>
#include <algorithm>
#include <boost/foreach.hpp>
#include <boost/functional/hash.hpp>
#include "analysis.h"


typedef std::pair<uint,uint> Spin;
typedef std::set<Spin>  Spins;
typedef std::vector<Spins>  SuperSpins;

void createSubsets(SuperSpins& superset) {
    std::vector<Spin> allSpins;
    for (uint x = 0; x < X; x++) {
        for (uint y = 0; y < Y; y++) {
            allSpins.push_back(Spin(X-x,Y-y));
        }
    }
    Spins first;
    //first.insert(allSpins.back());
    //allSpins.pop_back();
    superset.push_back(first);

    // allSpins has all combination of spin types 
    
    for(uint i = 0; i < allSpins.size(); i++) {
        uint size = superset.size();
        for(uint j = 0; j < size; j++) {
            Spins s = superset[j];

            s.insert(allSpins[i]);  

            superset.push_back(s);
        }
    }
}

void printSpins(Spins spins) {
    cout << "spins ";
    BOOST_FOREACH(Spin s, spins) {
        cout << s.first << "x" << s.second << " ";
    }
    cout << endl;
}




Grasp::Grasp() {
    _solved_bit.reset();
    _solved_normal.reset();
    for(uint i = 0; i < MAX_STEP; i++) {
        _bit[i].reset();
        _normal[i].reset();
    }
    _bit[0][0] = 1; 
    _normal[0][0] = 1; 
}




/*
 * comparing fixed with nofixed strategy
 */
void Grasp::search1() {
    time_t total;
    time(&total);

    for(uint step = 0; step < MAX_STEP; step++) {
        time_t start;
        time(&start);
        for(uint hash = 0; hash < SIZE && ( !step == 0 || hash == 0); hash++) {
            if (_solved_bit[hash]) { 
                _bit[step][hash] = 0;
                continue;
            } else if (_bit[step][hash]) {
                _solved_bit[hash] = 1; 
                int board1[X][Y]; 
                hash_to_board(hash,board1); 
                //print(board1);
                //cout << endl;
                for (uint x = 0; x < X; x++) {
                    for (uint y = 0; y < Y; y++) {
                        for (uint xx = x; xx < X; xx++) {
                            for (uint yy = y; yy < Y; yy++) {
                                int board2[X][Y]; 
                                Co c1(x,y); 
                                Co c2(xx,yy); 
                                Move move(c1,c2);
                                update(move,board1,board2); 
                                if (is_valid_move(move,board2)) {
                                    _bit[step+1][board_to_hash(board2)] = 1; 
                                }
                            }
                        }
                    }
                }
            } 
        }
        for(uint hash = 0; hash < SIZE && ( !step == 0 || hash == 0); hash++) {
            if (_solved_normal[hash]) { 
                _normal[step][hash] = 0;
                continue;
            } else if (_normal[step][hash]) {
                _solved_normal[hash] = 1; 
                int board1[X][Y]; 
                hash_to_board(hash,board1); 
                //print(board1);
                //cout << endl;
                for (uint x = 0; x < X; x++) {
                    for (uint y = 0; y < Y; y++) {
                        for (uint xx = x; xx < X; xx++) {
                            for (uint yy = y; yy < Y; yy++) {
                                int board2[X][Y]; 
                                Co c1(x,y); 
                                Co c2(xx,yy); 
                                Move move(c1,c2);
                                update(move,board1,board2); 
                                _normal[step+1][board_to_hash(board2)] = 1; 
                            }
                        }
                    }
                }
            } 
        }
        cout << step << "\t" << _normal[step].count() << "\t" << _bit[step].count() << "\t";;
        cout.precision(2);
        cout << (int) difftime(time(NULL),start) << " sec." << endl;
        for(uint hash = 0; hash < SIZE && ( !step == 0 || hash == 0); hash++) {
            if(_normal[step][hash] != _bit[step][hash]) {
                int board[X][Y];
                hash_to_board(hash,board);
                cout << endl;
                print(board);
            }
        }

    }
    cout << "total\t" << _solved_bit.count() << "\t";
    cout << (int) difftime(time(NULL),total) << " sec." << endl;
}

/*
 *  Determine the the maximum number of spins in an optimal
 *  solution to a 3x3 Spinpossible board that only allows 2x2
 *  square, 3x1 row, and 1x3 column spins.
 */

bool comp(Spins a, Spins b) {
    return a.size() < b.size();
}

void Grasp::search2() {
    time_t total;
    time(&total);

    SuperSpins superset;
    createSubsets(superset);

    std::sort(superset.begin(),superset.end(),comp);

    for(uint index = superset.size()-1; index < superset.size(); index ++) {

        Spins spins = superset[index];
        cout << endl;
        printSpins(spins);
        cout << endl;

        time_t total;
        time(&total);
        _normal[0].reset();
        _normal[0][0] = 1; 
        _normal[1].reset();
        _solved_normal.reset();

        int now = 0;
        for(uint step = 0; _normal[now].any(); step++) {
            _normal[(now+1)%2].reset();
            time_t start;
            time(&start);
            for(uint hash = 0; hash < SIZE && ( !step == 0 || hash == 0); hash++) {
                if (_normal[now][hash]) {
                    _solved_normal[hash] = 1; 
                    int board1[X][Y]; 
                    hash_to_board(hash,board1); 
                    for (uint x = 0; x < X; x++) {
                        for (uint y = 0; y < Y; y++) {
                            for (uint xx = x; xx < X; xx++) {
                                for (uint yy = y; yy < Y; yy++) {
                                    Co c1(x,y); 
                                    Co c2(xx,yy); 
                                    Move move(c1,c2);

                                    if ( spins.count(Spin(xx-x+1,yy-y+1)) > 0) {
                                        int board2[X][Y]; 
                                        update(move,board1,board2); 
                                        uint new_hash = board_to_hash(board2);
                                        if (_solved_normal[new_hash] == 0) {
                                            _normal[(now+1)%2][new_hash] = 1; 
                                        }
                                    }
                                }
                            }
                        }
                    }
                } 
            }
            cout << step << "\t" << _normal[now].count() << "\t";;
            cout.precision(2);
            cout << (int) difftime(time(NULL),start) << " sec." << endl;

            if (step > 1 && _normal[(now+1)%2].count() == 0 ) {//&& _normal[(now)%2].count() < 1000) {
                for(uint hash = 0; hash < SIZE; hash++) {
                    if(_normal[(now)%2][hash]) {
                        int board[X][Y];
                        hash_to_board(hash,board);
                        cout << endl;
                        print(board);
                    }
                }
            }
            now = (now+1)%2;
        }
        
        cout << "\ntotal\t" << _solved_normal.count() << "\t";
        cout << (int) difftime(time(NULL),total) << " sec." << endl;
    }
}

void Grasp::search3() {
    time_t total;
    time(&total);
    _normal[0].reset();
    _normal[0][0] = 1; 
    _normal[1].reset();
    _bit[0].reset();
    _bit[0][0] = 1; 
    _bit[1].reset();
    _solved_normal.reset();

    int now = 0;
    for(uint step = 0; _normal[now].any(); step++) {
        _normal[(now+1)%2].reset();
        _bit[(now+1)%2].reset();
        //_unique.reset();
        time_t start;
        time(&start);
        for(uint hash = 0; hash < SIZE && ( !step == 0 || hash == 0); hash++) {
            if (_normal[now][hash]) {
                _solved_normal[hash] = 1; 
                int board1[X][Y]; 
                hash_to_board(hash,board1); 
                for (uint x = 0; x < X; x++) {
                    for (uint y = 0; y < Y; y++) {
                        for (uint xx = x; xx < X; xx++) {
                            for (uint yy = y; yy < Y; yy++) {
                                Co c1(x,y); 
                                Co c2(xx,yy); 
                                Move move(c1,c2);

                                int board2[X][Y]; 
                                update(move,board1,board2); 
                                uint new_hash = board_to_hash(board2);

                                if (_solved_normal[new_hash] == 0) {
                                    _normal[(now+1)%2][new_hash] = 1; 

                                    if ( _unique[new_hash] == 0) {
                                        if (_bit[now][hash] == 1) {
                                            _bit[(now+1)%2][new_hash] = 1;
                                        }
                                    } else {
                                       _bit[(now+1)%2][new_hash] = 0;
                                    }
                                }
                                if ( _unique[new_hash] == 0) {
                                    _unique[new_hash] = 1;
                                }
                            }
                        }
                    }
                }
            } 
        }

        cout << step << "\t" << _normal[now].count() << "\t" << _bit[now].count() << "\t";;
        cout.precision(2);
        cout << (int) difftime(time(NULL),start) << " sec." << endl;

        if (step >= 5) {
            for(uint hash = 0; hash < SIZE && ( !step == 0 || hash == 0); hash++) {
                if(_bit[(now)%2][hash]) {
                    int board[X][Y];
                    hash_to_board(hash,board);
                    cout << endl;
                    print(board);
                }
            }
        }

        if (step > 1 && _bit[(now+1)%2].count() == 0 && _bit[(now)%2].count() < 1000) {
            for(uint hash = 0; hash < SIZE; hash++) {
                if(_bit[(now)%2][hash]) {
                    int board[X][Y];
                    hash_to_board(hash,board);
                    cout << endl;
                    print(board);
                }
            }
        }
        now = (now+1)%2;
    }
    
    cout << "\ntotal\t" << _solved_normal.count() << "\t";
    cout << (int) difftime(time(NULL),total) << " sec." << endl;
}

// defines strategy
bool is_valid_move(Move move, int board[][Y]) {

    bool is_valid_move = false; 
    //for (uint x = 0; x < X; x++) {
    uint x = 0; 
    if (move.first.first == x ) {
        for (uint y = 0; y < Y && !is_valid_move; y++) {
            if (board[x][y] < 0 || abs(board[x][y]) != x*2+y+1) is_valid_move = true;
        }
    } else {
        is_valid_move = true;
    }
    //}
    return is_valid_move;
}


int main() {
    run();
    //test();
    return 0;
}


int run() {
    Grasp g; 
    g.search2();
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

    if ( r >= SIZE ) {
        cout << "ERROR overflow\t: hash value with " << r << endl;
        print(board);
    }
    //cout << r << endl; 
    return r;
}
