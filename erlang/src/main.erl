-module(main).
-export([find/2, find/3, spin/2, ideal_input/2, get_spin_possibilites/1, is_solved/1, is_valid/1]).
-compile(export_all).

-record(grid, {width, height, data}).
-record(point, {x, y}).
-record(rect, {left, top, width, height}).

x() ->
	I=ideal_input(3,3),
	P={grid,3,3,[{5,true},{2,true},{3,true},{6,true},{1,true},{4,true},{7,true},{8,true},{9,true}]},
	find(I,P).

find(Key, Node) ->
	find(Key, Node, []).
find(Key, Key, Path) ->
	io:format("Path: ~p~n", [Path]),
	Path;
find(Key, Node, Path) ->
	Children = permutate(Node),
	spawn_children(Key, Node, Path, Children).

spawn_children(_Key, _Node, Path, _Children) when length(Path) > 3 -> 
%	io:format("pathlength: ~p~n", [length(Path)]);
	false;
spawn_children(_Key, _Node, _Path, []) -> 
%	io:format("children empty.~n");
	true;
spawn_children(Key, Node, Path, [Child|Children]) ->
	spawn(?MODULE, find, [Key, Child, [Node|Path]]),
%	find(Key, Child, [Node|Path]),
	spawn_children(Key, Node, Path, Children).



%find(_Key, undefined) -> false;
%find(Key,  Root)      -> find(Key, [Root], [], 0).

%find(_Key, [], [], _Path) -> % No more children
%    false;
%find(Key, [], Children, Path) -> % Next level, increase depth
%    find(Key, Children, [], Path + 1);
%find(Key, [Key|_Rest], _Children, Path) -> % Found it!
%    Path;
%find(Key, [Grid|Rest], Children, Path) -> % Add children to search
%    NewChildren = permutate(Grid),
%	find(Key, Rest, NewChildren ++ Children, Path).



permutate(Grid) ->
	lists:map(fun(S) -> spin(Grid, S) end, get_spin_possibilites(Grid)).



spin(Grid, Rect) ->
	IndexPairs = find_swap_index_pairs(Rect, Grid#grid.width),
	#grid{width = Grid#grid.width, height=Grid#grid.height, data=swap_all(Grid#grid.data, IndexPairs)}.

ideal_input(Width, Height) -> #grid{width=Width, height=Height, data=generate_items(Width*Height)}.

get_spin_possibilites(Grid) ->
	find_subrects(make_rect_from_grid(Grid)).
			
is_solved(Grid) -> is_solved(1, Grid#grid.data).
is_solved(N, [{N, true} | T]) -> is_solved(N+1, T);
is_solved(_, []) -> true;
is_solved(_, _) -> false.

is_valid(Grid) ->
	length(Grid#grid.data) =:= Grid#grid.height * Grid#grid.width.




% Generates an ascending list of tiles. Used for ideal_input/0.
generate_items(Count) -> generate_items(Count, []).
generate_items(0, Data) -> Data;
generate_items(N, Data) -> generate_items(N-1, [ {N, true} | Data ]).


% finds pairs of indexes of the data field of a grid that need to be swapped
% when wanting to spin the rectrangle.
find_swap_index_pairs(Rect, Width) ->
	StartPoint = #point{x = Rect#rect.left, y = Rect#rect.top},
	Points = find_swap_points([], StartPoint, Rect),
	Indexes = points_to_idexes(Points, Width),
	list_to_pairwise_tuples(Indexes).
point_to_index(Point, Width) ->
	(Point#point.x) + ((Point#point.y -1) * Width).
points_to_idexes(Points, Width) ->
	lists:map(fun(Point) -> point_to_index(Point, Width) end, Points).
find_swap_points(List, Point, Rect) when Point#point.x < Rect#rect.left + Rect#rect.width, Point#point.y < Rect#rect.top + Rect#rect.height ->
	find_swap_points([Point | List], #point{x=Point#point.x+1, y=Point#point.y}, Rect);
find_swap_points(List, Point, Rect) when Point#point.y < Rect#rect.top + Rect#rect.height ->
	find_swap_points(List, #point{x=Rect#rect.left, y=Point#point.y+1}, Rect);
find_swap_points(List, _Point, _Rect) -> List.


% helpers to convert between rects and points.
make_rect(Point1, Point2) -> #rect{left=Point1#point.x, top=Point1#point.y, width=Point2#point.x - Point1#point.x + 1, height=Point2#point.y - Point1#point.y + 1}.
make_bottomright(Rect) -> #point{x=Rect#rect.left + Rect#rect.width -1, y=Rect#rect.top + Rect#rect.height -1}.
make_rect_from_grid(Grid) -> #rect{left=1, top=1, width=Grid#grid.width, height=Grid#grid.width}.

% finds all rectangles contained in the given rect.
find_subrects(Rect) ->
	StartPoints = find_points_in_rect(Rect),
	find_subrects_for_startpoints(Rect, StartPoints, []).

find_subrects_for_startpoints(_Rect, [], FoundRects) -> FoundRects;
find_subrects_for_startpoints(Rect, StartPoints, FoundRects) ->
	[ StartPoint | Rem ] = StartPoints,
	A = find_subrects_for_startpoint(StartPoint, Rect),
	find_subrects_for_startpoints(Rect, Rem, FoundRects ++ A).

find_subrects_for_startpoint(StartPoint, Rect) ->
	AllEndPoints = find_points_in_rect(make_rect(StartPoint, make_bottomright(Rect))),
	EndPoints = lists:delete(StartPoint, AllEndPoints),
	FoundSubrects = find_subrects_for_startpoint_and_endpoints(StartPoint, EndPoints, []),
	FoundSubrects.

find_subrects_for_startpoint_and_endpoints(StartPoint, [], FoundRects) -> [ make_rect(StartPoint, StartPoint) | FoundRects];
find_subrects_for_startpoint_and_endpoints(StartPoint, EndPoints, FoundRects) ->
	[EndPoint | Rem] = EndPoints,
	FoundRect = make_rect(StartPoint, EndPoint),
	find_subrects_for_startpoint_and_endpoints(StartPoint, Rem, [ FoundRect | FoundRects ]).

find_points_in_rect(Rect) ->
	find_swap_points([], #point{x=Rect#rect.left, y=Rect#rect.top}, Rect).

% helper for swapping
list_to_pairwise_tuples(List) -> list_to_pairwise_tuples([], List).
list_to_pairwise_tuples(Tuples, [A | []]) -> [{A, A} | Tuples];
list_to_pairwise_tuples(Tuples, []) -> Tuples;
list_to_pairwise_tuples(Tuples, List) ->
	[A | Tmp] = List,
	[B | Rem] = lists:reverse(Tmp),
	RemainingList = lists:reverse(Rem),
	list_to_pairwise_tuples([{A, B} | Tuples], RemainingList).


swap_and_flip(List, I, I) ->
	{ List2, [ A | List3 ] } = lists:split(I-1, List),
	NewA = reverse(A), % this flips true to false, so the item is put on its head (or reverse)
	List2 ++ [NewA | List3];
swap_and_flip(List, I1, I2) -> 
	{ List2, [ A | List3 ] } = lists:split(I1-1, List),
	B = lists:nth(I2, List),
	NewA = reverse(A), % this flips true to false, so the item is put on its head (or reverse)
	NewB = reverse(B), % this flips true to false, so the item is put on its head (or reverse)
	LT = List2 ++ [ NewB | List3 ],
   	{ List4, [ _ | List5 ] } = lists:split(I2-1, LT),
   	List4 ++ [ NewA | List5 ].

reverse(A) ->
	{element(1, A), not element(2, A)}.


swap_all(List, []) -> List;
swap_all(List, Swaps) ->
	[ {I1, I2} | RemSwaps ] = Swaps,
	swap_all(swap_and_flip(List, I1, I2), RemSwaps).
	
