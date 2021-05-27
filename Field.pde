class Field {
  
  float x, y, w, h;
  String text;
  int textSize = 30;
  
  Field(String text, float x, float y, float w, float h) {
    this.text = text;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display(float x, float y, float w, float h) {
    fill(255);
    rect(x, y, w, h);
    fill(0);
    textSize(textSize);
    textAlign(LEFT);
    text(text, x + 5, y + textSize);
  }
}
