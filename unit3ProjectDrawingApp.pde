// Thomas Fang
// Drawing app
// 24 Feb, 2025
// Color pallette: https://coolors.co/03045e-023e8a-0077b6-0096c7-00b4d8-48cae4-90e0ef-ade8f4-caf0f8


// TODOS:
// PEN CURSOR, ERASER CURSOR
// SIZE SELECTION

PGraphics panelPG;
PGraphics paintPG;

int canvasStart = 190;
boolean isPanelOpen = true;
color currentStrokeColor = color(0);
int selectedButton = 0; // 0-11 = color buttons, 12 = eraser, 13 = stamp tool
color selectedButtonOutlineColor = color(255, 251, 3);

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

RectButton[] colorButtons;
RectButton eraserButton;
PImage eraserImg;

void setup() {
  size(1400, 900);
  frameRate(120);
  
  arrowDownImg = loadImage("arrow down.png");
  arrowUpImg = loadImage("arrow up.png");
  eraserImg = loadImage("eraser.png");
  
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
  
  // create color buttons
  colorButtons = new RectButton[12];
  int currentX = 80;
  int currentY = 35;
  for(int i = 0; i < colorButtons.length; i++) {
    colorButtons[i] = new RectButton(panelPG, currentX, currentY, 30, 30, lerpColor(color(#d8f3dc), color(#081c15), map(i, 0, colorButtons.length - 1, 0, 1)), color(0), color(100), color(100), 3, 2);
    colorButtons[i].setButtonNum(i);
    currentX += 40;
    if((i + 1) % 4 == 0) {
      currentX = 80;
      currentY += 40;
    }
  }
  colorButtons[0].setOutlineColor(selectedButtonOutlineColor);
  
  for(RectButton button : colorButtons) {
    button.setOnClick(() -> {
      currentStrokeColor = button.getButtonColor();
      selectButton(button.getButtonNum());
    });
  }
  
  // create eraser button
  eraserButton = new RectButton(panelPG, 300, 75, 80, 80, color(255), color(0), color(100), color(200), 4, 6);
  eraserButton.setOnClick(() -> {
    currentStrokeColor = color(255);
    selectButton(12);
  });
  
}

void draw() {
  //println(frameRate);
  
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
  for(RectButton button : colorButtons) {
    button.draw();
  }
  
  // draw eraser button + image
  eraserButton.draw();
  panelPG.beginDraw();
  panelPG.imageMode(CENTER);
  panelPG.image(eraserImg, 300, 75, 60, 60);
  panelPG.endDraw();
  
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

void mouseDragged() {
  if(isPanelOpen && mouseY < canvasStart - 36) { return; }
    mouseDraw();
}
void mouseReleased() {
  if(isPanelOpen) {
    for(RectButton button : colorButtons) {
      button.mouseReleased();
    }
    eraserButton.mouseReleased();
  }
  
  if(isTogglePanelButtonBeingPressed)
    togglePanel();
  
  isTogglePanelButtonBeingPressed = false;
}
void mousePressed() {
  if(isPanelOpen) {
    for(RectButton button : colorButtons) {
      button.mousePressed();
    }
    eraserButton.mousePressed();
  }
  
  if(isHoveringOverTogglePanelButton())
    isTogglePanelButtonBeingPressed = true;
  
  if(isPanelOpen && mouseY < canvasStart - 36) { return; }
    mouseDraw();
}
void mouseDraw() {
  paintPG.beginDraw();
  paintPG.strokeWeight(5);
  paintPG.stroke(currentStrokeColor);
  paintPG.line(pmouseX, pmouseY, mouseX, mouseY);
  paintPG.endDraw();
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
