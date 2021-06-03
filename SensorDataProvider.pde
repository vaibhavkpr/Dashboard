import static javax.swing.JOptionPane.*;
class SensorDataProvider{
  
  // Class Variables
  String filePath;  
  Table dataTable;
  int currentIndex = 0;
  TableRow row;
  int counter = 0;
  double changeInX;
  double changeInY;
  
  // Initialize Member Function
  void initialize(){
    
    // Check Vehicle Type
    if(choice == 1)
      filePath = "car_status_Truck_F150.csv";
    if(choice == 2)
      filePath = "car_status_BMW_323i.csv";
      
    // Load Values from Excel File into a Table
    dataTable = loadTable(filePath, "header");  
    row = dataTable.getRow(currentIndex);
    
  }
  
  // ReadNext Member Function
  void readNext(){
    
    // Check: If CurrentIndex is within Bounds
    if(currentIndex < 599){
      currentIndex++;
      row = dataTable.getRow(currentIndex); 
    }
    
    // Return to Main Menu Screen and Reset
    else{
      
      // Show Simulation End Message
      showMessageDialog(null, "The Simulation Has Ended, Please Click Ok To Return To The Main Menu", "Dash: Messages", INFORMATION_MESSAGE);
      
      // Reset Variables
      menu_selection = false;
      initialization = false;
    }
  }
  
  //Get previous fuel reading
  double previousFuel(){
    if(currentIndex != 0){
      int temp = currentIndex-1;
      TableRow rowtemp = dataTable.getRow(temp);
      return rowtemp.getDouble("Fuel Level (liter)");
    }
    else{
      return data.readFuelLevel();
      
    }
  }
  
  // ReadRPM Member Function gets RPM data
  int readRPM(){
    return row.getInt("RPM");
  }
  
  // ReadFuelLevel Member Function gets FuelLevel data
  double readFuelLevel(){
    return row.getDouble("Fuel Level (liter)");
  }
  
  // ReadRatio Member Function gets Gear Ratio data
  double readRatio(){
    return row.getDouble("Gear Ratio");
  }
  
  // ReadX Member Function gets X coordinate data
  double readX(){
    return row.getDouble("X");
  }
  
  // ReadY Member Function gets Y c data
  double readY(){
    return row.getDouble("Y");
  }
  
  // Get Change in X
  void changeInX(){
    
    if(currentIndex != 0){
      int temp = currentIndex-1;
      TableRow rowtemp = dataTable.getRow(temp);
      double oldX = rowtemp.getDouble("X");
      changeInX = data.readX()-oldX;
    }
    else
      changeInX = 0;
  }
  
  // Get Change in Y
  void changeInY(){
    if(currentIndex != 0){
      int temp = currentIndex-1;
      TableRow rowtemp = dataTable.getRow(temp);
      double oldY = rowtemp.getDouble("Y");
      changeInY = data.readY()-oldY;
    }
    else
      changeInY = 0;    
  } 
}
