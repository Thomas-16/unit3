// Thomas Fang
// 24 Feb, 2025
// Color pallette: https://coolors.co/03045e-023e8a-0077b6-0096c7-00b4d8-48cae4-90e0ef-ade8f4-caf0f8


color[] colors = {
  #03045E,
  #023E8A,
  #0077B6,
  #0096C7,
  #00B4D8,
  #48CAE4,
  #90E0EF,
  #ADE8F4,
  #CAF0F8
};


CircleButton circleButton1, circleButton2, circleButton3;
RectButton rectButton1, rectButton2, rectButton3;
color rectangleColor;
color circleColor;

void setup() {
  size(1400, 900);
  frameRate(120);
  
  //circleButton1 = new CircleButton(300, 700, 70, colors[2], colors[0], colors[4], colors[1], 4);
  //circleButton1.setOnClick(() -> {
  //  rectangleColor = circleButton1.getButtonColor();
  //});
  //circleButton2 = new CircleButton(700, 700, 70, colors[5], colors[0], colors[4], colors[1], 4);
  //circleButton2.setOnClick(() -> {
  //  rectangleColor = circleButton2.getButtonColor();
  //});
  //circleButton3 = new CircleButton(1100, 700, 70, colors[7], colors[0], colors[4], colors[1], 4);
  //circleButton3.setOnClick(() -> {
  //  rectangleColor = circleButton3.getButtonColor();
  //});
  
  rectButton1 = new RectButton(300, 700, 100, 60, colors[2], colors[0], colors[4], colors[1], 4);
  rectButton1.setOnClick(() -> {
    circleColor = rectButton1.getButtonColor();
  });
  rectButton2 = new RectButton(700, 700, 100, 60, colors[5], colors[0], colors[4], colors[1], 4);
  rectButton2.setOnClick(() -> {
    circleColor = rectButton2.getButtonColor();
  });
  rectButton3 = new RectButton(1100, 700, 100, 60, colors[7], colors[0], colors[4], colors[1], 4);
  rectButton3.setOnClick(() -> {
    circleColor = rectButton3.getButtonColor();
  });
}

void draw() {
  println(frameRate);
  
  background(colors[8]);
  
  rectMode(CENTER);
  //fill(rectangleColor);
  fill(circleColor);
  strokeWeight(10);
  stroke(colors[0]);
  //rect(width /2, height/2, 500, 300);
  circle(width/2, height/2, 400);
  //circleButton1.draw();
  //circleButton2.draw();
  //circleButton3.draw();
  
  rectButton1.draw();
  rectButton2.draw();
  rectButton3.draw();
  
}

void mouseReleased() {
  //circleButton1.mouseReleased();
  //circleButton2.mouseReleased();
  //circleButton3.mouseReleased();
  rectButton1.mouseReleased();
  rectButton2.mouseReleased();
  rectButton3.mouseReleased();
}
void mousePressed(){
  //circleButton1.mousePressed();
  //circleButton2.mousePressed();
  //circleButton3.mousePressed();
  rectButton1.mousePressed();
  rectButton2.mousePressed();
  rectButton3.mousePressed();
}

float sqrMagnitude(int x1, int y1, int x2, int y2) {
  return sq(x1 - x2) + sq(y1 - y2);
}
