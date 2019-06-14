//SmartAlarm
//Peter Johnson

//lcd pins
#include <LiquidCrystal.h>
LiquidCrystal lcd(2,3,32,34,36,38);//(12, 11, 5, 4, 3, 2); //rs, en, d4, d5, d6, d7

// Range trigger pins
int PinET1 = 6;
int PinET2 = 5;
int PinET3 = 4;

int ARPin = PinET1;
int AEPin = 0;

// Buzzer pin
int PinBuzz = 7;

// Variables
int seconds = 0;
int minutes = 0;
int hours = 0;
int clockhour = 0;
String AMPM = "AM";

long unsigned CurrentTimeMillis;
long unsigned SetTimeMillis = millis();

int SetHour = 0;
int SetMinute = 0;
int SetSecond = 0;

int AlarmHour = 6; //Alarm Start hour
int AlarmMinute = 30; // Alarm Start minute
int AlarmDuration = 120;

int RangeLow1 = 0;
int RangeHigh1 = 0;

int AlarmActive = 1;
int ActiveRange = 1;
int TimerPhase = 1;

long unsigned RT1;
long unsigned RT2;
int Range;
int Range1;
int Range2;
int Range3;

int BuzzerActive = 0;
int BuzzState = 0;
long unsigned BuzzTime1 = 0;
long unsigned BuzzTime2 = 0;

// Serial
char valSerial;
String valStr;
int SyncPhase = 0;

void setup() 
{
  Serial.begin(9600);
  // Range Pins
  pinMode(PinET1, OUTPUT);
  pinMode(PinET2, OUTPUT);
  pinMode(PinET3, OUTPUT);
  pinMode(A1, INPUT); // echo 1
  pinMode(A2, INPUT); // echo 2
  pinMode(A3, INPUT); // echo 3
  pinMode(A0, INPUT); // button
  // Buzzer Pin
  pinMode(PinBuzz, OUTPUT);
  // LCD pins
  lcd.begin(16, 2);
}

void loop() 
{
  TimeUpdate();
  DisplayTime();
  if (AlarmActive == 1)// check if alarm period is on
  {
    digitalWrite(ARPin, 1);
    RT1 = millis();
    RT2 = millis();
    while (RT2 - RT1 < 10)
    {
      RT2 = millis();
    }
    digitalWrite(ARPin, 0);
    while(analogRead(AEPin) < 500)
    {
      BuzzerCheck();
    }
    RT1 = millis();
    while(analogRead(AEPin) > 500)
    {
      BuzzerCheck();
    }
    RT2 = millis();
    Range = (RT2-RT1)*1000/58; //cm, error of ~15cm
    switch (ActiveRange)
    {
      case 1:
      Range1 = Range;
      ActiveRange = 2;
      ARPin = PinET2;
      AEPin = 1;
      break;
      case 2:
      Range2 = Range;
      ActiveRange = 3;
      ARPin = PinET3;
      AEPin = 2;
      break;
      case 3:
      Range3 = Range;
      ActiveRange = 1;
      ARPin = PinET1;
      AEPin = 0;
      break;
    }
  }
  BuzzerCheck();
}

void serialEvent()
{
  if (Serial.available() > 0)
  {
    switch(SyncPhase)
    {
      case 1:
      valStr = Serial.readStringUntil('\n');
      SetHour = valStr.toInt();
      SyncPhase = 0;
      Serial.println(SetHour);
      delay(300);
      break;
      default:
      valSerial = Serial.read();
      delay(1000);
      if (valSerial = 'Y')
      {
        Serial.println("1");
        SyncPhase = 1;
        SetTimeMillis = millis();
        delay(300);
      }
      break;
    }
  }
}

void BuzzerCheck()
{
  // compare range1 to threshold
  // compare range2 to threshold
  // compare range3 to threshold
  if (Range1 < 20 || Range2 < 20 || Range3 < 20) // test case
  {
    BuzzerActive = 1;
  }
  else
  {
    BuzzerActive = 0;
  }
  // if any are active, do below.
  if (BuzzerActive == 1)
  {
    Buzzer();
  }
  else
  {
    BuzzState = 0;
    analogWrite(PinBuzz, 0);
  }
}

void Buzzer()
{
  BuzzTime2 = millis();
  if (BuzzTime2 - BuzzTime1 > 1000)
  {
    if (BuzzState == 0)
    {
      BuzzState == 1;
      //analogWrite(PinBuzz, 100);
    }
    else
    {
      BuzzState == 0;
      //analogWrite(PinBuzz, 0);
    }
    BuzzTime1 = BuzzTime2;
  }
}

void TimeUpdate()
{
  CurrentTimeMillis = millis() - SetTimeMillis;
  seconds = (CurrentTimeMillis/1000+SetSecond)%60;
  minutes = (CurrentTimeMillis/60000+SetMinute)%60;
  hours = (CurrentTimeMillis/3600000+SetHour)%24;
  if (hours < 12)
  {
    AMPM = "AM";
    if (hours == 0)
    {
      clockhour = 12;
    }
    else
    {
      clockhour = hours;
    }
  }
  else
  {
    AMPM = "PM";
    if (hours == 12)
    {
      clockhour = 12;
    }
    else
    {
      clockhour = hours - 12;
    }
  }
}

void DisplayTime()
{
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Time");
  lcd.setCursor(0, 1);
  lcd.print(clockhour);
  lcd.setCursor(2, 1);
  lcd.print(":");
  lcd.setCursor(3, 1);
  lcd.print(minutes);
  lcd.setCursor(6, 1);
  lcd.print(AMPM);
}

