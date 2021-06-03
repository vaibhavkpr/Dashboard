class FuelTank{
  
  // Class Variables
  double tankCapacity;
  double consumedFuel = 0;
  double totalConsumedFuel = 0;
  double previousLevel;
  
  // Calculate Consumed Fuel
  double getConsumedFuel(){
    consumedFuel = data.previousFuel()-data.readFuelLevel(); 
    totalConsumedFuel += consumedFuel;
    return consumedFuel;
  }
}
