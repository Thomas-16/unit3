// Thomas Fang
// Drawing app
// 24 Feb, 2025
// Color pallette: https://coolors.co/03045e-023e8a-0077b6-0096c7-00b4d8-48cae4-90e0ef-ade8f4-caf0f8


// TODOS:
// COLOUR PICKER TOOL
// MAKE COLOUR PICKER BRIGHTNESS SLIDER CIRCLE OUTLINE THE CURRENT COLOUR
// MAKE STAMP THE UNIT 1 CHECKPOINT
// SHAPE TOOLS (LINE, RECTANGLE, CIRCLE, ELLIPSE)
// NEW, SAVE, LOAD BUTTONS

PGraphics panelPG;
PGraphics paintPG;
PGraphics strokeSizeIndicatorPG;
PGraphics stampSizeIndicatorPG;
PGraphics colorPickerPG;

int canvasStart = 190;
boolean isPanelOpen = true;
color currentStrokeColor = color(#f6ff00);
int selectedButton = 0; // 0-11 = color buttons, 12 = eraser, 13 = stamp tool
color selectedButtonOutlineColor = color(255, 251, 3);
int MIN_STROKE_SIZE = 2;
int MAX_STROKE_SIZE = 20;
float currentStrokeSize;

float panelY = 0;
int targetPanelY = 0;
float panelSpeed = 0.3;
float previousMillis;
float deltaTime;

PImage arrowDownImg;
PImage arrowUpImg;
color currentTogglePanelButtonOutlineColor = color(0);
color currentTogglePanelButtonColor = color(#ffbf47);
boolean isTogglePanelButtonBeingPressed = false;

CircleButton[] colorButtons;
RectButton eraserButton;
PImage eraserImg;
Slider sizeSlider;

float timeLastChangedStrokeSize;

PFont font1;

PVector previousSmoothed;
float smoothingFactor = 0.0;
boolean isDragging = false;
Slider stabilizationSlider;

RectButton stampButton;
PImage stampImg;
int MIN_STAMP_SIZE = 60;
int MAX_STAMP_SIZE = 200;
float currentStampSize = 100;

CircleButton colorPickerButton;
PImage colorPickerImg;
boolean isColorPickerOpen = false;
Slider brightnessSlider;
int colorPickerX = 700;
int colorPickerY = 400;
PVector[] colorPointsOnCP;
PGraphics colorPickerPGONLYWHEEL;


void setup() {
  size(1400, 900);
  frameRate(120);
  
  arrowDownImg = loadImage("arrow down.png");
  arrowUpImg = loadImage("arrow up.png");
  eraserImg = loadImage("eraser.png");
  stampImg = loadImage("lebron_stamp.png");
  colorPickerImg = loadImage("color_picker.png");
  
  font1 = createFont("Arial Bold", 35);
  
  // delta time calculation
  float currentMillis = millis();
  deltaTime = (currentMillis - previousMillis) / 1000.0;
  previousMillis = currentMillis;
  
  // create pgraphics
  paintPG = createGraphics(width, height);
  paintPG.beginDraw();
  paintPG.background(255);
  paintPG.endDraw();
  
  panelPG = createGraphics(width, canvasStart);
  
  strokeSizeIndicatorPG = createGraphics(MAX_STROKE_SIZE + 2, MAX_STROKE_SIZE + 2);
  stampSizeIndicatorPG = createGraphics(MAX_STAMP_SIZE, MAX_STAMP_SIZE);
  
  colorPickerPG = createGraphics(1400, 900);
  colorPickerPGONLYWHEEL = createGraphics(1400, 900);
  
  colorPickerPGONLYWHEEL.beginDraw();
  colorPickerPGONLYWHEEL.stroke(0);
  colorPickerPGONLYWHEEL.strokeWeight(4);
  colorPickerPGONLYWHEEL.noFill();
  colorPickerPGONLYWHEEL.imageMode(CENTER);
  colorPickerPGONLYWHEEL.image(colorPickerImg, 700 + 24, 400 +22, 500 * 1.1, 500 * 1.1);
  colorPickerPGONLYWHEEL.endDraw();
  
  // create color buttons
  colorButtons = new CircleButton[12];
  int currentX = 70;
  int currentY = 35;
  for(int i = 0; i < colorButtons.length; i++) {
    colorButtons[i] = new CircleButton(panelPG, currentX, currentY, 30, lerpColor(color(#f6ff00), color(#f21800), map(i, 0, colorButtons.length - 1, 0, 1)), color(0), color(100), color(100), 3);
    colorButtons[i].setButtonNum(i);
    currentX += 40;
    if((i + 1) % 4 == 0) {
      currentX = 70;
      currentY += 40;
    }
  }
  colorButtons[0].setOutlineColor(selectedButtonOutlineColor);
  
  for(CircleButton button : colorButtons) {
    button.setOnClick(() -> {
      currentStrokeColor = button.getButtonColor();
      selectButton(button.getButtonNum());
    });
  }
  
  colorPointsOnCP = new PVector[12];
  colorPointsOnCP[0] = new PVector(777.3191, 164.36093);
  colorPointsOnCP[1] = new PVector(724.67694, 153.23079);
  colorPointsOnCP[2] = new PVector(691.8465, 152.13408);
  colorPointsOnCP[3] = new PVector(657.08954, 155.74052);
  colorPointsOnCP[4] = new PVector(550.63495, 202.02504);
  colorPointsOnCP[5] = new PVector(518.3527, 231.15607);
  colorPointsOnCP[6] = new PVector(497.41486, 256.9501);
  colorPointsOnCP[7] = new PVector(497.41486, 256.9501);
  colorPointsOnCP[8] = new PVector(477.2288, 291.0184);
  colorPointsOnCP[9] = new PVector(465.3307, 319.78577);
  colorPointsOnCP[10] = new PVector(460.4604, 335.7756);
  colorPointsOnCP[11] = new PVector(452.90802, 378.7974);
  
  for(int i = 0; i < 12; i++) {
    colorButtons[i].setButtonColor(colorPickerPGONLYWHEEL.get(int(colorPointsOnCP[i].x), int(colorPointsOnCP[i].y)));
  }
  
  // create eraser button
  eraserButton = new RectButton(panelPG, 435, 75, 60, 60, color(255), color(0), color(100), color(200), 4, 6);
  eraserButton.setOnClick(() -> {
    currentStrokeColor = color(255);
    selectButton(12);
  });
  
  // create stroke size slider
  sizeSlider = new Slider(panelPG, 505, 75, 200, 8, color(0), 20, 3, color(0), color(100));
  sizeSlider.setOnSliderValueChanged(() -> {
    currentStrokeSize = map(sizeSlider.getSliderValue(), 0, 1, MIN_STROKE_SIZE, MAX_STROKE_SIZE);
    currentStampSize = map(sizeSlider.getSliderValue(), 0, 1, MIN_STAMP_SIZE, MAX_STAMP_SIZE);
    timeLastChangedStrokeSize = millis();
  });
  currentStrokeSize = map(sizeSlider.getSliderValue(), 0, 1, MIN_STROKE_SIZE, MAX_STROKE_SIZE);
  
  // Create stabilization slider
  stabilizationSlider = new Slider(panelPG, 740, 75, 200, 8, color(0), 20, 3, color(0), color(100));
  stabilizationSlider.setOnSliderValueChanged(() -> {
    smoothingFactor = map(stabilizationSlider.getSliderValue(), 0, 1, 0.5, 0.92);
  });
  smoothingFactor = map(stabilizationSlider.getSliderValue(), 0, 1, 0.5, 0.92);
  
  // create stamp button
  stampButton = new RectButton(panelPG, 1015, 75, 100, 72, color(255), color(0), color(100), color(200), 4, 6);
  stampButton.setOnClick(() -> {
    selectButton(13);
  });
  
  // create colour picker button
  colorPickerButton = new CircleButton(panelPG, 305, 75, 90, color(0, 0, 0, 0), color(0), color(100), color(200, 200, 200, 50), 4);
  colorPickerButton.setOnClick(() -> {
    if(!isColorPickerOpen && selectedButton > 11) {
      selectButton(0);
    }
    isColorPickerOpen = !isColorPickerOpen;
  });
  
  // create color picker brightness slider
  brightnessSlider = new Slider(colorPickerPG, 700-200, 720, 400, 10, color(0), 23, 4, color(0), color(100));
  brightnessSlider.setSliderValue(0);
  brightnessSlider.setOnSliderValueChanged(() -> {
    updateSelectedColorWithPicker();
  });
  
}

void draw() {
  //println(frameRate);
  
  background(255);
  
  // user drawing pg
  imageMode(CORNER);
  image(paintPG, 0, 0);
  
  panelPG.beginDraw();
  panelPG.clear();
  
  // open/close panel button
  currentTogglePanelButtonOutlineColor = isHoveringOverTogglePanelButton() ?  color(100) : color(0);
  currentTogglePanelButtonColor = isTogglePanelButtonBeingPressed ? lerpColor(color(100), color(#ffbf47), 0.6) : color(#ffbf47);
  panelPG.stroke(currentTogglePanelButtonOutlineColor);
  panelPG.strokeWeight(4);
  panelPG.fill(currentTogglePanelButtonColor);
  panelPG.rectMode(CENTER);
  panelPG.rect(width/2, canvasStart - 35, 80, 66, 10);
  
  // arrow image
  panelPG.imageMode(CENTER);
  PImage targetImg = isPanelOpen ? arrowUpImg : arrowDownImg;
  panelPG.image(targetImg, width/2, canvasStart - 35 + 17, 45, 33);
  
  // main panel background
  panelPG.noStroke();
  panelPG.fill(#ffbf47);
  panelPG.rectMode(CORNER);
  panelPG.rect(0,0, width, canvasStart - 35);
  panelPG.strokeWeight(4);
  panelPG.stroke(0);
  panelPG.line(0, canvasStart - 36, width, canvasStart - 36);
  
  // draw color buttons
  for(CircleButton button : colorButtons) {
    button.draw();
  }
  
  // draw eraser button + image
  eraserButton.draw();
  panelPG.beginDraw();
  panelPG.imageMode(CENTER);
  panelPG.image(eraserImg, 435, 75, 44, 44);
  panelPG.endDraw();
  
  // draw size slider
  sizeSlider.draw();
  panelPG.beginDraw();
  panelPG.textFont(font1);
  panelPG.textSize(25);
  panelPG.text("STROKE SIZE", 520, 115);
  panelPG.endDraw();
  
  // draw stabilization slider
  stabilizationSlider.draw();
  panelPG.beginDraw();
  panelPG.textFont(font1);
  panelPG.textSize(25);
  panelPG.text("STABILIZATION", 747, 115);
  panelPG.endDraw();
  
  // draw size indicators
  if(millis() - timeLastChangedStrokeSize < 1000 && millis() > 1000) {
    if(selectedButton == 13) {
      stampSizeIndicatorPG.beginDraw();
      stampSizeIndicatorPG.clear();
      stampSizeIndicatorPG.noStroke();
      stampSizeIndicatorPG.noFill();
      stampSizeIndicatorPG.imageMode(CENTER);
      stampSizeIndicatorPG.image(stampImg, MAX_STAMP_SIZE / 2, MAX_STAMP_SIZE / 2, currentStampSize, currentStampSize / 150.0 * 109.0);
      stampSizeIndicatorPG.endDraw();
      image(stampSizeIndicatorPG, width/2 - stampSizeIndicatorPG.width/2, height/2 - stampSizeIndicatorPG.height/2);
    } else {
      strokeSizeIndicatorPG.beginDraw(); 
      strokeSizeIndicatorPG.clear();
      strokeSizeIndicatorPG.stroke(0);
      strokeSizeIndicatorPG.strokeWeight(selectedButton == 12 ? 1 : 0);
      strokeSizeIndicatorPG.fill(currentStrokeColor);
      strokeSizeIndicatorPG.ellipseMode(CENTER);
      strokeSizeIndicatorPG.ellipse(strokeSizeIndicatorPG.width / 2, strokeSizeIndicatorPG.height / 2, currentStrokeSize, currentStrokeSize);
      strokeSizeIndicatorPG.endDraw();
      image(strokeSizeIndicatorPG, width/2 - strokeSizeIndicatorPG.width / 2, height/2 - strokeSizeIndicatorPG.height / 2);
    }
  }
  
  // draw stamp button + image
  stampButton.draw();
  panelPG.beginDraw();
  panelPG.imageMode(CENTER);
  panelPG.image(stampImg, 1015, 75, 100, 72);
  panelPG.endDraw();
  
  // draw color picker button + image
  panelPG.beginDraw();
  panelPG.image(colorPickerImg, 305+3, 75+3.5, 90 * 1.1, 90 * 1.1);
  colorPickerButton.draw();
  
  // draw the panel pg
  panelY = lerp(panelY, targetPanelY, deltaTime * panelSpeed);
  imageMode(CORNER);
  image(panelPG, 0, panelY);
  
  // draw color picker pg
  if(isColorPickerOpen) {
    // box
    colorPickerPG.beginDraw();
    colorPickerPG.clear();
    colorPickerPG.rectMode(CENTER);
    colorPickerPG.fill(#ffc94d);
    colorPickerPG.stroke(0);
    colorPickerPG.strokeWeight(8);
    colorPickerPG.rect(700, 450, 600, 700, 6);
    
    // color wheel image
    colorPickerPG.stroke(0);
    colorPickerPG.strokeWeight(4);
    colorPickerPG.noFill();
    colorPickerPG.imageMode(CENTER);
    colorPickerPG.image(colorPickerImg, 700 + 24, 400 +22, 500 * 1.1, 500 * 1.1);
    
    // black overlay
    colorPickerPG.noStroke();
    colorPickerPG.fill(0, 0, 0, map(brightnessSlider.getSliderValue(), 0, 1, 0, 255));
    colorPickerPG.circle(700, 400, 500);
    
    // color selector
    colorPickerPG.stroke(map(brightnessSlider.getSliderValue(), 0, 1, 0, 255));
    colorPickerPG.strokeWeight(2);
    
    PVector point = colorPointsOnCP[selectedButton];
    colorPickerPG.line(point.x - 6, point.y, point.x + 6, point.y);
    colorPickerPG.line(point.x, point.y - 6, point.x, point.y + 6);
    
    colorPickerPG.stroke(0);
    colorPickerPG.strokeWeight(4);
    colorPickerPG.noFill();
    colorPickerPG.circle(colorPickerX, colorPickerY, 500);
    
    
    colorPickerPG.textAlign(CENTER);
    colorPickerPG.textFont(font1);
    colorPickerPG.textSize(30);
    colorPickerPG.fill(0);
    colorPickerPG.text("BRIGHTNESS", 700, 765);
    
    colorPickerPG.endDraw();
    
    brightnessSlider.draw();
    
    imageMode(CORNER);
    image(colorPickerPG, 0, 0);
  }
  
  
} 

void controlColorPicker() {
  colorPointsOnCP[selectedButton].x = mouseX;
  colorPointsOnCP[selectedButton].y = mouseY;
  colorPointsOnCP[selectedButton] = clampToCircle(colorPointsOnCP[selectedButton], new PVector(colorPickerX, colorPickerY), 248);
  
  updateSelectedColorWithPicker();
}
void updateSelectedColorWithPicker() {
  color targetColor = colorPickerPGONLYWHEEL.get(int(colorPointsOnCP[selectedButton].x), int(colorPointsOnCP[selectedButton].y));
  color adjustedTargetColor = lerpColor(targetColor, color(0), brightnessSlider.getSliderValue());
  colorButtons[selectedButton].setButtonColor(adjustedTargetColor);
}

void keyPressed() {
  println(colorPointsOnCP[selectedButton]);
}

boolean isHoveringOverTogglePanelButton() { return mouseX < width/2 + 40 + 2 && mouseX > width/2 - 40 - 2 && mouseY < canvasStart -17 + panelY + 16.5 + 2 && mouseY > canvasStart -17 + panelY - 16.5 - 2; }

void selectButton(int buttonNum) {
  if(isColorPickerOpen && buttonNum > 11) { return; }
  
  if(selectedButton <= 11) {
    colorButtons[selectedButton].setOutlineColor(color(0));
  } else if(selectedButton == 12) {
    eraserButton.setOutlineColor(color(0));
  } else if(selectedButton == 13) {
    stampButton.setOutlineColor(color(0));
  }
  
  selectedButton = buttonNum;
  if(selectedButton <= 11) {
    colorButtons[selectedButton].setOutlineColor(selectedButtonOutlineColor);
  } else if(selectedButton == 12) {
    eraserButton.setOutlineColor(selectedButtonOutlineColor);
  } else if(selectedButton == 13) {
    stampButton.setOutlineColor(selectedButtonOutlineColor);
  }
}
void mousePressed() {
  isDragging = false;
  previousSmoothed = null; // Reset for new stroke
  
  if(isHoveringOverTogglePanelButton())
    isTogglePanelButtonBeingPressed = true;
    
  if(isPanelOpen) {
    for(CircleButton button : colorButtons) {
      button.mousePressed();
    }
    eraserButton.mousePressed();
    stampButton.mousePressed();
    colorPickerButton.mousePressed();
  }
  if(isColorPickerOpen && sqrMagnitude(colorPickerX, colorPickerY, mouseX, mouseY) <= sq(500 / 2)) {
    controlColorPicker();
  }

  if (isPanelOpen && mouseY < canvasStart) { return; }
  if (!isPanelOpen && mouseY < 30) { return; }
  mouseDraw();
}

void mouseDragged() {
  isDragging = true;
  
  if (isPanelOpen) {
    sizeSlider.mouseDragged();
    stabilizationSlider.mouseDragged();
  }
  if(isColorPickerOpen) {
    brightnessSlider.mouseDragged();
    if(sqrMagnitude(colorPickerX, colorPickerY, mouseX, mouseY) <= sq((500 / 2) + 60)) {
      controlColorPicker();
    }
  }
  
  if(isHoveringOverTogglePanelButton())
    isTogglePanelButtonBeingPressed = true;
  
  if (isPanelOpen && mouseY < canvasStart) { return; }
    mouseDraw();
}

void mouseReleased() {
  if (isPanelOpen) {
    for (CircleButton button : colorButtons) {
      button.mouseReleased();
    }
    eraserButton.mouseReleased();
    sizeSlider.mouseReleased();
    stabilizationSlider.mouseReleased();
    stampButton.mouseReleased();
    colorPickerButton.mouseReleased();
  }
  if(isColorPickerOpen) {
    brightnessSlider.mouseReleased();
  }

  // Handle single click
  if (!isDragging && !(isPanelOpen && mouseY < canvasStart) && selectedButton != 13 && !isColorPickerOpen) {
    paintPG.beginDraw();
    paintPG.strokeWeight(currentStrokeSize);
    paintPG.stroke(currentStrokeColor);
    paintPG.point(mouseX, mouseY);
    paintPG.endDraw();
  }

  if (isTogglePanelButtonBeingPressed && !isColorPickerOpen) togglePanel();
  
  isTogglePanelButtonBeingPressed = false;
}
void mouseDraw() {
  if(isColorPickerOpen) { return; }
  
  // stamp is selected
  if(selectedButton == 13) {
    paintPG.beginDraw();
    paintPG.image(stampImg, mouseX - currentStampSize/2, mouseY - currentStampSize / 300.0 * 109.0, currentStampSize, currentStampSize / 150.0 * 109.0);
    paintPG.endDraw();
  } else {
    PVector current = new PVector(mouseX, mouseY);
  
    if (previousSmoothed == null) {
      //println("clicked");
      previousSmoothed = current.copy();
      return;
    }
  
    // Calculate smoothed position
    PVector smoothed = new PVector(); 
    smoothed.x = previousSmoothed.x * smoothingFactor + current.x * (1 - smoothingFactor);
    smoothed.y = previousSmoothed.y * smoothingFactor + current.y * (1 - smoothingFactor);
  
    paintPG.beginDraw();
    paintPG.strokeWeight(currentStrokeSize);
    paintPG.stroke(currentStrokeColor);
    paintPG.line(previousSmoothed.x, previousSmoothed.y, smoothed.x, smoothed.y);
    paintPG.endDraw();
  
    previousSmoothed.set(smoothed);
  }
}

void togglePanel() {
  if(isPanelOpen){
      targetPanelY = -canvasStart + 33;
    }
    else {
      targetPanelY = 0;
    }
    isPanelOpen = !isPanelOpen;
}
PVector clampToCircle(PVector point, PVector center, float radius) {
  PVector dir = PVector.sub(point, center); // vector from center to point
  float dist = dir.mag(); 
  if (dist > radius) {
    dir.normalize(); 
    dir.mult(radius); // set the vector magnitude to the radius
    return PVector.add(center, dir);
  } else {
    return point;
  }
}
public float sqrMagnitude(int x1, int y1, int x2, int y2) {
  return sq(x1 - x2) + sq(y1 - y2);
}
