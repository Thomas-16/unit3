// Thomas Fang
// Drawing app
// 24 Feb, 2025
// Color pallette: https://coolors.co/03045e-023e8a-0077b6-0096c7-00b4d8-48cae4-90e0ef-ade8f4-caf0f8


// TODOS:
// AN INDICATOR SHOWING CURRENT COLOR AND THICKNESS
// STAMP TOOL

PGraphics panelPG;
PGraphics paintPG;
PGraphics strokeSizeIndicatorPG;

int canvasStart = 190;
boolean isPanelOpen = true;
color currentStrokeColor = color(0);
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


void setup() {
  size(1400, 900);
  frameRate(120);
  
  arrowDownImg = loadImage("arrow down.png");
  arrowUpImg = loadImage("arrow up.png");
  eraserImg = loadImage("eraser.png");
  
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
  
  // create color buttons
  colorButtons = new CircleButton[12];
  int currentX = 80;
  int currentY = 35;
  for(int i = 0; i < colorButtons.length; i++) {
    colorButtons[i] = new CircleButton(panelPG, currentX, currentY, 30, lerpColor(color(#f6ff00), color(#f21800), map(i, 0, colorButtons.length - 1, 0, 1)), color(0), color(100), color(100), 3);
    colorButtons[i].setButtonNum(i);
    currentX += 40;
    if((i + 1) % 4 == 0) {
      currentX = 80;
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
  
  // create eraser button
  eraserButton = new RectButton(panelPG, 290, 75, 60, 60, color(255), color(0), color(100), color(200), 4, 6);
  eraserButton.setOnClick(() -> {
    currentStrokeColor = color(255);
    selectButton(12);
  });
  
  // create stroke size slider
  sizeSlider = new Slider(panelPG, 370, 75, 200, 8, color(0), 20, 3, color(0), color(100));
  sizeSlider.setOnSliderValueChanged(() -> {
    currentStrokeSize = map(sizeSlider.getSliderValue(), 0, 1, MIN_STROKE_SIZE, MAX_STROKE_SIZE);
    timeLastChangedStrokeSize = millis();
  });
  currentStrokeSize = map(sizeSlider.getSliderValue(), 0, 1, MIN_STROKE_SIZE, MAX_STROKE_SIZE);
  
  // Create stabilization slider
  stabilizationSlider = new Slider(panelPG, 600, 75, 200, 8, color(0), 20, 3, color(0), color(100));
  stabilizationSlider.setOnSliderValueChanged(() -> {
    smoothingFactor = map(stabilizationSlider.getSliderValue(), 0, 1, 0.65, 0.92);
  });
  smoothingFactor = map(stabilizationSlider.getSliderValue(), 0, 1, 0.65, 0.92);
}

void draw() {
  println(frameRate);
  
  background(255);
  
  // user drawing pg
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
  panelPG.image(eraserImg, 290, 75, 44, 44);
  panelPG.endDraw();
  
  // draw size slider
  sizeSlider.draw();
  panelPG.beginDraw();
  panelPG.textFont(font1);
  panelPG.textSize(25);
  panelPG.text("STROKE SIZE", 383, 115);
  panelPG.endDraw();
  
  // draw stabilization slider
  stabilizationSlider.draw();
  panelPG.beginDraw();
  panelPG.textFont(font1);
  panelPG.textSize(25);
  panelPG.text("STABILIZATION", 600, 115);
  panelPG.endDraw();
  
  // draw stroke size indicator
  if(millis() - timeLastChangedStrokeSize < 1000 && millis() > 1000) {
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
  
  panelY = lerp(panelY, targetPanelY, deltaTime * panelSpeed);
  image(panelPG, 0, panelY);
  
} 
boolean isHoveringOverTogglePanelButton() { return mouseX < width/2 + 40 + 2 && mouseX > width/2 - 40 - 2 && mouseY < canvasStart -17 + panelY + 16.5 + 2 && mouseY > canvasStart -17 + panelY - 16.5 - 2; }

void selectButton(int buttonNum) {
  if(selectedButton <= 11) {
    colorButtons[selectedButton].setOutlineColor(color(0));
  } else if(selectedButton == 12) {
    eraserButton.setOutlineColor(color(0));
  }
  selectedButton = buttonNum;
  if(selectedButton <= 11) {
    colorButtons[selectedButton].setOutlineColor(selectedButtonOutlineColor);
  } else if(selectedButton == 12) {
    eraserButton.setOutlineColor(selectedButtonOutlineColor);
  }
}
void mousePressed() {
  isDragging = false;
  previousSmoothed = null; // Reset for new stroke
  
  if(isHoveringOverTogglePanelButton())
    isTogglePanelButtonBeingPressed = true;

  if (isPanelOpen && mouseY < canvasStart - 36) { return; }
  mouseDraw();
}

void mouseDragged() {
  isDragging = true;
  
  if (isPanelOpen) {
    sizeSlider.mouseDragged();
    stabilizationSlider.mouseDragged();
  }
  
  if(isHoveringOverTogglePanelButton())
    isTogglePanelButtonBeingPressed = true;
  
  if (isPanelOpen && mouseY < canvasStart - 36) { return; }
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
  }

  // Handle single click (draw point if not dragged)
  if (!isDragging && !(isPanelOpen && mouseY < canvasStart)) {
    paintPG.beginDraw();
    paintPG.strokeWeight(currentStrokeSize);
    paintPG.stroke(currentStrokeColor);
    paintPG.point(mouseX, mouseY);
    paintPG.endDraw();
  }

  if (isTogglePanelButtonBeingPressed) togglePanel();
  
  isTogglePanelButtonBeingPressed = false;
}
void mouseDraw() {
  PVector current = new PVector(mouseX, mouseY);

  if (previousSmoothed == null) {
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

void togglePanel() {
  if(isPanelOpen){
      targetPanelY = -canvasStart + 33;
    }
    else {
      targetPanelY = 0;
    }
    isPanelOpen = !isPanelOpen;
}

public float sqrMagnitude(int x1, int y1, int x2, int y2) {
  return sq(x1 - x2) + sq(y1 - y2);
}
