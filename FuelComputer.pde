class FuelComputer{
  
  // Class Variables
  double fuelEconomy;
  double avgFuelEconomy;
  float [] fuelEconomyHistory = new float [60];
  float [] avgFuelEconomylast60 = new float [60];
  double range;
  double maxRange;      // Max range is 690.7540km    Max range ford 578.1361km
  
  // Calculating Fuel Economy
  double calculateFuelEconomy(){ 
    
    if(tank.getConsumedFuel() == 0){
      fuelEconomy = 0.0;
    }
    else{
      // Calculate Fuel Economy for the Instance of Data (1 Second) and Fill it in an Array of Last 60 Values
      fuelEconomy = Trip.distanceTravelled()/tank.consumedFuel;
    }
    fillArray(fuelComputer.fuelEconomyHistory,(float)fuelComputer.fuelEconomy);
    return fuelEconomy;
    
  }
  
  // Calculating Average Fuel Economy
  void calculateAvgFuelEconomy(){
    
    // Reset Before Recalculating for Each 60 Trials if Available
    avgFuelEconomy = 0;
    
    // Calculate the Sum of Fuel Economy
    for(int x=0; x<fuelEconomyHistory.length-1; x++){
      
      // Calculate Sum of Previous Fuel Economy(s)
      avgFuelEconomy += fuelEconomyHistory[x]; 
        
    }
    
    // Check: Whether Less than 60 Data Values and Calculate Average
    if(data.currentIndex < 59){
      avgFuelEconomy = avgFuelEconomy/(data.currentIndex+1);
    }
    
    // Check: Whether 60 Trial Data is Available and Calculate Average
    else{
      avgFuelEconomy = avgFuelEconomy/60.0;
    }
    
    // Fill an Array with Calculated Average Fuel Economy
    fillArray(avgFuelEconomylast60,(float)avgFuelEconomy);
    
  }
  
  // Calculate Fuel Consumption
  double fuelConsumption(){
      return (1/avgFuelEconomy)*100.0;      
  }
  
  // Calculate Range
  double range(){
    range = avgFuelEconomy*data.readFuelLevel();
    return range;
  }
}
