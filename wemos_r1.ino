#include <SD.h>
#include <SPI.h>
#include <ESP8266WiFi.h>
#include <Wire.h>
#include <RtcDS1307.h>
#include <EEPROM.h>

File myFile;

RtcDS1307<TwoWire> Rtc(Wire);

#define WIFI_SSID "ESP_WIFI"
#define WIFI_PASSWORD "ESP12345"
#define SSPin 4
#define DIST 100
#define READNS 20
#define countof(a) (sizeof(a) / sizeof(a[0]))

//EEPROM and File IO
int addr_route = 0, addr_file = 10;
int curr_route_val = 0, curr_file_no = 1;
String file_no = String("file");
String file_no1 = "";
String txt = String(".txt");
String route_no = String("Route no: ");
byte high, low;
int rssi = 0, new_rssi, wrt_rssi;
int state=LOW;

//Distance to be travelled in cms
String distance = String(DIST)+String(" cm"); 
int readings = READNS;

char datestring[25];


void setup()
{
  //Initialize board interfaces
  Serial.begin(115200);
  Serial.println(" ");
  EEPROM.begin(512);

  //Configure pins
  pinMode(14,OUTPUT);
  pinMode(0,OUTPUT);
  pinMode(15, INPUT);
  
  digitalWrite(14,LOW);
  digitalWrite(0,LOW);
  
  //Read current route number from EEPROM
  high = EEPROM.read(addr_route);
  low = EEPROM.read(addr_route + 1);
  curr_route_val = (high << 8) + low; //reconstruct the integer
  route_no += curr_route_val;

  //Read current file number from EEPROM
  high = EEPROM.read(addr_file);
  low = EEPROM.read(addr_file + 1);
  curr_file_no = (high << 8) + low; //reconstruct the integer
  file_no += String(curr_file_no);
  file_no += txt;
  file_no1 = String(file_no);

  // Set WiFi to station mode and disconnect from an AP if it was previously  connected
  WiFi.mode(WIFI_STA);
  WiFi.disconnect();
  delay(200);

  // connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");

  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(700);
  }
  Serial.println();
  Serial.print("Connected to: ");
  Serial.println(WIFI_SSID);


  Serial.println("Signal log start...");

  //Initialize RTC
  Rtc.Begin();
  delay(200);
  if (!Rtc.GetIsRunning())
  {
    Serial.println("RTC was not actively running, starting now");
    Rtc.SetIsRunning(true);
  }

  //Read date and time into RTC object
  RtcDateTime now = Rtc.GetDateTime();
  snprintf_P(datestring, countof(datestring), PSTR("%02u/%02u/%04u %02u:%02u:%02u"),
             now.Day(), now.Month(), now.Year(), now.Hour(), now.Minute(), now.Second());


  int i = 0;

  //Initialize SD Card
  Serial.print("Initializing SD card...");
  if (!SD.begin(SSPin))
  {
    Serial.println("Initialization failed!");
  }
  else
  {
    Serial.println("Initialization done.");
  }

   //Create new file
  myFile = SD.open(file_no1, FILE_WRITE);

  if (myFile)
  {
    Serial.print("File created on: ");
    Serial.println(datestring);
    Serial.print("File: ");
    Serial.println(file_no1);
    Serial.print("Created for ");
    Serial.println(route_no);

    myFile.print("Created on: ");
    myFile.print(datestring);
    myFile.print(" Created for: ");
    myFile.println(route_no);
  }
 
  //Take readings till number of reqd
  while (i < readings)
  {           
              state = digitalRead(15);
              while(state)
              {
                  state = digitalRead(15);
                  yield();
              }
              yield();
              //Calculate RSSI
              delay(300);
              rssi=WiFi.RSSI();
              delay(300);
              rssi+=WiFi.RSSI();
              delay(300);
              rssi+=WiFi.RSSI();
              new_rssi=rssi/3;

              Serial.print("RSSI= ");
              Serial.println(new_rssi);

              //Write RSSI to file
              wrt_rssi=(-1)*new_rssi;
              myFile.print(wrt_rssi);
              myFile.print(" ");

              //Begin motor rotation
              analogWriteFreq(490);
              analogWrite(16, 511);
              yield();
              
              digitalWrite(14, LOW);
              digitalWrite(0, HIGH);

              
              delay(2500);
              yield();

              Serial.println("Motor Ok");
              digitalWrite(14, LOW);
              digitalWrite(0, LOW);
              analogWrite(16, 0);
              yield();    
              delay(2500); 
              
              ++i;
  }
  
  myFile.println();
  myFile.print("Number of readings: ");
  myFile.println(i);
  myFile.print("Distance: ");
  myFile.println(distance);
  myFile.close();

  Serial.println("SD Card Log Completed");
  Serial.println("------------------");

  //Update current file no and route no to EEPROM for future use
  if (curr_route_val == 3)
  {
    curr_route_val = 0;
  }
  else
  {
    curr_route_val += 1;
  }

  curr_file_no += 1;

  EEPROM.write(addr_route, highByte(curr_route_val)); //writing the first half
  EEPROM.write(addr_route + 1, lowByte(curr_route_val)); //writing second half

  Serial.print("Next Route: ");
  Serial.println(curr_route_val);

  EEPROM.write(addr_file, highByte(curr_file_no)); //writing the first half
  EEPROM.write(addr_file + 1, lowByte(curr_file_no)); //writing second half

  Serial.print("New file no: ");
  Serial.println(curr_file_no);

  Serial.println("---- Data written to EEPROM ----");

  EEPROM.commit();

}

void loop()
{
  yield();
}
