class DataDrawer {
  
  County[] counties;
  
  boolean isEmpty = false;
  
  float ySeperation = 50;
  
  int scrollAmount = 0;
  
  DataDrawer(Table table) {
    if(table == null) {
      isEmpty = true;
      return;
    }
    
    counties = new County[table.getRowCount()];
    for(int i = 0; i < counties.length; i++) {
      TableRow row = table.getRow(i);
      counties[i] = new County(row.getString("date"), row.getString("county"), row.getString("cases"));
    }
  }
  
  void display() {
    if(scrollAmount < 0)
      scrollAmount = 0;
    if(scrollAmount >= counties.length - 8)
      scrollAmount = counties.length - 8;
    
    for(int i = scrollAmount; i < scrollAmount + 8; i++) {
      if(i < 0 || i >= counties.length)
        continue;
      counties[i].display(ySeperation * (i - scrollAmount));
    }
  }
  
  void scroll(boolean isUp) {
    if(isUp)
      scrollAmount--;
    else
      scrollAmount++;
  }
}
