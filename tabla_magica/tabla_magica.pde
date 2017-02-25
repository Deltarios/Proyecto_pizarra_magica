import processing.serial.*;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 ** 25/02/2017
 ** Creado Por: Ariel Arturo Ríos Sierra
  ** Contacto: arturi.marking@gmail.com
 */

private Serial puerto;

private Date fecha;
private SimpleDateFormat formatoFecha;

private int potIzq;
private int potDer;
private int botonReset;

private int x;
private int y;

private int x2;
private int y2;

private int rojoAleatorio = (int) (Math.random() * 255);
private int verdAleatorio = (int) (Math.random() * 255);
private int azulAleatorio = (int) (Math.random() * 255);

void setup() {
  size(600, 600);

  printArray(Serial.list());

  String nombrePuerto = Serial.list()[1];

  puerto = new Serial(this, nombrePuerto, 9600);

  puerto.bufferUntil('\n');

  background(rojoAleatorio, verdAleatorio, azulAleatorio);

  x = 0;
  y = 0;
}

void draw() {

  lecturaPuertoSerial();
  x2 = (potIzq * (width - 1)) / 1023;

  y2 = (potDer * (height - 1)) / 1023;

  if (botonReset == 1) {
    clear();
    background((y * 255) / 1023, ((x * y) * 255) / (1046529), (x * 255) / 1023);
  }
  stroke((x * 255) / 1023, (y * 255) / 1023, ((x * y) * 255) / (1046529));
  line(x, y, x2, y2);
  noStroke();
  x = x2;
  y = y2;
}

void lecturaPuertoSerial() {
  if (puerto.available() > 0) {
    String inPuerto = puerto.readStringUntil('\n');

    if (inPuerto != null) {
      inPuerto = trim(inPuerto);
      int indexSplit = inPuerto.indexOf("-");
      int ultimoIndexSplit = inPuerto.lastIndexOf("-");
      int ultimoIndex = inPuerto.length();
      if (inPuerto.length() > 4) {

        String inDato1 = inPuerto.substring(0, indexSplit);
        String inDato2 = null;
        try {
          inDato2 = inPuerto.substring(indexSplit + 1, ultimoIndexSplit);
          try {
            potDer = Integer.parseInt(inDato2);
          } 
          catch (NumberFormatException e) {
            println(e);
          }
        } 
        catch(StringIndexOutOfBoundsException e) {
          println(e);
        }

        String inDato3 = inPuerto.substring(ultimoIndexSplit + 1, ultimoIndex);

        potIzq = Integer.parseInt(inDato1);
        botonReset = Integer.parseInt(inDato3);

        println("Potenciometro izquierdo: " + potIzq +" Potenciometro derecho: " + potDer + " Boton: " + botonReset);
      }
    }
  }
}

void keyPressed() {
  fecha = new Date();
  formatoFecha = new SimpleDateFormat("dd-MMMM-yyyy-hh-mm-ss");

  String fechaArchivo = formatoFecha.format(fecha);

  if (key == 's') {
    save("imagen-"+ fechaArchivo +".jpg");
    text("Imagen guardada", width / 2, height / 2 );
  }
}