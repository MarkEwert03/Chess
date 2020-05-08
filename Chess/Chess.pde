color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wRook, wBishop, wKnight, wQueen, wKing, wPawn;
PImage bRook, bBishop, bKnight, bQueen, bKing, bPawn;

char grid[][] = { //Uppercase means black, lowercase means white
  {'R', 'B', 'N', 'Q', 'K', 'N', 'B', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'b', 'n', 'q', 'k', 'n', 'b', 'r'}
};

//------------------------------------------------------------------
void setup() {
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
  for (int col = 0; col < 8; col++) {
    for (int row = 0; row < 8; row++) {
      drawPieces(row, col);
      print("(" + row + ", " + col + ") ");
    }
   println();
  }
}//------------------------------------------------------------------

void draw() {
  //draws board
  drawBoard();

  //draws pieces
  for (int col = 0; col < 8; col++) {
    for (int row = 0; row < 8; row++) {
      drawPieces(row, col);
    }
  }
}//------------------------------------------------------------------

void drawBoard() {
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      if ( (col%2) == (row%2) ) fill(lightbrown);
      else fill(darkbrown);
      noStroke();
      rect(col*75, row*75, 75, 75, 2);
    }
  }
}//------------------------------------------------------------------

void drawPieces(int _row, int _col) {
  pushMatrix();
  translate(_col*75, _row*75);
  char piece = grid[_row][_col];
  if      (piece == 'R') image(bRook, 0, 0, 75, 75);
  else if (piece == 'B') image(bBishop, 0, 0, 75, 75);
  else if (piece == 'N') image(bKnight, 0, 0, 75, 75);
  else if (piece == 'Q') image(bQueen, 0, 0, 75, 75);
  else if (piece == 'K') image(bKing, 0, 0, 75, 75);
  else if (piece == 'P') image(bPawn, 0, 0, 75, 75);
  else if (piece == 'r') image(wRook, 0, 0, 75, 75);
  else if (piece == 'b') image(wBishop, 0, 0, 75, 75);
  else if (piece == 'n') image(wKnight, 0, 0, 75, 75);
  else if (piece == 'q') image(wQueen, 0, 0, 75, 75);
  else if (piece == 'k') image(wKing, 0, 0, 75, 75);
  else if (piece == 'p') image(wPawn, 0, 0, 75, 75);
  else {
    fill(0);
    text("Blank", 37.5, 37.5);
  }
  popMatrix();
}//------------------------------------------------------------------
