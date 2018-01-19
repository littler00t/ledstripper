#include "FastLED.h"
FASTLED_USING_NAMESPACE

#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include "config.h"

CRGB leds[NUM_LEDS];

void initLEDs()
{
    FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS);
    FastLED.setCorrection(TypicalLEDStrip);
    FastLED.setBrightness(255);
    FastLED.setMaxPowerInVoltsAndMilliamps(5, MILLI_AMPS);
    fill_solid(leds, NUM_LEDS, CRGB::Black);  
    FastLED.show();
}

void initWifi()
{
    WiFi.mode(WIFI_STA);
    Serial.printf("Connecting to Wifi %s\n", SSID);
    WiFi.begin(SSID, WIFI_PASSWORD);
    
    if(WiFi.waitForConnectResult() != WL_CONNECTED)
    {
        Serial.printf("WiFi connection failed\n");
        while(true)
        {
            delay(100);
        }
    }
    
    Serial.print("Connected! With IP ");
    Serial.println(WiFi.localIP());
}

WiFiClient espClient;
PubSubClient client(espClient);

void messageReceived(char* topic, unsigned char* payload, unsigned int length)
{
    char message[length + 1];
    strncpy(message, (char*)payload, length);
    message[length] = '\0';

    Serial.printf("Received message on topic '%s': '%s'\n", topic, message);

    //TODO: check topic & handle message
}

void connectMqtt() {
    while (!client.connected()) {
        Serial.printf("connecting to MQTT broker at %s:%d\n", MQTT_SERVER, MQTT_PORT);
        if (client.connect(MQTT_CLIENT, MQTT_USER, MQTT_PASSWORD)) {
            Serial.println("connected");
            char topic[256];
            strncpy(topic, MQTT_BASE_TOPIC, 255);
            topic[255] = '\0';
            strncpy(topic + strlen(MQTT_BASE_TOPIC), "command", 255);
            client.subscribe(topic);
            Serial.printf("Subscribed to '%s'\n", topic);
            strncpy(topic + strlen(MQTT_BASE_TOPIC), "brightness", 255);
            client.subscribe(topic);
            Serial.printf("Subscribed to '%s'\n", topic);
            strncpy(topic + strlen(MQTT_BASE_TOPIC), "speed", 255);
            client.subscribe(topic);
            Serial.printf("Subscribed to '%s'\n", topic);
        }
        else
        {
            Serial.printf("failed to connect: %s, retrying...\n", client.state());
            delay(1000);
        }
    }
}

void initMqtt()
{
    client.setServer(MQTT_SERVER, MQTT_PORT);
    client.setCallback(messageReceived);
    connectMqtt();
}

void setup()
{
    Serial.begin(115200);

    initLEDs();
    initWifi();
    initMqtt();
}

void loop()
{
    connectMqtt();
    client.loop();
    FastLED.show();
    delay(500);
}
