
class CircleButton {
  int x, y;
  int diameter;
  color buttonColor;
  color outlineColor;
  color hoveringOutlineColor;
  color clickingButtonColor;
  int outlineWidth;
  color currentOutlineColor;
  color currentButtonColor;
  
  Runnable onClick; // onClick callback
  boolean isHoveredOver;
  
  CircleButton(int x, int y, int diameter, color buttonColor, color outlineColor, color hoveringOutlineColor, color clickingButtonColor, int outlineWidth) {
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.buttonColor = buttonColor;
    this.outlineColor = outlineColor;
    this.hoveringOutlineColor = hoveringOutlineColor;
    this.clickingButtonColor = clickingButtonColor;
    this.outlineWidth = outlineWidth;
  }
  
  void draw() {
    isHoveredOver = isHoveredOver();
    
    currentOutlineColor = isHoveredOver ? hoveringOutlineColor : outlineColor;
    stroke(currentOutlineColor);
    strokeWeight(outlineWidth);
    fill(buttonColor);
    circle(x, y, diameter);
  }
  
  void setOnClick(Runnable onClick) {
    this.onClick = onClick;
  }
  void mouseReleased() {
    if(onClick != null)
      onClick.run();
  }
  boolean isHoveredOver() {
    return sqrMagnitude(x, y, mouseX, mouseY) <= sq((diameter / 2) + (outlineWidth / 2));
  }
  
  color getButtonColor() { return buttonColor; }
}
