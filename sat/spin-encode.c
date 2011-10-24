#include <stdio.h>

//#define NO_SINGLES
//#define NO_DOUBLES

int main ( int argc, char** argv )
{
    int d, i, j, k, l, m;
    int tmp;
    int mark[10];

    if( argc != 11 )
    {
	printf("ERROR %i: incorrect input format: ./spin-encode <1>...<9> <moves>\n", argc );
	return 0;
    }

    int moves = atoi(argv[10]) + 1;
    int nrofvars = moves * 100 + (moves-1) * 36;
    int nrofclauses = 189 + 2514 * (moves-1);

//    nrofclauses -= 9*moves;
    nrofclauses += moves * 36 * 9;
#ifdef NO_SINGLES
	nrofclauses += 9 * (moves-1) ; 
#endif
#ifdef NO_DOUBLES
	nrofclauses += 12 * (moves-1) ; 
#endif
    printf("p cnf %i %i\n", nrofvars, nrofclauses );

#ifdef NO_SINGLES
    for( i = 1; i < moves; i++ )
        for( j = 1; j <= 9; j++ )
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

    for( i = 1; i <= 9; i++ )
    {
	tmp = atoi(argv[i]);

	for( k = 1; k <= 9; k++ )
	    if( k == abs(tmp) ) printf("%i 0\n",  (i-1)*10 + k );
	    else                printf("-%i 0\n", (i-1)*10 + k );

	printf("%i 0\n", tmp < 0?i*10:-i*10 ); 
    }

    for( i = 1; i <= moves; i++ )
	for( k = 1; k <= 9; k++ )
	{
	    for( l = 1; l <= 9; l++ )
		printf("%i ", (i-1)*100 + (k-1)*10 + l );
	    printf("0\n"); 

	    for( l = 1; l <= 9; l++ )
	        for( m = l+1; m <= 9; m++ )
		    printf("-%i -%i 0\n", (i-1)*100 + (k-1)*10 + l, (i-1)*100 + (k-1)*10 + m );
	}

    // fixing last states: 90 clauses
    for( k = 1; k <= 9; k++ )
	for( l = 1; l <= 10; l++ )
	    if( k == l ) printf("%i 0\n",  (moves-1)*100 + (k-1)*10 + l );
	    else         printf("-%i 0\n", (moves-1)*100 + (k-1)*10 + l );

    // equivalence constraints" : 90 clauses per MOVE
    for( i = 1; i < moves; i++ )
	for( k = 1; k <= 9; k++ )
	    for( l = 1; l <= 10; l++ )
	    {
		int e = 100*i-10+k;
		int f = 100*i-10*(11-k)+l;
		printf("-%i -%i %i 0\n", e, f, f + 100 );
		printf("-%i %i -%i 0\n", e, f, f + 100 );
	    }

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

		for( k=1; k<=9; k++ )
		    if( mark[ k ] == tmp )
		    {
			printf("-%i -%i 0\n",  tmp, i*100 - 10 + k );
			for( l=1; l <= 9; l++ )
			{
			    printf("-%i %i -%i 0\n", tmp, (i-1)*100 + (k-1)*10+l, i*100 + (2*j+d-k-1)*10+l );
			    printf("-%i -%i %i 0\n", tmp, (i-1)*100 + (k-1)*10+l, i*100 + (2*j+d-k-1)*10+l );
			}
			printf("-%i %i %i 0\n",   tmp, (i-1)*100 + k*10, i*100 + (2*j+d-k)*10 );
			printf("-%i -%i -%i 0\n", tmp, (i-1)*100 + k*10, i*100 + (2*j+d-k)*10 );
		    }
		    else printf("-%i %i 0\n", tmp, i*100 - 10 + k );
	    }
    }
}
