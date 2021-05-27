class DataField extends Field {
  
  String cases;
  float growth;
  color col;
  
  DataField(String date, String county, String cases, float x, float y, float w, float h, String growth) {
    super(date + ": " + county, x, y, w, h);
    this.cases = cases;
    if(growth != null) {
      this.growth = Float.parseFloat(growth);
      if(this.growth > 100)
        this.growth = 100;
      this.growth = 100 - this.growth;
    }
    else
      this.growth = -1;
    colorMode(HSB, 100);
    col = color(this.growth / 4, 100, 100);
    colorMode(RGB, 255);
  }
  
  void display(float ySeperation) {
    float yTemp = y + ySeperation;
    super.display(x, yTemp, w, h);
    textAlign(RIGHT);
    text(cases, x + w - 5, yTemp + 30);
    if(growth >= 0)
      drawGrowthCircle(yTemp);
  }
  
  void drawGrowthCircle(float y) {
    float r = h/2;
    fill(col);
    circle(w + x + r, y + r, r);
  }
}
