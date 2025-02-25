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


CircleButton circleButton1;
color rectangleColor;

void setup() {
  size(1400, 900);
  frameRate(120);
  
  circleButton1 = new CircleButton(300, 700, 70, colors[5], colors[0], colors[6], colors[1], 4);
  circleButton1.setOnClick(() -> {
    rectangleColor = circleButton1.getButtonColor();
  });
}

void draw() {
  println(frameRate);
  
  background(colors[8]);
  
  rectMode(CENTER);
  fill(rectangleColor);
  strokeWeight(10);
  stroke(colors[0]);
  rect(width /2, height/2, 500, 300);
  circleButton1.draw();
  
}

void mouseReleased() {
  circleButton1.mouseReleased();
}

float sqrMagnitude(int x1, int y1, int x2, int y2) {
  return sq(x1 - x2) + sq(y1 - y2);
}
