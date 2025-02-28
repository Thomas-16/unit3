// Thomas Fang
// Drawing app
// 24 Feb, 2025
// Color pallette: https://coolors.co/03045e-023e8a-0077b6-0096c7-00b4d8-48cae4-90e0ef-ade8f4-caf0f8


int canvasStart = 150;
boolean isPanelOpen = true;
PGraphics panelPG;
int panelY = 0;
color currentStrokeColor = color(0);

RectButton[] colorButtons;

void setup() {
  size(1400, 900);
  frameRate(120);
  
  panelPG = createGraphics(width, canvasStart);
  colorButtons = new RectButton[12];
  
  int currentX = 40;
  int currentY = 40;
  for(int i = 0; i < colorButtons.length; i++) {
    colorButtons[i] = new RectButton(currentX, currentY, 40, 40, lerpColor(color(#d8f3dc), color(#081c15), map(i, 0, colorButtons.length - 1, 0, 1)), color(0), color(100), color(200), 2);
    currentX += 50;
  }
  for(RectButton button : colorButtons) {
    button.setOnClick(() -> {
      currentStrokeColor = button.getButtonColor();
    });
  }
}

void draw() {
  //println(frameRate);
  
  panelPG.beginDraw();
  panelPG.clear();
  panelPG.noStroke();
  panelPG.fill(#ffbf47);
  panelPG.rect(0,0, width, canvasStart);
  panelPG.strokeWeight(4);
  panelPG.stroke(0);
  panelPG.line(0, canvasStart - 1, width, canvasStart - 1);
  panelPG.endDraw();
  image(panelPG, 0, panelY);
  
  for(RectButton button : colorButtons) {
    button.draw();
  }
  
} 

float sqrMagnitude(int x1, int y1, int x2, int y2) {
  return sq(x1 - x2) + sq(y1 - y2);
}

void mouseDragged() {
  if(mouseY < canvasStart) return;
  
  strokeWeight(5);
  stroke(0);
  line(pmouseX, pmouseY, mouseX, mouseY);
}
void mouseReleased() {
  for(RectButton button : colorButtons) {
    button.mouseReleased();
  }
}
void mousePressed() {
  for(RectButton button : colorButtons) {
    button.mousePressed();
  }
}
void keyPressed() {
  if(key != CODED) return;
  
  if(keyCode == UP) {
    println("panel shifted");
    if(panelY == 0) panelY = -151;
    if(panelY == -151) panelY = 0;
  }
}
