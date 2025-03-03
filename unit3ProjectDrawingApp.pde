
class CircleButton {
  private PGraphics pGraphics;
  private int x, y;
  private int diameter;
  private color buttonColor;
  private color outlineColor;
  private color hoveringOutlineColor;
  private color clickingButtonColor;
  private int outlineWidth;
  
  private int buttonNum;
  
  private Runnable onClick; // onClick callback
  private boolean isBeingPressed;
  
  CircleButton(PGraphics pGraphics, int x, int y, int diameter, color buttonColor, color outlineColor, color hoveringOutlineColor, color clickingButtonColor, int outlineWidth) {
    this.pGraphics = pGraphics;
    this.x = x;
    this.y = y;
    this.diameter = diameter;
    this.buttonColor = buttonColor;
    this.outlineColor = outlineColor;
    this.hoveringOutlineColor = hoveringOutlineColor;
    this.clickingButtonColor = clickingButtonColor;
    this.outlineWidth = outlineWidth;
  }
  
  public void draw() {
    color currentOutlineColor = isHoveredOver() ? hoveringOutlineColor : outlineColor;
    color currentButtonColor = isBeingPressed ? clickingButtonColor : buttonColor;
    
    pGraphics.beginDraw();
    pGraphics.stroke(currentOutlineColor);
    pGraphics.strokeWeight(outlineWidth);
    pGraphics.fill(currentButtonColor);
    pGraphics.circle(x, y, diameter);
    pGraphics.endDraw();
  }
  
  public void setOutlineColor(color outlineColor) {
    this.outlineColor = outlineColor;
  }
  public void setButtonNum(int buttonNum) { this.buttonNum = buttonNum; }
  public int getButtonNum() { return this.buttonNum; }
  
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
    return sqrMagnitude(x, y, mouseX, mouseY) <= sq((diameter / 2) + (outlineWidth / 2));
  }
  
  public color getButtonColor() { return buttonColor; }
}
