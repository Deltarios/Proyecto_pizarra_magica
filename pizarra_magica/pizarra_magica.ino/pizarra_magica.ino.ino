/**
 ** 25/02/2017
 ** Creado Por: Ariel Arturo Ríos Sierra
 ** Contacto: arturi.marking@gmail.com

 * **********Pizarra Mágica*************
   Este codigo de Arduino contiene todo
   para la lectura de dos potenciometros
   y un boton, que se usa para el funcionamiento
   de un codigo en Processing, este es para
   el funcionamiento de todos los sensores,
   y hardware del proyecto.
*/

// Variable del pin del potenciometro izquierdo
const int potIzquierdo = A0;
// Variable del pin del potenciometro derecho
const int potDerecho = A1;
// Variable del pin del botón
const int botonReset = 5;

// Variable para almacenar los datos del potenciometro izquierdo
int potIzquierdoDato = 0;
// Variable para almacenar los datos del potenciometro derecho
int potDerchoDato = 0;
// Valor booleano del boton definido inicialmente como falso
bool valorBoton = false;

// Configuraciones iniciales de los pines
void setup() {
  // Se inicia como entrada el potenciometro izquierdo
  pinMode(potIzquierdo, INPUT);
  // Se inicia como entrada el potenciometro derecho
  pinMode(potDerecho, INPUT);
  // Se inicia como entrada el botón
  pinMode(botonReset, INPUT_PULLUP);
  // Se inicia el monitor serial a 9600 baudios
  Serial.begin(9600);
}

// Se crea la lectura de datos de forma ciclica
void loop() {
  // Leemos los datos recibidos por el potenciometro izquierdo
  // desde su pin A0 de forma analogica
  potIzquierdoDato = analogRead(potIzquierdo);
  // Leemos los datos recibidos por el potenciometro derecho
  // desde su pin A1 de forma analogica
  potDerchoDato = analogRead(potDerecho);

  // Lemos la entrada del boton que posteriormente
  // sera nuestra salida, hacemos un llamado a la funcion datoBoton()
  int outBoton = datoBoton();

  // Le damos formato de string a lo recibido del potenciometro
  String potFormatoDatoIzq = String(potIzquierdoDato);
  // Le damos formato de string a lo recibido del potenciometro
  String potFormatoDatoDer = String(potDerchoDato);

  // Creamos una cadena de datos con todos los valores
  String datos = (potFormatoDatoIzq + "-" + potFormatoDatoDer + "-" + outBoton);
  // Enviamos al monitor serial todos los datos
  Serial.println(datos);
  // Esperamos 200 milisegundos para no saturar el sistema
  delay(200);
}

/**
    Se crea la funcion para devolver en forma de entero el
    estado del boton, para saber si esta prendido o apagado
    @return valor
*/
int datoBoton() {
  // Le asigana el valor al boton es un bool
  valorBoton = lecturaBoton();
  // Creamos la variable para almacenar y devolver el valor
  int valor = 0;

  // Verificamos su estado
  if (valorBoton) {
    // Si es verdadero devolvera 1
    return valor = 1;
  } else {
    // Si es falso devolvera 0
    return valor = 0;
  }
}

/**
   Funcion encargada de la lectura del boton
   para posteriormente asignarle un valor
   verdadero o falso dependiendo su estado
   esta funcion devuelve un bool
   @return valorBoton
*/
bool lecturaBoton() {
  // Creamos e inicializamos con el valor digital del boton (0-1)
  bool estadoBoton = digitalRead(botonReset);
  // Si es 1 devolvemos verdadero, si es 0 devolvemos falso
  return estadoBoton;
}
