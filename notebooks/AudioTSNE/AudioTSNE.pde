import ddf.minim.*;
import ddf.minim.effects.*;

float distThresh = 1000;

class SoundClip {
  SoundClip(String path, float x, float y) {
    this.path = path;
    this.x = x;
    this.y = y;
    this.sound = minim.loadSnippet(path);
    this.playing = false;
  }
  void play() {
    sound.play();
    playing = true;
  }
  void stop() {
    sound.pause();
    playing = false;
  }
  void draw() {
    stroke(playing ? color(0, 255, 0) : color(255));
    ellipse(x * width, y * height, 5, 5);
  }
  String path;
  float x;
  float y;
  boolean playing;
  AudioSnippet sound; // not the right class
}

Minim minim;
JSONArray json;
ArrayList<SoundClip> clips;


void setup() {
  size(800, 800);
  minim = new Minim(this);
  clips = new ArrayList<SoundClip>();
  json = loadJSONArray("data.json");
  int numSamples = json.size();
  // you may need to reduce numSamples if you run out of memory
  numSamples = 1500;
  for (int i = 0; i < numSamples; i++) {
    JSONObject entry = json.getJSONObject(i);
    JSONArray point = entry.getJSONArray("point");
    float x = point.getFloat(0);
    float y = point.getFloat(1);
    String path = entry.getString("path");
    SoundClip clip = new SoundClip(path, x, y);
    clips.add(clip);
  } 
  
}

void draw() {
  background(0);
  stroke(255);  
  for(int i = 0; i < clips.size() - 1; i++) {
    clips.get(i).draw();
  }
}

void mouseMoved() {
  for(int i = 0; i < clips.size() - 1; i++) {
    float dx = mouseX - clips.get(i).x * width;
    float dy = mouseY - clips.get(i).y * height;
    float distToMouse = dx*dx + dy*dy;
    if (distToMouse < distThresh && !clips.get(i).playing) {
      clips.get(i).play();
    } else if (distToMouse > distThresh && clips.get(i).playing) {
      clips.get(i).stop();
    }   
  }
}

void keyPressed()
{
}