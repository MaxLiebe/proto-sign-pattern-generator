class GreenSnakePattern extends Pattern {
  //example of a typical pattern implementation
 
  PVector[] positions;
  PVector speed;
  float snakeThickness = 2;
  
  GreenSnakePattern(int horLEDs, int verLEDs, int patternWidth, int patternHeight) {
    super(horLEDs, verLEDs, patternWidth, patternHeight);
  }

  @Override
  public void initialSetup() {
    //set some initial values here (e.g. initial frame buffer values)
    
    //example: we start by placing the snake somewhere on the screen
    positions = new PVector[30];
    for(int i = positions.length - 1; i > 0; i--) {
      positions[i] = new PVector();
    }
    positions[0] = new PVector(random(0, horLEDs), random(0, verLEDs));
    
    speed = new PVector();
  }
  
  @Override
  public void animation() {
    //your animation here, every execution of this function handles 1 frame
    
    //example: move the snake in a random direction and draw it
    speed.add(new PVector(random(-1, 1), random(-1, 1)));
    speed.limit(0.5);
    positions[0].add(speed);
    
    //make sure we can't go through walls
    if(positions[0].x < 0) positions[0].x = 0; 
    if(positions[0].x > (float)horLEDs - 1) positions[0].x = (float)horLEDs - 1; 
    if(positions[0].y < 0) positions[0].y = 0; 
    if(positions[0].y > (float)verLEDs - 1) positions[0].y = (float)verLEDs - 1;
    
    //draw the snake
    for(int x = 0; x < horLEDs; x++) {
      for(int y = 0; y < verLEDs; y++) {
        boolean setPixel = false;
        for(int i = 0; i < positions.length; i++) {
          if(abs(positions[i].x - x) <= snakeThickness && abs(positions[i].y - y) <= snakeThickness / ((float)horLEDs / (float)verLEDs)) {
            frameBuffer[x][y] = color(0, 255 - map(i, 0, positions.length, 0, 255), 0);
            setPixel = true;
            break;
          }
        }
        if(!setPixel) {
          frameBuffer[x][y] = color(0); 
        }
      }
    }
    
    //shift the previous positions list
    for(int i = positions.length - 2; i >= 0; i--) {
      positions[i + 1] = positions[i];
    }
    positions[0] = positions[0].copy();
  }
}
