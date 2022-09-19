class Pattern {
  //parent class for all patterns, DO NOT ALTER
  
  protected color[][] frameBuffer; //main "image" buffer of the animation, should get updated every frame in the animation() method
  protected int horLEDs = 37; //max: 255, 37 is the resolution of the Proto sign
  protected int verLEDs = 15; //max: 255, 15 is the resolution of the Proto sign
  protected int patternWidth = 800; //preview window width in pixels
  protected int patternHeight = 800; //preview window height in pixels
  
  Pattern(int horLEDs, int verLEDs, int patternWidth, int patternHeight) {
    frameBuffer = new color[horLEDs][verLEDs];
    this.horLEDs = horLEDs;
    this.verLEDs = verLEDs;
    this.patternWidth = patternWidth;
    this.patternHeight = patternHeight;
    initialSetup();
  }
  
  public void initialSetup(){}
  public void animation(){}
  public color[][] getFrameBuffer() {return frameBuffer;}
  public int getHorLEDs() {return horLEDs;}
  public int getVerLEDs() {return verLEDs;}
  public int getPatternWidth() {return patternWidth;}
  public int getPatternHeight() {return patternHeight;}
  
  public void drawPreviewFrame(int ledRadius) {
    for(int x = 0; x < horLEDs; x++) {
      for(int y = 0; y < verLEDs; y++) {
        fill(frameBuffer[x][y]);
        circle(map(x, 0, horLEDs, ledRadius, patternWidth), map(y, 0, verLEDs, ledRadius, patternHeight), ledRadius);
      }
    }
  }
  
  public byte[] runAnimationBufferData(int frames, int headerLength) {
    byte[] buf = new byte[6 + (3 * frames * horLEDs * verLEDs)];
    
    //reset the pattern
    initialSetup();
    
    //run the animation
    for(int i = 0; i < frames; i++) {
      animation();
      for(int x = 0; x < horLEDs; x++) {
        for(int y = 0; y < verLEDs; y++) {
          int offset = headerLength + (3 * i * horLEDs * verLEDs) + (3 * x * verLEDs) + (3 * y);
          color pixel = frameBuffer[x][y];
          buf[offset] = byte(red(pixel));
          buf[offset + 1] = byte(green(pixel));
          buf[offset + 2] = byte(blue(pixel));
        }
      } 
    }
    
    return buf;
  }
}
