/**
 ** 25/02/2017
 ** Creado Por: Ariel Arturo Ríos Sierra
 ** Contacto: arturi.marking@gmail.com
*/

const int potIzquierdo = A0;
const int potDerecho = A1;
const int botonReset = 5;

int potIzquierdoDato = 0;
int potDerchoDato = 0;
bool valorBoton = false;

void setup() {
  pinMode(potIzquierdo, INPUT);
  pinMode(potDerecho, INPUT);
  pinMode(botonReset, INPUT_PULLUP);
  Serial.begin(9600);
}

void loop() {
  potIzquierdoDato = analogRead(potIzquierdo);
  potDerchoDato = analogRead(potDerecho);

  int outBoton = datoBoton();

  String potFormatoDatoIzq = String(potIzquierdoDato);
  String potFormatoDatoDer = String(potDerchoDato);

  String datos = (potFormatoDatoIzq + "-" + potFormatoDatoDer + "-" + outBoton);
  Serial.println(datos);
  delay(200);
}

int datoBoton() {
  valorBoton = lecturaBoton();
  int valor = 0;

  if (valorBoton) {
    return valor = 1;
  } else {
    return valor = 0;
  }
}

bool lecturaBoton() {
  bool estadoBoton = digitalRead(botonReset);
  if (estadoBoton) {
    return valorBoton = true;
  } else {
    return valorBoton = false;
  }
}
