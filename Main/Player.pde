class Player{
  PVector pos;
  PVector vel;
  float gravity = 0.2;
  float fitness = 0;
  int imgWidth = 47;
  int imgHeight = 34;
  int moveCount = 0;
  int moveInterval = 12;
  int score = 0;
  boolean dead = false;
  boolean isBest = false;
  
  Brain brain;
  
  Player(){
    brain = new Brain(4000);
    
    pos = new PVector(20+(imgWidth/2), 200);
    vel = new PVector(0,0);
  }
  
  //---------------------------------------------------
  void update(){
    if(!dead){
      move();
      
      if(pos.y < (imgHeight/2) || pos.y > height-(imgHeight/2)-groundHeight){ // End of Screen
        dead = true;
      }
      
      for(int i = 0; i< barriers.size(); i++){ // Collided with a Barrier
        if(barriers.get(i).collided(pos.x, pos.y, imgWidth, imgHeight)){
          dead = true;
        }
      }
      
      if(!hideAll){
        show();
      }
    }
  }
  
  void show(){
    moveCount++;
    
    if(vel.y < 2){
      if(moveCount < moveInterval){
        image(playerFlapDownImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else if(moveCount < moveInterval*2){
        image(playerFlapImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else if(moveCount < moveInterval*3){
        image(playerFlapUpImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else{
        image(playerFlapImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }
    }else if(vel.y > 8){
      if(moveCount < moveInterval){
        image(playerFallImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else if(moveCount < moveInterval*2){
        image(playerFallUpImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else if(moveCount < moveInterval*3){
        image(playerFallImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else{
        image(playerFallUpImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }
    }else{
      if(moveCount < moveInterval){
        image(playerDownImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else if(moveCount < moveInterval*2){
        image(playerImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else if(moveCount < moveInterval*3){
        image(playerUpImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }else{
        image(playerImg, pos.x-(imgWidth/2), pos.y-(imgHeight/2));
      }
    }
    
    if(moveCount == moveInterval*4){
      moveCount = 0;
    }
    
    /*// Marks the best in the generation with a dot
    if(isBest){
      fill(255, 0, 0);
      ellipse(pos.x, pos.y, imgWidth/4, imgHeight/4);
    }*/
  }
  
  void move(){
    if(!isPlayer){
      if(brain.moves.length > brain.step){
        if(brain.moves[brain.step] == 1){
          jump();
        }
        brain.step++;
      }else{
        dead = true;
      }
    }
    
    pos.y += vel.y;
    vel.y += gravity;
  }

  //---------------------------------------------------
  void jump(){
    vel.y = -6.5;
  }
  
  //---------------------------------------------------
  void calcFitness(){
    if(score != 0){
      float distanceToGoal = dist(pos.x, pos.y, goal.pos.x, goal.pos.y);
      fitness = 1.0/(distanceToGoal * distanceToGoal) + score;
    }
  }
  
  //---------------------------------------------------
  Player createChild(){
    Player child = new Player();
    child.brain = brain.clone();
    return child;
  }   
}
