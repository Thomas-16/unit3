
class RectButton {
  private int x, y;
  private int w, h;
  private color buttonColor;
  private color outlineColor;
  private color hoveringOutlineColor;
  private color clickingButtonColor;
  private int outlineWidth;
  
  private Runnable onClick; // onClick callback
  private boolean isBeingPressed;
  
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
  
  public void draw() {
    color currentOutlineColor = isHoveredOver() ? hoveringOutlineColor : outlineColor;
    color currentButtonColor = isBeingPressed ? clickingButtonColor : buttonColor;
    
    stroke(currentOutlineColor);
    strokeWeight(outlineWidth);
    fill(currentButtonColor);
    rectMode(CENTER);
    rect(x, y, w, h);
  }
  
  public void setOnClick(Runnable onClick) {
    this.onClick = onClick;
  }
  public void mouseReleased() {
    isBeingPressed = false;
    if(onClick != null && isHoveredOver())
      onClick.run();
  }
  public void mousePressed() {
    if(isHoveredOver())
      isBeingPressed = true;
  }
  private boolean isHoveredOver() {
    return mouseX < x + w/2 + outlineWidth/2 && mouseX > x - w/2 - outlineWidth/2 && mouseY < y + h/2 + outlineWidth/2 && mouseY > y - h/2 - outlineWidth/2;
  }
  
  public  color getButtonColor() { return buttonColor; }
}
