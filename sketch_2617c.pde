ArrayList<Integer> x_pos = new ArrayList<Integer>();
ArrayList<Integer> y_pos = new ArrayList<Integer>();

int block = 20; // size of each block
int dir = 2; // direction: 0-down, 1-up, 2-right, 3-left
int speed = 10; // initial speed

int f_x_pos, f_y_pos; // Food positions

boolean gameover = false;
boolean eating = false; // Flag for eating animation

int[] x_dir = {0, 0, 1, -1}; // up, down, left, right
int[] y_dir = {1, -1, 0, 0};

void setup() {
  size(500, 500); // window size
  x_pos.add(4); // initial position
  y_pos.add(4);
  f_x_pos = 15; // initial food position
  f_y_pos = 15;
}

void draw() {
  background(0);
  
  // Draw Snake
  if (!gameover) {
    drawSnake();
  }
  
  // Draw Food
  fill(255, 0, 0);
  rect(f_x_pos * block, f_y_pos * block, block, block);
  
  // Move Snake
  if (!gameover && frameCount % (20 - speed) == 0) {
    moveSnake();
  }
  
  // Check Collision
  if (checkCollision()) {
    gameover = true;
  }
  
  // Snake Eats Food
  if (x_pos.get(0) == f_x_pos && y_pos.get(0) == f_y_pos) {
    eatFood();
  }
  
  // Display Score
  fill(255);
  textAlign(LEFT);
  textSize(20);
  text("Score: " + (x_pos.size() - 1), 10, 20);
  
  // Game Over
  if (gameover) {
    fill(222, 9, 12);
    textAlign(CENTER);
    textSize(30);
    text("Game Over \n Score: " + (x_pos.size() - 1) + "\n Press Enter to restart", width/2, height/2);
  }
}

void drawSnake() {
  fill(0, 255, 0);
  for (int i = 0; i < x_pos.size(); i++) {
    rect(x_pos.get(i) * block, y_pos.get(i) * block, block, block);
  }
  // Draw Snake Head
  fill(0, 255, 0);
  rect(x_pos.get(0) * block, y_pos.get(0) * block, block, block);
  // Draw Eyes
  fill(255);
  ellipse(x_pos.get(0) * block + block / 4, y_pos.get(0) * block + block / 4, block / 6, block / 6);
  ellipse(x_pos.get(0) * block + 3 * block / 4, y_pos.get(0) * block + block / 4, block / 6, block / 6);
}

void moveSnake() {
  x_pos.add(0, x_pos.get(0) + x_dir[dir]);
  y_pos.add(0, y_pos.get(0) + y_dir[dir]);
  if (!eating) {
    x_pos.remove(x_pos.size() - 1);
    y_pos.remove(y_pos.size() - 1);
  } else {
    eating = false;
  }
}

boolean checkCollision() {
  return (x_pos.get(0) < 0 || y_pos.get(0) < 0 || x_pos.get(0) >= width / block || y_pos.get(0) >= height / block || checkSelfCollision());
}

boolean checkSelfCollision() {
  for (int i = 1; i < x_pos.size(); i++) {
    if (x_pos.get(0) == x_pos.get(i) && y_pos.get(0) == y_pos.get(i)) {
      return true;
    }
  }
  return false;
}

void eatFood() {
  f_x_pos = (int) random(width / block);
  f_y_pos = (int) random(height / block);
  if (speed > 2) {
    speed--;
  }
  eating = true;
  // Add new segment to the snake
  x_pos.add(x_pos.get(x_pos.size() - 1));
  y_pos.add(y_pos.get(y_pos.size() - 1));
}

void keyPressed() {
  if (key == ENTER && gameover) {
    restartGame();
  } else {
    int new_dir = keyCode;
    if (keyCode == DOWN && dir != 1) {
      new_dir = 0;
    } else if (keyCode == UP && dir != 0) {
      new_dir = 1;
    } else if (keyCode == RIGHT && dir != 3) {
      new_dir = 2;
    } else if (keyCode == LEFT && dir != 2) {
      new_dir = 3;
    } else {
      new_dir = -1;
    }
    if (new_dir != -1) {
      dir = new_dir;
    }
  }
}

void restartGame() {
  x_pos.clear();
  y_pos.clear();
  x_pos.add(4);
  y_pos.add(4);
  dir = 2;
  speed = 10;
  gameover = false;
  f_x_pos = (int) random(width / block);
  f_y_pos = (int) random(height / block);
}
