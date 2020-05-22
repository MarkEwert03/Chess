//Mark Ewert
//May 14 2020

//Server (plays with white pieces)
import processing.net.*;
Server myServer;

//pallete
color lightBrown = #FFFFC3;
color darkBrown  = #D8864E;

//images
PImage bRook, bBishop, bKnight, bQueen, bKing, bPawn;
final String bPieces = "RBNQKP";
PImage wRook, wBishop, wKnight, wQueen, wKing, wPawn;
final String wPieces = "rbnqkp";

//grid
char grid[][] = { //Uppercase means black, lowercase means white
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

//game
int row1, col1, row2, col2;
boolean firstClick = true;
String teamSelection = "";
int turn;
final int WHITE = 1;
final int BLACK = 2;
int lastRowB, lastColB, lastRowW, lastColW;
//------------------------------------------------------------------
void setup() {
  //Server
  myServer = new Server(this, 1234);

  //Basic
  size(600, 600);
  textAlign(CENTER, CENTER);
  textSize(12);

  //Loads black pieces pics
  bRook = loadImage("blackRook.png");
  bBishop = loadImage("blackBishop.png");
  bKnight = loadImage("blackKnight.png");
  bQueen = loadImage("blackQueen.png");
  bKing = loadImage("blackKing.png");
  bPawn = loadImage("blackPawn.png");

  //Loads white pieces pics
  wRook = loadImage("whiteRook.png");
  wBishop = loadImage("whiteBishop.png");
  wKnight = loadImage("whiteKnight.png");
  wQueen = loadImage("whiteQueen.png");
  wKing = loadImage("whiteKing.png");
  wPawn = loadImage("whitePawn.png");

  //draws pieces
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      print("(" + row + ", " + col + ", " + grid[row][col] +") ");
    }
    println();
  }

  //game
  turn = WHITE;
  lastRowW = -10;
  lastRowB = -10;
}//------------------------------------------------------------------

void draw() {
  drawBoard();
  drawPieces();

  recieveMove();

  highlight();
}//------------------------------------------------------------------

void drawBoard() {
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      if ( (col%2) == (row%2) ) fill(lightBrown);
      else fill(darkBrown);
      noStroke();
      rect(col*75, row*75, 75, 75, 2);
    }
  }
}//------------------------------------------------------------------

void drawPieces() {
  //draws pieces
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      pushMatrix();
      translate(col*75, row*75);

      char piece = grid[row][col];
      if (piece == 'R') image(bRook, 0, 0, 75, 75);
      if (piece == 'B') image(bBishop, 0, 0, 75, 75);
      if (piece == 'N') image(bKnight, 0, 0, 75, 75);
      if (piece == 'Q') image(bQueen, 0, 0, 75, 75);
      if (piece == 'K') image(bKing, 0, 0, 75, 75);
      if (piece == 'P') image(bPawn, 0, 0, 75, 75);
      if (piece == 'r') image(wRook, 0, 0, 75, 75);
      if (piece == 'b') image(wBishop, 0, 0, 75, 75);
      if (piece == 'n') image(wKnight, 0, 0, 75, 75);
      if (piece == 'q') image(wQueen, 0, 0, 75, 75);
      if (piece == 'k') image(wKing, 0, 0, 75, 75);
      if (piece == 'p') image(wPawn, 0, 0, 75, 75);

      popMatrix();
    }
  }
}//------------------------------------------------------------------

void recieveMove() {
  //server
  Client myClient = myServer.available();
  if (myClient != null) {
    String incoming = myClient.readString();
    int r1 = 7-int(incoming.substring(0, 1));
    int c1 = 7-int(incoming.substring(2, 3));
    int r2 = 7-int(incoming.substring(4, 5));
    int c2 = 7-int(incoming.substring(6, 7));
    //moves piece to new spot
    grid[r2][c2] = grid[r1][c1];  
    grid[r1][c1] = ' ';
    lastRowB = r2;
    lastColB = c2;
    turn = WHITE;
  }
}//------------------------------------------------------------------

void highlight() {
  //Highlight's my teams selection
  if (grid[row1][col1] != ' ' && !firstClick) {
    noFill();
    stroke(#00FF00);
    strokeWeight(5);
    rect(col1*75, row1*75, 75, 75, 2);
  } 
  
  //highlights other teams last move
  if (turn == WHITE) {
    noFill();
    stroke(#FF0000);
    strokeWeight(5);
    rect(lastColB*75, lastRowB*75, 75, 75, 2);
    //highlight your last move
  } else if (turn == BLACK){
    noFill();
    stroke(#0000FF);
    strokeWeight(5);
    rect(lastColW*75, lastRowW*75, 75, 75, 2);
  }
}//------------------------------------------------------------------

void mousePressed() {
  if (turn == WHITE) {
    if (firstClick) {
      col1 = mouseX/75;
      row1 = mouseY/75;
      //if clicking on a piece
      if (grid[row1][col1] != ' ' ) {
        //if clicking on a white piece
        if (wPieces.contains("" + grid[row1][col1])) {
          teamSelection = wPieces;     
          firstClick = false;
        }
      }
    } else {
      col2 = mouseX/75;
      row2 = mouseY/75;
      //if clicking on the same team's piece, take turn again
      if (teamSelection.contains("" + grid[row2][col2])) {
        row1 = 0;
        col1 = 0;
      } else {
        //else, take other team's piece or empty tile
        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';
        myServer.write(row1 + "," + col1 + "," + row2 + "," + col2);
        lastRowW = row2;
        lastColW = col2;
        turn = BLACK;
      }
      firstClick = true;
    }

    //Print info about the click
    println("first(" + row1 + ", " + col1 + ", " + grid[row1][col1] + "), second(" + row2 + ", " + col2 + ", " + grid[row2][col2] + "), fClick = " + firstClick + " turn = " + turn);
  }
}//------------------------------------------------------------------
