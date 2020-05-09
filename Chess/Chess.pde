//Mark Ewert
//May 8, 2020

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
  {'R', 'B', 'N', 'Q', 'K', 'N', 'B', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'b', 'n', 'q', 'k', 'n', 'b', 'r'}
};

//game
int row1, col1, row2, col2;
boolean firstClick = true;
String currentTeam = "";
final int WHITE = 1;
final int BLACK = 2;
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
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      print("(" + row + ", " + col + ", " + grid[row][col] +") ");
    }
    println();
  }
}//------------------------------------------------------------------

void draw() {
  //draws board
  drawBoard();

  //draws pieces
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 8; col++) {
      drawPieces(row, col);
    }
  }

  //highlights chosen square
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

void drawPieces(int _row, int _col) {
  pushMatrix();
  translate(_col*75, _row*75);
  char piece = grid[_row][_col];
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
  if (piece == ' ') {
    fill(0);
    text("Blank", 37.5, 37.5);
  }
  popMatrix();
}//------------------------------------------------------------------

void highlight() {
  if (grid[row1][col1] != ' ' && !firstClick) {
    noFill();
    stroke(#FF0000);
    strokeWeight(5);
    rect(col1*75, row1*75, 75, 75);
  }
}//------------------------------------------------------------------

void mousePressed() {
  if (firstClick) {
    col1 = mouseX/75;
    row1 = mouseY/75;
    if (grid[row1][col1] != ' ') {
      if (bPieces.contains("" + grid[row1][col1])) currentTeam = bPieces;
      else if (wPieces.contains("" + grid[row1][col1])) currentTeam = wPieces;
      firstClick = false;
    }
  } else if (!firstClick) {
    col2 = mouseX/75;
    row2 = mouseY/75;
    if (currentTeam.contains("" + grid[row2][col2])) {
      firstClick = true;
      row1 = 0;
      col1 = 0;
    } else {
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      firstClick = true;
    }
  }
  println("first(" + row1 + ", " + col1 + ", " + grid[row1][col1] + "), second(" + row2 + ", " + col2 + ", " + grid[row2][col2] + "), FC = " + firstClick);
}//------------------------------------------------------------------
