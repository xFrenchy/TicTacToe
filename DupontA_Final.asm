TITLE final.asm
;Program Description: Tic Tac Toe
;Author: Anthony Dupont
;Creation Date: 12/3/2018

include Irvine32.inc

Newline  textequ <0ah, 0dh>
displayTable PROTO, offsetOfTable: DWORD
player1 PROTO, offsetOfTable: DWORD, letterForUser: BYTE, spots: BYTE
comp1 PROTO, offsetOfTable: DWORD, letterForComp: BYTE, spots: BYTE
checkIfGameOver PROTO, offsetOfTable: DWORD, letter: BYTE, offsetOfArrayMatch: DWORD
TicTacVersion PROTO
PvCgame PROTO, offsetOfTable: DWORD, offsetOfPlayer1Letter: DWORD, offsetOfPLayer2Letter: DWORD, numOfSpotTaken: BYTE, offsetOfArrayMatch: DWORD
PvPgame PROTO, offsetOfTable: DWORD, offsetOfPlayer1Letter: DWORD, offsetOfPLayer2Letter: DWORD, numOfSpotTaken: BYTE, offsetOfArrayMatch: DWORD
CvCgame PROTO, offsetOfTable: DWORD, offsetOfPlayer1Letter: DWORD, offsetOfPLayer2Letter: DWORD, numOfSpotTaken: BYTE, offsetOfArrayMatch: DWORD
statsOfGame PROTO, amountOfPvP: BYTE, amountOfPvC: BYTE, amountOfCvC: BYTE, amountOfTies: BYTE
displayAllStats PROTO, amountOfPvP: BYTE, amountOfPvC: BYTE, amountOfCvC: BYTE, amountOfTies: BYTE
displayWinningPath PROTO, offsetOfTable: DWORD, offsetOfArrayMatch: DWORD

.data
     table BYTE 3 DUP("-")
     Rowsize = ($ - table)    ;no need to divide
          BYTE 3 DUP("-")
          BYTE 3 DUP("-")          
          ;table is now 3x3
     letterPlayer1 BYTE 0
     letterPlayer2 BYTE 0
     letterComputer1 BYTE 0
     letterComputer2 BYTE 0
     spotTaken BYTE 0
     playAgain BYTE "Do you wish to play again?(Y/N)",newline, 0
     wrongInput BYTE "Wrong input",newline, 0
     gameOver BYTE 0
     amountPvP BYTE 0
     amountPvC BYTE 0
     amountCvC BYTE 0
     amountTies BYTE 0
     arrayOfIndexMatch BYTE 3 DUP(0)
     matchTie BYTE "It was a tie!", 0
.code
     
main proc
     call Randomize           ;seed for the random number generator
     
     startAgain:
     call clrscr              ;clear screen
     INVOKE TicTacVersion
     cmp eax, 1
     JE playPvC
     cmp eax, 2
     JE playPvP
     cmp eax, 3
     JE playCvC
     cmp eax, 4
     JE stats
     cmp eax, 5
     JE endProg
                                   ;else it's wrong input
     mov edx, OFFSET wrongInput
     call writeString
     call waitMsg
     jmp startAgain

     stats:
     INVOKE statsOfGame,           ;displays menu for user to choose an option
          amountPvP,
          amountPvC,
          amountCvC,
          amountTies

     jmp startAgain


     playPvC:
     inc amountPvC                           ;inc variable because we are playing a PvC game
     call waitMsg                            ;allows the user to read and presses a key to continue to the game
     call clrscr                             ;clear screen again
                    ;clear everything
     mov ecx, 9
     mov edi, 0
     L3:
     mov [table + edi], "-"
     inc edi
     loop L3
                    ;table has been cleared
     mov letterPlayer1, 0
     mov letterPlayer2, 0
     mov letterComputer1, 0
     mov letterComputer2, 0
     mov spotTaken, 0
     mov gameover, 0
                    ;end of reseting all variables
     INVOKE PvCgame,
          OFFSET table,
          OFFSET letterPlayer1,
          OFFSET letterComputer1,
          spotTaken,
          OFFSET arrayOfIndexMatch
                    ;game has been played now we check if it's a tie 
     cmp eax, 0
     JE L2
     cmp eax, 1
     JE L2
                    ;else it was a tie
     inc amountTies
     mov dh, 1
     mov dl, 10
     call GotoXY
     mov edx, OFFSET matchTie
     call writeString
     jmp L2

     playPvP:
     inc amountPvP                 ;inc variable cuz game being played
     call waitMsg                            ;allows the user to read and presses a key to continue to the game
     call clrscr                             ;clear screen again
                    ;clear everything
     mov ecx, 9
     mov edi, 0
     L4:
     mov [table + edi], "-"
     inc edi
     loop L4
                    ;table has been cleared
     mov letterPlayer1, 0
     mov letterPlayer2, 0
     mov letterComputer1, 0
     mov letterComputer2, 0
     mov spotTaken, 0
     mov gameover, 0
                    ;end of reseting all variables
     INVOKE PvPgame,
          OFFSET table,
          OFFSET letterPlayer1,
          OFFSET letterComputer1,
          spotTaken,
          OFFSET arrayOfIndexMatch
     cmp eax, 0
     JE L2
     cmp eax, 1
     JE L2
               ;else it was a tie
     inc amountTies
     mov dh, 1
     mov dl, 10
     call GotoXY
     mov edx, OFFSET matchTie
     call writeString
     jmp L2
     
     playCvC:
     inc amountCvC
     call waitMsg                            ;allows the user to read and presses a key to continue to the game
     call clrscr                             ;clear screen again
                    ;clear everything
     mov ecx, 9
     mov edi, 0
     L5:
     mov [table + edi], "-"
     inc edi
     loop L5
                    ;table has been cleared
     mov letterPlayer1, 0
     mov letterPlayer2, 0
     mov letterComputer1, 0
     mov letterComputer2, 0
     mov spotTaken, 0
     mov gameover, 0
                    ;end of reseting all variables
     INVOKE CvCgame,
          OFFSET table,
          OFFSET letterPlayer1,
          OFFSET letterComputer1,
          spotTaken,
          OFFSET arrayOfIndexMatch
     cmp eax, 0
     JE L2
     cmp eax, 1
     JE L2
                    ;else it was a tie
     inc amountTies
     mov dh, 1
     mov dl, 10
     call GotoXY
     mov edx, OFFSET matchTie
     call writeString
     jmp L2

     L2:
     mov eax, 0
     mov edx, OFFSET playAgain
     call writeString         ;ask user if they want to play again
     call readChar
     cmp al, 'Y'
     JE startAgain
     cmp al, 'y'
     JE startAgain
     cmp al, 'N'
     JE endProg
     cmp al, 'n'
     JE endProg
                         ;else wrong input
     mov edx, OFFSET wrongInput
     jmp L2

     endProg:
     INVOKE displayAllStats,
          amountPvP,
          amountPvC,
          amountCvC,
          amountTies
     exit

main endp ;end main

displayAllStats PROC, amountOfPvP: BYTE, amountOfPvC: BYTE, amountOfCvC: BYTE, amountOfTies: BYTE
;Description: Displays all the stats before the program ends
;Receives: amount of teach type of game played and amount of ties
;Returns: Nothing
.data
     PvP BYTE "Amount of PvP games played: ", 0
     PvC BYTE "Amount of PvC games played: ", 0
     CvC BYTE "Amount of CvC games played: ", 0
     Ties BYTE "Amount of ties: ", 0
.code
     mov edx, OFFSET PvP
     call writeString
     movzx eax, amountOfPvP
     call writeDec
     call crlf
     mov edx, OFFSET PvC
     call writeString
     movzx eax, amountOfPvC
     call writeDec
     call crlf
     mov edx, OFFSET CvC
     call writeString
     movzx eax, amountOfCvC
     call writeDec
     call crlf
     mov edx, OFFSET ties
     call writeString
     movzx eax, amountOfTies
     call writeDec
     call crlf
     ret
displayAllStats ENDP


statsOfGame PROC, amountOfPvP: BYTE, amountOfPvC: BYTE, amountOfCvC: BYTE, amountOfTies: BYTE
;Description: Prompts the user with a menu for stats of the game
;Recieves: amount of each type of game played and amount of ties
;Returns: Nothing
.data
     statsMenu BYTE "1)Display amount of PvP games played",newline
               BYTE "2)Display amount of PvC games played",newline
               BYTE "3)Display amount of CvC games played",newline
               BYTE "4)Display amount of games resulting in a draw",newline,0
     statsWrong BYTE "Wrong input! Must be between 1-4",newline,0
     amountPlayed BYTE "Amount: ",0
.code

begin:
     mov edx, OFFSET statsMenu
     call writeString
     call readInt
     ;answer is in eax
     cmp eax, 0
     JE wrongAnswer
     JO wrongAnswer
     JS wrongAnswer
     cmp eax, 5
     JAE wrongAnswer                ;jump if above or equal
     ;else we choose which stat to display
     L1:
          cmp eax, 1
          JNE L2
          mov edx, OFFSET amountPlayed
          call writeString
          movzx eax, amountOfPvP
          call writeDec
          call crlf
          call waitMsg
          ret
     L2:
          cmp eax, 2
          JNE L3
          mov edx, OFFSET amountPlayed
          call writeString
          movzx eax, amountOfPvC
          call writeDec
          call crlf
          call waitMsg
          ret
     L3:
          cmp eax, 3
          JNE L4
          mov edx, OFFSET amountPlayed
          call writeString
          movzx eax, amountOfCvC
          call writeDec
          call crlf
          call waitMsg
          ret
     L4:
          cmp eax, 4
          JNE wrongAnswer
          mov edx, OFFSET amountPlayed
          call writeString
          movzx eax, amountOfTies
          call writeDec
          call crlf
          call waitMsg
          ret

     wrongAnswer:
     mov edx, OFFSET statsWrong
     call writeString
     jmp begin
     ret
statsOfGame ENDP

CvCgame PROC, offsetOfTable: DWORD, offsetOfPlayer1Letter: DWORD, offsetOfPLayer2Letter: DWORD, numOfSpotTaken: BYTE, offsetOfArrayMatch: DWORD
;Description: Plays CvC tic tac toe
;Recieves: offset of the table, offset of letter for player 1 and player 2, offset of spot taken
;Returns: returns who won in eax, 0 comp1, 1 comp2, 2 tie
.data
     comp1WonGame1 BYTE "CPU 1 has won!",newline, 0
     comp2WonGame BYTE "CPU 2 has won!",newline, 0
     gameDone2 BYTE "Game over",newline, 0
.code
     mov eax, 2
     call randomRange         ;(0-1)
     cmp eax, 0
     JE comp2Starts
     ;else comp1 starts

     comp1Start:
     mov BYTE PTR [offsetOfPlayer1Letter], "O"
     mov BYTE PTR [offsetOfPlayer2Letter], "X"
     INVOKE displayTable,
          offsetOfTable
     ;table has been shown
     INVOKE comp1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating spotTaken variable

     mov eax, 1000
     call Delay
     call clrscr              ;clear screen
     ;comp1 has played so now I have to check if they won

     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          offsetOfArrayMatch
     cmp al, 1
     JE player1Won
     mov eax, 2

     ;now comp2 starts
     INVOKE displayTable,
          offsetOfTable
     INVOKE comp1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al
     mov eax, 1000
     call Delay
     call clrscr
     ;comp2 has played so now I have to check if they won

     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          offsetOfArrayMatch
     cmp al, 1
     JE player2Won
     mov eax, 2
     jmp endOfTurn1

     ;end of turn for comp1 start first

     endOfTurn1:
     cmp numOfSpotTaken, 9         ;if 9 then all spots are taken
     je endOfTicTacToe
     ;else keep playing
     jmp comp1Start
     
     
     ;#######
     ;Everything under is executed if the player 1 starts first, above is executed if the computer starts first
     ;#######


     comp2Starts:
     mov BYTE PTR [offsetOfPlayer1Letter], "X"
     mov BYTE PTR [offsetOfPlayer2Letter], "O"
     startGamePvP:
     INVOKE displayTable,
          offsetOfTable
     INVOKE comp1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating spotTaken variable
     mov eax, 1000
     call Delay             ;wait before clear
     call clrscr              ;clear screen
     ;comp2 has played so now I have to check if they won
     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          offsetOfArrayMatch
     cmp al, 1
     JE player2Won
     mov eax, 2

     INVOKE displayTable,
          offsetOfTable
     INVOKE comp1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating variable
     ;player1 has played so now I have to check if they won
     mov eax, 1000
     call Delay
     call clrscr
     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          offsetOfArrayMatch
     cmp al, 1
     JE player1Won
     mov eax, 2
     jmp endOfTurn

     endOfTurn:
     cmp numOfSpotTaken, 9         ;if 9 then all spots are taken
     je endOfTicTacToe
     ;else keep playing
     jmp comp2Starts

     ;Below here will never execute unless jumped to

     player1Won:
     mov dh, 0
     mov dl, 10
     call GotoXY
     mov edx, OFFSET comp1WonGame1
     call writeString
     mov eax, 0
     jmp endOfTicTacToe

     player2Won:
     mov dh, 0
     mov dl, 10
     call GotoXY
     mov edx, OFFSET comp2WonGame
     call writeString
     mov eax, 1
     jmp endOfTicTacToe

     endOfTicTacToe:
     push eax
     INVOKE displayTable,
          OFFSET table
     pop eax
     mov edx, OFFSET gameDone1
     call writeString

     ret
CvCgame ENDP

PvPgame PROC, offsetOfTable: DWORD, offsetOfPlayer1Letter: DWORD, offsetOfPLayer2Letter: DWORD, numOfSpotTaken: BYTE, offsetOfArrayMatch: DWORD
;Description: Plays PvP tic tac toe
;Recieves: offset of the table, offset of letter for player 1 and player 2, offset of spot taken
;Returns: returns who won in eax, 0 player1, 1 player2, 2 tie
.data
     player1WonGame1 BYTE "Player1 has won!",newline, 0
     player2WonGame BYTE "Player2 has won!",newline, 0
     gameDone1 BYTE "Game over",newline, 0
.code
     mov eax, 2
     call randomRange         ;(0-1)
     cmp eax, 0
     JE player1Start
     ;else comp1 starts

     player1Start:
     mov BYTE PTR [offsetOfPlayer1Letter], "O"
     mov BYTE PTR [offsetOfPlayer2Letter], "X"
     INVOKE displayTable,
          offsetOfTable
     ;table has been shown
     INVOKE player1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating spotTaken variable
     call waitMsg             ;wait before clear
     call clrscr              ;clear screen
     ;player 1 has played so now I have to check if they won

     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          offsetOfArrayMatch
     ;mov gameover, al
     cmp al, 1
     mov eax, 2
     JE player1Won

     ;now player2 starts
     INVOKE displayTable,
          offsetOfTable
     INVOKE player1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al
     call waitMsg
     call clrscr
     ;player 2 has played so now I have to check if they won

     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          offsetOfArrayMatch
     cmp al, 1
     JE player2Won
     mov eax, 2
     jmp endOfTurn1

     ;end of turn for player 1 start first

     endOfTurn1:
     cmp numOfSpotTaken, 9         ;if 9 then all spots are taken
     je endOfTicTacToe
     ;else keep playing
     jmp player1Start
     
     
     ;#######
     ;Everything under is executed if the player 1 starts first, above is executed if the computer starts first
     ;#######

     
     player2Start:
     mov BYTE PTR [offsetOfPlayer1Letter], "X"
     mov BYTE PTR [offsetOfPlayer2Letter], "O"
     startGamePvP:
     INVOKE displayTable,
          offsetOfTable
     INVOKE player1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating spotTaken variable
     call waitMsg             ;wait before clear
     call clrscr              ;clear screen
     ;player 2 has played so now I have to check if they won
     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          offsetOfArrayMatch
     ;mov gameover, al
     cmp al, 1
     mov eax, 2
     JE player2Won

     INVOKE displayTable,
          offsetOfTable
     INVOKE player1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating variable
     ;player1 has played so now I have to check if they won

     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          offsetOfArrayMatch
     ;mov gameover, al
     cmp al, 1
     JE player1Won
     mov eax, 2
     jmp endOfTurn

     endOfTurn:
     cmp numOfSpotTaken, 9         ;if 9 then all spots are taken
     je endOfTicTacToe
     ;else keep playing
     jmp startGamePvP

     ;Below here will never execute unless jumped to

     player1Won:
     mov dh, 0
     mov dl, 10
     call GotoXY
     mov edx, OFFSET player1WonGame1
     call writeString
     mov eax, 0
     jmp endOfTicTacToe

     player2Won:
     mov dh, 0
     mov dl, 10
     call GotoXY
     mov edx, OFFSET player2WonGame
     call writeString
     mov eax, 1
     jmp endOfTicTacToe

     endOfTicTacToe:
     push eax
     INVOKE displayTable,
          OFFSET table
     pop eax
     mov edx, OFFSET gameDone1
     call writeString
     ret
PvPgame ENDP


PvCgame PROC, offsetOfTable: DWORD, offsetOfPlayer1Letter: DWORD, offsetOfPLayer2Letter: DWORD, numOfSpotTaken: BYTE, offsetOfArrayMatch: DWORD
;Description: Plays PvC tic tac toe
;Recieves: offset of the table, offset of letter for player 1 and player 2, offset of spot taken
;Returns: returns who won in eax, 0 player, 1 CPU, 1 tie
.data
     player1WonGame BYTE "Player1 has won!",newline, 0
     comp1WonGame BYTE "Computer1 has won!",newline, 0
     gameDone BYTE "Game over",newline, 0
.code
;determine who goes first
     mov eax, 2
     call randomRange         ;(0-1)
     cmp eax, 0
     JE player1Start
     ;else comp1 starts

     comp1Start:
     mov BYTE PTR [offsetOfPlayer1Letter], "X"
     mov BYTE PTR [offsetOfPlayer2Letter], "O"
     INVOKE displayTable,
          offsetOfTable
     INVOKE comp1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating variable
     ;comp has played so now I have to check if they won

     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          offsetOfArrayMatch
     cmp al, 1
     JE comp1Won
     ;else rest eax because I can't leave it to be equal 1 or 0 if the game ends with no winner
     mov eax, 2
     cmp numOfSpotTaken, 9         ;if 9 then all spots are taken
     je endOfTicTacToe

     INVOKE displayTable,
          offsetOfTable
     INVOKE player1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating spotTaken variable
     call waitMsg             ;wait before clear
     call clrscr              ;clear screen
     ;player 1 has played so now I have to check if they won

     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          offsetOfArrayMatch
     ;mov gameover, al
     cmp al, 1
     JE player1Won
     mov eax, 2
     jmp endOfTurn1
     ;end of turn for computer start first


     ;Everything under is executed if the player 1 starts first, above is executed if the computer starts first

     endOfTurn1:
     cmp numOfSpotTaken, 9         ;if 9 then all spots are taken
     je endOfTicTacToe
     ;cmp gameOver, 1
     ;JE endOfTicTacToe
     ;else keep playing
     jmp comp1Start


     player1Start:
     mov BYTE PTR [offsetOfPlayer1Letter], "O"
     mov BYTE PTR [offsetOfPlayer2Letter], "X"
     startGamePvC1:
     INVOKE displayTable,
          offsetOfTable
     INVOKE player1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating spotTaken variable
     call waitMsg             ;wait before clear
     call clrscr              ;clear screen
     ;player 1 has played so now I have to check if they won
     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer1Letter],
          offsetOfArrayMatch
     ;mov gameover, al
     cmp al, 1
     JE player1Won
     mov eax, 2
     cmp numOfSpotTaken, 9         ;if 9 then all spots are taken
     je endOfTicTacToe

     INVOKE comp1,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          numOfSpotTaken
     mov numOfSpotTaken, al        ;updating variable
     ;comp has played so now I have to check if they won

     INVOKE checkIfGameOver,
          offsetOfTable,
          BYTE PTR [offsetOfPlayer2Letter],
          offsetOfArrayMatch
     ;mov gameover, al
     cmp al, 1
     JE comp1Won
     mov eax, 2
     jmp endOfTurn

     endOfTurn:

     cmp spotTaken, 9         ;if 9 then all spots are taken
     je endOfTicTacToe
     ;cmp gameOver, 1
     ;JE endOfTicTacToe
     ;else keep playing
     jmp startGamePvC1

     ;Below here will never execute unless jumped to

     player1Won:
     mov dh, 0
     mov dl, 10
     call GotoXY
     mov edx, OFFSET player1WonGame
     call writeString
     mov eax, 0
     jmp endOfTicTacToe

     comp1Won:
     mov dh, 0
     mov dl, 10
     call GotoXY
     mov edx, OFFSET comp1WonGame
     call writeString
     mov eax, 1
     jmp endOfTicTacToe

     endOfTicTacToe:
     push eax
     INVOKE displayTable,
          OFFSET table
     pop eax
     mov edx, OFFSET gameDone
     call writeString

     ret
PVCGame ENDP


TicTacVersion PROC
;Description: displays the rules and asks the user which version they want to play
;Recieves: Nothing
;Returns: user decision in eax
.data
     TTTversion BYTE "1)PvC",newline
               BYTE "2)PvP",newline
               BYTE "3)CvC",newline
               BYTE "4)Check Statistics",newline
               BYTE "5)Exit",newline
               BYTE "=====> ",0
     ticTacToePrompt BYTE "Welcome to Tic Tac Toe!",newline
               BYTE "The rules are to try and match 3 of your letters (You will be assigned X or O depending on who goes first)",newline
               BYTE "in a row or column or diagonal to win!",newline, 0
     answerPrompt BYTE "Answer must be 1-5",newline, 0
.code
begin:
     mov edx, OFFSET ticTacToePrompt         ;displays welcome message and rules
     call writeString
     mov edx, OFFSET TTTversion
     call writeString
     call readInt
     ;answer is in eax
     cmp eax, 0
     JE wrongAnswer
     JO wrongAnswer
     JS wrongAnswer
     cmp eax, 6
     JAE wrongAnswer                ;jump if above or equal
     ;else we return the answer in eax
     ret

     wrongAnswer:
     mov edx, OFFSET answerPrompt
     call writeString
     jmp begin
TicTacVersion ENDP

displayWinningPath PROC, offsetOfTable: DWORD, offsetOfArrayMatch: DWORD
;Description: highlights the winning path of the table
;Receives: all 3 indexes that form a match and offset of the table
;Returns: Nothing
.data
     winningPath BYTE "Here is the winning path!",0
.code
     mov esi, offsetOfTable
     mov ecx, 9
     mov dh, 0           ;row
     mov dl, 0           ;column
     mov ebx, 0
     L1:
          call GotoXY
          movzx eax, BYTE PTR [esi + ebx]
          push eax
          cmp bl, BYTE PTR [offsetOfArrayMatch + 0]
          JE match
          cmp bl, BYTE PTR [offsetOfArrayMatch + 1]
          JE match
          cmp bl, BYTE PTR [offsetOfArrayMatch + 2]
          JE match
          ;else it's normal
          mov eax, lightGreen
          call SetTextColor

          displayChar:
          pop eax
          call writeChar
          inc ebx
          add dl, 2      ;moving 1 spaces to the right
          cmp dl, 6     ;if it's 3 we want to move to the next column
          je nextColumn
          ;else continue
          mov eax, 124        ;bar '|'
          call writeChar
          loop L1
          jmp theEnd

          match:
          mov eax, blue + (white * 16)  ;blue on white background
          call SetTextColor
          jmp displayChar

          nextColumn:
          add dh, 1
          mov dl, 0
          loop L1

          theEnd:
          mov eax, lightGreen
          call SetTextColor
          mov dh, 2
          mov dl, 10
          call GotoXY
          mov edx, OFFSET winningPath
          call writeString
          mov eax, 2000
          call Delay
          call crlf      ;newline
     ret
     ret
displayWinningPath ENDP


checkIfGameOver PROC, offsetOfTable: DWORD, letter: BYTE, offsetOfArrayMatch: DWORD
;Description: Checks if somebody has won depending on the letter given, hihglights the winning path
;Receives: offset of the table and letter
;Returns: if player has won or not in eax
.data

.code
     ;table is 3x3
     ;0,1,2
     ;3,4,5
     ;6,7,8
     mov esi, offsetOfTable
     mov edi, 0
     mov ecx, 3                    ;3 because there is 3 rows to check
     L1:
          push edi            ;pushing 0 or 3 to the stack
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextRow
          ;else it's a match from the letter and we look at the right
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 0], al
          pop eax
          inc edi
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextRow
          ;else it's another match and we check one more time
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 1], al
          pop eax
          inc edi
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextRow
          ;else it's a match all across, somebody won
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 2], al
          pop eax
          INVOKE displayWinningPath,
               esi,
               offsetOfArrayMatch
          mov eax, 1
          ret

          goToNextRow:
               pop edi        ;putting 0 or 3 in edi
               add edi, 3
               loop L1
     ;row has been checked, now we move on to check column
     mov edi, 0          ;reset
     mov ecx, 3          ;3 because there is 3 columns to check
     L2:
          push edi            ;pushing 0 or 1 to the stack
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextColumn
          ;else it's a match from the letter and we look down
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 0], al
          pop eax
          add edi, 3
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextColumn
          ;else it's another match and we check one more time
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 1], al
          pop eax
          add edi, 3
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextColumn
          ;else it's a match all across, somebody won
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 2], al
          pop eax
          INVOKE displayWinningPath,
               esi,
               offsetOfArrayMatch
          mov eax, 1
          ret

          goToNextColumn:
               pop edi        ;putting 0 or 1 in edi
               inc edi
               loop L2
     ;colunm has been checked, now we check diagonal
     ;0 1 2
     ;3 4 5 
     ;6 7 8
     mov edi, 0          ;reset
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextDia
          ;else it's a match from the letter and we look down to the right
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 0], al
          pop eax
          add edi, 4
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextDia
          ;else it's another match and we check one more time
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 1], al
          pop eax
          add edi, 4
          movzx eax, BYTE PTR [esi + edi]
          cmp al, letter
          JNE goToNextDia
          ;else it's a match all across, somebody won
          push eax
          mov eax, edi
          mov BYTE PTR [offsetOfArrayMatch + 2], al
          pop eax
          INVOKE displayWinningPath,
               esi,
               offsetOfArrayMatch
          mov eax, 1
          ret

          goToNextDia:
          mov edi, 2
               movzx eax, BYTE PTR [esi + edi]
               cmp al, letter
               JNE noMatches
               ;else it's a match from the letter and we look down to the left
               push eax
               mov eax, edi
               mov BYTE PTR [offsetOfArrayMatch + 0], al
               pop eax
               add edi, 2
               movzx eax, BYTE PTR [esi + edi]
               cmp al, letter
               JNE noMatches
               ;else it's another match and we check one more time
               push eax
               mov eax, edi
               mov BYTE PTR [offsetOfArrayMatch + 1], al
               pop eax
               add edi, 2
               movzx eax, BYTE PTR [esi + edi]
               cmp al, letter
               JNE noMatches
               ;else it's a match all across, somebody won
               push eax
               mov eax, edi
               mov BYTE PTR [offsetOfArrayMatch + 2], al
               pop eax
               INVOKE displayWinningPath,
               esi,
               offsetOfArrayMatch
               mov eax, 1
               ret

         noMatches:
     mov eax, 0               ;this means the player/comp has not won
     ret
checkIfGameOver ENDP

displayTable PROC, offsetOfTable: DWORD
;Description: Shows the 3x3 table in colors
;Recieves: offset of the tabel
;Returns: nothing
.data
     
.code
     mov esi, offsetOfTable
     mov ecx, 9
     mov dh, 0           ;row
     mov dl, 0           ;column
     mov edi, 0
     L1:
          call GotoXY
          movzx eax, BYTE PTR [esi + edi]
          push eax
          cmp eax, "X"
          JE colorYellow
          cmp eax, "O"
          JE colorBlue
          ;else it's normal
          mov eax, lightGreen
          call SetTextColor
          displayChar:
          pop eax
          call writeChar
          inc edi
          add dl, 2      ;moving 1 spaces to the right
          cmp dl, 6     ;if it's 3 we want to move to the next column
          je nextColumn
          ;else continue
          mov eax, 124
          call writeChar
          loop L1
          jmp theEnd

          colorYellow:
          mov eax, yellow
          call SetTextColor
          jmp displayChar

          colorBlue:
          mov eax, lightBlue
          call SetTextColor
          jmp displayChar

          nextColumn:
          add dh, 1
          mov dl, 0
          loop L1

          theEnd:
          mov eax, lightGreen
          call SetTextColor
          call crlf      ;newline
     ret
displayTable ENDP

player1 PROC, offsetOfTable: DWORD, letterForUser: BYTE, spots: BYTE
;Description: instructions for what player 1 does
;Recieves: offset of the table and letter for the user
;Returns: table filled with the user decision, and amount of spots taken
.data
     promptPlayer1 BYTE "Enter the number for the grid you want to fill(1-9)===>",0
     large BYTE "Input is too large!",newline, 0
     wrong BYTE "Try again",newline, 0
     invLocation BYTE "That spot is already taken!",newline, 0
.code
     mov esi, offsetOfTable
     cmp spots, 9
     JE gameIsOver

     L1:
     mov edx, OFFSET promptPlayer1
     call writeString
     call readInt
     JO tooLarge                 ;jump overflow
     cmp eax, 0
     JE zeroCase                   ;jump if input is zero
     JS negativeNum                ;jump if the sign flag is set, meaning the number is negative
     cmp eax, 10
     JAE tooLarge                  ;jump if above or equal

     ;else check if that spot in the grid is open to place something in it
     dec eax                       ;array starts at 0
     movzx ebx, BYTE PTR [esi + eax]              ;placing what is in the table at that location in ebx
     cmp ebx, "-"
     JE spotOpen                        ;user chose a valid location
     ;else it's invalid location
     mov edx, OFFSET invLocation
     call writeString
     jmp L1

     spotOpen:
     movzx ebx, letterForUser
     mov [esi + eax], bl
     movzx eax, spots
     inc eax
     ret


     tooLarge:
     mov edx, OFFSET large
     call writeString
     jmp L1

     zeroCase:
     mov edx, OFFSET wrong
     call writeString
     jmp L1

     negativeNum:
     mov edx, OFFSET wrong
     call writeString
     jmp L1

     gameIsOver:
     movzx eax, spots    ;setting up eax before I return
     ret

     ret
player1 ENDP

comp1 PROC, offsetOfTable: DWORD, letterForComp: BYTE, spots: BYTE
;Description: instruction for what comp 1 does
;Recieves: offset of the table and letter for the computer
;Returns: table filled with computer decision
.data

.code
     cmp spots, 9
     JE gameIsOver

     ;first check if the middle is taken
     mov esi, offsetOfTable
     movzx eax, BYTE PTR [esi + 4]      ;retrieve middle of the table
     cmp eax, "-"
     JE middleNotTaken             ;middle is not taken so we fill that
     L1:
     ;else middle is taken and we generate random number to fill table
     mov eax, 9          ;(0-8)
     call randomRange
     movzx ebx, BYTE PTR [esi + eax]      ;retrieves what is in that spot on the table
     cmp ebx, "-"
     JE spotOpen
     ;else spot is not open and we have to choose again
     jmp L1

     spotOpen:
     movzx ebx, letterForComp
     mov [esi + eax], bl
     movzx eax, spots
     inc eax
     ret


     middleNotTaken:
     movzx ebx, letterForComp
     mov [esi + 4], bl
     movzx eax, spots
     inc eax
     ret

     gameIsOver:
     movzx eax, spots    ;setting up eax before I return
     ret
comp1 ENDP

end main  ;end code