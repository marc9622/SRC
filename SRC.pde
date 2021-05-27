DataDrawer dataDrawer = new DataDrawer();
Button buttonLive = new Button("Cases today", 100, 50, 190, 40, "live");
Button buttonAll = new Button("Cases the past 5 days", 300, 50, 330, 40, "all");

String whichDataSetToLoad = "live"; //Denne eksisterer kun fordi threads ikke kan bruge inputs >:(
String whichDataSetToShow = "";

boolean isLoading = false;
String loadError = "no data";

long requiredMemory = 800000000l; //Enheden er bits, og tallet svarer til 87,5 MB

void setup() {
  size(1000, 500);
  background(0);
  surface.setResizable(true);
  thread("loadData");
}

void draw() {
  background(0);
  if(!dataDrawer.isEmpty)
    drawData();
  buttonLive.display();
  buttonAll.display();
  if(loadError != null)
    dataDrawer.drawError(loadError);
  if(isLoading)
    dataDrawer.drawLoading();
}

void loadData() {  
  if(!isLoading) {
    isLoading = true;
    dataDrawer.updateData(getData());
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
        getRelevantData(rawTable);
        return rawTable;
      }
      case "all": {
        if(!isEnoughMemory()) {
          loadError = "memory";
          isLoading = false;
          return null;
        }
        Table rawTable = loadTable("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv", "header");
        rawTable = getRelevantData(rawTable);
        addGrowth(rawTable);
        return rawTable;
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
    println(e);
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

void addGrowth(Table table) {
  table.addColumn("growth");
  table.setColumnType("cases", "int");
  int count = table.getRowCount();
  for(int i = 0; i < count; i++) {
    if((i > 58 && i <= 58 * 5) || i >= 58 * 6)
      table.removeRow(count - i - 1);
  }
  for(int i = 58 * 2 - 1; i >= 0; i--) {
    if(i < 58) {
      table.removeRow(i);
      continue;
    }
    int oldCases = table.getInt(i - 58, "cases");
    int newCases = table.getInt(i, "cases");
    float percentChange = (float)(newCases - oldCases) / oldCases * 10000f;
    table.setInt(i, "growth", round(percentChange));
  }
}

Table removeColumnsExcept(Table table, StringList titlesToKeep) {
  String[] columnTitles = table.getColumnTitles();
  boolean shouldKeep = false;
  for(String titleInTable : columnTitles) {
    for(int i = 0; i < titlesToKeep.size(); i++) {
      if(titleInTable.equals(titlesToKeep.get(i))) {
        titlesToKeep.remove(i);
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

void mouseClicked() {
  buttonLive.detectClick();
  buttonAll.detectClick();
}
