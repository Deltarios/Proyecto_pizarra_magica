/**
 **
 ** 25/02/2017
 ** Creado Por: Ariel Arturo Ríos Sierra
 ** Contacto: arturi.marking@gmail.com
 *
 *************Codigo de pizarra magica*******************
 * Programa para crear una pizarra magica con processing 
 * y Arduino, comunicandolos ambos.
 *
 * Aqui se encuentra toda la logica del programa de la 
 * pizarra la lectura de los datos recibidos del potencio-
 * metro, asi como igual, el posterior guardado de la imagen
 ******************************************************** 
 */

import processing.serial.*;
import java.util.Date;
import java.text.SimpleDateFormat;

// Variable para crear un objeto de tipo Serial
private Serial puerto;
// Variable para crear una fecha.
private Date fecha;
// Variable para el formato de la fecha 
private SimpleDateFormat formatoFecha;

// Almacena el valor del poteciometro izquierdo
private int potIzq;
// Almacena el valor del potenciometro derecho
private int potDer;
// Almacena el estado del boton 
private int botonReset;

// La posicion de la coordenada inicial en x
private int x;
// La posicion de la coordenada inicial en y
private int y;

// La posicion de la coordenada actualizada en x
private int x2;
// La posicion de la coordenada actualizada en y
private int y2;

/**
 * Crear 3 variables para el espectro RGB generados de manera aleatoria.
 */
private int rojoAleatorio = (int) (Math.random() * 255);
private int verdAleatorio = (int) (Math.random() * 255);
private int azulAleatorio = (int) (Math.random() * 255);

// Inicializa una sola vez las variables de configuracion
void setup() {
  // Establece el tamaño de la pantalla del programa
  size(600, 600);

  // Imprime en consola los nombres los puertos disponibles
  printArray(Serial.list());

  // Obtenemos el nombre del puerto serial 1 *En MAC* en windows es el 0
  String nombrePuerto = Serial.list()[1];

  // Creamos un objeto de puerto serial, para obtener los datos del Arduino
  puerto = new Serial(this, nombrePuerto, 9600);

  // Se envia una nueva linea de datos
  puerto.bufferUntil('\n');

  // Establecemos el color de fondo al principio con valores aleatorios
  background(rojoAleatorio, verdAleatorio, azulAleatorio);

  // Iniciamos el valor incial de la coordenada en x
  x = 0;
  // Iniciamos el valor incial de la coordenada en y
  y = 0;
}

void draw() {

  // Leemos los datos que recibmos con el arduino
  lecturaPuertoSerial();

  // Actualiza el valor de la coordenada en x, con el nuevo valor de potenciometro
  x2 = (potIzq * (width - 1)) / 1023;

  // Actualiza el valor de la coordenada en y, con el nuevo valor de potenciometro
  y2 = (potDer * (height - 1)) / 1023;

  // Comprobamos el valor recibido en el boton si esta es 1, borramos la pantalla
  if (botonReset == 1) {
    // Limpiamos la pantalla
    clear();
    // Establemos un nuevo fondo, con la ultima posicion de nuestros potenciometros
    background((y * 255) / 1023, ((x * y) * 255) / (1046529), (x * 255) / 1023);
  }

  // Le damos colores a la linea
  stroke((x * 255) / 1023, (y * 255) / 1023, ((x * y) * 255) / (1046529));
  // Dibujamos una nueva linea con base a las coordenadas actuales y las anteriores
  line(x, y, x2, y2);
  // Dejamos de colorear las lineas (Solo para que no se coloree lo demas)
  noStroke();

  // Actualizamos nuestras nuevas coordenadas en x, para eliminar las anteriores
  x = x2;
  // Actualizamos nuestras nuevas coordenadas en y, para eliminar las anteriores
  y = y2;
}

/**
 * Esta funcion hace una lectura de datos enviados por nuestro Arduino, desde un puerto serial
 * toma los valores, de una cadena de tipo String y la divide en partes 
 * y se asigna a sus correspondientes variables
 * aqui se encuentran los datos de los potenciometros y el boton para resetear
 * debe recibir un valor de tipo String como: "xxxx-xxxx-x"
 * donde x es cualquier numero de 0 al 1023
 */
void lecturaPuertoSerial() {
  // Verificamos si hay puertos disponibles
  if (puerto.available() > 0) {
    // Leemos nuestro puerto de datos con la informacion del Arduino (Elegir el puerto donde está el Arduino)
    String inPuerto = puerto.readStringUntil('\n');

    // Comprobamos si la entrada del puerto no esta vacia (Para no tener errores)
    if (inPuerto != null) {
      // Eliminamos cualquier espacio en blanco que se genere
      inPuerto = trim(inPuerto);
      // Obtenemos la primera posicion donde se encuentre el guion alto '-'
      int indexSplit = inPuerto.indexOf("-");
      // Obtenemos la ultima posicion donde tenemos un guion alto '-'
      int ultimoIndexSplit = inPuerto.lastIndexOf("-");
      // Obtenemos el tamaño total del cadena de caracteres
      int ultimoIndex = inPuerto.length();

      // Comprobamos que la cadena no sea menor a 5 caracteres si es menor podruce errores
      if (inPuerto.length() > 4) {

        // Protegemos de un posible error de index fuera de string a la variable 
        try {
          // Creamos y le asignamos el primer dato en un string, para posteriomente darselo a la variable del potIzq
          String inDato1 = inPuerto.substring(0, indexSplit);
          // Creamos y le asignamos el segundo dato en un string, para posteriomente darselo a la variable del potIzq
          String inDato2 = inPuerto.substring(indexSplit + 1, ultimoIndexSplit);
          // Creamos y le asignamos el tercer dato en un string, para posteriomente darselo a la variable del potIzq
          String inDato3 = inPuerto.substring(ultimoIndexSplit + 1, ultimoIndex);

          // Protegemos de un error a la variable de tipo formato de numero excepcion 
          try { 
            // Le asignamos a la variable el primer Split(parte) de la cadena recibida ya convertida a Integer(Entero)
            potIzq = Integer.parseInt(inDato1);

            // Le asignamos a la variable el segundo Split(parte) de la cadena recibida ya convertida a Integer(Entero)
            potDer = Integer.parseInt(inDato2);

            // Le asignamos a la variable el tercer Split(parte) de la cadena recibida ya convertida a Integer(Entero)
            botonReset = Integer.parseInt(inDato3);
          }
          // Atrapamos la excepcion
          catch (NumberFormatException e) {
            // Imprimimos en pantalla el error si ocurre
            println(e);
          }
        } 
        // Atrapamos la excepcion
        catch(StringIndexOutOfBoundsException e) {
          // Imprimimos en pantalla el error si ocurre
          println(e);
        }

        // Escribimos en pantalla los valores reales de los potenciometros y el boton 
        println("Potenciometro izquierdo: " + potIzq +" Potenciometro derecho: " + potDer + " Boton: " + botonReset);
      }
    }
  }
}

/**
 * Funcion creada para cuando se detecta un evento de tecla presionada se guarda la imagen
 * en una ruta especifica y con una tecla definida en esta funcion
 */
void keyPressed() {
  // Verificamos si la tecla precionada es la 's' para guarda la imagen
  if (key == 's') {
    // Creamos un objeto de tipo Date para usarlo para obtener la fecha actual
    fecha = new Date();
    // Especificamos que tipo de forma de la fecha queremos
    formatoFecha = new SimpleDateFormat("dd-MMMM-yyyy-hh-mm-ss");

    // Convertimos en String la fecha, para darselo como nombre de defecto de la imagen
    String fechaArchivo = formatoFecha.format(fecha);
    // Guardamos la imagen en una carpeta imagenes, con el nombre de "imagen-fechaArchivo" en formato jpg
    save("imagenes/imagen-"+ fechaArchivo +".jpg");

    // Creamos una fuente para la pantalla, del mensaje de notificacion de imagen guardada
    PFont fuente = loadFont("Arial-Black-20.vlw");
    // Definimos el tamaño de la letra
    textSize(20);
    // Llamos a la fuente creada previamente
    textFont(fuente);
    // Mostramos en la pantalla del programa, un mensaje de notificacion de que se ha guardado la imagen
    text("Imagen guardada", width / 2 - 100, height / 2 - 20);
  }
}
