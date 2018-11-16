class Brain{
  int[] moves;
  int step = 0;
  
  Brain(int size){
    moves = new int[size];
    randomize();
  }
  
  void randomize(){
    for(int i=0; i<moves.length; i++){
      int randomMove = floor(random(1, 50));
      moves[i] = randomMove;
    }
  }

  //---------------------------------------------------
  Brain clone(){
    Brain clone = new Brain(moves.length);
    for(int i = 0; i < moves.length; i++){
      clone.moves[i] = moves[i];
    }
    
    return clone;
  }
  
  //---------------------------------------------------
  void mutate(int start){
    float mutationRate = 0.1;
    for(int i = start; i < moves.length; i++){
      float rand = random(1);
      if(rand < mutationRate){
        // Overwrite memory
        int randomMove = floor(random(1, 30));
        moves[i] = randomMove;
      }
    }
  }
}
