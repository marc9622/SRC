class DataDrawer {
  
  DataField[] dataFields;
  
  boolean isEmpty = true;
  
  float ySeperation = 50;
  
  int scrollAmount = 0;
  int fieldsAtOnce = 7;
  
  void updateData(Table table) {
    if(table == null) {
      isEmpty = true;
      return;
    }
    createFields(table);
    isEmpty = false;
  }
  
  void createFields(Table table) {
    dataFields = new DataField[table.getRowCount()];
    for(int i = 0; i < dataFields.length; i++) {
      TableRow row = table.getRow(i);
      if(whichDataSetToShow == "live")
        dataFields[i] = new DataField(row.getString("date"), row.getString("county"), row.getString("cases"), 100, 100, 600, 40, row.getString("growth"));
      else
        dataFields[i] = new DataField(row.getString("date"), row.getString("county"), row.getString("cases"), 100, 100, 600, 40, null);
    }
  }
  
  void display() {
    if(scrollAmount < 0)
      scrollAmount = 0;
    if(scrollAmount >= dataFields.length - fieldsAtOnce)
      scrollAmount = dataFields.length - fieldsAtOnce;
    
    for(int i = scrollAmount; i < scrollAmount + fieldsAtOnce; i++) {
      if(i < 0 || i >= dataFields.length)
        continue;
      dataFields[i].display(ySeperation * (i - scrollAmount));
    }
  }
  
  void scroll(boolean isUp) {
    if(isUp)
      scrollAmount--;
    else
      scrollAmount++;
  }
  
  void drawError(String errorType) {
    textAlign(CENTER);
    textSize(50);
    fill(255);
    text("Could not show data :(", width/2, height/2);
    textSize(30);
    switch(errorType) {
      case "connection": {
        text("Please ensure you have a stable internet connection.\nPress r to attempt load again.", width/2, height/2 + 60);
        break;
      }
      case "memory": {
        text("Please ensure you have enough available memory.\nPress r to attempt load again.", width/2, height/2 + 60);
        break;
      }
      case "no data": {
        text("Please ensure you have selected a valid data set.\nPress r to attempt load again.", width/2, height/2 + 60);
        break;
      }
    }
  }
  
  void drawLoading() {
    int dotsAmount = round(frameCount % 100) / 17;
    String dots = "";
    for(int i = 0; i < dotsAmount; i++)
      dots += '.';
    
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    textAlign(LEFT);
    textSize(50);
    fill(255);
    text("Loading" + dots, width/2 - 100, height/2);
  }
}
