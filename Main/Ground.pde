class Ground{
  PVector pos;
  int recHeight = 74;
  int recWidth = 809;

  Ground(int x){
    pos = new PVector(x, height-recHeight);
  }
 
  //---------------------------------------------------
  void show(){
    image(groundImg, pos.x, pos.y);
  }
  
  //---------------------------------------------------
  void move(float speed){
    pos.x -= speed;
  }
}
