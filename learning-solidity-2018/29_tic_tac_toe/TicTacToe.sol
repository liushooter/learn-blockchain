// based on https://gist.github.com/spidfire
pragma solidity ^0.4.24;

contract TicTacToe {
    uint[] board = new uint[](9);
    address player1;
    address player2;
    uint start = 0;
    
    constructor() public {
        player1 = msg.sender;
    }
    
    function joinGame() public {
        player2 = msg.sender;
    }
    
    function doMove(uint place) public returns (string){
        uint winner = checkWinner();
        if(winner == 1) {
            return "The game is over and the Winner is X";
        }
        if (winner == 2){
            return "The game is over and the Winner is O";
        }

        if(start == 0) {
            if(msg.sender != player1) return "you are not player 1";
        } else if(start == 1){
            if(msg.sender != player2) return "you are not player 2";
        }
        
        // is on the board
        if(place < 0 || place >= 9) return "not on the board";
        
        // Is not already set
        if(board[place] != 0) return "already occupied";
        
        board[place] = start+1;
        start = 1 - start;
        return "OK";   
    }

    uint[][] tests = [
        [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]
    ];
   
    function checkWinner() public view returns (uint){
        for(uint i=0; i < 8; i++){
            uint[] memory b = tests[i];
            if(board[b[0]] != 0 && board[b[0]] == board[b[1]] && board[b[0]] == board[b[2]]) return board[b[0]];
        }
        return 0;
    }
    
    function current() public view returns(string, string) {
        string memory text = "No winner yet";
        uint winner = checkWinner();
        if(winner == 1){
            text = "Winner is X";
        }
        
        if (winner == 2) {
            text = "Winner is O";
        }
        
        bytes memory out = new bytes(11);
        byte[] memory signs = new byte[](3);
        signs[0] = "-";
        signs[1] = "X";
        signs[2] = "O";
        bytes(out)[3] = "|";
        bytes(out)[7] = "|";
        
        for(uint i = 0; i < 9; i++){
            bytes(out)[i + i/3] = signs[board[i]];
        }
        return (text, string(out));
    }
}