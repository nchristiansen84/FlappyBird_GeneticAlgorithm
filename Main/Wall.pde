class Wall{
  PVector pos;
  int recHeight;
  int recWidth = 86;
  boolean bottomPipe = false;

  Wall(int y, int sizeY){
    pos = new PVector(width+recWidth, y);
      
    if(sizeY != 0){
      recHeight = sizeY;
    }
  }
 
  //---------------------------------------------------
  void show(){
    if(bottomPipe){
      image(wallImg, pos.x, pos.y, recWidth, recHeight-groundHeight);
      image(wallTopImg, pos.x, pos.y);
    }else{
      image(wallImg, pos.x, pos.y, recWidth, recHeight);
      image(wallBottomImg, pos.x, pos.y+recHeight-39);
    }
  }
  
  //---------------------------------------------------
  void move(float speed){
    pos.x -= speed;
  }
  
  //---------------------------------------------------
  boolean collided(float playerX, float playerY, float playerWidth, float playerHeight){
    float playerRight = playerX + playerWidth/2;
    float playerLeft = playerX - playerWidth/2;
    float thisRight = pos.x + recWidth;
    float thisLeft = pos.x;

    if((playerLeft <= thisRight && playerRight >= thisLeft ) || (thisLeft <= playerRight && thisRight >= playerLeft)){
      float playerUp = playerY + playerHeight/2;
      float playerDown = playerY - playerHeight/2;
      float thisUp = pos.y + recHeight;
      float thisDown = pos.y;
      
      if(playerDown <= thisUp && playerUp >= thisDown){
        return true;
      }
    }
    return false;
  }
}
