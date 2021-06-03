class TripComputer{
  
  // Class Variables
  double totalDistanceTravelled;
  double currentSpeed;
  double radius;
  int direction;
  int counter = -1;
  
  // Get Current Speed
  double getCurrentSpeed(){
   currentSpeed = (data.readRPM()/60.0)*(1/data.readRatio())*(2)*(PI)*(radius)*(3.6);
   return currentSpeed;
  }
  
  // Get Total Distance Travelled
  double updateTotalDistance(){
    totalDistanceTravelled += currentSpeed/3600;    
    return totalDistanceTravelled;
  }
  
  // Get Distance Travelled in One Instance
  double distanceTravelled(){
    return currentSpeed/3600;
  }
  
  // Get Direction of Vehicle
  void getdirection(){
  
    // Get Change in X and Y Coordinates to Calculate Direction which are Coded as Numbers that act as Booleans
    data.changeInX();
    data.changeInY();
    
    // Check: EAST
    if(data.changeInX > 0){
      
      // Check: NorthEast  [1]
      if(data.changeInY > 0){                               
        direction = 1; 
      }
      // Check: East       [5]
      else if(data.changeInY == 0){                         
        direction = 5;
      }
      // Check: SouthEast  [2]
      else{                                                 
        direction = 2;
      }      
    }
    
    // Check: No-Movement  [0]
    else if(data.changeInX == 0 && data.changeInY == 0){  
      direction = 0;
    }
    
    // Check: WEST
    else if(data.changeInX < 0){
      
      // Check: NorthWest  [3]
      if(data.changeInY > 0){                              
        direction = 3;      
      }
      // Check: West       [6]
      else if(data.changeInY == 0){                        
        direction = 6;
      }
      // Check: SouthWest  [4]
      else{                                               
        direction = 4;
      }
    }
    
    // Check: NORTH/SOUTH  
    else if(data.changeInX == 0){      
      
      // Check: North      [7]
      if(data.changeInY > 0){                              
        direction = 7;
      }
      // Check: South      [8]
      else{                                                
        direction = 8;
      }
    }
  }
}
