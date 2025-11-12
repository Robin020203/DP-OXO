:- use_module([ library(lists), io, fill]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.4 BOARD REPRESENTATION (15%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
(1,1)|(2,1)|(3,1)
----------------
(1,2)|(2,2)|(3,2)
----------------
(1,3)|(2,3)|(3,3)

board(Box1_1, Box2_1, Box3_1, Box1_2, Box2_2, Box3_2, Box1_3, Box2_3, Box3_3)
*/


% succeeds when its argument is the cross character in the representation.
is_cross('x').

%succeeds when its argument is the nought character in the representation.
is_nought('o').

% succeeds when its argument is the empty square character in the representation.
is_empty(' ').

% succeeds when its argument is either the cross character or the nought character.
is_piece(X) :- 
    is_cross(X) ; 
    is_nought(X).

/* 
succeeds when both its arguments are player representation characters, 
but they are different.
*/
other_player(P1, P2) :-
    is_piece(P1) ,
    is_piece(P2) ,
    P1 \= P2.



/* 
succeeds when its first argument is a row number (between 1 and 3) and its second
is a representation of a board state. The third argument will then be a term like this:
row( N, A, B, C ), where N is the row number, and A, B, C are the values of the
squares in that row.
*/
row(1, board(Box1_1, Box2_1, Box3_1, _, _, _, _, _, _), row(1, Box1_1, Box2_1, Box3_1)).
row(2, board(_, _, _, Box1_2, Box2_2, Box3_2, _, _, _), row(2, Box1_2, Box2_2, Box3_2)).
row(3, board(_, _, _, _, _, _, Box1_3, Box2_3, Box3_3), row(3, Box1_3, Box2_3, Box3_3)).

/*
succeeds when its first argument is a column number (between 1 and 3) and its
second is a representation of a board state. The third argument will then be a term like
this: col( N, A, B, C ), where N is the column number, and A, B, C are the values
of the squares in that column.
*/
column(1, board(Box1_1, _, _, Box1_2, _, _, Box1_3, _, _), col(1, Box1_1, Box1_2, Box1_3)).
column(2, board(_, Box2_1, _, _, Box2_2, _, _, Box2_3, _), col(2, Box2_1, Box2_2, Box2_3)).
column(3, board(_, _, Box3_1, _, _, Box3_2, _, _, Box3_3), col(3, Box3_1, Box3_2, Box3_3)).

/*
succeeds when its first argument is either top_to_bottom or bottom_to_top
and its second is a representation of a board state. The third argument will then be
a term like this: dia( D, A, B, C ), where D is the direction of the line (as above),
and A, B, C are the values of the squares in that diagonal. The diagonal direction (eg
top-to-bottom) is moving from left to right.
*/
diagonal(top_to_bottom, board(Box1_1, _, _, _, Box2_2, _, _, _, Box3_3), dia(top_to_bottom, Box1_1, Box2_2, Box3_3)).
diagonal(bottom_to_top, board(_, _, Box3_1, _, Box2_2, _, Box1_3, _, _), dia(bottom_to_top, Box3_1, Box2_2, Box1_3)).

/*
succeeds when its first two arguments are numbers between 1 and 3, and its third
is a representation of a board state. The fourth argument will then be a term like this:
squ( X, Y, Piece ), where (X,Y) are the coordinates of the square given in the first
two arguments, and Piece is one of the three square representation characters, indicating
what if anything occupies the relevant square.
*/
square(1, 1, board(Piece, _, _, _, _, _, _, _, _), squ(1, 1, Piece)).
square(2, 1, board(_, Piece, _, _, _, _, _, _, _), squ(2, 1, Piece)).
square(3, 1, board(_, _, Piece, _, _, _, _, _, _), squ(3, 1, Piece)).
square(1, 2, board(_, _, _, Piece, _, _, _, _, _), squ(1, 2, Piece)).
square(2, 2, board(_, _, _, _, Piece, _, _, _, _), squ(2, 2, Piece)).
square(3, 2, board(_, _, _, _, _, Piece, _, _, _), squ(3, 2, Piece)).
square(1, 3, board(_, _, _, _, _, _, Piece, _, _), squ(1, 3, Piece)).
square(2, 3, board(_, _, _, _, _, _, _, Piece, _), squ(2, 3, Piece)).
square(3, 3, board(_, _, _, _, _, _, _, _, Piece), squ(3, 3, Piece)).

/*
succeeds when its first two arguments are coordinates on the board, and
the square they name is empty.
*/
empty_square(X, Y, Board) :-
    square(X, Y, Board, squ(X, Y, Piece)),
    is_empty(Piece).


/*
succeeds when its argument represents the initial state of the board.
*/
initial_board(board(' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ')).

/*
succeeds when its argument represents an uninstantiated board (ie with Pro-
log variables in all the spaces).
*/
empty_board(board(_, _, _, _, _, _, _, _, _)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.5 SPOTTING A WINNER (15%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
succeeds when its first argument represents a board, and the second
is a player who has won on that board. (Hint: use the predicates above here; you need
3 clauses.)
*/
and_the_winner_is(Board, Player) :-
    is_piece(Player),
    ( row(_, Board, row(_, Player, Player, Player)) ;
    column(_, Board, col(_, Player, Player, Player)) ;
    diagonal(_, Board, dia(_, Player, Player, Player))).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3.6 RUNNING A GAME FOR 2 HUMAN PLAYERS (20%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
We will assume that x is always going to start.
We will use a predicate called playHH/0 (for “play human vs. human”) 
to begin a game, defined as follows:
*/
playHH :- 
    welcome,
    initial_board( Board ),
    display_board( Board ),
    is_cross( Cross ),
    playHH( Cross, Board ).

/*
succeeds if the board represented in its argument has no empty squares in it.
*/
no_more_free_squares(Board) :-
    \+ empty_square(_, _, Board).


/*
playHH/2 is recursive. It has two arguments: a player, the first, and a board state, the
second. For this section of the practical, it has three possibilities:

1. The board represents a winning state, and we have to report the winner. Then we
are finished.
2. There are no more free squares on the board, and we have to report a stalemate.
Again, we are finished.
3. We can get a (legal) move from the player named in argument 1, fill the square
he or she gives, switch players, display the board and then play again, with the
updated board and the new player.
*/
playHH(_, Board) :-
    and_the_winner_is(Board, Player),
    report_winner( Player ).

playHH(_, Board) :-
    no_more_free_squares(Board),
    report_stalemate.

playHH(Player, Board) :-
    % GET LEGAL MOVE (to get (X,Y))
    get_legal_move( Player, X, Y, Board ) ,

    % FILL SQUARE
    fill_square( X, Y, Player, Board, NewBoard ) ,

    % SWITCH PLAYER
    other_player(Player, OtherPlayer) ,

    % DISPLAY BOARD
    display_board( NewBoard ) ,

    % PLAY AGAIN (with updated board and new player)
    playHH(OtherPlayer, NewBoard).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 4. RUNNING A GAME FOR 1 HUMAN AND THE COMPUTER (20%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5. IMPLEMENTING THE HEURISTICS (20%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 5.1 SPOTTING A STALEMATE (10%)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 7. TESTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%