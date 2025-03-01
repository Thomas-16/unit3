// Thomas Fang
// Drawing app
// 24 Feb, 2025
// Color pallette: https://coolors.co/03045e-023e8a-0077b6-0096c7-00b4d8-48cae4-90e0ef-ade8f4-caf0f8


int canvasStart = 190;
boolean isPanelOpen = true;
PGraphics panelPG;
PGraphics paintPG;
float panelY = 0;
color currentStrokeColor = color(0);
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

void setup() {
  size(1400, 900);
  frameRate(120);
  
  arrowDownImg = loadImage("arrow down.png");
  arrowUpImg = loadImage("arrow up.png");
  
  // delta time calculation
  float currentMillis = millis();
  deltaTime = (currentMillis - previousMillis) / 1000.0;
  previousMillis = currentMillis;
  
  paintPG = createGraphics(width, height);
  paintPG.beginDraw();
  paintPG.background(255);
  paintPG.endDraw();
  
  panelPG = createGraphics(width, canvasStart);
  
  colorButtons = new RectButton[12];
  int currentX = 60;
  int currentY = 35;
  for(int i = 0; i < colorButtons.length; i++) {
    colorButtons[i] = new RectButton(panelPG, currentX, currentY, 30, 30, lerpColor(color(#d8f3dc), color(#081c15), map(i, 0, colorButtons.length - 1, 0, 1)), color(0), color(100), color(200), 2, 2);
    currentX += 40;
    if((i + 1) % 4 == 0) {
      currentX = 60;
      currentY += 40;
    }
  }
  for(RectButton button : colorButtons) {
    button.setOnClick(() -> {
      currentStrokeColor = button.getButtonColor();
    });
  }
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
  panelPG.endDraw();
  
  for(RectButton button : colorButtons) {
    button.draw();
  }
  
  panelY = lerp(panelY, targetPanelY, deltaTime * panelSpeed);
  image(panelPG, 0, panelY);
  
} 
boolean isHoveringOverTogglePanelButton() { return mouseX < width/2 + 40 + 2 && mouseX > width/2 - 40 - 2 && mouseY < canvasStart -17 + panelY + 16.5 + 2 && mouseY > canvasStart -17 + panelY - 16.5 - 2; }


void mouseDragged() {
  paintPG.beginDraw();
  paintPG.strokeWeight(5);
  paintPG.stroke(currentStrokeColor);
  paintPG.line(pmouseX, pmouseY, mouseX, mouseY);
  paintPG.endDraw();
}
void mouseReleased() {
  for(RectButton button : colorButtons) {
    if(isPanelOpen)
      button.mouseReleased();
  }
  
  isTogglePanelButtonBeingPressed = false;
  if(isHoveringOverTogglePanelButton())
    togglePanel();
}
void mousePressed() {
  for(RectButton button : colorButtons) {
    if(isPanelOpen)
      button.mousePressed();
  }
  
  if(isHoveringOverTogglePanelButton())
      isTogglePanelButtonBeingPressed = true;
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

float sqrMagnitude(int x1, int y1, int x2, int y2) {
  return sq(x1 - x2) + sq(y1 - y2);
}
