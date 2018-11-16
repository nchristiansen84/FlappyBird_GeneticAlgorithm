class Population{
  Player[] players;
  float fitnessSum = 0;
  float bestFitness = 0;
  int gen = 1;
  int bestPerson = 0;
  int bestScore = 0;
  int mutateStart = 0;
  
  Population(int size){
    players = new Player[size];
    
    for(int i = 0; i < size; i++){
      players[i] = new Player();
    }
  }
  
  //---------------------------------------------------
  void show(){
    for(int i = 1; i < players.length; i++){
      if(!players[i].dead){
        players[i].show();
      }
    }
    if(!players[0].dead){
      players[0].show();
    }
  }
  
  //---------------------------------------------------
  void update(){
    for(int i = 0; i < players.length; i++){
      players[i].update();
    }
  }
  
  //---------------------------------------------------
  void calcFitness(){
    for(int i = 0; i < players.length; i++){
      players[i].calcFitness();
    }
  }
  
  void calcFitnessSum(){
    fitnessSum = 0;
    for(int i = 0; i < players.length; i++){
      fitnessSum += players[i].fitness;
    }
  }
  
  //---------------------------------------------------
  boolean allDead(){
    for(int i = 0; i < players.length; i++){
      if(!players[i].dead){
        return false;
      }
    }
    
    return true;
  }
  
  int areAlive(){
    int count = popSize;
    
    for(int i = 0; i < players.length; i++){
      if(players[i].dead){
        count--;
      }
    }
    
    return count;
  }
  
  //---------------------------------------------------
  void addScore(){
    for(int i = 0; i < players.length; i++){
      if(!players[i].dead){
        players[i].score++;
      }
    }
    
    mutateStart = players[0].brain.step - 12;
  }
  
  //---------------------------------------------------
  void naturalSelection(){
    Player[] nextGen = new Player[players.length];
    
    saveBestPerson();
    calcFitnessSum();
    
    nextGen[0] = players[bestPerson].createChild();
    nextGen[0].isBest = true;
    for(int i = 1; i < nextGen.length; i++){
      // Select Parent from Fitness
      Player parent = selectParent();
      
      // Create Child
      if(parent == null){
        nextGen[i] = players[i].createChild();
      }else{
        nextGen[i] = parent.createChild();
      }
    }
    
    players = nextGen.clone();
    gen++;
    //println("Gen:", gen);
  }
  
  Player selectParent(){
    float rand = random(fitnessSum);
    float runningSum = 0;
    
    for(int i = 0; i < players.length; i++){
      runningSum += players[i].fitness;
      if(runningSum > rand){
        return players[i]; 
      }
    }
    
    return null;
  }
  
  void saveBestPerson(){
    float max = 0;
    int maxIndex = 0;
    
    for(int i = 0; i < players.length; i++){
      if(players[i].fitness > max){
        max = players[i].fitness;
        maxIndex = i;
        bestFitness = max;
      }
      
      if(players[i].score > bestScore){
        bestScore = players[i].score;
      }
    }
    
    bestPerson = maxIndex;
  }
  
  void copyInitBrain(Player parent){
    for(int i = 0; i< players.length; i++){
      for(int j = 0; j < mutateStart; j++){
        players[i].brain.moves[j] = parent.brain.moves[j];
      }
    }
  }
  
  //---------------------------------------------------
  void mutate(){
    for(int i = 1; i < players.length; i++){
      players[i].brain.mutate(mutateStart);
    }
  }
}
