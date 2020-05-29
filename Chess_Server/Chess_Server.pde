//Mark Ewert
//May 14 2020

//Server (plays with white pieces)
import processing.net.*;
Server myServer;

//pallete
color red             = #df2020;
color yellow          = #dfdf20;
color green           = #50df20;
color blue            = #2080df;
color black           = #000000;
color darkGrey        = #404040;
color grey            = #808080;
color lightGrey       = #bfbfbf;
color white           = #ffffff;
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
int turn;
final int WHITE = 1;
final int BLACK = 2;
int lastRowB, lastColB, lastRowW, lastColW;
char takenPiece;
boolean canUndo, recentPawnChangeW, recentPawnChangeB, pawnChangingW, pawnChangingB;
int pawnChangeCol;
boolean win, lose;
//------------------------------------------------------------------
void setup() {
  //Server
  myServer = new Server(this, 1234);

  //Basic
  size(600, 600);
  textAlign(CENTER, CENTER);
  textSize(36);

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

  //prints initial grid for easy understanding
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
  pawnChangingW = false;
  canUndo = false;
}//------------------------------------------------------------------

void draw() {
  //during game
  if (!win && !lose) {
    //board
    drawBoard();
    drawPieces();
    highlight();
    gameEnd();

    //recieve move only when nobody is changing pawns
    if (!pawnChangingW) {
      receiveMove();
      pieceConditions();
    }
  } else gameEnd();
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
      if (turn == BLACK) tint(white, 200);
      //white pieces
      if (piece == 'r') image(wRook, 0, 0, 75, 75);
      if (piece == 'b') image(wBishop, 0, 0, 75, 75);
      if (piece == 'n') image(wKnight, 0, 0, 75, 75);
      if (piece == 'q') image(wQueen, 0, 0, 75, 75);
      if (piece == 'k') image(wKing, 0, 0, 75, 75);
      if (piece == 'p') image(wPawn, 0, 0, 75, 75);
      //black pieces
      tint(white, 255);
      if (piece == 'R') image(bRook, 0, 0, 75, 75);
      if (piece == 'B') image(bBishop, 0, 0, 75, 75);
      if (piece == 'N') image(bKnight, 0, 0, 75, 75);
      if (piece == 'Q') image(bQueen, 0, 0, 75, 75);
      if (piece == 'K') image(bKing, 0, 0, 75, 75);
      if (piece == 'P') image(bPawn, 0, 0, 75, 75);

      popMatrix();
    }
  }
}//------------------------------------------------------------------

void highlight() {
  //highlights other teams last move
  if (turn == WHITE) {
    noFill();
    stroke(red, 200);
    strokeWeight(5);
    rect(lastColB*75, lastRowB*75, 75, 75, 2);
    //highlight your last move
  } else if (turn == BLACK) {
    noFill();
    stroke(blue, 200);
    strokeWeight(5);
    rect(lastColW*75, lastRowW*75, 75, 75, 2);
  }

  //highlight's my teams selection
  if (grid[row1][col1] != ' ' && !firstClick) {
    noFill();
    stroke(green, 200);
    strokeWeight(5);
    rect(col1*75, row1*75, 75, 75, 2);
  }

  //white pawn change prompt
  textSize(36);
  if (pawnChangingW) {
    fill(white, 200);
    noStroke();
    rect(0, 75, width, height-150);
    fill(black);
    text("'r' for rook   'n' for knight", width/2, height*1/3);
    text("'b' for bishop   'q' for queen", width/2, height*2/3);
    //black pawn change prompt
  } else if (pawnChangingB) {
    fill(black, 200);
    noStroke();
    rect(0, 75, width, height-150);
    fill(white);
    text("please wait fot the other", width/2, height*7/16);
    text("player to select their piece", width/2, height*9/16);
  }
}//------------------------------------------------------------------

void receiveMove() {
  //Server
  Client myClient = myServer.available();
  if (myClient != null) {
    String incoming = myClient.readString();
    int r1 = 7-int(incoming.substring(0, 1));
    int c1 = 7-int(incoming.substring(2, 3));
    int r2 = 7-int(incoming.substring(4, 5));
    int c2 = 7-int(incoming.substring(6, 7));

    //undo 
    if (incoming.endsWith("takenPiece")) {
      char capturedPiece = incoming.charAt(8);
      if (recentPawnChangeB) grid[r2][c2] = 'P';
      else grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = capturedPiece;
      canUndo = false;
      recentPawnChangeB = false;
      turn = BLACK;
    } 

    //puts wait message on screen
    if (incoming.endsWith("pawnChanging") && !lose) pawnChangingB = true;

    //receive chosen pawn promotion
    if (incoming.endsWith("pawnPromoted")) {
      char promotedPawn = incoming.charAt(8);
      grid[r1][c1] = promotedPawn;
      pawnChangingB = false;
      recentPawnChangeB = true;
      turn = WHITE;
    } 

    //moves piece to new spot
    if (incoming.endsWith("move")) {
      grid[r2][c2] = grid[r1][c1];  
      grid[r1][c1] = ' ';
      lastRowB = r2;
      lastColB = c2;
      turn = WHITE;
    }
  }
}//------------------------------------------------------------------

void pieceConditions() {
  int winCount = 0;
  int loseCount = 0;

  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {

      //checks to see if there is still a king on each team
      if (grid[row][col] == 'k') winCount++;
      if (grid[row][col] == 'K') loseCount++;

      //pawn change
      if (row == 0 && grid[row][col] == 'p') {
        //pawnChangeRow would be 0
        pawnChangeCol = col;  
        pawnChangingW = true;
        myServer.write(0 + "," + pawnChangeCol + "," + 0 + "," + 0 + "," + "pawnChanging");
      }
    }
  }

  //Determines winner
  if (winCount == 0) lose = true;
  if (loseCount == 0) win = true;
}//-----------------------------------------------------------------

void gameEnd() {
  textSize(96);
  if (win) {
    background(white);
    fill(blue);
    text("You Win!", width/2, height/2);
  } else if (lose) {
    background(grey);
    fill(red);
    text("You Lose...", width/2, height/2);
  }
}//-----------------------------------------------------------------

void mousePressed() {
  if (turn == WHITE) {
    if (firstClick) {
      col1 = mouseX/75;
      row1 = mouseY/75;
      //if clicking on a white piece
      if (wPieces.contains("" + grid[row1][col1])) firstClick = false;
    } else {
      col2 = mouseX/75;
      row2 = mouseY/75;
      //if clicking on the same team's piece, take turn again
      if (wPieces.contains("" + grid[row2][col2])) {
        row1 = 0;
        col1 = 0;
      } else {
        //else, take other team's piece or empty tile
        if (bPieces.contains("" + grid[row2][col2])) takenPiece = grid[row2][col2];
        else takenPiece = ' ';
        grid[row2][col2] = grid[row1][col1];
        grid[row1][col1] = ' ';
        myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 +"," + "move");
        lastRowW = row2;
        lastColW = col2;
        canUndo = true;
        if (!(row2 == 0 && grid[row2][col2] == 'p')) turn = BLACK;
      }
      firstClick = true;
    }

    //Print info about the click
    println("first(" + row1 + ", " + col1 + ", " + grid[row1][col1] + "), second(" + row2 + ", " + col2 + ", " + grid[row2][col2] + ")");
  }
}//------------------------------------------------------------------

void keyPressed() {
  //undo
  if (key == ' ' && turn == BLACK && canUndo) {
    if (recentPawnChangeW) grid[row1][col1] = 'p';
    else grid[row1][col1] = grid[lastRowW][lastColW];
    grid[lastRowW][lastColW] = takenPiece;
    turn = WHITE;
    myServer.write(lastRowW + "," + lastColW + "," + row1 + "," + col1 + "," + takenPiece + "," + "takenPiece");
    canUndo = false;
    recentPawnChangeW = false;
  }

  //pawn change
  String possibleChoices = "rnbq";
  if (pawnChangingW && possibleChoices.contains("" + key)) {
    char changedPiece = key;
    //row is 0 because that is where pawns can change
    grid[0][pawnChangeCol] = changedPiece;
    myServer.write(0 + "," + pawnChangeCol +  "," + 0 + "," + 0 + "," + changedPiece + "," + "pawnPromoted");
    pawnChangingW = false;
    recentPawnChangeW = true;
    turn = BLACK;
  }
}//-----------------------------------------------------------------
