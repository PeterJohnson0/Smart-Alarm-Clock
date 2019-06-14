import processing.serial.*; //import the Serial library
Serial myPort;
String val;

PFont mainFont;
// Values to sync with Arduino
int hour;
int minute;
int second;

int alarmhour = 4;
int alarmminute = 30;
int alarmAMPM = 1;
int alarmDur = 120;

int Volume = 2;

int R1min = 30;
int R1max = 90;
int R2min = 30;
int R2max = 90;
int R3min = 30;
int R3max = 90;

int newnum = 0;
int newnumindex = 0;

void setup()
{
  // Setting up the Serial Connection
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n'); 
  
  // Setting up the program graphics
  size(640,480);
}

void draw()
{
  background(160,160,255);
  mainFont = createFont("Arial",30,true);
  //buttons
  fill(200);
  rect(550,60,80,33); //Sync
  rect(260,255,58,30); // R1 min
  rect(260,295,58,30); // R2 min
  rect(260,335,58,30); // R3 min
  rect(400,255,63,30); // R1 max
  rect(400,295,63,30); // R2 max
  rect(400,335,63,30); // R3 max
  rect(560,10,70,30); // The exit button
  //Lines
  fill(0);
  line(0,50,640,50);
  line(0,100,640,100);
  line(0,240,640,240);
  line(0,380,640,380);
  //Text
  textFont(mainFont,30);
  textAlign(CENTER);
  text("Smart Alarm Clock Config", 320, 40);
  textAlign(RIGHT);
  text("Current Time:", 240, 140);
  text("Alarm Time:", 240, 180);
  text("Alarm Duration:", 240, 220);
  text("Rangefinger 1:", 240, 280);
  text("Rangefinger 2:", 240, 320);
  text("Rangefinger 3:", 240, 360);
  text("Alarm Volume:", 240, 420);
  text("Alarm Tune:", 240, 460);
  
  //Button Text
  textAlign(LEFT);
  text("Sync",555,85);
  text("Min",265,280);
  text("Min",265,320);
  text("Min",265,360);
  text("Max",404,280);
  text("Max",404,320);
  text("Max",404,360);
  text("Exit", 570, 35);
  
  fill(130,130,255);
  rect(250,115,200,30);
  fill(0);
  textAlign(RIGHT);
  hour = hour();
  minute = minute();
  second = second();
  
  if(hour < 12)
  {
    text("AM",430,140);
    if(hour == 0)
    {
      text(hour+12,290,140);
    }
    else
    {
      text(hour,290,140);
    }
  }
  else
  {
    text("PM",430,140);
    if(hour > 12)
    {
      text(hour-12,290,140);
    }
    else
    {
      text(hour,290,140);
    }
  }
  text(":",300,140);
  text(minute,335,140);
  text(":",345,140);
  text(second,380,140);
  
  fill(220);
  rect(250,155,50,30); // alarm hour
  rect(310,155,50,30); // alarm minute
  rect(370,155,50,30); // alarm AM/PM
  rect(250,195,50,30); // duration
  
  rect(330,255,50,30); // R1 min
  rect(330,295,50,30); // R2 min
  rect(330,335,50,30); // R3 min
  
  rect(475,255,50,30); // R1 max
  rect(475,295,50,30); // R2 max
  rect(475,335,50,30); // R3 max
  
  rect(250,395,50,30); // Volume
  fill(0);
  text("Beep",325,460); // Tune
  
  // number text
  textAlign(CENTER);
  text(alarmhour,275,180);// text Alarmhour
  text(alarmminute,335,180);// text Alarmminute
  if (alarmAMPM == 0)
  {
    text("AM",395,180);// text AM/PPM
  }
  else
  {
    text("PM",395,180);// text AM/PPM
  }
  text(alarmDur,275,220);// text alarmDur
  text(R1min,355,280);// text R1min
  text(R1max,500,280);// text R1max
  text(R2min,355,320);// text R2min
  text(R2max,500,320);// text R2max
  text(R3min,355,360);// text R3min
  text(R3max,500,360); // text R3max
  text(Volume,275,420); // text volume
  
  if (newnumindex > 0)
  {
    fill(220);
    rect(210,60,70,30);
    fill(0);
    textAlign(RIGHT);
    text("New Number:",200,85);
    text(newnum,260,85);
  }
  
  
  // button presses
  
  // Sync
  if (mouseX > 550 && mouseX < 630 && mouseY > 60 && mouseY < 93) 
  {
    if (mousePressed == true) 
    {                           
      serialSync();
    }
  }
  
  // Exit
  if (mouseX > 560 && mouseX < 630 && mouseY > 10 && mouseY < 40) 
  {
    if (mousePressed == true) 
    {                           
      exit();
    }
  }
  
  // alarmhour
  if (mouseX > 250 && mouseX < 300 && mouseY > 155 && mouseY < 185) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 1;
    }
  }
  
  // alarmminute
  if (mouseX > 310 && mouseX < 360 && mouseY > 155 && mouseY < 185) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 2;
    }
  }
  
  //alarmAMPM
  if (mouseX > 370 && mouseX < 420 && mouseY > 155 && mouseY < 185) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 3;
    }
  }
  
  
  // Alarmduration
  if (mouseX > 250 && mouseX < 300 && mouseY > 195 && mouseY < 225) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 4;
    }
  }
  
  
  //R1min
  if (mouseX > 330 && mouseX < 380 && mouseY > 255 && mouseY < 285) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 5;
    }
  }
  
  
  //R1max
  if (mouseX > 475 && mouseX < 525 && mouseY > 255 && mouseY < 285) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 6;
    }
  }
  
  
  //R2min
  if (mouseX > 330 && mouseX < 380 && mouseY > 295 && mouseY < 325) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 7;
    }
  }
  
  //R2max
  if (mouseX > 475 && mouseX < 525 && mouseY > 295 && mouseY < 325) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 8;
    }
  }
  
  //R3min
  if (mouseX > 330 && mouseX < 380 && mouseY > 335 && mouseY < 365) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 9;
    }
  }
  
  
  //R3max
  if (mouseX > 475 && mouseX < 525 && mouseY > 335 && mouseY < 365) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 10;
    }
  }
  
  //Volume
  if (mouseX > 250 && mouseX < 300 && mouseY > 395 && mouseY < 425) 
  {
    if (mousePressed == true) 
    {                           
      newnumindex = 11;
    }
  }
  
  
}

void serialSync()
{
  delay(1000);
  myPort.write('Y');        
  //println("Y");
}

void keyPressed() 
{
  if (newnumindex > 0 && newnum < 100)
  {
    if (key == '1') 
    {
      newnum = newnum * 10;
      newnum = newnum + 1;
    } 
    else if (key == '2')
    {
      newnum = newnum * 10;
      newnum = newnum + 2;
    }
    else if (key == '3')
    {
      newnum = newnum * 10;
      newnum = newnum + 3;
    }
    else if (key == '4')
    {
      newnum = newnum * 10;
      newnum = newnum + 4;
    }
    else if (key == '5')
    {
      newnum = newnum * 10;
      newnum = newnum + 5;
    }
    else if (key == '6')
    {
      newnum = newnum * 10;
      newnum = newnum + 6;
    }
    else if (key == '7')
    {
      newnum = newnum * 10;
      newnum = newnum + 7;
    }
    else if (key == '8')
    {
      newnum = newnum * 10;
      newnum = newnum + 8;
    }
    else if (key == '9')
    {
      newnum = newnum * 10;
      newnum = newnum + 9;
    }
    else if (key == '0')
    {
      newnum = newnum * 10;
      newnum = newnum + 0;
    }
  }
  
  if (key == 10)
  {
    if (newnumindex == 1)
    {
      if (newnum >= 1 && newnum <= 12)
      {
        alarmhour = newnum;
      }
    }
    else if (newnumindex == 2)
    {
      if (newnum >= 0 && newnum <= 60)
      {
      alarmminute = newnum;
      }
    }
    else if (newnumindex == 3)
    {
      if (newnum >= 0 && newnum <= 1)
      {
        alarmAMPM = newnum;
      }
    }
    else if (newnumindex == 4)
    {
      alarmDur = newnum;
    }
    else if (newnumindex == 5)
    {
      R1min = newnum;
    }
    else if (newnumindex == 6)
    {
      R1max = newnum;
    }
    else if (newnumindex == 7)
    {
      R2min = newnum;
    }
    else if (newnumindex == 8)
    {
      R2max = newnum;
    }
    else if (newnumindex == 9)
    {
      R3min = newnum;
    }
    else if (newnumindex == 10)
    {
      R3max = newnum;
    }
    else if (newnumindex == 11)
    {
      if (newnum < 11)
      {
        Volume = newnum;
      }
      else
      {
        Volume = 10;
      }    
    }
    newnumindex = 0;
    newnum = 0;
  }
}

void serialEvent(Serial myPort) 
{
  val = myPort.readStringUntil('\n');
  delay(300);
  if (val != null) 
  {
    val = trim(val);
    println(val);
    if(val.equals("1") == true)
    {
      hour = hour();
      myPort.write(str(hour));
    }
    else if(val.equals("2") == true)
    {
      minute = minute();
      myPort.write(str(minute));
    }
    else if(val.equals("3") == true)
    {
      second = second();
      myPort.write(str(second));
    }
    else if(val.equals("4") == true)
    {
      myPort.write(str(alarmhour));
    }
    else if(val.equals("5") == true)
    {
      myPort.write(str(alarmminute));
    }
    else if(val.equals("6") == true)
    {
      myPort.write(str(alarmAMPM));
    }
    else if(val.equals("7") == true)
    {
      myPort.write(str(alarmDur));
    }
    else if(val.equals("8") == true)
    {
      myPort.write(str(Volume));
    }
    else if(val.equals("a") == true)
    {
      myPort.write(str(R1min));
    }
    else if(val.equals("b") == true)
    {
      myPort.write(str(R1max));
    }
    else if(val.equals("c") == true)
    {
      myPort.write(str(R2min));
    }
    else if(val.equals("d") == true)
    {
      myPort.write(str(R2max));
    }
    else if(val.equals("e") == true)
    {
      myPort.write(str(R3min));
    }
    else if(val.equals("f") == true)
    {
      myPort.write(str(R3max));
    }
  }
}