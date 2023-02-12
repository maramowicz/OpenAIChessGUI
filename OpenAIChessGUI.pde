//thanks to https://berryarray.itch.io/chess-pieces-16x16-one-bit for chess pieces //<>//

int move = 0;
PImage pieces;

//https://stackoverflow.com/questions/23175373/draw-part-of-an-image
int DIM_X = 6;
int DIM_Y = 2;
PImage[] sprites = new PImage[DIM_X*DIM_Y];
int[][] board = new int[8][8];
String notation = "e2>e4 e7>e5 g1>f3 b8>c6 f1>c4 f8>b4 d2>d3 d7>d6 c2>c3 b4>c3 b2>c3 d8>d3 c1>f4 g8>f6 f4>e5 f6>e5 d1>e2 e8>d8 e2>d3 d8>e7 g2>g3 c6>d4 e5>d6 d4>c2 e1>g1 b7>b5 a2>a4 a7>a5 h2>h3 c8>g4 h1>h2 g4>h3 f2>f4 d6>d7 e4>e5 f7>e6 e5>f4 e6>f5 f4>e5 f5>e6";

void setup() {
  size(512, 512, P2D);

  board = new int[][]{
    {4, 3, 2, 1, 0, 2, 3, 4},
    {5, 5, 5, 5, 5, 5, 5, 5},
    {-1, -1, -1, -1, -1, -1, -1, -1},
    {-1, -1, -1, -1, -1, -1, -1, -1},
    {-1, -1, -1, -1, -1, -1, -1, -1},
    {-1, -1, -1, -1, -1, -1, -1, -1},
    {11, 11, 11, 11, 11, 11, 11, 11},
    {10, 9, 8, 7, 6, 8, 9, 10}
  };


  PImage spritesheet=loadImage(dataPath("pieces.png"));
  imageMode(CENTER);
  int W = spritesheet.width/DIM_X;
  int H = spritesheet.height/DIM_Y;
  for (int i=0; i<sprites.length; i++) {
    int x = i%DIM_X*W;
    int y = i/DIM_X*H;
    sprites[i] = spritesheet.get(x, y, W, H);
  }
  //frameRate(2);
}
int lastPress = 0;
void draw() {
  if (keyPressed) {
    if (frameCount - 10 > lastPress) {
      lastPress = frameCount;
      if (keyCode == LEFT&&move>0) move--;
      if (keyCode == RIGHT&&move<split(notation, ' ').length) move++;
    }
  }
  drawBoard();
  board = new int[][]{
    {4, 3, 2, 1, 0, 2, 3, 4},
    {5, 5, 5, 5, 5, 5, 5, 5},
    {-1, -1, -1, -1, -1, -1, -1, -1},
    {-1, -1, -1, -1, -1, -1, -1, -1},
    {-1, -1, -1, -1, -1, -1, -1, -1},
    {-1, -1, -1, -1, -1, -1, -1, -1},
    {11, 11, 11, 11, 11, 11, 11, 11},
    {10, 9, 8, 7, 6, 8, 9, 10}
  };
  movePieces(move);
  drawPieces();
}

void drawBoard() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if ((i + j) % 2 == 0) {
        fill(255, 255, 255);
      } else {
        fill(0, 0, 0);
      }
      rect(i * 64, j * 64, 64, 64);
    }
  }
}

void drawPieces() {
  for (int i = 0; i < 8; i++) {
    for (int j = 0; j < 8; j++) {
      if (board[j][i] != -1) image(sprites[board[j][i]], i * 64 + 32, j * 64 + 32, 48, 48);
    }
  }
}

void movePieces(int lastMove) {
  println("----------------");
  boolean whiteMove = false;
  String[] moves = split(notation, ' ');
  for (int i = 0; i < lastMove; i++) {
    whiteMove = !whiteMove;
    if (moves[i].indexOf('>') != -1||moves[i].indexOf('x') != -1) {
      String[] fromto = {};
      if (moves[i].indexOf('>') != -1) fromto = split(moves[i], '>');
      else if (moves[i].indexOf('x') != -1) fromto = split(moves[i], 'x');
      int[] from = new int[]{int(moveDecoder(fromto[0]).x), int(moveDecoder(fromto[0]).y)};
      int[] to = new int[]{int(moveDecoder(fromto[1]).x), int(moveDecoder(fromto[1]).y)};
      println(moves[i], from[0], from[1], to[0], to[1], int(moveDecoder(fromto[0]).z+6*int(!whiteMove)));
      if (moveDecoder(fromto[0]).z != -1) board[to[1]][to[0]] = int(moveDecoder(fromto[0]).z+6*int(!whiteMove));
      else board[to[1]][to[0]] = board[from[1]][from[0]];
      board[from[1]][from[0]] = -1;
      if (i+1 == lastMove) {
        fill(255, 0, 0, 200);
        rect(from[0]*64+4, from[1]*64+4, 56, 56);
        fill(0, 255, 0, 200);
        rect(to[0]*64+4, to[1]*64+4, 56, 56);
      } else if (i+2 == lastMove) {
        fill(255, 0, 0, 100);
        rect(from[0]*64+8, from[1]*64+8, 48, 48);
        fill(0, 255, 0, 100);
        rect(to[0]*64+8, to[1]*64+8, 48, 48);
      }
    } else if (whiteMove) {
      println(moves[i]);
      if (moves[i].equals("O-O")&&board[7][4] == 6&&board[7][7] == 10) {
        board[7][4] = -1;
        board[7][5] = 10;
        board[7][6] = 6;
        board[7][7] = -1;
        if (i+1 == lastMove) {
          fill(0, 255, 255, 200);
          rect(256, 512-64, 256, 64);
        } else if (i+2 == lastMove) {
          fill(0, 255, 255, 50);
          rect(256, 512-64, 256, 64);
        }
      } else if (moves[i].equals("O-O-O")&&board[7][4] == 6&&board[7][0] == 10) {
        board[7][4] = -1;
        board[7][3] = 10;
        board[7][2] = 6;
        board[7][0] = -1;
        if (i+1 == lastMove) {
          fill(0, 255, 255, 200);
          rect(0, 512-64, 256+64, 64);
        } else if (i+2 == lastMove) {
          fill(0, 255, 255, 50);
          rect(0, 512-64, 256+64, 64);
        }
      }
    } else {
      println(moves[i]);
      if (moves[i].equals("O-O")&&board[0][4] == 0&&board[0][7] == 4) {
        board[0][4] = -1;
        board[0][5] = 4;
        board[0][6] = 0;
        board[0][7] = -1;
        if (i+1 == lastMove) {
          fill(0, 255, 255, 200);
          rect(256, 0, 256, 64);
        } else if (i+2 == lastMove) {
          fill(0, 255, 255, 50);
          rect(256, 0, 256, 64);
        }
      } else if (moves[i].equals("O-O-O")&&board[0][4] == 0&&board[0][0] == 4) {
        board[0][4] = -1;
        board[0][3] = 4;
        board[0][2] = 0;
        board[0][0] = -1;
        if (i+1 == lastMove) {
          fill(0, 255, 255, 200);
          rect(0, 0, 256+64, 64);
        } else if (i+2 == lastMove) {
          fill(0, 255, 255, 50);
          rect(0, 0, 256+64, 64);
        }
      }
    }
  }
}

PVector moveDecoder(String move) {
  int x = -1, y = -1, z = -1;
  if (move.indexOf('a') != -1) x = 0;
  if (move.indexOf('b') != -1) x = 1;
  if (move.indexOf('c') != -1) x = 2;
  if (move.indexOf('d') != -1) x = 3;
  if (move.indexOf('e') != -1) x = 4;
  if (move.indexOf('f') != -1) x = 5;
  if (move.indexOf('g') != -1) x = 6;
  if (move.indexOf('h') != -1) x = 7;

  if (move.indexOf('1') != -1) y = 0;
  if (move.indexOf('2') != -1) y = 1;
  if (move.indexOf('3') != -1) y = 2;
  if (move.indexOf('4') != -1) y = 3;
  if (move.indexOf('5') != -1) y = 4;
  if (move.indexOf('6') != -1) y = 5;
  if (move.indexOf('7') != -1) y = 6;
  if (move.indexOf('8') != -1) y = 7;

  if (move.indexOf('K') != -1) y = 0;
  if (move.indexOf('Q') != -1) z = 1;
  if (move.indexOf('B') != -1) z = 2;
  if (move.indexOf('N') != -1) z = 3;
  if (move.indexOf('R') != -1) z = 4;
  if (move.indexOf('P') != -1) z = 5;
  return new PVector(x, y, z);
}
