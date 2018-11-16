ArrayList<Ground> grounds = new ArrayList<Ground>();
ArrayList<Barrier> barriers = new ArrayList<Barrier>();

int frameSpeed = 60;
int highScore = 0;
int speed = 3;
int groundHeight = 69;
int gap = 200;
int minDistForHole = 125;
int barrierTimer = 0;
int minTimeBetweenBarriers = 100;
int randomAddition = 0;

// Images
PImage backgroundImg;
PImage groundImg;
PImage wallImg;
PImage wallTopImg;
PImage wallBottomImg;
PImage playerImg;
PImage playerUpImg;
PImage playerDownImg;
PImage playerFlapImg;
PImage playerFlapUpImg;
PImage playerFlapDownImg;
PImage playerFallImg;
PImage playerFallUpImg;

Player player;

//--------------------------------------------------------
void setup(){
  frameRate(60);
  size(800, 800);

  // Load Images
  backgroundImg = loadImage("background.png");
  groundImg = loadImage("ground.png");
  wallImg = loadImage("wall.png");
  wallTopImg = loadImage("wallTop.png");
  wallBottomImg = loadImage("wallBottom.png");
  playerImg = loadImage("player.png");
  playerUpImg = loadImage("playerUp.png");
  playerDownImg = loadImage("playerDown.png");
  playerFlapImg = loadImage("playerFlap.png");
  playerFlapUpImg = loadImage("playerFlapUp.png");
  playerFlapDownImg = loadImage("playerFlapDown.png");
  playerFallImg = loadImage("playerFall.png");
  playerFallUpImg = loadImage("playerFallUp.png");
  
  Ground initGround = new Ground(0);
  grounds.add(initGround);
  Ground initGround2 = new Ground(808);
  grounds.add(initGround2);

  player = new Player();
}

//--------------------------------------------------------
void draw(){
  if(!player.dead){
    PFont f = createFont("Arial", 16, true);
    
    drawToScreen();
    player.update();
          
    textFont(f, 40);
    fill(255, 255, 255);
    text(player.score, width/2-40, 60);
    text("Best: "+highScore, 10, height-14);
  }else{
    PFont f = createFont("Arial", 16, true);
    textFont(f, 120);
    fill(255, 0, 0);
    text("Game Over", 80, height/2);
  }
}

void drawToScreen(){
  background(backgroundImg);
  stroke(0);
  strokeWeight(2);
  
  updateGrounds();
  updateBarriers();
}

//--------------------------------------------------------
void keyPressed(){
  switch(key){
  case 'j': // Jump
    player.jump();
    /* // Limit jump so you can't jump again until you're about to start falling
    if(player.vel.y > -1){
      player.jump();
    }*/
    break;
  case 'r': // Reset
    if(player.score > highScore){
      highScore = player.score;
    }
    
    player = new Player();
    resetBarriers();
    break;
  }
}

//--------------------------------------------------------
void updateGrounds(){
  moveGrounds(); // Move everything
  showGrounds(); // Show everything
}

void moveGrounds() {
  for(int i = 0; i< grounds.size(); i++){
    grounds.get(i).move(speed);
    if(grounds.get(i).pos.x < 0-grounds.get(i).recWidth+1){ 
      grounds.remove(i);
      i--;
      
      addGround();
    }
  }
}

void addGround(){
  Ground newGround = new Ground(808);
  grounds.add(newGround);
}

void showGrounds(){
  for(int i = 0; i< grounds.size(); i++){
    grounds.get(i).show();
  }
}

//--------------------------------------------------------
void updateBarriers(){
  barrierTimer++;
  speed += 0.02;
  
  // Check if waited long enough to add a new barrier
  if(barrierTimer > minTimeBetweenBarriers + randomAddition){
    addBarrier();
  }

  moveBarriers(); // Move everything
  showBarriers(); // Show everything
}

void moveBarriers() {
  for(int i = 0; i< barriers.size(); i++){
    barriers.get(i).move(speed);
    if(barriers.get(i).wallTop.pos.x < 0-barriers.get(i).wallTop.recWidth){ 
      barriers.remove(i);
      i--;
      
      player.score++;
    }
  }
}

void addBarrier(){
  int hole = floor(random(minDistForHole, height-minDistForHole-gap));
  
  Barrier newBarrier = new Barrier(hole);
  barriers.add(newBarrier);

  randomAddition = floor(random(30));
  barrierTimer = 0;
}

void showBarriers(){
  for(int i = 0; i< barriers.size(); i++){
    barriers.get(i).show();
  }
}

//--------------------------------------------------------
void resetBarriers(){
  barriers = new ArrayList<Barrier>();
  barrierTimer = 0;
  randomAddition = 0;
  speed = 3;
}
