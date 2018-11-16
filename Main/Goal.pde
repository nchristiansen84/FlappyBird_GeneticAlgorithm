class Goal{
  PVector pos;

  Goal(int x, int y){
    pos = new PVector(x, y);
  }
 
  //---------------------------------------------------
  void show(){
    fill(0, 255, 0);
    ellipse(pos.x, pos.y, 10, 10);
  }
  
  void update(float x, float y){
    pos.x = x;
    pos.y = y;
  }
}
