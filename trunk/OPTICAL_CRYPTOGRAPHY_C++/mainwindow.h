#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QMessageBox>
#include <QImage>
#include <QFileDialog>
#include <QTimer>
#include <QTcpServer>
#include <QTcpSocket>
#include <QNetworkSession>
#include <QtNetwork>
#include <cv.h>
#include <highgui.h>
#include <stdlib.h>
#include <time.h>
#include "qtipl.h"


namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    
private:
    Ui::MainWindow *ui;

	//GENERAR LLAVE
	int Alto_Llave, Ancho_Llave, Tipo_Distribucion; //Parámetros de entrada para generar la Máscara de Fase (Llave de Encriptación).
	CvRNG Numeros_Aleatorios;						//Punto semilla para generar números aleatorios;
	IplImage *Llave_Generar;						//Estructura para almacenar la Llave generada.
	IplImage *Llave_Generar_Visualizar;				//Estructura para visualizar la Llave generada.
	bool Validar_Generar_Fase();					//Valida los parámetros de entrada para generar la Máscara de Fase (Llave de Encriptación).

	//ENCRIPTAR IMAGEN
	int Alto_Imagen_Encriptar;
	int Ancho_Imagen_Encriptar;
	int Alto_Llave_Imagen_Encriptar;
	int Ancho_Llave_Imagen_Encriptar;
	int Canales_Imagen_Encriptar;
    int Tipo_Imagen_Encriptar;
	IplImage *Imagen_Entrada_Encriptar;
	IplImage *Imagen_Entrada_Encriptar_Visualizar;
    IplImage *Imagen_Salida_Encriptar;
	IplImage *Imagen_Salida_Encriptar_Visualizar;
	IplImage *Llave_Entrada_Encriptar;
    IplImage *Llave_Entrada_Encriptar_Visualizar;
	bool Validar_Imagen_Encriptar();

	//DECRIPTAR IMAGEN
	int Alto_Imagen_Decriptar;
	int Ancho_Imagen_Decriptar;
	int Alto_Llave_Imagen_Decriptar;
	int Ancho_Llave_Imagen_Decriptar;
	int Canales_Imagen_Decriptar;
    int Tipo_Imagen_Decriptar;
	IplImage *Imagen_Entrada_Decriptar;
	IplImage *Imagen_Entrada_Decriptar_Visualizar;
    IplImage *Imagen_Salida_Decriptar;
	IplImage *Imagen_Salida_Decriptar_Visualizar;
	IplImage *Llave_Entrada_Decriptar;
    IplImage *Llave_Entrada_Decriptar_Visualizar;
	bool Validar_Imagen_Decriptar();

	//ENCRIPTAR VIDEO
	bool ServidorON;
	bool EncriptarVideoON;
    bool EmitirVideoON;
	bool PlayVideoEncriptar;
	bool Llave_Determina_Dimensiones;
	int Alto_Llave_Video_Encriptar;
	int Ancho_Llave_Video_Encriptar;
	int Alto_Visualizar_Video_Encriptar;
	int Ancho_Visualizar_Video_Encriptar;
	QTimer *Temporizador_Video_Encriptar;
	QTcpServer *ServidorTCPEncriptarVideo;
	QNetworkSession *Sesion_Red_Video_Encriptar;

	IplImage *Llave_Video_Encriptar;
	IplImage *Llave_Video_Encriptar_Visualizar;
	IplImage *Llave_Redimensionar_Video_Encriptar_Visualizar;
	IplImage *Imagen_Entrada_Video_Encriptar;
	IplImage *Imagen_Entrada_Video_Encriptar_Visualizar;
	IplImage *Imagen_Salida_Video_Encriptar;
	IplImage *Imagen_Salida_Video_Encriptar_Visualizar;

	IplImage *Imagen_Redimensionada_Entrada_Video_Encriptar_Visualizar;

	CvCapture *CapturaVideoEncriptar;
	int ID_Device;


	//DECRIPTAR VIDEO
	bool ClienteON;
	bool DecriptarVideoON;
	bool LlavePemiteRecibir;
	bool RecibirVideoON;
	bool Llave_Determina_Dimensiones_Video_Decriptar;
	int Alto_Llave_Video_Decriptar;
	int Ancho_Llave_Video_Decriptar;
	int Ancho_Visualizar_Video_Decriptar;
	int Alto_Visualizar_Video_Decriptar;
	QTimer *Temporizador_Video_Decriptar;

	QTcpSocket *SocketTCP_Cliente_Video_Decriptar;
	QNetworkSession *Sesion_Red_Video_Decriptar;
	quint16 blockSize;

	IplImage *Llave_Video_Decriptar;
	IplImage *Llave_Video_Decriptar_Visualizar;
	IplImage *Llave_Redimensionar_Video_Decriptar_Visualizar;
	IplImage *Imagen_Entrada_Video_Decriptar;
	IplImage *Imagen_Entrada_Video_Decriptar_Visualizar;
	IplImage *Imagen_Redimensionar_Entrada_Video_Decriptar_Visualizar;
	IplImage *Imagen_Salida_Video_Decriptar;
	IplImage *Imagen_Salida_Video_Decriptar_Visualizar;
	IplImage *Imagen_Redimensionar_Salida_Video_Decriptar_Visualizar;



	//FUNCIONES CRIPTOGRAFÍA ÓPTICA
	void Generar_Mascara_Fase(IplImage *, CvRNG); //Genera una Máscara de Fase Aleatoria de tipo IplImage con  IPL_DEPTH_64F y de dos canales (Canal Real y Canal Imaginario).

	void Encriptar(IplImage *, IplImage *, IplImage *); // El primer argumento de esta funcion, es una imagen de IPL_DEPTH_8U y un canal, el segundo argumento es la mascara de fase utilizada
                                                    // para encriptar y el tercer argumento es la informacion encriptada de tipo IPL_DEPTH_64F y dos canales.

	void Desencriptar(IplImage *, IplImage *, IplImage *); // El primer argumento de esta funcion es una imagen encriptada de tipo IPL_DEPTH_64F y 2 canales, el segundo argumento es la mascara de fase
                                                       // utilizada para desencriptar la informacion y el tercer arguemtno es la imagen desencriptada de tipo IPL_DEPTH_64F y dos canales.

	void Conjugar_Mascara(IplImage *);    // Obtiene el conjugado complejo de una imagen de tipo IPL_DEPTH_64F y dos canales (Canal Real y Canal Imaginario).

	void cvShiftDFT(CvArr *, CvArr *);    // Ordena ejes cuando se aplica una transformada de fourier discreta, para poderla observar apropiadamente.

	void cvMultiplicar(CvMat *, IplImage *, IplImage *);  // Multiplica (Multiplicacion de Numeros complejos) 2 arreglos, el primero de tipo CvMat y el segundo de tipo IplImage y guarda el resultado en un arreglo de tipo IplImage. Todos los arreglos tienen formato  IPL_DEPTH_64F y dos canales (Imaginario).

	void cvMultiplicar2(IplImage *, IplImage *, IplImage *); // Multiplica 2 arreglos de tipo IplImage y guarda el resultado en un arreglo de tipo IplImage. Todos los arreglos tienen formato  IPL_DEPTH_64F y dos canales (Imaginario).

	void Obtner_Fourier_2show(CvMat *, IplImage *);   // Esta funcion permite obtener un IplImage (IPL_DEPTH_8U y 1 Canal) adecuado para poder visualizar  una transformada de fourier discreta (CvMat).

	void Obtner_ENCRIPT_DESENCRIPT_2show(IplImage *, IplImage *); // Esta funcion permite obtener un IplImage (IPL_DEPTH_8U y 1 Canal) adecuado para poder visualizar  IplImage de tipo IPL_DEPTH_64F y 2 Canales.

	void Obtner_MASCARA_FASE_2show(IplImage *, IplImage *); // Esta funcion permite obtener un IplImage (IPL_DEPTH_8U y 1 Canal) adecuado para poder visualizar  IplImage de tipo IPL_DEPTH_64F y 2 Canales.

	void Obtener_Histograma(IplImage *, IplImage *); //Grafica el histograma de una imagen de un solo canal.


private slots:
	// GENERAR FASE
	void Generar_Mascara_Fase();
	void Guardar_Mascara_Fase();
	void Cargar_Mascara_Fase();
	// FIN GENERAR FASE

	// ENCRIPTAR IMAGEN
	void Cargar_Imagen_Entrada_Encriptar();
	void Cargar_Llave_Imagen_Encriptar();
	void Encriptar_Imagen();
	void Guardar_Imagen_Salida_Encriptar();
	// FIN ENCRIPTAR IMAGEN

	// ENCRIPTAR IMAGEN
	void Cargar_Imagen_Entrada_Decriptar();
	void Cargar_Llave_Imagen_Decriptar();
	void Decriptar_Imagen();
	void Guardar_Imagen_Salida_Decriptar();
	// FIN ENCRIPTAR IMAGEN

	// ENCRIPTAR VIDEO
	void Encriptar_Video();
	void Cargar_Llave_Video_Encriptar();
    void Iniciar_Captura_Video_Encriptar();
	void Actualizar_Imagenes_Video_Encriptar();
    void Iniciar_Servidor_Video_Encriptar();
	void Empezar_Emitir_Video_Encriptado();
	void Sesion_Abierta_Video_Encriptar();
	void Enviar_Imagen_Video_Encriptar();
	// FIN ENCRIPTAR VIDEO

	// DECRIPTAR VIDEO
	void Decriptar_Video();
	void Cargar_Llave_Video_Decriptar();
	void Iniciar_Cliente_Video_Decriptar();
	void Recibir_Cliente_Video_Decriptar();
	void Sesion_Abierta_Video_Decriptar();
	void Empezar_Recibir_Video_Encriptado();
	void Mostrar_Errores_Conexion_Video_Decritpar(QAbstractSocket::SocketError socketError);
	void Actualizar_Imagenes_Video_Decriptar();
	//void requestNewFortune();
	void Decritpar_Nueva_Imagen();
    void Tomar_Foto_Video_Decriptar();
	// FIN DECRIPTAR VIDEO


};

#endif // MAINWINDOW_H
