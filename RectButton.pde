
class RectButton {
  int x, y;
  int w, h;
  color buttonColor;
  color outlineColor;
  color hoveringOutlineColor;
  color clickingButtonColor;
  int outlineWidth;
  
  Runnable onClick; // onClick callback
  boolean isBeingPressed;
  
  RectButton(int x, int y, int w, int h, color buttonColor, color outlineColor, color hoveringOutlineColor, color clickingButtonColor, int outlineWidth) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.buttonColor = buttonColor;
    this.outlineColor = outlineColor;
    this.hoveringOutlineColor = hoveringOutlineColor;
    this.clickingButtonColor = clickingButtonColor;
    this.outlineWidth = outlineWidth;
  }
  
  void draw() {
    color currentOutlineColor = isHoveredOver() ? hoveringOutlineColor : outlineColor;
    color currentButtonColor = isBeingPressed ? clickingButtonColor : buttonColor;
    
    stroke(currentOutlineColor);
    strokeWeight(outlineWidth);
    fill(currentButtonColor);
    rectMode(CENTER);
    rect(x, y, w, h);
  }
  
  void setOnClick(Runnable onClick) {
    this.onClick = onClick;
  }
  void mouseReleased() {
    isBeingPressed = false;
    if(onClick != null && isHoveredOver())
      onClick.run();
  }
  void mousePressed() {
    if(isHoveredOver())
      isBeingPressed = true;
  }
  boolean isHoveredOver() {
    return mouseX < x + w/2 + outlineWidth/2 && mouseX > x - w/2 - outlineWidth/2 && mouseY < y + h/2 + outlineWidth/2 && mouseY > y - h/2 - outlineWidth/2;
  }
  
  color getButtonColor() { return buttonColor; }
}
