class Slider {
  private PGraphics pGraphics;
  private int leftX;
  private int y;
  private int sliderLength;
  private int sliderThickness;
  private color sliderColor; 
  private int circleSize;
  private int circleOutlineSize;
  private color circleOutlineColor;
  private color circleHoveringOutlineColor;
  
  private Runnable onSliderValueChanged;
  private float sliderX;
  
  
  Slider(PGraphics pGraphics, int leftX, int y, int sliderLength, int sliderThickness, color sliderColor, int circleSize, int circleOutlineSize, color circleOutlineColor, color circleHoveringOutlineColor) {
    this.pGraphics = pGraphics;
    this.leftX = leftX;
    this.y = y;
    this.sliderLength = sliderLength;
    this.sliderThickness = sliderThickness;
    this.sliderColor = sliderColor;
    this.circleSize = circleSize;
    this.sliderX = leftX + 0.1 * sliderLength;
    this.circleOutlineSize = circleOutlineSize;
    this.circleOutlineColor = circleOutlineColor;
    this.circleHoveringOutlineColor = circleHoveringOutlineColor;
  }
  
  public void setOnSliderValueChanged(Runnable onSliderValueChanged) {
    this.onSliderValueChanged = onSliderValueChanged;
  }
  public float getSliderValue() {
    return map(sliderX, leftX, leftX + sliderLength, 0, 1);
  }
  public void setSliderValue(float value) {
    sliderX = map(value, 0, 1, leftX, leftX + sliderLength);
  }
  
  public void draw() {
    pGraphics.beginDraw();
    pGraphics.stroke(sliderColor);
    pGraphics.strokeWeight(sliderThickness);
    pGraphics.line(leftX, y, leftX + sliderLength, y);
    pGraphics.noStroke();
    pGraphics.fill(sliderColor);
    
    color currentOutlineColor = isCircleHoveredOver() ? circleHoveringOutlineColor : circleOutlineColor;
    pGraphics.stroke(currentOutlineColor);
    pGraphics.strokeWeight(circleOutlineSize);
    pGraphics.circle(sliderX, y, circleSize);
    pGraphics.endDraw();
  }
  
  public void mouseDragged() {
    controlSlider();
  }
  public void mouseReleased() {
    controlSlider();
  }
  private void controlSlider() {
    if(mouseX > leftX - (circleSize/2) - 10 && mouseX < leftX + sliderLength + (circleSize/2) + 10 && mouseY > y - (circleSize/2) - 10 && mouseY < y + (circleSize/2) + 10) {
      sliderX = constrain(mouseX, leftX, leftX + sliderLength);
      if(onSliderValueChanged != null) onSliderValueChanged.run();
    }
  }
  private boolean isCircleHoveredOver() {
    return sqrMagnitude(int(sliderX), y, mouseX, mouseY) <= sq((circleSize / 2) + (circleOutlineSize / 2));
  }
}
