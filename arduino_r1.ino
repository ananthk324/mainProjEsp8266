#include <EEPROM.h>
#include <SoftwareSerial.h>

#define DIST 100
#define READNS 20


//EEPROM and File IO
int addr_route = 0;
int curr_route_val = 0;
String route_no = String("Route no: ");
byte high, low;

//Distance to be travelled in cms
String distance = String(DIST)+String(" cm"); 
int readings = READNS;
int j = 0;
int state = 0;

//Software serial interface to connect to ESP8266
const byte rxPin = 3;
const byte txPin = 4;
SoftwareSerial ESP8266(rxPin, txPin);
String inData;

//Print fucntion for ESP Response
void ESPPrint()
{
  delay(300);
  if(ESP8266.available())
  {
     inData = ESP8266.readStringUntil('\t');
     Serial.println("Reponse: " +inData);
  }
}


void setup()
{
  //Initializes board I/O
  Serial.begin(9600);
  Serial.println(" ");
  
  //Change baudrate to match ESP
  ESP8266.begin(9600);

  //Configure board pins
  pinMode(8,OUTPUT);
  pinMode(9,OUTPUT);
  pinMode(12,INPUT);
  
  //Read current route number from EEPROM
  high = EEPROM.read(addr_route);
  low = EEPROM.read(addr_route + 1);
  curr_route_val = (high << 8) + low; //reconstruct the integer
  route_no += curr_route_val;


  //Update current file no and route no to EEPROM for future use
  int new_route_val;
  if (curr_route_val == 3)
  {
    new_route_val = 0;
  }
  else
  {
    new_route_val = curr_route_val + 1;
  }


  EEPROM.write(addr_route, highByte(new_route_val)); //writing the first half
  EEPROM.write(addr_route + 1, lowByte(new_route_val)); //writing second half

  Serial.print("Next Route: ");
  Serial.println(new_route_val);
  Serial.println("---- Data written to EEPROM ----");

  //Add AT commands here
//  ESP8266.println("AT");
//  ESPPrint();
//  ESP8266.println("AT+CWSAP_DEF=\"ESP_WIFI\",\"ESP12345\",1,4");
//  ESPPrint();
  delay(3500);
  
  while(j < readings)
  {
    state = digitalRead(12);
    while(state)
    {
      state = digitalRead(12);
      delay(0);
    }
    delay(1000);
    //Begin motor rotation
    analogWrite(5, 160);

    digitalWrite(8, HIGH);
    digitalWrite(9, LOW);

    delay(2500);
    
    Serial.println("Motor Ok");
    
    digitalWrite(8, LOW);
    digitalWrite(9, LOW);
    analogWrite(5, 0);

    delay(2500);
    
    ++j;

  }
 
}

void loop()
{
  delay(0);
}
