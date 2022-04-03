#include <Arduino_JSON.h>

String server = "104.198.225.231";
String ssid = "CLARO_8D038B";
String password = "74C9369A29";
int ledPin = 8;

//variables para enviar al servidor
float temperature = 23;


void setup() {
  pinMode(ledPin, OUTPUT);   // Configuramos el ledPin como output
  delay(500) ;
  Serial.begin(115200);
  Serial3.begin(115200);
  Serial3.setTimeout(2000);

  //Verificamos si el ESP8266 responde
  Serial3.println("AT");
  if (Serial3.find("OK"))
    Serial.println("Respuesta AT correcto");
  else
    Serial.println("Error en ESP8266");

  //-----Configuración de red-------//Podemos comentar si el ESP ya está configurado

  //ESP8266 en modo estación (nos conectaremos a una red existente)
  Serial3.println("AT+CWMODE=1");
  if (Serial3.find("OK"))
    Serial.println("ESP8266 en modo Estacion");

  //Nos conectamos a una red wifi
  connectWifi();

  //Desabilitamos las conexiones multiples
  Serial3.println("AT+CIPMUX=0");
  if (Serial3.find("OK"))
    Serial.println("Multiconexiones deshabilitadas");

  //------fin de configuracion-------------------

  delay(1000);

}

//reset the esp8266 module
void reset() {
  Serial3.println("AT+RST");
  delay(1000);
  if (Serial3.find("OK") ) Serial.println("Module Reset");
}

//connect to your wifi network
void connectWifi() {
  String cmd = "AT+CWJAP=\"" + ssid + "\",\"" + password + "\"";
  Serial3.println(cmd);
  Serial.println("Conectandose a la red ...");
  Serial3.setTimeout(30000); //Aumentar si demora la conexion
  if (Serial3.find("OK")) {
    Serial.println("Connected!");
  }
  else {
    connectWifi();
    Serial.println("Cannot connect to wifi");
  }
  Serial3.setTimeout(2000);
}


void loop() {

  //Nos conectamos con el servidor:

  getIllumination();
  delay(60000);

  sendMagnitudes();
  delay(60000);
}

void getIllumination() {
  String uri = "/automation";
  Serial3.println("AT+CIPSTART=\"TCP\",\"" + server + "\",3000"); //start a TCP connection.
  if (Serial3.find("OK"))
  {
    Serial.println("TCP connection ready");
    delay(1000);

    //Armamos el encabezado de la peticion http
    String getRequest =
      "GET " + uri + " HTTP/1.0\r\n" +
      "Host: " + server + "\r\n" +
      "\r\n";

    //Enviamos el tamaño en caracteres de la peticion http:
    Serial3.print("AT+CIPSEND=");
    Serial3.println(String(getRequest.length()));
    delay(500);

    //esperamos a ">" para enviar la petcion  http
    if (Serial3.find(">")) // ">" indica que podemos enviar la peticion http
    {
      Serial.println("Sending HTTP . . .");
      Serial3.println(getRequest);

      if (Serial3.find("SEND OK"))
      {
        Serial.println("Packet sent");
        boolean conc = false;
        boolean fin_respuesta = false;
        String cadena = "";
        String response = "";

        while (fin_respuesta == false)
        {
          while (Serial3.available())
          {
            char c = Serial3.read();
            cadena.concat(c);
            if (c == '{')conc = true;
            if (conc) response.concat(c);//guardamos la respuesta en el string "cadena"
            if (c == '}')conc = false;
          }
          //si recibimos un CLOSED significa que ha finalizado la respuesta
          if (cadena.indexOf("CLOSED") > 0) {
            JSONVar myObject = JSON.parse(response);
            if (myObject["illumination"])
            {
              digitalWrite(ledPin, HIGH); // Prendemos la LED
            }
            else
            {
              digitalWrite(ledPin, LOW); // Apagamos la LED
            }
            fin_respuesta = true;
          }
        }

        // close the connection
        Serial3.println("AT+CIPCLOSE");
        Serial.println(response);
        Serial.println();

      }
      else
      {
        Serial.println("No se ha podido enviar HTTP.....");
      }
    }
  }
  else
  {
    Serial.println("No se ha podido conectarse con el servidor");
  }
}

void sendMagnitudes () {
  String uri = "/magnitudes";
  Serial3.println("AT+CIPSTART=\"TCP\",\"" + server + "\",3000"); //start a TCP connection.
  if (Serial3.find("OK"))
  {
    Serial.println("TCP connection ready");
    delay(1000);

    float decimal = random(0, 99);
    decimal = decimal / 100;
    temperature = random(22, 28);
    temperature = temperature + decimal;
    String data = "{\"temperature\":" + String(temperature) + ", \"device\": \"iot-001\"}";
    //Armamos el encabezado de la peticion http
    String postRequest =
      "POST " + uri + " HTTP/1.0\r\n" +
      "Host: " + server + "\r\n" +
      "Accept: *" + "/" + "*\r\n" +
      "Content-Length: " + String(data.length()) + "\r\n" +
      "Content-Type: application/json\r\n" +
      "\r\n" + data;

    //Enviamos el tamaño en caracteres de la peticion http:
    Serial3.print("AT+CIPSEND=");
    Serial3.println(String(postRequest.length()));
    delay(500);

    //esperamos a ">" para enviar la petcion  http
    if (Serial3.find(">")) // ">" indica que podemos enviar la peticion http
    {
      Serial.println("Sending HTTP . . .");
      Serial3.println(postRequest);

      if (Serial3.find("SEND OK"))
      {
        Serial.println("Packet sent");
        while (Serial3.available())
        {
          String cadena = Serial3.readString();
          Serial.println(cadena);
        }
        // close the connection
        Serial3.println("AT+CIPCLOSE");
        Serial.println();
      }
      else
      {
        Serial.println("No se ha podido enviar HTTP.....");
      }
    }
  }
  else
  {
    Serial.println("No se ha podido conectarse con el servidor");
  }
}
