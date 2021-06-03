class Gauge{
  
  // Class Variables
  double minimum;
  double maximum;
  double currentValue;
  float power;      
  float rotation_speed = 0;
  float rotation_rpm = 0;
  double speedtick = 2;
  double rpmtick = 0;
  int duration_ms = 1;
  int duration_s = 0;
  int duration_min = 0;
  int alternate_animation = 1;
  int rectx1 = 0;
  int rectx2 = 0;
  PFont fontLarge = loadFont("AgencyFB-Reg-80.vlw");
  PFont fontSmall = loadFont("AgencyFB-Reg-25.vlw");
  
  // Display the Values on the Screen
  void displayValues(){

    // Display logo
    if(choice == 1)
      image(logo,765,320);
    else if(choice == 2)
      image(logo,786,313);
    
    // Load Font for Display    
    textFont(fontLarge);
    fill(255);
    
    // Display Fuel Levels
    textSize(58);
    textAlign(CENTER);
    if(data.readFuelLevel() <= tank.tankCapacity)  
      text(String.format("%.2f",data.readFuelLevel()), 809, 430); 
    else  // Set Max Limit for Fuel Levels
      text(String.format("%.2f",tank.tankCapacity), 809, 430);
    
    //Display RPM
    textSize(80);
    textAlign(CENTER);
    text(data.readRPM(), 1195, 415); 
    
    // Display Current Speed
    textSize(80);
    textAlign(CENTER);
    text(String.format("%.2f",Trip.getCurrentSpeed()), 425, 415); 
    
    // Load Smaller Font for Other Data
    textFont(fontSmall);
    
    // Display Odometer
    fill(200,0,0);
    textSize(25);
    textAlign(CENTER);
    text(String.format("%.2f",Trip.updateTotalDistance())+" Km", 726, 685);
    
    // Calculate Trip Duration in Time Format
    duration_ms++;
    if(duration_ms == 60){
      alternate_animation *= -1;
      duration_s++;
      duration_ms = 0;
    }
    if(duration_s == 60){
      duration_min++;
      duration_s = 0;
    }
    // Display Trip Duration
    fill(200,0,0);
    textSize(25);
    textAlign(CENTER);
    text(nf(duration_min,2)+":"+nf(duration_s,2)+":"+nf(duration_ms,2), 726, 742);
    
    // Display Fuel Economy
    fuelComputer.calculateFuelEconomy();
    if(fuelComputer.fuelEconomy >= 10.0)
      fill(0,200,0);
    else if(fuelComputer.fuelEconomy < 2.5)
      fill(255,245,50);
    else
      fill(200,0,0);
    textSize(25);
    textAlign(CENTER);
    text(String.format("%.2f",fuelComputer.fuelEconomy)+" Km/L", 1011, 628);
    
    // Display Fuel Consumption
    fill(200,0,0);
    textSize(25);
    textAlign(CENTER);
    text(String.format("%.2f",fuelComputer.fuelConsumption())+" L/100km", 1031, 743);
    
    // Calculate Range
    fuelComputer.range();
    
    // Check: Top 15% (Show as Green)
    if(fuelComputer.range >= 0.85*(fuelComputer.maxRange))
      fill(0,200,0);
    
    // Check: Bottom 15% (Show as Yellow)
    else if(fuelComputer.range <= 0.15*(fuelComputer.maxRange))
      fill(227,210,18);
      
    // Check: Mid-Range (Show as Red)
    else
      fill(200,0,0);
    
    // Display Range
    textSize(25);
    textAlign(CENTER);
    text(String.format("%.2f",fuelComputer.range)+" km", 718, 628);
    
    // Display Fuel Percent Available
    fill(200,0,0);
    textSize(25);
    textAlign(CENTER);
    text(String.format("%.2f",data.readFuelLevel()*(100/tank.tankCapacity))+" %", 1006, 686);
    
    // Display Direction
    fill(255);
    textSize(30);
    textAlign(CENTER);
    Trip.getdirection();
    
    // Check: No-Movement
    if(Trip.direction == 0)
      text("(*)", 809, 195);
    // Check: East
    if(Trip.direction == 5)
      text("E", 809, 195);
    // Check: NorthEast
    if(Trip.direction == 1)
      text("NE", 809, 195); 
    // Check: SouthEast
    if(Trip.direction == 2)
      text("SE", 809, 195); 
    // Check: NorthWest
    if(Trip.direction == 3)
      text("NW", 809, 195); 
    // Check: SouthWest
    if(Trip.direction == 4)
      text("SW", 809, 195);
    // Check: West
    if(Trip.direction == 6)
      text("W", 809, 195);
    // Check: North
    if(Trip.direction == 7)
      text("N", 809, 195);
    // Check: South
    if(Trip.direction == 8)
      text("S", 809, 195);
    
    // Create and Send Arrays to BarCharts
    textSize(25);
    BarChart(35,795,20,fuelComputer.avgFuelEconomylast60);
    BarChart(1100,795,50,fuelconsumption);
    BarChart(570,795,20,fuelComputer.fuelEconomyHistory);

  }
  
  // Animation
  void animation(){
    
    pushMatrix();
    
    // Speedometer Animation (Dial)
    imageMode(CENTER);
    translate(430,405);
    
    // Speedometer Dial Animation 
    if((int)speedtick < (int)Trip.currentSpeed){
      speedtick += 1.9;
    }
    else if((int)speedtick > (int)Trip.currentSpeed){
      speedtick -= 1.9;
    }
    if((int)speedtick == (int)Trip.currentSpeed+1 || (int)speedtick == (int)Trip.currentSpeed-1){
      speedtick = (int)Trip.currentSpeed;
    }
    if((int)speedtick > 220){ // Speed Max Limit
      speedtick = 220;
    }
    rotate(((pow(((float)speedtick)-5,1.0334)))*PI/180.0); 
    
    //rotate(((pow(((float)Trip.currentSpeed)-5,1.0334)))*PI/180.0);                   //Without Ticks Animation
    
    image(speeddial,-speeddial.width/16,-speeddial.height/16);    
    popMatrix();
    
    // RPM Animation (Dial)
    pushMatrix();
    imageMode(CENTER);
    translate(1185,405);
    
    // Calibration
    if(data.readRPM() > 5000){
      power = 1.19;
    }
    if(data.readRPM() > 4000 && data.readRPM() <= 5000){
      power = 1.210;
    }
    if(data.readRPM() <= 1000){
      power = 1.150; 
    }
    else{
      power = 1.218;
    }
    float currentrpm = pow(((float)data.readRPM())*(1.0/100.0),power);
    
    // RPM Dial Animation
    if((int)rpmtick < (int)currentrpm){
      rpmtick += 1.9;
    }
    else if((int)rpmtick > (int)currentrpm){
      rpmtick -= 1.9;
    }
    if((int)rpmtick == (int)currentrpm+1 || (int)rpmtick == (int)currentrpm-1){
      rpmtick = (int)currentrpm;
    }
    if((int)rpmtick > 11000){  // Set RPM Max Limit
      rpmtick = 11000;
    }
    rotate((float)rpmtick*PI/180.0); 
                      
    image(rpmdial,-rpmdial.width/16,-rpmdial.height/16);
    popMatrix();
    imageMode(CORNER); 
    
    // Moving Bar Animation Under Speed and RPM
    fill(200,0,0);    
    if(alternate_animation == -1){
      rectx1 -= 1;
      rectx2 -= 1;
    }
    else{
      rectx1 += 1;
      rectx2 += 1;
    }
    rect(330,580,((float)(rectx1*200.0/60.0)),5);
    rect(1300,580,((float)(-rectx2*200.0/60.0)),5);
    
    // Trial Progress Bar
    fill(255);
    rect(0,1187,data.currentIndex*2.67,13);

  }
}
