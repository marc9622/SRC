class Button extends Field {
  
  String dataType;
  
  Button(String text, float x, float y, float w, float h, String dataType) {
    super(text, x, y, w, h);
    this.dataType = dataType;
  }
  
  void display() {
    super.display(x, y, w, h);
  }
  
  void detectClick() {
    float wTemp = w/2, hTemp = h/2;
    if(abs((x + wTemp) - mouseX) < wTemp && abs((y + hTemp) - mouseY) < hTemp)
      requestData();
  }
  
  void requestData() {
    if(whichDataSetToLoad != dataType) {
      whichDataSetToLoad = dataType;
      thread("loadData");
    }
  }
}
