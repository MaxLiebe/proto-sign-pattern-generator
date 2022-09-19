class RandomRainbowPattern extends Pattern {
  //example of a typical pattern implementation
  
  RandomRainbowPattern(int horLEDs, int verLEDs, int patternWidth, int patternHeight) {
    super(horLEDs, verLEDs, patternWidth, patternHeight);
  }

  @Override
  public void initialSetup() {
    //set some initial values here (e.g. initial frame buffer values)
    
    //example: each pixel starts at a random hue with full saturation and brightness.
    for(int x = 0; x < horLEDs; x++) {
      for(int y = 0; y < verLEDs; y++) {
        pushStyle();
        colorMode(HSB);
        frameBuffer[x][y] = color(random(255), 255, 255);
        popStyle();
      }
    }
  }
  
  @Override
  public void animation() {
    //your animation here, every execution of this function handles 1 frame
    
    //example: shift the hue of each LED by 1, looping around at the end
    for(int x = 0; x < horLEDs; x++) {
      for(int y = 0; y < verLEDs; y++) {
        pushStyle();
        colorMode(HSB);
        frameBuffer[x][y] = color(hue(frameBuffer[x][y]) + 1, 255, 255);
        popStyle();
      }
    }
  }
}
