#include "FastLED.h"
FASTLED_USING_NAMESPACE

#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include "config.h"
#include "animation.hpp"
#include "rainbow.hpp"
#include "movingrainbow.hpp"
#include "white.hpp"
#include "sparkle.hpp"

CRGB leds[NUM_LEDS];
byte brightness = 255;
unsigned long int delayTime = 100;

void setBrightness(byte brightness) {
      Serial.printf("Setting brightness %i\n", brightness);
      FastLED.setBrightness(brightness);
}

void setDelay(unsigned long int _delay) {
      Serial.printf("Setting delay %i\n", _delay);
      delayTime = _delay;
}

void initLEDs()
{
    FastLED.addLeds<LED_TYPE, LED_PIN, COLOR_ORDER>(leds, NUM_LEDS);
    FastLED.setCorrection(TypicalLEDStrip);
    setBrightness(255);
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

bool isTopic(char* topic, char* expectedTopic) {
    return !strcmp(topic + strlen(MQTT_BASE_TOPIC), expectedTopic);
}

void messageReceived(char* topic, unsigned char* payload, unsigned int length)
{
    char message[length + 1];
    strncpy(message, (char*)payload, length);
    message[length] = '\0';

    Serial.printf("Received message on topic '%s': '%s'\n", topic, message);

    if (isTopic(topic, "brightness"))
    {
        int value = atoi((char *)message) * 255 / 100;
        if (value >= 0 && value <= 255)
        {
            setBrightness(value);
        }
    }
    else if (isTopic(topic, "speed"))
    {
        int value = atoi((char *)message);
        if (value >= 0 && value <= 2000)
        {
            setDelay(value);
        }
    }
    else if (isTopic(topic, "command"))
    {
        switchToAnimation(message);
    }
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

static const uint8_t animationCount = 4;
Animation* animations[animationCount];
Animation* currentAnimation = nullptr;

void initAnimations()
{
    animations[0] = new Rainbow(leds, NUM_LEDS);
    animations[1] = new White(leds, NUM_LEDS);
    animations[2] = new MovingRainbow(leds, NUM_LEDS, 1, NUM_LEDS);
    animations[3] = new Sparkle(leds, NUM_LEDS);
    currentAnimation = animations[0];
}

void switchToAnimation(const char* animation)
{
    fill_solid(leds, NUM_LEDS, CRGB::Black);
    FastLED.show();

    for(size_t i = 0; i < animationCount; ++i)
    {
        if (!strcmp(animations[i]->getName(), animation))
        {
            currentAnimation = animations[i];
        }
    }
}

void setup()
{
    Serial.begin(115200);

    initLEDs();
    initWifi();
    initMqtt();
    initAnimations();
}

void loop()
{
    connectMqtt();
    client.loop();
    EVERY_N_MILLIS_I(frameTimer, delayTime)
    {
        currentAnimation->drawFrame();
    }
    frameTimer.setPeriod( delayTime );
    FastLED.show();
}
