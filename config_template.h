#ifndef CONFIG_H
#define CONFIG_H

#define LED_PIN 3
#define LED_TYPE WS2812
#define COLOR_ORDER GRB
#define NUM_LEDS 150
#define MILLI_AMPS 26000

static const char* SSID = "";
static const char* WIFI_PASSWORD = "";

static const char* MQTT_SERVER = "";
static const uint16_t MQTT_PORT = 1883;
static const char* MQTT_BASE_TOPIC = "/led";
static const char* MQTT_CLIENT = "";
static const char* MQTT_USER = "";
static const char* MQTT_PASSWORD = "";

#endif