ArrayList<Barrier> barriers = new ArrayList<Barrier>();

int frameSpeed = 60;
int highScore = 0;
int speed = 3;
int gap = 200;
int minDistForHole = 125;
int barrierTimer = 0;
int minTimeBetweenBarriers = 100;
int randomAddition = 0;

Player player;

//--------------------------------------------------------
void setup(){
  frameRate(60);
  size(800, 800);

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
  background(173, 216, 230);
  stroke(0);
  strokeWeight(2);
  
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
