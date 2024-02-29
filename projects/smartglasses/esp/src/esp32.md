```#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_ST7789.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include "esp_task_wdt.h"
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

// ST7789
#define TFT_CS    14
#define TFT_RST   2
#define TFT_DC    15
#define TFT_SCL   18
#define TFT_SDA   23
Adafruit_ST7789 tft = Adafruit_ST7789(TFT_CS, TFT_DC, TFT_RST);
// Assumed fixed character width
const int CHAR_WIDTH = 1;
// MPU6050 - I2C
Adafruit_MPU6050 mpu;
float x, y, z;
// TFMini-S - UART
#define RXD2 16
#define TXD2 17

unsigned char check;        /*----save check value------------------------*/
unsigned char uart[9];  /*----save data measured by LiDAR-------------*/
const int HEADER=0x59; /*----frame header of data package------------*/
int rec_debug_state = 0x01;//receive state for frame

// Setup WiFi & MQTT Info
const char *ssid = "<SSID>";
const char *password = "<PASSWORD>";
const char *mqtt_server = "<IP>";
WiFiClient espClient;
PubSubClient client(espClient);

// reconnect to MQTT
void reconnect() {
    while (!client.connected()) {
        Serial.println("Connecting to MQTT...");

        if (client.connect("ESP32Client")) {
            Serial.println("Connected to MQTT");

            // Subscribe to the desired topics after a successful connection
            client.subscribe("python/print");
            client.subscribe("python/measure");
            
        } else {
            Serial.print("Failed, rc=");
            Serial.print(client.state());
            Serial.println(" Retrying in 3 seconds...");
            delay(3000);
        }
    }
}

void printText(const char* text) {
    tft.setTextSize(2);
    tft.setTextColor(ST77XX_WHITE);
    tft.setCursor(0, 0);

    int lineSpacing = 15;  // spacing between lines
    int lineHeight = tft.height() / lineSpacing;
    int currentLine = 0;

    // Iterate through each character in the text
    for (int i = 0; text[i] != '\0'; i++) {
        tft.print(text[i]);
        // Move the cursor to the next line if needed
        if (tft.getCursorX() + CHAR_WIDTH >= tft.width()) {
            tft.setCursor(0, tft.getCursorY() + lineSpacing);
            currentLine++;
        }
        // Check if the current line is full
        if (currentLine * lineSpacing >= tft.height()) {
            // Clear the screen and reset the cursor to the top
            tft.fillScreen(ST77XX_BLACK);
            tft.setCursor(0, 0);
            currentLine = 0;
        }
        delay(45); // Adjust the delay time as needed
        esp_task_wdt_reset();
    }
}

int Get_Lidar_data(){
    int dist = 0;
    while (dist<=0){
        if (Serial2.available()) { //check if serial port has data input
            if(rec_debug_state == 0x01){  //the first byte
                uart[0]=Serial2.read();
                if(uart[0] == 0x59)
                {
                    check = uart[0];
                    rec_debug_state = 0x02;
                }
            }
        else if(rec_debug_state == 0x02){//the second byte
            uart[1]=Serial2.read();
            if(uart[1] == 0x59){
                check += uart[1];
                rec_debug_state = 0x03;
            }
            else{
                rec_debug_state = 0x01;
            }
        }
        else if(rec_debug_state == 0x03)
                {
                    uart[2]=Serial2.read();
                    check += uart[2];
                    rec_debug_state = 0x04;
                }
        else if(rec_debug_state == 0x04)
                {
                    uart[3]=Serial2.read();
                    check += uart[3];
                    rec_debug_state = 0x05;
                }
        else if(rec_debug_state == 0x05)
                {
                    uart[4]=Serial2.read();
                    check += uart[4];
                    rec_debug_state = 0x06;
                }
        else if(rec_debug_state == 0x06)
                {
                    uart[5]=Serial2.read();
                    check += uart[5];
                    rec_debug_state = 0x07;
                }
        else if(rec_debug_state == 0x07)
                {
                    uart[6]=Serial2.read();
                    check += uart[6];
                    rec_debug_state = 0x08;
                }
        else if(rec_debug_state == 0x08)
                {
                    uart[7]=Serial2.read();
                    check += uart[7];
                    rec_debug_state = 0x09;
                }
        else if(rec_debug_state == 0x09)
                {
                    uart[8]=Serial2.read();
                    if(uart[8] == check)
                    {
                        
                        dist = uart[2] + uart[3]*256;//the distance
                        //strength = uart[4] + uart[5]*256;//the strength
                        //temprature = uart[6] + uart[7] *256;//calculate chip temprature
                        //temprature = temprature/8 - 256;                              
                        Serial.print("dist = ");
                        Serial.print(dist); //output measure distance value of LiDAR
                        Serial.print('\n');
                        //Serial.print("strength = ");
                        //Serial.print(strength); //output signal strength value
                        //Serial.print('\n');
                        // Serial.print("\t Chip Temprature = ");
                        // Serial.print(temprature);
                        // Serial.println(" celcius degree"); //output chip temperature of Lidar                                                       
                        while(Serial2.available()){Serial2.read();} // This part is added becuase some previous packets are there in the buffer so to clear serial buffer and get fresh data.
                        delay(100);
                    }
                    rec_debug_state = 0x01;
                }
            }
    }
    return dist;
}

void capture_angle(){
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);
        // Calculate pitch and roll using accelerometer data
    x = atan2(a.acceleration.y, sqrt(a.acceleration.x * a.acceleration.x + a.acceleration.z * a.acceleration.z)) * RAD_TO_DEG;
    y = atan2(-a.acceleration.x, a.acceleration.z) * RAD_TO_DEG;
    z = atan2(-a.acceleration.z, a.acceleration.x) * RAD_TO_DEG;

    Serial.print("X: ");
    Serial.print(x);
    Serial.print(" | Y: ");
    Serial.print(y);
    Serial.print(" | Z: ");
    Serial.println(z);
}

void callback(char *topic, byte *payload, unsigned int length) {
    Serial.print("Received message from topic: ");
    Serial.println(topic);

    Serial.print("Message: ");
    for (int i = 0; i < length; i++) {
        Serial.print((char)payload[i]);
    }
    Serial.println();

    // Handle the received data based on the topic
    if (strcmp(topic, "python/print") == 0) {
        // Process data from "python/print" topic
        payload[length] = '\0';  
        tft.fillScreen(ST77XX_BLACK);
        printText((char*)(payload));
        client.publish("esp32/data", "function executed");
        
    }  else if (strcmp(topic, "python/measure") == 0) {
        int dist = Get_Lidar_data();
        dist = Get_Lidar_data();
        capture_angle();

        String result = "dist: " + String(dist) + ", x: " + String(x) + ", y: " + String(y) + ", z: " + String(z);

        client.publish("esp32/measure", result.c_str());

        // Process data from "python/measure" topic
        // Add code to handle image data as needed

    } else {
        // Handle unknown topic
        Serial.println("Unknown topic");
    }
}

void setup() {
    
    Serial.begin(115200);
    // Lidar init
    Serial2.begin(115200);
    // TFT initialize
    tft.init(240, 240, SPI_MODE3);
    tft.setRotation(2); // Adjust the rotation if needed
    tft.fillScreen(ST77XX_BLACK);
    // MPU6050 init
    Wire.begin();
    mpu.begin();
    // Connect to WiFi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi; IP Address: http://");
    Serial.println(WiFi.localIP());
    // Connect to MQTT
    client.setServer(mqtt_server, 1883);
    client.setCallback(callback);
}

void loop() {
    if (!client.connected()) {
        reconnect();
    }

    client.loop();
}
```