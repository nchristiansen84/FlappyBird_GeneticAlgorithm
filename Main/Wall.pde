class Wall{
  PVector pos;
  int recHeight;
  int recWidth = 86;

  Wall(int y, int sizeY){
    pos = new PVector(width+recWidth, y);
      
    if(sizeY != 0){
      recHeight = sizeY;
    }
  }
 
  //---------------------------------------------------
  void show(){
    fill(0, 64, 0);
    rect(pos.x, pos.y, recWidth, recHeight);
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
