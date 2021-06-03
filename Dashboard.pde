import org.gicentre.utils.stat.*;

// Global Variables                            
PImage menubackground;
PImage displaybackground;
PImage background;
PImage bmwlogo;
PImage fordlogo;
PImage logo;
PImage speeddial;
PImage rpmdial;
int fill;
int choice;
boolean menu_selection;
boolean initialization;
SensorDataProvider data;
TripComputer Trip;
Gauge gauge;
FuelTank tank;
FuelComputer fuelComputer;
BarChart barChart;
float [] fuelconsumption, avgfueleconomy;

// Setup (runs once)
void setup() {    
    
  // Load Images
  menubackground = loadImage("menu.png");
  displaybackground = loadImage("dashboard4.png");
  fordlogo = loadImage("fordlogo.png");
  bmwlogo = loadImage("bmwlogo.png");
  speeddial = loadImage("speeddial.png");
  rpmdial = loadImage("rpmdial.png");
  
  // Initialize Barchart / Arrays
  barChart = new BarChart(this);  
  avgfueleconomy = new float [40];
  fuelconsumption = new float [60];
  
  // Set Window
  size (1600,1200);
  background(menubackground);
}

// Draw loop (keeps repeating)
void draw (){
  
  // Initialize Data (Once)
  if(menu_selection == true && initialization == false){
    initialization = true;
    barChart = new BarChart(this);
    data.initialize();
  }
  
  // Check if not initialized and reset (Once)
  if(menu_selection == false && initialization == false){
    background(menubackground);
    data = new SensorDataProvider();
    Trip = new TripComputer();
    gauge = new Gauge();
    tank = new FuelTank();
    fuelComputer = new FuelComputer();
    barChart = new BarChart(this);
    avgfueleconomy = new float [40];
    fuelconsumption = new float [60];
  }
  
  // Check whether data is intialized and then proceed (Repeating)
  if(initialization){
    
    // Set FrameRate
    frameRate(60);
    
    // Refresh Background Image 
    background(displaybackground);
            
    // Display the Values on the Screen
    gauge.displayValues();
    gauge.animation();
        
    // Calculate and fill fuelConsumption in an array of last 60 seconds
    fillArray(fuelconsumption,(float)fuelComputer.fuelConsumption());
    
    // Calculate Average Fuel Economy
    fuelComputer.calculateAvgFuelEconomy();
    println(fuelconsumption);
    // Increase currentIndex for DataTable to Move to Next Row of Data
    data.readNext();      
  }
}

// Create Bar Chart
void BarChart(int x, int y, int max, float [] array){
  barChart.setData(array);
  barChart.setMinValue(0);
  barChart.setMaxValue(max);
  textFont(createFont("Serif", 10), 10);
  barChart.showValueAxis(true);
  barChart.setValueFormat("#");
  barChart.showCategoryAxis(true);
  barChart.setBarColour(color(200,0,0));
  barChart.setBarGap(5);
  barChart.draw(x,y,450,300);  
}

// Fill Array with Previous Values for Last 60 Seconds
void fillArray(float [] array, float x){
  
  // Avoid Infinity Values
  if(x > 99999){
    x=0;
  }
  // Fill Array by Data by Shifting the Data Over
  if(data.currentIndex>=0){
    for(int y=0; y<array.length-1; y++){
      array[y]=array[y+1];
    }
    array[array.length-1]=x;
  }
}

// KeyPress function
void keyPressed (){
  
  // Check Menu Key Press
  if(menu_selection == false){
    
    // Ford F150 Selection: Set Car Parameters
    if(key == '1'){
      choice = 1;
      menu_selection = true;
      Trip.radius = 0.254;
      tank.tankCapacity = 80;
      logo = fordlogo;
      fuelComputer.maxRange = 578.1361;
    }
    
    // BMW 323i Selection: Set Car Parameters
    if(key == '2'){
      choice = 2;
      menu_selection = true;
      Trip.radius = 0.23;
      tank.tankCapacity = 60;
      logo = bmwlogo;
      fuelComputer.maxRange = 690.7540; 
    }
    
    // Exit the Program
    if(key == '0'){
      choice = 0;  
      exit();
    }
  }
}
