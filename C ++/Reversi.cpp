#include <iostream>
using namespace std;
int validMoves(char board[6][6], int checkValid); //This function counts the number of valid moves available
int validCheck (char board[6][6],int row, int col, int check); //This function checks if a given move is valid
void checkCol (char board[6][6],int row, int col, int n, int a, int condition); //This function executes the changes in the columns (flips)
void checkRow (char board[6][6],int row, int col, int n, int a,int condition); //This function executes the changes in the columns (flips)
int main()
{
char x = 'X';
char o='O';
char board[6][6];

int check;
int counter=0;
int row, col;
int a=0;
int n=0;
int circlewin=0;
int crosswin=0;
int newRow, newCol;
int rowCheck, colCheck;
int gameOver=0;
int checkValid=0;
int moveCounter=2;


//sets up the values in the board
for (int k=0;k<6;k++){
for (int y=0;y<6;y++){
board[y][k] = ' '; //change to ' ' empty character
					}
					}
	board[2][2] = x;
    board[3][2] = o;
    board[2][3]=o;
    board[3][3]=x;

	
	
//sets up the board for the first viewing
for (int i = 0; i < 6; i++)
							{
cout << "-------------\n";
for (int j = 0; j < 6; j++)
cout << "|" << board[i][j];
cout << "|\n";
							}
cout << "-------------" << endl;

cout<<"type -1 as a row to end game"<<endl;

//This do while loop is where the gameplay takes place
 do{
	 
//The next few lines implement a turn system where the first move is for X (since moveCounter is initially declared as 2) and the next one is for O
if (moveCounter%2==1){
cout<<"it's circle's turn"<<endl;
    if( validMoves(board, 1)) //this checks if there is a valid move for O
       {cout<<"NO VALID MOVES FOR O"<<endl;
		check =1;
		}
	else{check=0;
		}
					}
else if (moveCounter%2==0){
cout<<"it's cross's turn"<<endl;
	if( validMoves(board, 2)) //this checks if there is a valid move for X
    {cout<<"NO VALID MOVES FOR X"<<endl;
			check =0;

	}
	else{check=1;
		}
							}

cout << "Enter a row (0-5): ";
cin >> row;
cout << "Enter a column (0-5): ";
cin >> col;

//The next few lines are checking if the move is valid and are adding the values (if valid) on the board
if(board[row][col]==' '){
    for(int vv=-1;vv<2;vv++){
        for(int mm=-1;mm<2;mm++){
            if(check==1){
            int chekk=validCheck(board, row,  col ,check);
                if(chekk){
					board[row][col] = x; 
				moveCounter=3;}
                else{
								moveCounter=2;
					}
						}
            else if (check==0){
            int chekk=validCheck(board, row,  col ,check);
                if(chekk){board[row][col] = o; moveCounter=2;
						}
                else{
				moveCounter=3;
					}
							}
								}
									}

if(board[row][col]==o){ //these loops check if there is an X in the immediate vicinity of the initial O and if there is then the next step is to check for another O.
    for(n=-1;n<2;n++){
        for(a=-1;a<2;a++){
            if(board[row+n][col+a]==x){
           
            newRow=row+n;
            newCol=col+a;
                 if(  (row==newRow)||(col==newCol)){//the x is in the row or column
                checkCol (board, row, col, n, a,1);
                checkRow (board, row, col, n, a,1);
                                                    }
                else {//the x is in the diagonal
                    if (n==1 && a==1){//bottom right corner
                    newRow=row+n;
                    newCol=col+a;
                    colCheck = newCol;
                    rowCheck = newRow;
                        while(newCol<6 &&  newRow<6 && (board[rowCheck][colCheck]!=' ') ) //This condition tells us to stop before reaching the extremes and avoid flipping empty spaces
                            {
                    //This part searches for xs and os the diagonal square after newRow and newCol
                        newCol++;
                        newRow++;
                        rowCheck++;
                        colCheck++;
                            if (board[rowCheck][colCheck]==o && (rowCheck<6) && (rowCheck>-1) && (colCheck>-1) && (colCheck<6)){
                                while(rowCheck>row)//we start rolling back till we reach the first square with an o
                                {
                                rowCheck--;
                                colCheck--;
                                board[rowCheck][colCheck]=o;
                                }
                                                                                                                                }
                            }
                                    }
                   else if (n==-1 && a==-1)
                    {//top left corner
                   newRow=row-1;
                   newCol=col-1;
                   colCheck = newCol;
                   rowCheck = newRow;

                        while(newCol>-1 &&  newRow>-1 && (board[rowCheck][colCheck]!=' ') )
                        {
                        newCol--;
                        newRow--;
                        rowCheck--;
                        colCheck--;
                            if (board[rowCheck][colCheck]==o && (rowCheck<6) && (rowCheck>-1) && (colCheck>-1) && (colCheck<6))
                                {
                                while(rowCheck<row){
                                rowCheck++;
                                colCheck++;
                                board[rowCheck][colCheck]=o;
                                                    }
                                }
                        }
                    }
                    else if (n==-1 && a==1){//top right corner
                    newRow=row-1;
                    newCol=col+1;
                    colCheck = newCol;
                    rowCheck = newRow;
                        while(newCol<6 &&  newRow>-1 && (board[rowCheck][colCheck]!=' '))
                        {
                        newCol++;
                        newRow--;
                        rowCheck--;
                        colCheck++;
                             if (board[rowCheck][colCheck]==o && (rowCheck<6) && (rowCheck>-1) && (colCheck>-1) && (colCheck<6))
                                {
                                while(rowCheck<row){
                                rowCheck++;
                                colCheck--;
                                board[rowCheck][colCheck]=o;
                                                    }
                                }

                        }
                                            }
                    else if (n==1 && a==-1){//bottom left corner
                    newRow=row+1;
                    newCol=col-1;
                    colCheck = newCol;
                    rowCheck = newRow;
                        while(newCol>-1 &&  newRow<6 && (board[rowCheck][colCheck]!=' '))
                        {
                        newCol--;
                        newRow++;
                        rowCheck++;
                        colCheck--;
                            if (board[rowCheck][colCheck]==o && (rowCheck<6) && (rowCheck>-1) && (colCheck>-1) && (colCheck<6))
                            {
                                while(rowCheck>row){
                                rowCheck--;
                                colCheck++;
                                board[rowCheck][colCheck]=o;
                                                    }
                            }
                        }                   }
                        }
                                    }
                                }
                            }
                        }
//if the value inputed is x then
else if(board[row][col]==x){ //these loops check if there is an O adjacent the initial X and if there is then the next step is to check for another X.
	for(n=-1;n<2;n++){
		for(a=-1;a<2;a++){
    if(board[row+n][col+a]==o){
    newRow=row+n;
    newCol=col+a;
        if((row==newRow)||(col==newCol))
            {
        checkCol (board, row, col, n, a,2);
        checkRow (board, row, col, n, a,2);
            }
        else
        {//the O is in the diagonal
if (n==1 && a==1)
{//bottom right corner
            newRow=row+n;
            newCol=col+a;
            colCheck = newCol;
            rowCheck = newRow;
                while(newCol<6 &&  newRow<6 && (board[rowCheck][colCheck]!=' ')) //This condition tells us to stop before reaching the extremes and avoid flipping empty spaces
                {
                newCol++;
                newRow++;
                rowCheck++;
                colCheck++;
                    if (board[rowCheck][colCheck]==x && (rowCheck<6) && (rowCheck>-1) && (colCheck>-1) && (colCheck<6))
                    {
                        while(rowCheck>row)
                        {
                        rowCheck--;
                        colCheck--;
                        board[rowCheck][colCheck]=x;
                        }
                    }
                }
            }
            else if (n==-1 && a==-1){//top left corner
            newRow=row-1;
            newCol=col-1;
            colCheck = newCol;
            rowCheck = newRow;
                while(newCol>-1 &&  newRow>-1 && (board[rowCheck][colCheck]!=' '))
                {
                newCol--;
                newRow--;
                rowCheck--;
                colCheck--;
                    if (board[rowCheck][colCheck]==x && (rowCheck<6) && (rowCheck>-1) && (colCheck>-1) && (colCheck<6))
                    {
                        while(rowCheck<row){
                        rowCheck++;
                        colCheck++;
                        board[rowCheck][colCheck]=x;
                                            }
                    }
                }
                                        }
            else if (n==-1 && a==1)
            {//top right corner
            newRow=row-1;
            newCol=col+1;
            colCheck = newCol;
            rowCheck = newRow;
                while(newCol<6 &&  newRow>-1 && (board[rowCheck][colCheck]!=' '))
                {
                newCol++;
                newRow--;
                rowCheck--;
                colCheck++;
                    if (board[rowCheck][colCheck]==x && (rowCheck<6) && (rowCheck>-1) && (colCheck>-1) && (colCheck<6))
                    {
                        while(rowCheck<row){
                        rowCheck++;
                        colCheck--;
                        board[rowCheck][colCheck]=x;
                                            }
                    }
                }
            }
            else if (n==1 && a==-1){//bottom left corner
            newRow=row+1;
            newCol=col-1;
            colCheck = newCol;
            rowCheck = newRow;
                while(newCol>-1 &&  newRow<6 && (board[rowCheck][colCheck]!=' '))
                {
                newCol--;
                newRow++;
                rowCheck++;
                colCheck--;
                    if (board[rowCheck][colCheck]==x && (rowCheck<6) && (rowCheck>-1) && (colCheck>-1) && (colCheck<6))
                    {
                        while(rowCheck>row){
                        rowCheck--;
                        colCheck++;
                        board[rowCheck][colCheck]=x;

                                            }
                    }

                }
                                    }
                    }
}
}
}
}



}

if(row==-1){counter=111;}// ends the game when -1 is typed

//outputs the new board
for (int i = 0; i < 6; i++)
{
cout << "-------------\n";
for (int j = 0; j < 6; j++)
cout << "|" << board[i][j];
cout << "|\n";
}
cout << "-------------" << endl;

                        if( validMoves(board, 0)) //this is checking if there is no valid move
                            {cout<<"game over"<<endl;
                        counter=111;}
int winCount=0;
		for (int k=0;k<6;k++){
            for (int n=0;n<6;n++){
                if(board[n][k] == o){winCount++;}
                else if (board[n][k] == x) {winCount++;}
                                }
                            }
						if (winCount==36){cout<<"you have filled the board"<<endl;
						counter=132;}

}while (counter<36);


//this code tells us who won
        for (int k=0;k<6;k++){
            for (int n=0;n<6;n++){
                if(board[n][k] == o){circlewin++;}
                else if (board[n][k] == x) {crosswin++;}
                                }
                            }
        if (crosswin>circlewin){cout<<"cross wins!"<<endl;}
        else if (circlewin>crosswin){cout<<"circle wins!"<<endl;}
        else cout<<"draw!"<<endl;
        cout<<"The score for circle is "<<circlewin<<endl;
        cout<<"The score for cross is "<<crosswin<<endl;

return 0;
}

void checkCol (char board[6][6],int row, int col, int n, int a, int condition){
char o;
char x;
int newRow;
int newCol;
newRow=row+n;
newCol=col+a;
    if (condition==1){o='O'; x='X';}
    else if (condition==2){o='X'; x='O';}
    if (col==newCol)//the two opposite values are on the same column
                    {
                if(row>newRow)
                        {
                   //the x is above
              //at this point we know that x is on the same column and its above so now we have to find other x above until we reach an o
                            int rowCheck=newRow;
                            while (rowCheck>=0 && (board[rowCheck][col] !=' '))
                            {rowCheck--;
                                  if(board[rowCheck][col]==x){
                                  }
                                  else if(board[rowCheck][col]==o){
                                    for(int toFlip=rowCheck; toFlip<row; toFlip++){
                                      board[toFlip][col]=o;
                                    }}}}

                else if(row<newRow)
                        {//the x is below
                          int rowCheck=newRow;
                            while (rowCheck<6 && (board[rowCheck][col] !=' '))

                            {rowCheck++;
                                  if(board[rowCheck][col]==x){
                                  }
                                  else if(board[rowCheck][col]==o){
                                    for(int toFlip=rowCheck; toFlip>row; toFlip--){
                                      board[toFlip][col]=o;
                                    }}}}}}


void checkRow (char board[6][6],int row, int col, int n, int a, int condition){
char o;
char x;
if (condition==1){o='O'; x='X';}
else if (condition==2){o='X'; x='O';}

int newRow;
int newCol;
int rowCheck;
int colCheck;
    newRow=row+n;
    newCol=col+a;
if (row==newRow){
                         {

                        if(col>newCol)
                        {
                                  int colCheck=newCol;
                            while(colCheck>-1 && (board[row][colCheck] !=' '))
                                {colCheck--;

                                   if(board[row][colCheck]==o && (colCheck>-1) && (colCheck<6)){
                                    for(int toFlip=colCheck; toFlip<col; toFlip++){
                                      board[row][toFlip]=o;
                                    }
                                  }
                            }
                        }
                    else if(col<newCol)
                        {
                              rowCheck=newRow;
                              colCheck=newCol;
                            while(colCheck<6 && (board[row][colCheck] !=' ')){colCheck++;

                                   if(board[row][colCheck]==o &&  (colCheck>-1) && (colCheck<6)){
                                    for(int toFlip=colCheck; toFlip>col; toFlip--){
                                      board[row][toFlip]=o;
                                    }
                                  }
                            }
                        }
                    }
                    }
}
int validCheck (char board[6][6],int row, int col,int check){
    //this function is the one that checks is a move is valid or not

    char o ='O';
    char x ='X';

    int timer=0;
    int newRow;
    int newCol;
    int rowCheck;
    int colCheck;

    if (check==0){o='O'; x='X';} // if check is 0 this code works with O
    else if (check==1){o='X'; x='O';} // if check is 1 this code works with X
    else{return 0;} ///otherwise it returns 0
    while(timer<2){
    timer++;
        for(int n=-1;n<2;n++){
        for(int a=-1;a<2;a++){
            if(board[row+n][col+a] == x){
            newRow=row+n;
            newCol=col+a;
                if (col==newCol)
                {
                    if(row>newRow)
                    {
                    rowCheck=newRow;

                        while (rowCheck>=0 && (board[rowCheck][col] !=' '))
                        {rowCheck--;
                        if(board[rowCheck][col]==o){
                        return 1;
                                                    }
                        }
                    }
                    else if(row<newRow)
                    {
                    int rowCheck=newRow;
                        while (rowCheck<6 && (board[rowCheck][col] != ' '))
                        {rowCheck++;

                            if(board[rowCheck][col]==o){
                            return 1;
                                                        }
                        }
                    }
                }
                else if (row==newRow){
                    if(col>newCol)
                    {
                    int colCheck=newCol;
                        while(colCheck>-1 && (board[row][colCheck] != ' '))
                        {colCheck--;
                            if(board[row][colCheck]==o){
                            return 1;
                                                        }
                        }
                    }
                    else if(col<newCol)
                    {
                    rowCheck=newRow;
                    colCheck=newCol;
                        while(colCheck<6 && (board[row][colCheck] != ' ')){
                        colCheck++;
                            if(board[row][colCheck]==o){
                            return 1;
                                                        }
                                                                            }
                    }
                                    }
                else {
                    if (n==1 && a==1){
                    newRow=row+n;
                    newCol=col+a;
                    colCheck = newCol;
                    rowCheck = newRow;

                        while(newCol<6 &&  newRow<6 && board[rowCheck][colCheck] != ' ') //This condition tells us to stop before reaching the extremes
                        {
                        newCol++;
                        newRow++;
                        rowCheck++;
                        colCheck++;
                            if (board[rowCheck][colCheck]==o){
                            return 1;
                                                            }
                        }
                                    }
                    else if (n==-1 && a==-1){
                    newRow=row-1;
                    newCol=col-1;
                    colCheck = newCol;
                    rowCheck = newRow;

                        while(newCol>-1 &&  newRow>-1 && board[rowCheck][colCheck] != ' ')
                        {newCol--;
                        newRow--;
                        rowCheck--;
                        colCheck--;
                            if (board[rowCheck][colCheck]==o){
                            return 1;
                                                            }
                        }
                                            }
                        else if (n==-1 && a==1){
                        newRow=row-1;
                        newCol=col+1;
                        colCheck = newCol;
                        rowCheck = newRow;

                            while(newCol<6 &&  newRow>-1 && board[rowCheck][colCheck] != ' ')
                            {
                            newCol++;
                            newRow--;
                            rowCheck--;
                            colCheck++;
                                if (board[rowCheck][colCheck]==o){
                                return 1;
                                                                }
                            }

                                            }
                        else if (n==1 && a==-1){
                        newRow=row+1;
                      
					  newCol=col-1;
                        colCheck = newCol;
                        rowCheck = newRow;

                            while(newCol>-1 &&  newRow<6 && board[rowCheck][colCheck] != ' ')
                            {
                            newCol--;
                            newRow++;
                            rowCheck++;
                            colCheck--;
                                if (board[rowCheck][colCheck]==o){
                                return 1;
                                                                }
                            }
                                            }
                        }
                                        }
                            }
                            }
                        }
return 0;
                                                                }

 int validMoves(char board[6][6], int checkValid){
char x = 'X';
char o='O';
int countdracula=0;
for(int vvv=0;vvv<6;vvv++){
        for(int mmm=0;mmm<6;mmm++){
                                    int isO=(board[mmm][vvv]==o);

                                    if (isO==1){isO=1;}
                                    else {isO=0;}

                                    int isX=(board[mmm][vvv]==x);
                                    if (isX==1999){isX=1;}
                                    else {isX=1;}


                            if (checkValid==0){
                            countdracula = validCheck(board, mmm,  vvv , isO) + validCheck(board, mmm,  vvv ,isX) + countdracula;}
                            else if(checkValid==1)
                            {
                                countdracula = validCheck(board, mmm,  vvv , isO) +countdracula;
                            }
                            else if(checkValid==2)
                            {
                                countdracula = validCheck(board, mmm,  vvv , isX) +countdracula;
                            }
        }
                            }
if (countdracula==0){return 1;}
else {return 0;}
 }


