
import processing.video.*;
Capture rCap;
Capture gCap;
Capture bCap;

int nDelayFrames = 10; // about 3 seconds
int nDelayFramesB = 21;
int currentFrame = nDelayFrames-1;
int currentFrameB = nDelayFramesB-1;
PImage frames[];
PImage framesB[];

void setup() {
  size (640, 480);
  rCap = new Capture(this, width, height);
  gCap = new Capture(this, width, height);
  bCap = new Capture(this, width, height);
  rCap.start();

  frames = new PImage[nDelayFrames];
  for (int i=0; i<nDelayFrames; i++) {
    frames[i] = new PImage(width, height);
  }
  framesB = new PImage[nDelayFramesB];
  for (int i=0; i<nDelayFramesB; i++) {
    framesB[i] = new PImage(width, height);
  }
}

void draw() {
  if (rCap.available()) {
    rCap.read();
    gCap.read();
    bCap.read();
    for (int d = 0; d < width; d++) {
      for (int j = 0; j < height; j++) {
        int loc = d + j * width;
        int pixelColour = rCap.pixels[loc];
        int r = (pixelColour >> 16) & 0xff;
        int g = (pixelColour >> 8) & 0xff;
        int b = pixelColour & 0xff;
        rCap.pixels[loc] = color(r, 0, 0); 
        gCap.pixels[loc] = color(0, g, 0); 
        bCap.pixels[loc] = color(0, 0, b);
        rCap.updatePixels();
        gCap.updatePixels();
        bCap.updatePixels();
      }
    }
    frames[currentFrame].loadPixels();
    arrayCopy (gCap.pixels, frames[currentFrame].pixels);
    frames[currentFrame].updatePixels();
    currentFrame = (currentFrame-1 + (nDelayFrames)) % nDelayFrames;
    framesB[currentFrameB].loadPixels();
    arrayCopy (bCap.pixels, framesB[currentFrameB].pixels);
    framesB[currentFrameB].updatePixels();
    currentFrameB = (currentFrameB-1 + nDelayFramesB) % nDelayFramesB;
  }
  
  pushMatrix();
    scale(-1, 1);
    translate(-width, 0);
    blendMode(NORMAL);
    // RED
    image(rCap, 0, 0, width, height);
    blendMode(SCREEN);
    // BLUE
    image (framesB[currentFrameB], 0, 0, width, height);
    // GREEN
    image (frames[currentFrame], 0, 0, width, height);
  popMatrix();
}