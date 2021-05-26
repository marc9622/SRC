DataDrawer dataDrawer;

String whichDataSetToLoad = "live"; //Denne eksisterer kun fordi threads ikke kan bruge inputs >:(
String whichDataSetToShow = "";

boolean isLoading = false;
String loadError = "no data";

long requiredMemory = 700000000l; //Enheden er bits, og tallet svarer til 87,5 MB

void setup() {
  size(1000, 500);
  background(0);
  surface.setResizable(true);
  thread("loadData");
}

void draw() {
  background(0);  
  drawData();
  if(loadError != null)
    drawError(loadError);
  if(isLoading)
    drawLoading();
}

void loadData() {  
  if(!isLoading) {
    isLoading = true;
    dataDrawer = new DataDrawer(getData());
    whichDataSetToShow = whichDataSetToLoad;
  
    if(!dataDrawer.isEmpty) {
      isLoading = false;
      loadError = null;
      //printTable(countyTable);
    }
  }
}

Table getData() { //https://github.com/nytimes/covid-19-data
  try{
    switch(whichDataSetToLoad) {
      case "live": {
        Table rawTable = loadTable("https://raw.githubusercontent.com/nytimes/covid-19-data/master/live/us-counties.csv", "header");
        return getRelevantData(rawTable);
      }
      case "all": {
        if(!isEnoughMemory()) {
          loadError = "memory";
          isLoading = false;
          return null;
        }
        Table rawTable = loadTable("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv", "header");
        return getRelevantData(rawTable);
      }
      default: {
        loadError = "no data";
        return null;
      }
    }
  }
  catch(Exception e) {
    isLoading = false;
    loadError = "connection";
    return null;
  }
}

Table getRelevantData(Table rawTable) {
  Table tempTable = new Table();

  for(TableRow row : rawTable.findRows("New York", "state"))
    tempTable.addRow(row);
  for(int i = 0; i < rawTable.getColumnCount(); i++)
    tempTable.setColumnTitles(rawTable.getColumnTitles());
  return removeColumnsExcept(tempTable, new StringList("date", "county", "cases"));
}

Table removeColumnsExcept(Table table, StringList titlesToRemove) {
  String[] columnTitles = table.getColumnTitles();
  boolean shouldKeep = false;
  for(String titleInTable : columnTitles) {
    for(int i = 0; i < titlesToRemove.size(); i++) {
      if(titleInTable.equals(titlesToRemove.get(i))) {
        titlesToRemove.remove(i);
        shouldKeep = true;
        break;
      }
    }
    if(!shouldKeep)
      table.removeColumn(titleInTable);
    else
      shouldKeep = false;
  }
  return table;
}

boolean isEnoughMemory() { //https://stackoverflow.com/questions/3571203/what-are-runtime-getruntime-totalmemory-and-freememory
  long usedMemory = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
  long availableMemory = Runtime.getRuntime().maxMemory() - usedMemory;
  return availableMemory > requiredMemory;
}

void drawData() {
  switch(whichDataSetToShow) {
      case "live": {
        dataDrawer.display();
        break;
      }
      case "all": {
        dataDrawer.display();
        break;
      }
      default: {
        loadError = "no data";
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

void printTable(Table table) {
  String columnTitles = "";
  
  for(int i = 0; i < table.getColumnCount(); i++)
    columnTitles += table.getColumnTitle(i) + "; ";
    
  println(columnTitles);
  
  for(TableRow row : table.rows()) {
    String rowString = "";
    
    for(int i = 0; i < table.getColumnCount(); i++)
      rowString += row.getString(i) + "; ";
      
    println(rowString);
  }
}

void keyPressed() {
  if(key == 'r')
    thread("loadData");
  if(dataDrawer != null) {
    if(keyCode == UP)
      dataDrawer.scroll(true);
    if(keyCode == DOWN)
      dataDrawer.scroll(false);
  }
}
