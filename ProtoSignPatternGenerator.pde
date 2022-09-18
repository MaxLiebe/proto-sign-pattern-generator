/*
Proto Sign Pattern Generator
Written by Max Liebe, secretary of the 12th board of S.A. Proto.

HOW TO USE
----------
In order to generate a custom pattern, you can use the initialSetup() and animation() functions for basic animations. 

Feel free to extend this program should you want to create more complex animations. However, make sure that it can be reset with initialSetup()
and that each frame gets fully handled with animation() or the exported animation might differ from the preview

Once you're satisfied with the pattern you've created, you can set the duration and fps you want to export it with, and then export it as a .plep file.
.plep files will be parsed by [REDACTED]

NOTE
----
If the program gives an error, make sure to install the G4P library.
*/

int VERSION = 0;

int patternScreenWidth = 800;
int patternScreenHeight = 800;

int horLEDs = 37; //max: 255, 37 is the resolution of the Proto sign
int verLEDs = 15; //max: 255, 15 is the resolution of the Proto sign
int ledRadius = 20; //radius at which the preview LEDs are drawn

int targetFrameRate = 60; //targeted frame rate the animation is exported (and previewed, if possible) with

color[][] frameBuffer; //main "image" buffer of the animation, should get updated every frame in the animation() method

//gui stuff
import g4p_controls.*;

GLabel fpsLabel;
GCustomSlider fpsSlider;
GLabel fpsWarning;

GTextField durationInput;
GButton exportButton;

  void setup() {
    size(800, 850);
    frameBuffer = new color[horLEDs][verLEDs];
    noStroke();
    
    //initial setup should reset/prepare the animation
    initialSetup();
    
    //gui stuff
    fpsLabel = new GLabel(this, 170, height - 30, 40, 60);
    fpsLabel.setTextAlign(GAlign.LEFT, GAlign.TOP);
    fpsLabel.setText("FPS:");
    
    G4P.setSliderFont("Arial", G4P.BOLD, 10); // New for G4P V4.3
    fpsSlider = new GCustomSlider(this, 210, height - 50, 140, 50, null);
    fpsSlider.setShowDecor(false, true, true, true);
    fpsSlider.setLimits(targetFrameRate, 5, 120);
    
    fpsWarning = new GLabel(this, 360, height - 45, 230, 100);
    fpsWarning.setTextAlign(GAlign.LEFT, GAlign.TOP);
    fpsWarning.setText("Note: set FPS may differ from visible FPS if performance is hindered. Animation is always exported with the set FPS.");
    
    durationInput = new GTextField(this, 20, height - 35, 130, 20);
    durationInput.setPromptText("Duration in frames");
    durationInput.setNumeric(1, 3600, 300);
    
    exportButton = new GButton(this, width - 190, height - 35, 170, 20, "Export animation");
  }
  
  void draw() {
    background(0);
    animation();
    drawBufferframe();
    
    //gui stuff
    fill(190);
    rect(0, patternScreenHeight, width, height);
  }
  
  void initialSetup() {
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
  
  void animation() {
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
  
  void drawBufferframe() {
    for(int x = 0; x < horLEDs; x++) {
      for(int y = 0; y < verLEDs; y++) {
        fill(frameBuffer[x][y]);
        circle(map(x, 0, horLEDs, ledRadius, patternScreenWidth), map(y, 0, verLEDs, ledRadius, patternScreenHeight), ledRadius);
      }
    }
  }
  
  void handleTextEvents(GEditableTextControl textControl, GEvent event) {
    exportButton.setEnabled(durationInput.isValid());
  }
  
  void handleButtonEvents(GButton button, GEvent event) {
    //export the animation as a .plep file to be parsed
    int frames = durationInput.getValueI();
    byte[] data = new byte[6 + (3 * frames * horLEDs * verLEDs)];
    
    //write the version, length, frame rate and resolution of the animation as a header
    data[0] = (byte)VERSION;
    data[1] = (byte)(frames);
    data[2] = (byte)(frames >> 8);
    data[3] = (byte)(targetFrameRate);
    data[4] = (byte)horLEDs;
    data[5] = (byte)verLEDs;
    
    initialSetup();
    for(int i = 0; i < frames; i++) {
      animation();
      for(int x = 0; x < horLEDs; x++) {
        for(int y = 0; y < verLEDs; y++) {
          int offset = 6 + (3 * i * horLEDs * verLEDs) + (3 * x * verLEDs) + (3 * y);
          data[offset] = byte(red(frameBuffer[x][y]));
          data[offset + 1] = byte(green(frameBuffer[x][y]));
          data[offset + 2] = byte(blue(frameBuffer[x][y]));
        }
      } 
    }
    String file = G4P.selectOutput("Choose a location to save to", "plep", "Proto LED Effect Pattern");
    if(file.endsWith(".plep")){
      file = file.substring(0, file.length()-5);
    }
    saveBytes(file + ".plep", data);
  }
  
  void handleSliderEvents(GValueControl slider, GEvent event) {
    targetFrameRate = slider.getValueI();
    frameRate(targetFrameRate);
  }
