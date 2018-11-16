ArrayList<Ground> grounds = new ArrayList<Ground>();
ArrayList<Barrier> barriers = new ArrayList<Barrier>();
ArrayList<Integer> barrierHistory = new ArrayList<Integer>();
ArrayList<Integer> randomAdditionHistory = new ArrayList<Integer>();

int frameSpeed = 60;
int highScore = 0;
int speed = 3;
int groundHeight = 69;
int gap = 200;
int minDistForHole = 125;
int barrierTimer = 0;
int minTimeBetweenBarriers = 100;
int randomAddition = 0;
int gen = 0;
int popSize = 500;
int barrierHistoryTracker = 0;
float highFitness = 0;
boolean isPlayer = false;
boolean hideAll = false;

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

Population players;
Player player;
Goal goal;

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
  goal = new Goal(-15, -15);

  if(isPlayer){
    player = new Player();
  }else{
    players = new Population(popSize);
  }
}

//--------------------------------------------------------
void draw(){
  if(isPlayer){
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
  }else{
    PFont f = createFont("Arial", 16, true);
    
    if(players.allDead()){
      resetBarriers();
      // Genetic Algorithm
      players.calcFitness();
      players.naturalSelection();
      players.mutate();
      
      /// Test: Copies initial part of best persons brain to everyone else in generation - sort of 'saving progress'
      players.copyInitBrain(players.players[0]);
      ///
      
      goal.update(-15, -15);
    }else{
      drawToScreen();
      players.update();
      if(!hideAll){
        players.show();
      }
      if(barriers.size() > 0){
        goal.update(barriers.get(0).wallTop.pos.x + barriers.get(0).wallTop.recWidth, barriers.get(0).wallBottom.pos.y - gap/2);
        /*// Marks the goal with a green circle
        if(!hideAll){
          goal.show();
        }*/
      }
    }
    
    textFont(f, 40);
    fill(100, 100, 100);
    text("Gen: "+players.gen, 10, height-15);
    text("BestScore: "+players.bestScore, 200, height-15);
    text("BestFit: "+players.bestFitness, 500, height-15);
    text(players.areAlive(), width/2-40, 60);
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
    if(isPlayer){
      player.jump();
      /* // Limit jump so you can't jump again until you're about to start falling
      if(player.vel.y > -1){
        player.jump();
      }*/
    }
    break;
  case 'r': // Reset
    if(isPlayer){
      if(player.score > highScore){
        highScore = player.score;
      }
      
      player = new Player();
      resetBarriers();
    }
    break;
  case 'h': // Hide all in order to speed up computation
    hideAll = !hideAll;
    break;
  }
}

//--------------------------------------------------------
void updateGrounds(){
  moveGrounds(); // Move everything
  if(!hideAll){ // Show everything
    showGrounds();
  }
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
  if(isPlayer){
    speed += 0.02;
  }
  
  // Check if waited long enough to add a new barrier
  if(barrierTimer > minTimeBetweenBarriers + randomAddition){
    addBarrier();
  }

  moveBarriers(); // Move everything
  if(!hideAll){ // Show everything
    showBarriers();
  }
}

void moveBarriers() {
  for(int i = 0; i< barriers.size(); i++){
    barriers.get(i).move(speed);
    if(barriers.get(i).wallTop.pos.x < 0-barriers.get(i).wallTop.recWidth){ 
      barriers.remove(i);
      i--;
      
      if(isPlayer){
        player.score++;
      }else{
        players.addScore();
      }
    }
  }
}

void addBarrier(){
  int hole = floor(random(minDistForHole, height-minDistForHole-gap));
  
  if(isPlayer){
    Barrier newBarrier = new Barrier(hole);
    barriers.add(newBarrier);
  
    randomAddition = floor(random(30));
    barrierTimer = 0;
  }else{
    if(barrierHistoryTracker < barrierHistory.size()){
      Barrier newBarrier = new Barrier(barrierHistory.get(barrierHistoryTracker));
      barriers.add(newBarrier);
    
      randomAddition = randomAdditionHistory.get(barrierHistoryTracker);
      barrierHistoryTracker++;
    }else{
      Barrier newBarrier = new Barrier(hole);
      barriers.add(newBarrier);
      barrierHistory.add(hole);
    
      randomAddition = floor(random(30));
      randomAdditionHistory.add(randomAddition);
    }
    barrierTimer = 0;
  }
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
  barrierHistoryTracker = 0;
  speed = 3;
}
