import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
import java.io.InputStreamReader;

color off = #245A7A;
color on = #408DD2;

int w = 800, h = 600;
String alf = "    АБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ";
String[] lines = new String[60000];

void setup() {
  size(w, h);
  
  try {

    InputStream fi = createInput("dict.txt");
            
    InputStreamReader input = new InputStreamReader(fi);
    BufferedReader reader = new BufferedReader(input);
    
    String line;
    int i = 0;
    while ((line = reader.readLine()) != null) {
      lines[i] = line;
      // println(line);
      i++;
    }
    reader.close();
  }
  
  catch (IOException e) {
    e.printStackTrace();
  }
  
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[10], 57600);
  arduino.pinMode(7, Arduino.INPUT);
}

void phonebuttn(int x, int y, String text, boolean sel)
{
  int hbtn = h/5;
  int wbtn = w/5;
  if (sel)
    fill(on);
  else 
    fill(off);  
  rect(x, y, wbtn, hbtn);
  textSize(24);
  textAlign(CENTER, TOP);
  fill(255, 255, 255);
  text(text, x + wbtn/2, y + hbtn/2);
}
int t = 0, dir = 0;
int xsel = 0, ysel = 0;

void draw() {
  background(off);
  strokeWeight(3);
  stroke(on);
  t++;
  text(lines[100], 400, 50);
  delay(300);  
  if (arduino.digitalRead(7) == Arduino.HIGH)
  {
    if (dir == 0) xsel++;
    if (dir == 1) ysel++;
    if (dir == 2) dir = 0;
    
    t = 0;
  }
  if (t>4 && dir == 0) {dir=1; t=0;} 
  if (t>8 && dir == 1) {dir=2; t=0;}
  
  boolean sel = false;
  for (int i = 0; i < 3; i++)
    for (int j = 0; j < 3; j++)
    {
      if (i == xsel && j == ysel) sel = true;
      String str = ""+alf.charAt(j*12+i*4)+alf.charAt(j*12+i*4+1)+alf.charAt(j*12+i*4+2)+alf.charAt(j*12+i*4+3);
      phonebuttn(i * w/5 + w/5, j * h/5 + h/5, str, sel);
      sel = false;
    }

  noFill();
}
