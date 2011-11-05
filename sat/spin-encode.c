#include <stdio.h>

//#define NO_SINGLES
//#define NO_DOUBLES
#define SYMMETRY
//#define LOG_ENCODING
//#define ROW_COLUMN

int main ( int argc, char** argv )
{
    int d, i, j, k, l, tmp;
    int mark[10], marks[37][10];
    int colorvars = 9, nroftiles = 9;
#ifdef LOG_ENCODING
    colorvars = 4;
#endif
    for( i = 1; i <= 36; i++ ) for( k = 1; k <= nroftiles; k++ ) marks[i][k] = 0;

    if( argc != 11 )
    {
	printf("ERROR %i: incorrect input format: ./spin-encode <1>...<9> <moves>\n", argc );
	return 0;
    }

    int moves = atoi(argv[10]) + 1;
    int nrofvars = moves * 100 + (moves-1) * 36;
    int nrofclauses = 2 * nroftiles * (colorvars+1) * moves + 325 * (moves-1) + 200 * (colorvars+1) * (moves-1);
#ifdef ROW_COLUMN
    nrofclauses += (2*nroftiles*(colorvars+1) - 36*3 + 4) * (moves-1);
#endif
#ifdef SYMMETRY
    if( moves > 2 ) nrofclauses += (moves-2) * 535;
#endif
#ifdef NO_SINGLES
    nrofclauses += nroftiles * (moves-1) ; 
#endif
#ifdef NO_DOUBLES
    nrofclauses += 12 * (moves-1) ; 
#endif
    printf("p cnf %i %i\n", nrofvars, nrofclauses );

#ifdef NO_SINGLES
    for( i = 1; i < moves; i++ )
        for( j = 1; j <= nroftiles; j++ )
	    printf("-%i 0\n", 100 * moves + (i-1)*36 + j );
#endif
#ifdef NO_DOUBLES
    for( i = 1; i < moves; i++ )
        for( j = 10; j <= 15; j++ )
	    printf("-%i 0\n", 100 * moves + (i-1)*36 + j );

    for( i = 1; i < moves; i++ )
        for( j = 19; j <= 24; j++ )
	    printf("-%i 0\n", 100 * moves + (i-1)*36 + j );
#endif
     // fixing the initial state: nroftiles * (colorsvars + 1) clauses
    for( k = 1; k <= nroftiles; k++ )
    {
	tmp = abs(atoi(argv[k]));
	for( l = 1; l <= colorvars; l++ )
	{
#ifdef LOG_ENCODING
	    if( tmp % 2 )  printf("%i 0\n",  (k-1)*10 + l );
	    else           printf("-%i 0\n", (k-1)*10 + l );
	    tmp = tmp >> 1;
#else
	    if( l == tmp ) printf("%i 0\n",  (k-1)*10 + l );
	    else           printf("-%i 0\n", (k-1)*10 + l );
#endif
	}
	tmp = atoi(argv[k]);
	if( tmp < 0 ) 	   printf("%i 0\n",  (k-1)*10 + l );
	else         	   printf("-%i 0\n", (k-1)*10 + l );
    }

    // fixing the goal state: nroftiles * (colorsvars + 1) clauses
    for( k = 1; k <= nroftiles; k++ )
    {
	tmp = k;
	for( l = 1; l <= colorvars; l++ )
	{
#ifdef LOG_ENCODING
	    if( tmp % 2 ) printf("%i 0\n",  (moves-1)*100 + (k-1)*10 + l );
	    else          printf("-%i 0\n", (moves-1)*100 + (k-1)*10 + l );
	    tmp = tmp >> 1;
#else
	    if( k == l )  printf("%i 0\n",  (moves-1)*100 + (k-1)*10 + l );
	    else          printf("-%i 0\n", (moves-1)*100 + (k-1)*10 + l );
#endif
	}
	printf("-%i 0\n", (moves-1)*100 + (k-1)*10 + l );
    }

    // equivalence constraints: 2 * nroftiles * (colorvars+1) clauses per MOVE
#ifdef ROW_COLUMN
    for( i = 1; i < moves; i++ )
    {
	tmp = i*100 - 10;
	for( k = 0; k < nroftiles; k++ )
	    for( l = 1; l <= (colorvars+1); l++ )
	    {
		int s = (i-1)*100 + k*10 + l;
		printf("-%i %i -%i 0\n", tmp + (k/3) + 1, s,  s+100 );
		printf("-%i -%i %i 0\n", tmp + (k/3) + 1, s,  s+100 );
		printf("-%i %i -%i 0\n", tmp + (k%3) + 4, s,  s+100 );
		printf("-%i -%i %i 0\n", tmp + (k%3) + 4, s,  s+100 );
	    }

	printf("-%i -%i -%i 0\n", tmp+1, tmp+2, tmp+3 );
	printf("-%i -%i -%i 0\n", tmp+4, tmp+5, tmp+6 );
	printf("%i -%i %i 0\n", tmp+1, tmp+2, tmp+3 );
	printf("%i -%i %i 0\n", tmp+4, tmp+5, tmp+6 );
    }
#else
    for( i = 1; i < moves; i++ )
	for( k = 1; k <= nroftiles; k++ )
	    for( l = 1; l <= (colorvars+1); l++ )
	    {
		int e = 100*i-10+k;
		int f = 100*i-10*(11-k)+l;
		printf("-%i -%i %i 0\n", e, f, f + 100 );
		printf("-%i %i -%i 0\n", e, f, f + 100 );
	    }
#endif

    // clauses for the transition constraints
    tmp = moves * 100;
    for( i = 1; i < moves; i++ )
    {
	for( j=1; j<=36; j++ ) printf("%i ", tmp + j); printf("0\n");

	for( d=0; d <=8; d++ )
	    for( j=1; j<=9-d; j++ )
	    {
		if( ((j-1)%3) + (d%3) >= 3 ) continue;

		tmp++;
		for( k = 0; k < 3; k++ )
		    if( d%3 >= k ) { mark[ j+k ] = tmp; mark[ j+d-k ] = tmp; }

		if( d>=3 ) { mark[j+3] = tmp; mark[j+d-3] = tmp; }
		if( d==8 )   mark[5  ] = tmp;

		for( k = 1; k <= nroftiles; k++ )
		    if( mark[ k ] == tmp )
		    {
			if( tmp <= moves * 100 + 36 ) marks[ tmp - moves * 100 ][ k ] = 1;
#ifndef ROW_COLUMN
			printf("-%i -%i 0\n",  tmp, i*100 - 10 + k );
#endif
			for( l = 1; l <= colorvars; l++ )
			{
			    printf("-%i %i -%i 0\n", tmp, (i-1)*100 + (k-1)*10+l, i*100 + (2*j+d-k-1)*10+l );
			    printf("-%i -%i %i 0\n", tmp, (i-1)*100 + (k-1)*10+l, i*100 + (2*j+d-k-1)*10+l );
			}
			printf("-%i %i %i 0\n",   tmp, (i-1)*100 + (k-1)*10+l, i*100 + (2*j+d-k-1)*10+l );
			printf("-%i -%i -%i 0\n", tmp, (i-1)*100 + (k-1)*10+l, i*100 + (2*j+d-k-1)*10+l );
		    }
#ifndef ROW_COLUMN
		    else printf("-%i %i 0\n", tmp, i*100 - 10 + k );
#endif
	    }
    }

#ifdef ROW_COLUMN
    tmp = moves * 100;
    for( i = 1; i < moves; i++ )
      for( j = 1; j <= 36; j++ )
      {
        tmp++;
	for( k = 0; k <= 2; k++ )
	{
	    int flag = marks[j][3*k+1] | marks[j][3*k+2] | marks[j][3*k+3];
	    if (flag) printf("-%i -%i 0\n", tmp, i*100 - 9 + k );
	    else      printf("-%i %i 0\n" , tmp, i*100 - 9 + k );
	}
	for( k = 1; k <= 3; k++ )
	{
	    int flag = marks[j][k+0] | marks[j][k+3] | marks[j][k+6];
	    if (flag) printf("-%i -%i 0\n", tmp, i*100 - 7 + k );
	    else      printf("-%i %i 0\n" , tmp, i*100 - 7 + k );
	}
      }
#endif

#ifdef SYMMETRY
    for( i = 1; i <= 36; i++ )
	for( j = 1; j <= i; j++ )
	{
	    int flag = 0;
	    for( k = 1; k <= nroftiles; k++ )
	    {
		if( marks[ i ][ k ] == 1 && marks[ j ][ k ] == 1 ) flag |= 1;
		if( marks[ i ][ k ] == 1 && marks[ j ][ k ] == 0 ) flag |= 2;
		if( marks[ i ][ k ] == 0 && marks[ j ][ k ] == 1 ) flag |= 4;
	    }

	    if( flag != 7 )
	        for( k = 1; k < moves - 1; k++ )
		    printf("-%i -%i 0\n", moves*100 +(k-1)*36 + i, moves * 100 + k*36 + j );
	}
#endif
}
