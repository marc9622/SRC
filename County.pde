class County {
  
  float x = 100;
  float w = 600;
  float h = 40;
  
  String name, date, cases;
  
  County(String date_, String county_, String cases_) {
    date = date_;
    name = county_;
    cases = cases_;
  }
  
  void display(float ySeperation) {
    float y = 40 + ySeperation;
    fill(255);
    rect(x, y, w, h);
    fill(0);
    textSize(30);
    textAlign(LEFT);
    text(date + ": " + name, x, y + 30);
    textAlign(RIGHT);
    text(cases, x + w, y + 30);
  }
  
}
