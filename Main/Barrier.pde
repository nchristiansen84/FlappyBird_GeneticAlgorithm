class Barrier{
  Wall wallTop;
  Wall wallBottom;
  
  Barrier(int hole){
    wallTop = new Wall(0, hole);
    wallBottom = new Wall(hole+gap, height-hole-gap);
    wallBottom.bottomPipe = true;
  }
  
  //---------------------------------------------------
  void show(){
    wallTop.show();
    wallBottom.show();
  }
  
  //---------------------------------------------------
  void move(float speed){
    wallTop.move(speed);
    wallBottom.move(speed);
  }
  
  //---------------------------------------------------
  boolean collided(float playerX, float playerY, float playerWidth, float playerHeight){
    if(wallTop.collided(playerX, playerY, playerWidth, playerHeight)){
      return true;
    }else if(wallBottom.collided(playerX, playerY, playerWidth, playerHeight)){
      return true;
    }else{
      return false;
    }
  }
}
