class Player{
  PVector pos;
  PVector vel;
  float gravity = 0.2;
  int size = 40;
  int score = 0;
  boolean dead = false;
  
  Player(){
    pos = new PVector(20+(size/2), 200);
    vel = new PVector(0,0);
  }
  
  //---------------------------------------------------
  void update(){
    if(!dead){
      move();
      
      if(pos.y < (size/2) || pos.y > height-(size/2)){ // End of Screen
        dead = true;
      }
      
      for(int i = 0; i< barriers.size(); i++){ // Collided with a Barrier
        if(barriers.get(i).collided(pos.x, pos.y, size, size)){
          dead = true;
        }
      }
      
      show();
    }
  }
  
  void show(){
    fill(255, 0, 0);
    ellipse(pos.x, pos.y, size, size);
  }

  void move(){
    pos.y += vel.y;
    vel.y += gravity;
  }

  //---------------------------------------------------
  void jump(){
    vel.y = -6.5;
  }
}
