#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent), ui(new Ui::MainWindow), ServidorTCPEncriptarVideo(0), Sesion_Red_Video_Encriptar(0), Sesion_Red_Video_Decriptar(0)
{
    ui->setupUi(this);

	// GENERAR LLAVE CONSTRUCTOR
	Alto_Llave = 20;
	Ancho_Llave = 20;
	Tipo_Distribucion = 0;
	Numeros_Aleatorios = cvRNG(1);
	srand (time(NULL));
	Llave_Generar = 0;
	Llave_Generar_Visualizar = 0;

	connect(ui->toolButtonGenerarLlave, SIGNAL(clicked()), this, SLOT(Generar_Mascara_Fase()));
	connect(ui->toolButtonGuardarLlave, SIGNAL(clicked()), this, SLOT(Guardar_Mascara_Fase()));
	connect(ui->toolButtonAbrirLlave, SIGNAL(clicked()), this, SLOT(Cargar_Mascara_Fase()));
	// FIN GENERAR LLAVE CONSTRUCTOR



	// ENCRIPTAR IMAGEN CONSTRUCTOR
	Alto_Imagen_Encriptar = 0;
	Ancho_Imagen_Encriptar = 0;
	Alto_Llave_Imagen_Encriptar = 0;
	Ancho_Llave_Imagen_Encriptar = 0;

	Llave_Entrada_Encriptar = 0;
	Llave_Entrada_Encriptar_Visualizar = 0;
	Imagen_Entrada_Encriptar = 0;
	Imagen_Entrada_Encriptar_Visualizar = 0;
	Imagen_Salida_Encriptar = 0;
	Imagen_Salida_Encriptar_Visualizar = 0;

	connect(ui->toolButtonCargarLlaveImagenEncriptar, SIGNAL(clicked()), this, SLOT(Cargar_Llave_Imagen_Encriptar()));
	connect(ui->toolButtonCargarImagenEncriptar, SIGNAL(clicked()), this, SLOT(Cargar_Imagen_Entrada_Encriptar()));
	connect(ui->toolButtonEncriptarImagen, SIGNAL(clicked()), this, SLOT(Encriptar_Imagen()));
	connect(ui->toolButtonGuardarImagenEncriptar, SIGNAL(clicked()), this, SLOT(Guardar_Imagen_Salida_Encriptar()));	
	// FIN ENCRIPTAR IMAGEN CONSTRUCTOR

	// DECRIPTAR IMAGEN CONSTRUCTOR
	Alto_Imagen_Decriptar = 0;
	Ancho_Imagen_Decriptar = 0;
	Alto_Llave_Imagen_Decriptar = 0;
	Ancho_Llave_Imagen_Decriptar = 0;

	Llave_Entrada_Decriptar = 0;
	Llave_Entrada_Decriptar_Visualizar = 0;
	Imagen_Entrada_Decriptar = 0;
	Imagen_Entrada_Decriptar_Visualizar = 0;
	Imagen_Salida_Decriptar = 0;
	Imagen_Salida_Decriptar_Visualizar = 0;

	connect(ui->toolButtonCargarLlaveImagenDecriptar, SIGNAL(clicked()), this, SLOT(Cargar_Llave_Imagen_Decriptar()));
	connect(ui->toolButtonCargarImagenDecriptar, SIGNAL(clicked()), this, SLOT(Cargar_Imagen_Entrada_Decriptar()));
	connect(ui->toolButtonDecriptarImagen, SIGNAL(clicked()), this, SLOT(Decriptar_Imagen()));
	connect(ui->toolButtonGuardarImagenDecriptar, SIGNAL(clicked()), this, SLOT(Guardar_Imagen_Salida_Decriptar()));	
	// FIN DECRIPTAR IMAGEN CONSTRUCTOR


	// ENCRIPTAR VIDEO
	EncriptarVideoON = false;
	ServidorON = false;
	EmitirVideoON = false;
	Llave_Determina_Dimensiones = true;
	PlayVideoEncriptar = false;
	Alto_Llave_Video_Encriptar = 0;
	Ancho_Llave_Video_Encriptar = 0;
	Alto_Visualizar_Video_Encriptar = 240;
	Ancho_Visualizar_Video_Encriptar = 320;

	Llave_Redimensionar_Video_Encriptar_Visualizar = 0;
	Llave_Video_Encriptar = 0;
	Llave_Video_Encriptar_Visualizar = 0;
	Imagen_Entrada_Video_Encriptar = 0;
	Imagen_Entrada_Video_Encriptar_Visualizar = 0;
	Imagen_Redimensionada_Entrada_Video_Encriptar_Visualizar = 0;
	Imagen_Salida_Video_Encriptar = 0;
	Imagen_Salida_Video_Encriptar_Visualizar = 0;
    
	QNetworkConfigurationManager manager;
    if (manager.capabilities() & QNetworkConfigurationManager::NetworkSessionRequired) {
        // Obtener configuraciones de red guardadas.
        QSettings settings(QSettings::UserScope, QLatin1String("Trolltech"));
        settings.beginGroup(QLatin1String("QtNetwork"));
        const QString id = settings.value(QLatin1String("DefaultNetworkConfiguration")).toString();
        settings.endGroup();

        // Si no se encuentr alguna, utiliza la del sistema pro defecto.
        QNetworkConfiguration config = manager.configurationFromIdentifier(id);
        if ((config.state() & QNetworkConfiguration::Discovered) !=
            QNetworkConfiguration::Discovered) {
            config = manager.defaultConfiguration();
        }

        Sesion_Red_Video_Encriptar = new QNetworkSession(config, this);
        connect(Sesion_Red_Video_Encriptar, SIGNAL(opened()), this, SLOT(Sesion_Abierta_Video_Encriptar()));

        Sesion_Red_Video_Encriptar->open();
    } else {
        Sesion_Abierta_Video_Encriptar();
    }

	CapturaVideoEncriptar = 0;
	ID_Device = 0;
	Temporizador_Video_Encriptar = new QTimer(this);

	connect(ui->toolButtonEncriptarVideo, SIGNAL(clicked()), this, SLOT(Encriptar_Video()));
	connect(ui->toolButtonCargarLlaveVideoEncritpar, SIGNAL(clicked()), this, SLOT(Cargar_Llave_Video_Encriptar()));
	connect(ui->toolButtonIniciarCapturaVideoEncritpar, SIGNAL(clicked()), this, SLOT(Iniciar_Captura_Video_Encriptar()));
	connect(Temporizador_Video_Encriptar, SIGNAL(timeout()), this, SLOT(Actualizar_Imagenes_Video_Encriptar()));
	connect(ui->toolButtonHabilitarServidor, SIGNAL(clicked()), this, SLOT(Iniciar_Servidor_Video_Encriptar()));
	connect(ui->toolButtonEmitir, SIGNAL(clicked()), this, SLOT(Empezar_Emitir_Video_Encriptado()));
	connect(ServidorTCPEncriptarVideo, SIGNAL(newConnection()), this, SLOT(Enviar_Imagen_Video_Encriptar()));
	
	// FIN ENCRIPTAR VIDEO


	// DECRIPTAR VIDEO
	DecriptarVideoON = false;
	ClienteON = false;
	Llave_Determina_Dimensiones_Video_Decriptar = true;
	LlavePemiteRecibir = false;
	RecibirVideoON = false;
	Alto_Llave_Video_Decriptar = 0;
	Ancho_Llave_Video_Decriptar = 0;
	Ancho_Visualizar_Video_Decriptar = 320;
	Alto_Visualizar_Video_Decriptar = 240;
	Temporizador_Video_Decriptar = new QTimer(this);
	
	//////////////////
	SocketTCP_Cliente_Video_Decriptar = new QTcpSocket(this);
    QNetworkConfigurationManager manager2;
    if (manager2.capabilities() & QNetworkConfigurationManager::NetworkSessionRequired) {
        // Obtener configuración de red guardada.
        QSettings settings(QSettings::UserScope, QLatin1String("Trolltech"));
        settings.beginGroup(QLatin1String("QtNetwork"));
        const QString id = settings.value(QLatin1String("DefaultNetworkConfiguration")).toString();
        settings.endGroup();

        // Utilizar la del sistema por defecto en caso de no obtener la guardada.
        QNetworkConfiguration config = manager2.configurationFromIdentifier(id);
        if ((config.state() & QNetworkConfiguration::Discovered) !=
            QNetworkConfiguration::Discovered) {
            config = manager2.defaultConfiguration();
        }

        Sesion_Red_Video_Decriptar = new QNetworkSession(config, this);
        connect(Sesion_Red_Video_Decriptar, SIGNAL(opened()), this, SLOT(Sesion_Abierta_Video_Decriptar()));
        Sesion_Red_Video_Decriptar->open();
     } 

	//////////////////
	Llave_Video_Decriptar = 0;
	Llave_Video_Decriptar_Visualizar = 0;
	Llave_Redimensionar_Video_Decriptar_Visualizar = 0;

	Imagen_Entrada_Video_Decriptar = 0;
	Imagen_Entrada_Video_Decriptar_Visualizar = 0;
	Imagen_Redimensionar_Entrada_Video_Decriptar_Visualizar = 0;
	Imagen_Salida_Video_Decriptar = 0;
	Imagen_Salida_Video_Decriptar_Visualizar = 0;
	Imagen_Redimensionar_Salida_Video_Decriptar_Visualizar = 0;

	connect(ui->toolButtonDecriptarVideo, SIGNAL(clicked()), this, SLOT(Decriptar_Video()));
	connect(ui->toolButtonCargarLlaveVideoDecriptar, SIGNAL(clicked()), this, SLOT(Cargar_Llave_Video_Decriptar()));
	connect(ui->toolButtonHabilitarCliente, SIGNAL(clicked()), this, SLOT(Iniciar_Cliente_Video_Decriptar()));
	connect(ui->toolButtonRecibir, SIGNAL(clicked()), this, SLOT(Recibir_Cliente_Video_Decriptar()));
	connect(SocketTCP_Cliente_Video_Decriptar, SIGNAL(readyRead()), this, SLOT(Empezar_Recibir_Video_Encriptado()));
    connect(SocketTCP_Cliente_Video_Decriptar, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(Mostrar_Errores_Conexion_Video_Decritpar(QAbstractSocket::SocketError)));
	connect(Temporizador_Video_Decriptar, SIGNAL(timeout()), this, SLOT(Actualizar_Imagenes_Video_Decriptar()));
	connect(ui->toolButtonIniciarCapturaVideoDecriptar, SIGNAL(clicked()), this, SLOT(Tomar_Foto_Video_Decriptar()));

    connect(SocketTCP_Cliente_Video_Decriptar, SIGNAL(readyRead()), this, SLOT(Empezar_Recibir_Video_Encriptado()));


	// FIN DECRIPTAR VIDEO
	Temporizador_Video_Encriptar->start(5);
	Temporizador_Video_Decriptar->start(5);
}

MainWindow::~MainWindow()
{
    delete ui;
	if(CapturaVideoEncriptar)
		cvReleaseCapture(&CapturaVideoEncriptar);

}


//GENERAR LLAVE
void MainWindow::Generar_Mascara_Fase()
{

	ui->lineEditAltoAbrirLlave->setText(QString(""));
	ui->lineEditAnchoAbrirLlave->setText(QString(""));
	ui->lineEditRutaArchivoLlave->setText(QString(""));

	if (!Validar_Generar_Fase())
	{
		ui->toolButtonGuardarLlave->setEnabled(false);
		ui->labelImagenLlave->setText(QString("Llave Generada/Cargada"));
		QMessageBox msgBox;
		msgBox.setText("Verfica que los parámetros de entrada estén correctos");
		QImage Imagen_Temp;
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/01_Warning_32x32.png"));		
		msgBox.setIconPixmap(QPixmap::fromImage(Imagen_Temp));
		msgBox.exec();
		return;
	}

	if(Llave_Generar)
		cvReleaseImage(&Llave_Generar);

	if(Llave_Generar_Visualizar)
		cvReleaseImage(&Llave_Generar_Visualizar);

	Llave_Generar = cvCreateImage(cvSize(Ancho_Llave, Alto_Llave),IPL_DEPTH_64F, 2);
	Llave_Generar_Visualizar = cvCreateImage(cvSize(Ancho_Llave, Alto_Llave),8, 1);
	Numeros_Aleatorios = cvRNG(rand() % 10000000);
    Generar_Mascara_Fase(Llave_Generar, Numeros_Aleatorios);
    Obtner_MASCARA_FASE_2show(Llave_Generar, Llave_Generar_Visualizar);
	cvSaveImage("TEMP.png",Llave_Generar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));

	ui->toolButtonGuardarLlave->setEnabled(true);	
	ui->labelImagenLlave->setPixmap(QPixmap::fromImage(Imagen_Temp));


    
}
bool MainWindow::Validar_Generar_Fase()
{
     bool validado = false;
	 Alto_Llave = ui->lineEditAltoGenerarLlave->text().toInt();
	 Ancho_Llave = ui->lineEditAnchoGenerarLlave->text().toInt();
	 Tipo_Distribucion = ui->comboBoxTipoDistribucion->currentIndex();
     
	 if ((Alto_Llave <= 0) ||  (Ancho_Llave <= 0))
		 validado = false;
	 else
		 validado = true;
    
	 return validado;

}
void MainWindow::Guardar_Mascara_Fase()
{
    QString Nombre_Archivo_Guardar_Mascara = QFileDialog::getSaveFileName(this, tr("Guardar Llave"), QDir::currentPath(), tr("Archivos XML (*.xml)"));
    if (Nombre_Archivo_Guardar_Mascara.isEmpty())
        return;
	cvSave(Nombre_Archivo_Guardar_Mascara.toLocal8Bit().constData(), Llave_Generar);
}
void MainWindow::Cargar_Mascara_Fase()
{
	QString Nombre_Archivo_Cargar_Mascara = QFileDialog::getOpenFileName(this, tr("Cargar Llave"), QDir::currentPath(), tr("Archivos XML (*.xml)"));
    if (Nombre_Archivo_Cargar_Mascara.isEmpty())
        return;

	if(Llave_Generar)
		cvReleaseImage(&Llave_Generar);

	if(Llave_Generar_Visualizar)
		cvReleaseImage(&Llave_Generar_Visualizar);

	Llave_Generar = (IplImage *)cvLoad(Nombre_Archivo_Cargar_Mascara.toLocal8Bit().constData());
	if(!Llave_Generar)
		return;

	Llave_Generar_Visualizar = cvCreateImage(cvSize(Llave_Generar->width, Llave_Generar->height),8, 1);
	Obtner_MASCARA_FASE_2show(Llave_Generar, Llave_Generar_Visualizar);
	cvSaveImage("TEMP.png",Llave_Generar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));

	ui->labelImagenLlave->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->lineEditAltoAbrirLlave->setText(QString().sprintf("%d", Llave_Generar->height));
	ui->lineEditAnchoAbrirLlave->setText(QString().sprintf("%d", Llave_Generar->width));
	ui->lineEditRutaArchivoLlave->setText(Nombre_Archivo_Cargar_Mascara);
	ui->toolButtonGuardarLlave->setEnabled(false);


}
//FIN GENERAR LLAVE

// ENCRIPTAR IMAGEN
void MainWindow::Cargar_Imagen_Entrada_Encriptar()
{
	QString Nombre_Archivo_Cargar_Imagen_Entrada_Encriptar = QFileDialog::getOpenFileName(this, tr("Cargar Imagen"), QDir::currentPath(), tr("Archivos de Imagen (*.png *.bmp *.jpg)"));
    if (Nombre_Archivo_Cargar_Imagen_Entrada_Encriptar.isEmpty())
        return;

	if(Imagen_Entrada_Encriptar)
		cvReleaseImage(&Imagen_Entrada_Encriptar);

	if(Imagen_Entrada_Encriptar_Visualizar)
		cvReleaseImage(&Imagen_Entrada_Encriptar_Visualizar);

    Imagen_Entrada_Encriptar = cvLoadImage(Nombre_Archivo_Cargar_Imagen_Entrada_Encriptar.toLocal8Bit().constData(), CV_LOAD_IMAGE_GRAYSCALE);
	if(!Imagen_Entrada_Encriptar)
		return;

	Alto_Imagen_Encriptar = Imagen_Entrada_Encriptar->height;
	Ancho_Imagen_Encriptar = Imagen_Entrada_Encriptar->width;

	Imagen_Entrada_Encriptar_Visualizar = cvCreateImage(cvSize(Imagen_Entrada_Encriptar->width, Imagen_Entrada_Encriptar->height),Imagen_Entrada_Encriptar->depth, Imagen_Entrada_Encriptar->nChannels);
	cvCopy(Imagen_Entrada_Encriptar, Imagen_Entrada_Encriptar_Visualizar);
	cvSaveImage("TEMP.png",Imagen_Entrada_Encriptar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));

	ui->labelImagenEntradaEncriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->lineEditAltoImagenEntradaEncriptar->setText(QString().sprintf("%d", Imagen_Entrada_Encriptar->height));
	ui->lineEditAnchoImagenEntradaEncriptar->setText(QString().sprintf("%d", Imagen_Entrada_Encriptar->width));
	ui->lineEditCanalesImagenEntradaEncriptar->setText(QString().sprintf("%d", Imagen_Entrada_Encriptar->nChannels));
	ui->lineEditTipoImagenEntradaEncriptar->setText(QString().sprintf("%d", Imagen_Entrada_Encriptar->depth));

}
void MainWindow::Cargar_Llave_Imagen_Encriptar()
{
	QString Nombre_Archivo_Cargar_Mascara = QFileDialog::getOpenFileName(this, tr("Cargar Llave"), QDir::currentPath(), tr("Archivos XML (*.xml)"));
    if (Nombre_Archivo_Cargar_Mascara.isEmpty())
        return;

	if(Llave_Entrada_Encriptar)
		cvReleaseImage(&Llave_Entrada_Encriptar);

	if(Llave_Entrada_Encriptar_Visualizar)
		cvReleaseImage(&Llave_Entrada_Encriptar_Visualizar);

	Llave_Entrada_Encriptar = (IplImage *)cvLoad(Nombre_Archivo_Cargar_Mascara.toLocal8Bit().constData());
	if(!Llave_Entrada_Encriptar)
		return;

	Alto_Llave_Imagen_Encriptar = Llave_Entrada_Encriptar->height;
	Ancho_Llave_Imagen_Encriptar = Llave_Entrada_Encriptar->width;

	Llave_Entrada_Encriptar_Visualizar = cvCreateImage(cvSize(Llave_Entrada_Encriptar->width, Llave_Entrada_Encriptar->height),8, 1);
	Obtner_MASCARA_FASE_2show(Llave_Entrada_Encriptar, Llave_Entrada_Encriptar_Visualizar);
	cvSaveImage("TEMP.png",Llave_Entrada_Encriptar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));

	ui->labelLlaveImagenEncriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->lineEditAltoLlaveImagenEncriptar->setText(QString().sprintf("%d", Llave_Entrada_Encriptar->height));
	ui->lineEditAnchoLlaveImagenEncriptar->setText(QString().sprintf("%d", Llave_Entrada_Encriptar->width));
	ui->lineEditCanalesLlaveImagenEncriptar->setText(QString().sprintf("%d", Llave_Entrada_Encriptar->nChannels));
	ui->lineEditTipoLlaveImagenEncriptar->setText(QString().sprintf("%d", Llave_Entrada_Encriptar->depth));

}
void MainWindow::Guardar_Imagen_Salida_Encriptar()
{
    QString Nombre_Archivo_Guardar_Imagen_Salida_Encriptar = QFileDialog::getSaveFileName(this, tr("Guardar Imagen Encriptada"), QDir::currentPath(), tr("Archivos XML (*.xml)"));
    if (Nombre_Archivo_Guardar_Imagen_Salida_Encriptar.isEmpty())
        return;
	cvSave(Nombre_Archivo_Guardar_Imagen_Salida_Encriptar.toLocal8Bit().constData(), Imagen_Salida_Encriptar);
}
void MainWindow::Encriptar_Imagen()
{
	if(!Validar_Imagen_Encriptar())
	{
		QMessageBox msgBox;
		msgBox.setText("Debes ingresar Llave e Imagen de Entrada, y/o verficar que sus dimensiones sean iguales");
		QImage Imagen_Temp;
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/01_Warning_32x32.png"));		
		msgBox.setIconPixmap(QPixmap::fromImage(Imagen_Temp));
		msgBox.exec();
		ui->labelImagenSalidaEncriptar->setText(QString("Imagen Encriptada"));
		ui->toolButtonGuardarImagenEncriptar->setEnabled(false);
		return;
	}

    if(Imagen_Salida_Encriptar)
		cvReleaseImage(&Imagen_Salida_Encriptar);
    if(Imagen_Salida_Encriptar_Visualizar)
		cvReleaseImage(&Imagen_Salida_Encriptar_Visualizar);

	Imagen_Salida_Encriptar = cvCreateImage(cvSize(Ancho_Llave_Imagen_Encriptar, Alto_Llave_Imagen_Encriptar),IPL_DEPTH_64F, 2);
	Imagen_Salida_Encriptar_Visualizar = cvCreateImage(cvSize(Ancho_Llave_Imagen_Encriptar, Alto_Llave_Imagen_Encriptar),8, 1);

	Encriptar(Imagen_Entrada_Encriptar, Llave_Entrada_Encriptar, Imagen_Salida_Encriptar);
	Obtner_ENCRIPT_DESENCRIPT_2show(Imagen_Salida_Encriptar, Imagen_Salida_Encriptar_Visualizar);
	cvSaveImage("TEMP.png",Imagen_Salida_Encriptar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));
	ui->labelImagenSalidaEncriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->toolButtonGuardarImagenEncriptar->setEnabled(true);

	ui->lineEditAltoImagenSalidaEncriptar->setText(QString().sprintf("%d",Imagen_Salida_Encriptar->height));
	ui->lineEditAnchoImagenSalidaEncriptar->setText(QString().sprintf("%d",Imagen_Salida_Encriptar->width));
	ui->lineEditCanalesImagenSalidaEncriptar->setText(QString().sprintf("%d",Imagen_Salida_Encriptar->nChannels));
	ui->lineEditTipoImagenSalidaEncriptar->setText(QString().sprintf("%d",Imagen_Salida_Encriptar->depth));

}
bool MainWindow::Validar_Imagen_Encriptar()
{
	bool validado = true;

	if ((Alto_Imagen_Encriptar == 0) || (Alto_Llave_Imagen_Encriptar == 0) || (Ancho_Imagen_Encriptar == 0) || (Ancho_Llave_Imagen_Encriptar == 0))
		return false;

	if((Alto_Imagen_Encriptar != Alto_Llave_Imagen_Encriptar) || (Ancho_Imagen_Encriptar != Ancho_Llave_Imagen_Encriptar))
		validado = false;
	else
        validado = true;

	return validado;
}
// FIN ENCRIPTAR IMAGEN

// DECRIPTAR IMAGEN
void MainWindow::Cargar_Imagen_Entrada_Decriptar()
{
	QString Nombre_Archivo_Cargar_Imagen_Entrada_Decriptar = QFileDialog::getOpenFileName(this, tr("Cargar Imagen Encriptada"), QDir::currentPath(), tr("Archivos XML (*.xml)"));
    if (Nombre_Archivo_Cargar_Imagen_Entrada_Decriptar.isEmpty())
        return;

	if(Imagen_Entrada_Decriptar)
		cvReleaseImage(&Imagen_Entrada_Decriptar);

	if(Imagen_Entrada_Decriptar_Visualizar)
		cvReleaseImage(&Imagen_Entrada_Decriptar_Visualizar);

    Imagen_Entrada_Decriptar = (IplImage *)cvLoad(Nombre_Archivo_Cargar_Imagen_Entrada_Decriptar.toLocal8Bit().constData());
	if(!Imagen_Entrada_Decriptar)
		return;

	Alto_Imagen_Decriptar = Imagen_Entrada_Decriptar->height;
	Ancho_Imagen_Decriptar = Imagen_Entrada_Decriptar->width;

	Imagen_Entrada_Decriptar_Visualizar = cvCreateImage(cvSize(Imagen_Entrada_Decriptar->width, Imagen_Entrada_Decriptar->height),8, 1);
	Obtner_ENCRIPT_DESENCRIPT_2show(Imagen_Entrada_Decriptar, Imagen_Entrada_Decriptar_Visualizar);
	cvSaveImage("TEMP.png",Imagen_Entrada_Decriptar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));

	ui->labelImagenEntradaDecriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->lineEditAltoImagenEntradaDecriptar->setText(QString().sprintf("%d", Imagen_Entrada_Decriptar->height));
	ui->lineEditAnchoImagenEntradaDecriptar->setText(QString().sprintf("%d", Imagen_Entrada_Decriptar->width));
	ui->lineEditCanalesImagenEntradaDecriptar->setText(QString().sprintf("%d", Imagen_Entrada_Decriptar->nChannels));
	ui->lineEditTipoImagenEntradaDecriptar->setText(QString().sprintf("%d", Imagen_Entrada_Decriptar->depth));

}
void MainWindow::Cargar_Llave_Imagen_Decriptar()
{
	QString Nombre_Archivo_Cargar_Mascara = QFileDialog::getOpenFileName(this, tr("Cargar Llave"), QDir::currentPath(), tr("Archivos XML (*.xml)"));
    if (Nombre_Archivo_Cargar_Mascara.isEmpty())
        return;

	if(Llave_Entrada_Decriptar)
		cvReleaseImage(&Llave_Entrada_Decriptar);

	if(Llave_Entrada_Decriptar_Visualizar)
		cvReleaseImage(&Llave_Entrada_Decriptar_Visualizar);

	Llave_Entrada_Decriptar = (IplImage *)cvLoad(Nombre_Archivo_Cargar_Mascara.toLocal8Bit().constData());
	if(!Llave_Entrada_Decriptar)
		return;

	Alto_Llave_Imagen_Decriptar = Llave_Entrada_Decriptar->height;
	Ancho_Llave_Imagen_Decriptar = Llave_Entrada_Decriptar->width;

	Llave_Entrada_Decriptar_Visualizar = cvCreateImage(cvSize(Llave_Entrada_Decriptar->width, Llave_Entrada_Decriptar->height),8, 1);
	Obtner_MASCARA_FASE_2show(Llave_Entrada_Decriptar, Llave_Entrada_Decriptar_Visualizar);
	cvSaveImage("TEMP.png",Llave_Entrada_Decriptar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));

	ui->labelLlaveImagenDecriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->lineEditAltoLlaveImagenDecriptar->setText(QString().sprintf("%d", Llave_Entrada_Decriptar->height));
	ui->lineEditAnchoLlaveImagenDecriptar->setText(QString().sprintf("%d", Llave_Entrada_Decriptar->width));
	ui->lineEditCanalesLlaveImagenDecriptar->setText(QString().sprintf("%d", Llave_Entrada_Decriptar->nChannels));
	ui->lineEditTipoLlaveImagenDecriptar->setText(QString().sprintf("%d", Llave_Entrada_Decriptar->depth));

}
void MainWindow::Guardar_Imagen_Salida_Decriptar()
{
    QString Nombre_Archivo_Guardar_Imagen_Salida_Decriptar = QFileDialog::getSaveFileName(this, tr("Guardar Imagen Decriptada"), QDir::currentPath(), tr("Archivos de Imagen (*.png *.bmp *.jpg)"));
    if (Nombre_Archivo_Guardar_Imagen_Salida_Decriptar.isEmpty())
        return;

	cvSaveImage(Nombre_Archivo_Guardar_Imagen_Salida_Decriptar.toLocal8Bit().constData(), Imagen_Salida_Decriptar_Visualizar);
}
void MainWindow::Decriptar_Imagen()
{
	if(!Validar_Imagen_Decriptar())
	{
		QMessageBox msgBox;
		msgBox.setText("Debes ingresar Llave e Imagen de Entrada Encriptada, y/o verficar que sus dimensiones sean iguales");
		QImage Imagen_Temp;
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/01_Warning_32x32.png"));		
		msgBox.setIconPixmap(QPixmap::fromImage(Imagen_Temp));
		msgBox.exec();
		ui->labelImagenSalidaDecriptar->setText(QString("Imagen Decriptada"));
		ui->toolButtonGuardarImagenDecriptar->setEnabled(false);
		return;
	}

    if(Imagen_Salida_Decriptar)
		cvReleaseImage(&Imagen_Salida_Decriptar);
    if(Imagen_Salida_Decriptar_Visualizar)
		cvReleaseImage(&Imagen_Salida_Decriptar_Visualizar);

	Imagen_Salida_Decriptar = cvCreateImage(cvSize(Ancho_Llave_Imagen_Decriptar, Alto_Llave_Imagen_Decriptar),IPL_DEPTH_64F, 2);
	Imagen_Salida_Decriptar_Visualizar = cvCreateImage(cvSize(Ancho_Llave_Imagen_Decriptar, Alto_Llave_Imagen_Decriptar),8, 1);

	Desencriptar(Imagen_Entrada_Decriptar, Llave_Entrada_Decriptar, Imagen_Salida_Decriptar);
	Obtner_ENCRIPT_DESENCRIPT_2show(Imagen_Salida_Decriptar, Imagen_Salida_Decriptar_Visualizar);
	cvSaveImage("TEMP.png",Imagen_Salida_Decriptar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));
	ui->labelImagenSalidaDecriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->toolButtonGuardarImagenDecriptar->setEnabled(true);

	ui->lineEditAltoImagenSalidaDecriptar->setText(QString().sprintf("%d",Imagen_Salida_Decriptar->height));
	ui->lineEditAnchoImagenSalidaDecriptar->setText(QString().sprintf("%d",Imagen_Salida_Decriptar->width));
	ui->lineEditCanalesImagenSalidaDecriptar->setText(QString().sprintf("%d",Imagen_Salida_Decriptar->nChannels));
	ui->lineEditTipoImagenSalidaDecriptar->setText(QString().sprintf("%d",Imagen_Salida_Decriptar->depth));


}
bool MainWindow::Validar_Imagen_Decriptar()
{
	bool validado = true;

	if ((Alto_Imagen_Decriptar == 0) || (Alto_Llave_Imagen_Decriptar == 0) || (Ancho_Imagen_Decriptar == 0) || (Ancho_Llave_Imagen_Decriptar == 0))
		return false;

	if((Alto_Imagen_Decriptar != Alto_Llave_Imagen_Decriptar) || (Ancho_Imagen_Decriptar != Ancho_Llave_Imagen_Decriptar))
		validado = false;
	else
        validado = true;

	return validado;
}
// FIN DECRIPTAR IMAGEN

// ENCRIPTAR VIDEO
void MainWindow::Encriptar_Video()
{
	EncriptarVideoON = !EncriptarVideoON;

	QImage Imagen_Temp;
	QString Texto_Encriptar;
	QString Titulo_GroupBox_Video_Encriptado;
    QString Titulo_Label_Video_Encriptado;

	if(EncriptarVideoON)
	{
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/noencrypt.png"));	
		Texto_Encriptar.sprintf("NO ENCRIPTAR");
		Titulo_GroupBox_Video_Encriptado.sprintf("VIDEO ENCRIPTADO - MAGNITUD");
		Titulo_Label_Video_Encriptado.sprintf("Video Encriptado");
	}else{
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/encrypt.png"));	
		Texto_Encriptar.sprintf("ENCRIPTAR");
		Titulo_GroupBox_Video_Encriptado.sprintf("VIDEO NO ENCRIPTADO - MAGNITUD");
		Titulo_Label_Video_Encriptado.sprintf("Video NO Encriptado");
	}

	ui->toolButtonEncriptarVideo->setIcon(QIcon(QPixmap::fromImage(Imagen_Temp)));
	ui->toolButtonEncriptarVideo->setText(Texto_Encriptar);
	ui->groupBoxVideoEncriptado->setTitle(Titulo_GroupBox_Video_Encriptado);
	ui->labelVideoSalidaEncriptar->setText(Titulo_Label_Video_Encriptado);

	


}
void MainWindow::Cargar_Llave_Video_Encriptar()
{
	QString Nombre_Archivo_Cargar_Mascara = QFileDialog::getOpenFileName(this, tr("Cargar Llave"), QDir::currentPath(), tr("Archivos XML (*.xml)"));
    if (Nombre_Archivo_Cargar_Mascara.isEmpty())
        return;

	if(Llave_Video_Encriptar)
		cvReleaseImage(&Llave_Video_Encriptar);

	if(Llave_Video_Encriptar_Visualizar)
		cvReleaseImage(&Llave_Video_Encriptar_Visualizar);

	if(Llave_Redimensionar_Video_Encriptar_Visualizar)
		cvReleaseImage(&Llave_Redimensionar_Video_Encriptar_Visualizar);

	Llave_Video_Encriptar = (IplImage *)cvLoad(Nombre_Archivo_Cargar_Mascara.toLocal8Bit().constData());
	if(!Llave_Video_Encriptar)
		return;

	Alto_Llave_Video_Encriptar = Llave_Video_Encriptar->height;
	Ancho_Llave_Video_Encriptar = Llave_Video_Encriptar->width;

	Llave_Video_Encriptar_Visualizar = cvCreateImage(cvSize(Llave_Video_Encriptar->width, Llave_Video_Encriptar->height),8, 1);
	Obtner_MASCARA_FASE_2show(Llave_Video_Encriptar, Llave_Video_Encriptar_Visualizar);
	Llave_Redimensionar_Video_Encriptar_Visualizar = cvCreateImage(cvSize(Ancho_Visualizar_Video_Encriptar, Alto_Visualizar_Video_Encriptar),8,1);
	cvResize(Llave_Video_Encriptar_Visualizar, Llave_Redimensionar_Video_Encriptar_Visualizar, CV_INTER_LINEAR);
	cvSaveImage("TEMP.png",Llave_Redimensionar_Video_Encriptar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));

	ui->labelLlaveVideoEncriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->lineEditAltoLlaveVideoEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->height));
	ui->lineEditAnchoLlaveVideoEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->width));
	ui->lineEditCanalesLlaveVideoEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->nChannels));
	ui->lineEditTipoLlaveVideoEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->depth));
	ui->toolButtonIniciarCapturaVideoEncritpar->setEnabled(true);

	//ESTABLECIENDO DIMENSIONES DE DE VIDEO DE ENTRADA Y ENCRIPTADO IGUALES A LAS DIMENSIONES DE LA LLAVE
	if (Llave_Determina_Dimensiones)
	{
		ui->lineEditAltoVideoEntradaEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->height));
		ui->lineEditAnchoVideoEntradaEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->width));
		ui->lineEditCanalesVideoEntradaEncriptar->setText(QString().sprintf("%d", 1));
		ui->lineEditTipoVideoEntradaEncriptar->setText(QString().sprintf("%d", 8));

		ui->lineEditAltoVideoSalidaEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->height));
		ui->lineEditAnchoVideoSalidaEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->width));
		ui->lineEditCanalesVideoSalidaEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->nChannels));
		ui->lineEditTipoVideoSalidaEncriptar->setText(QString().sprintf("%d", Llave_Video_Encriptar->depth));
	}

	//////////////////////////////////////////////////////////////////////////////////////////////////////////

}
void MainWindow::Iniciar_Captura_Video_Encriptar()
{
	PlayVideoEncriptar = !PlayVideoEncriptar;
	QImage Imagen_Temp;
	QString Texto_Encriptar;

	if(PlayVideoEncriptar)
	{
		if(CapturaVideoEncriptar)
			cvReleaseCapture(&CapturaVideoEncriptar);

		CapturaVideoEncriptar = cvCaptureFromCAM(ID_Device);

		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/Stop.png"));	
		Texto_Encriptar.sprintf("STOP");

	}else{
		if(CapturaVideoEncriptar)
			cvReleaseCapture(&CapturaVideoEncriptar);
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/simulate.png"));	
		Texto_Encriptar.sprintf("PLAY");

	}

	ui->toolButtonEmitir->setEnabled(ServidorON & PlayVideoEncriptar);
	ui->toolButtonIniciarCapturaVideoEncritpar->setIcon(QIcon(QPixmap::fromImage(Imagen_Temp)));
	ui->toolButtonIniciarCapturaVideoEncritpar->setText(Texto_Encriptar);


	if (!(ServidorON & PlayVideoEncriptar) && EmitirVideoON)
		Empezar_Emitir_Video_Encriptado();
}
void MainWindow::Actualizar_Imagenes_Video_Encriptar()
{
	if((!PlayVideoEncriptar) || (!CapturaVideoEncriptar))
		return;

	Imagen_Entrada_Video_Encriptar = cvQueryFrame(CapturaVideoEncriptar);
	if(Imagen_Entrada_Video_Encriptar_Visualizar)
		cvReleaseImage(&Imagen_Entrada_Video_Encriptar_Visualizar);
    
	if(Imagen_Redimensionada_Entrada_Video_Encriptar_Visualizar)
		cvReleaseImage(&Imagen_Redimensionada_Entrada_Video_Encriptar_Visualizar);

	Imagen_Redimensionada_Entrada_Video_Encriptar_Visualizar = cvCreateImage(cvSize(Ancho_Llave_Video_Encriptar, Alto_Llave_Video_Encriptar),8,1);
	Imagen_Entrada_Video_Encriptar_Visualizar = cvCreateImage(cvSize(Imagen_Entrada_Video_Encriptar->width, Imagen_Entrada_Video_Encriptar->height),8,1);
	cvCvtColor(Imagen_Entrada_Video_Encriptar, Imagen_Entrada_Video_Encriptar_Visualizar,CV_BGR2GRAY);
	cvResize(Imagen_Entrada_Video_Encriptar_Visualizar,Imagen_Redimensionada_Entrada_Video_Encriptar_Visualizar,CV_INTER_LINEAR);

	if(Imagen_Entrada_Video_Encriptar_Visualizar)
		cvReleaseImage(&Imagen_Entrada_Video_Encriptar_Visualizar);

	Imagen_Entrada_Video_Encriptar_Visualizar = cvCreateImage(cvSize(Ancho_Visualizar_Video_Encriptar, Alto_Visualizar_Video_Encriptar),8,1);
	cvResize(Imagen_Redimensionada_Entrada_Video_Encriptar_Visualizar, Imagen_Entrada_Video_Encriptar_Visualizar, CV_INTER_LINEAR);

    QImage Imagen_Temp(IplImage2QImage(Imagen_Entrada_Video_Encriptar_Visualizar));
	ui->labelVideoEntradaEncriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));

	if(EncriptarVideoON)
	{
		if(Imagen_Salida_Video_Encriptar)
			cvReleaseImage(&Imagen_Salida_Video_Encriptar);

		if(Imagen_Salida_Video_Encriptar_Visualizar)
			cvReleaseImage(&Imagen_Salida_Video_Encriptar_Visualizar);
		
		Imagen_Salida_Video_Encriptar = cvCreateImage(cvSize(Ancho_Llave_Video_Encriptar, Alto_Llave_Video_Encriptar), Llave_Video_Encriptar->depth, Llave_Video_Encriptar->nChannels);
		Imagen_Salida_Video_Encriptar_Visualizar = cvCreateImage(cvSize(Ancho_Llave_Video_Encriptar, Alto_Llave_Video_Encriptar), 8, 1);
		
		Encriptar(Imagen_Redimensionada_Entrada_Video_Encriptar_Visualizar, Llave_Video_Encriptar, Imagen_Salida_Video_Encriptar);
		Obtner_ENCRIPT_DESENCRIPT_2show(Imagen_Salida_Video_Encriptar, Imagen_Salida_Video_Encriptar_Visualizar);
		cvResize(Imagen_Salida_Video_Encriptar_Visualizar, Imagen_Entrada_Video_Encriptar_Visualizar, CV_INTER_LINEAR);
		
		QImage Imagen_Temp(IplImage2QImage(Imagen_Entrada_Video_Encriptar_Visualizar));
		ui->labelVideoSalidaEncriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));


	}else{
		ui->labelVideoSalidaEncriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));	
	}

}
void MainWindow::Sesion_Abierta_Video_Encriptar()
{
    // Guarda la configuración utilizada.
    if (Sesion_Red_Video_Encriptar) {
        QNetworkConfiguration config = Sesion_Red_Video_Encriptar->configuration();
        QString id;
        if (config.type() == QNetworkConfiguration::UserChoice)
            id = Sesion_Red_Video_Encriptar->sessionProperty(QLatin1String("UserChoiceConfiguration")).toString();
        else
            id = config.identifier();

        QSettings settings(QSettings::UserScope, QLatin1String("Trolltech"));
        settings.beginGroup(QLatin1String("QtNetwork"));
        settings.setValue(QLatin1String("DefaultNetworkConfiguration"), id);
        settings.endGroup();
    }

    ServidorTCPEncriptarVideo = new QTcpServer(this);
    if (!ServidorTCPEncriptarVideo->listen()) {
        QMessageBox::critical(this, tr("Fortune Server"),
                              tr("Unable to start the server: %1.")
                              .arg(ServidorTCPEncriptarVideo->errorString()));
        close();
        return;
    }
    QString ipAddress;
    QList<QHostAddress> ipAddressesList = QNetworkInterface::allAddresses();
    // Utiliza la primera dirección non-localhost IPv4.
    for (int i = 0; i < ipAddressesList.size(); ++i) {
        if (ipAddressesList.at(i) != QHostAddress::LocalHost &&
            ipAddressesList.at(i).toIPv4Address()) {
            ipAddress = ipAddressesList.at(i).toString();
            break;
        }
    }
    // Si no se encuentra alguno, utiliza localhost IPv4.
    if (ipAddress.isEmpty())
        ipAddress = QHostAddress(QHostAddress::LocalHost).toString();
	ui->lineEditIPServidor->setText(tr("%1").arg(ipAddress));
	ui->lineEditPuertoServidor->setText(tr("%2").arg(ServidorTCPEncriptarVideo->serverPort()));

}

void MainWindow::Enviar_Imagen_Video_Encriptar()
{	
	////////////////////////////////////
	
	QString *information_string = new QString(QString::fromLocal8Bit(Imagen_Salida_Video_Encriptar->imageData, Imagen_Salida_Video_Encriptar->imageSize));

    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_0);
    out << (quint16)0;
	out << *information_string;
    out.device()->seek(0);
    out << (quint16)(block.size() - sizeof(quint16));

    QTcpSocket *clientConnection = ServidorTCPEncriptarVideo->nextPendingConnection();
    connect(clientConnection, SIGNAL(disconnected()),
            clientConnection, SLOT(deleteLater()));

	if(EmitirVideoON)
		clientConnection->write(block);

    clientConnection->disconnectFromHost();
	delete information_string;
}
void MainWindow::Empezar_Emitir_Video_Encriptado()
{
    EmitirVideoON = !EmitirVideoON;


	QImage Imagen_Temp;
	QString Texto_Encriptar;
	QString Texto_Emitir_Encriptar;

	if(EmitirVideoON)
	{
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/nobroadcasting.png"));	
		Texto_Encriptar.sprintf("NO EMITIR");
		Texto_Emitir_Encriptar.sprintf("EMITIENDO!");
	}else{
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/broadcasting.png"));	
		Texto_Encriptar.sprintf("EMITIR");
		Texto_Emitir_Encriptar.sprintf("NO EMITIENDO!");
	}
	ui->toolButtonEmitir->setIcon(QIcon(QPixmap::fromImage(Imagen_Temp)));
	ui->toolButtonEmitir->setText(Texto_Encriptar);  
	ui->labelEstadoEmitirImagenVideoEncriptar->setText(Texto_Emitir_Encriptar);
}

void MainWindow::Iniciar_Servidor_Video_Encriptar()
{
	ServidorON = !ServidorON;

	if (ServidorON)
		ui->labelHabilitarServidorON->setText(QString("ON"));
	else
		ui->labelHabilitarServidorON->setText(QString("OFF"));

	ui->toolButtonEmitir->setEnabled(ServidorON & PlayVideoEncriptar);
	
	ui->lineEditIPServidor->setEnabled(ServidorON);
	ui->lineEditPuertoServidor->setEnabled(ServidorON);

	if (!(ServidorON & PlayVideoEncriptar) && EmitirVideoON)
		Empezar_Emitir_Video_Encriptado();

}
// FIN ENCRIPTAR VIDEO

// DECRIPTAR VIDEO
void MainWindow::Decriptar_Video()
{
	DecriptarVideoON = !DecriptarVideoON;

	QImage Imagen_Temp;
	QString Texto_Decriptar;
	QString Titulo_GroupBox_Video_Decriptado;
    QString Titulo_Label_Video_Decriptado;

	if(DecriptarVideoON)
	{
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/nodecrypt.png"));	
		Texto_Decriptar.sprintf("NO DECRIPTAR");
		Titulo_GroupBox_Video_Decriptado.sprintf("VIDEO DECRIPTADO - MAGNITUD");
		Titulo_Label_Video_Decriptado.sprintf("Video Decriptado");
	}else{
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/decrypt.png"));	
		Texto_Decriptar.sprintf("DECRIPTAR");
		Titulo_GroupBox_Video_Decriptado.sprintf("VIDEO NO DECRIPTADO - MAGNITUD");
		Titulo_Label_Video_Decriptado.sprintf("Video NO Decriptado");
	}

	ui->toolButtonDecriptarVideo->setIcon(QIcon(QPixmap::fromImage(Imagen_Temp)));
	ui->toolButtonDecriptarVideo->setText(Texto_Decriptar);
	ui->groupBoxVideoDecriptado->setTitle(Titulo_GroupBox_Video_Decriptado);
	ui->labelVideoSalidaDecriptar->setText(Titulo_Label_Video_Decriptado);
}
void MainWindow::Cargar_Llave_Video_Decriptar()
{
	QString Nombre_Archivo_Cargar_Mascara = QFileDialog::getOpenFileName(this, tr("Cargar Llave"), QDir::currentPath(), tr("Archivos XML (*.xml)"));
    if (Nombre_Archivo_Cargar_Mascara.isEmpty())
        return;

	if(Llave_Video_Decriptar)
		cvReleaseImage(&Llave_Video_Decriptar);

	if(Llave_Video_Decriptar_Visualizar)
		cvReleaseImage(&Llave_Video_Decriptar_Visualizar);

	if(Llave_Redimensionar_Video_Decriptar_Visualizar)
		cvReleaseImage(&Llave_Redimensionar_Video_Decriptar_Visualizar);

	Llave_Video_Decriptar = (IplImage *)cvLoad(Nombre_Archivo_Cargar_Mascara.toLocal8Bit().constData());
	if(!Llave_Video_Decriptar)
		return;

	Alto_Llave_Video_Decriptar = Llave_Video_Decriptar->height;
	Ancho_Llave_Video_Decriptar = Llave_Video_Decriptar->width;

	Llave_Video_Decriptar_Visualizar = cvCreateImage(cvSize(Llave_Video_Decriptar->width, Llave_Video_Decriptar->height),8, 1);
	Obtner_MASCARA_FASE_2show(Llave_Video_Decriptar, Llave_Video_Decriptar_Visualizar);
	Llave_Redimensionar_Video_Decriptar_Visualizar = cvCreateImage(cvSize(Ancho_Visualizar_Video_Decriptar, Alto_Visualizar_Video_Decriptar),8,1);
	cvResize(Llave_Video_Decriptar_Visualizar, Llave_Redimensionar_Video_Decriptar_Visualizar, CV_INTER_LINEAR);
	cvSaveImage("TEMP.png",Llave_Redimensionar_Video_Decriptar_Visualizar);
	QImage Imagen_Temp;
	Imagen_Temp.load(QString("TEMP.png"));

	ui->labelLlaveVideoDecriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	ui->lineEditAltoLlaveVideoDecriptar->setText(QString().sprintf("%d", Llave_Video_Decriptar->height));
	ui->lineEditAnchoLlaveVideoDecriptar->setText(QString().sprintf("%d", Llave_Video_Decriptar->width));
	ui->lineEditCanalesLlaveVideoDecriptar->setText(QString().sprintf("%d", Llave_Video_Decriptar->nChannels));
	ui->lineEditTipoLlaveVideoDecriptar->setText(QString().sprintf("%d", Llave_Video_Decriptar->depth));
	LlavePemiteRecibir = true;
	ui->toolButtonRecibir->setEnabled(ClienteON & LlavePemiteRecibir);

	//ESTABLECIENDO DIMENSIONES DE DE VIDEO DE ENTRADA Y DECRIPTADO IGUALES A LAS DIMENSIONES DE LA LLAVE
	if (Llave_Determina_Dimensiones_Video_Decriptar)
	{
		ui->lineEditAltoVideoEntradaDecriptar->setText(QString().sprintf("%d", Llave_Video_Decriptar->height));
		ui->lineEditAnchoVideoEntradaDecriptar->setText(QString().sprintf("%d", Llave_Video_Decriptar->width));
		ui->lineEditCanalesVideoEntradaDecriptar->setText(QString().sprintf("%d", 1));
		ui->lineEditTipoVideoEntradaDecriptar->setText(QString().sprintf("%d", 8));

		ui->lineEditAltoVideoSalidaDecriptar->setText(QString().sprintf("%d", Llave_Video_Decriptar->height));
		ui->lineEditAnchoVideoSalidaDecriptar->setText(QString().sprintf("%d", Llave_Video_Decriptar->width));
		ui->lineEditCanalesVideoSalidaDecriptar->setText(QString().sprintf("%d", 1));
		ui->lineEditTipoVideoSalidaDecriptar->setText(QString().sprintf("%d", 8));
	}
	
	if(RecibirVideoON)
		Recibir_Cliente_Video_Decriptar();

	//////////////////////////////////////////////////////////////////////////////////////////////////////////

}
void MainWindow::Iniciar_Cliente_Video_Decriptar()
{
	ClienteON = !ClienteON;

	if (ClienteON)
		ui->labelHabilitarClienteON->setText(QString("ON"));
	else
		ui->labelHabilitarClienteON->setText(QString("OFF"));

	ui->toolButtonRecibir->setEnabled(ClienteON & LlavePemiteRecibir);
	
	ui->lineEditIPCliente->setEnabled(ClienteON);
	ui->lineEditPuertoCliente->setEnabled(ClienteON);

	if(RecibirVideoON)
		Recibir_Cliente_Video_Decriptar();
}
void MainWindow::Recibir_Cliente_Video_Decriptar()
{
	RecibirVideoON = !RecibirVideoON;
	QImage Imagen_Temp;
	QString Texto_Decriptar;
	
	if(RecibirVideoON)
	{
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/noSign-Download-icon.png"));	
		Texto_Decriptar.sprintf("NO RECIBIR");

	}else{
		Imagen_Temp.load(QString::fromUtf8(":/new/prefix1/resources/Sign-Download-icon.png"));	
		Texto_Decriptar.sprintf("RECIBIR");

	}
	
	ui->toolButtonRecibir->setIcon(QIcon(QPixmap::fromImage(Imagen_Temp)));
	ui->toolButtonRecibir->setText(Texto_Decriptar);

	ui->toolButtonIniciarCapturaVideoDecriptar->setEnabled(!RecibirVideoON);

}
void MainWindow::Sesion_Abierta_Video_Decriptar()
{
    // Guardar la configuración utilizada.
    QNetworkConfiguration config = Sesion_Red_Video_Decriptar->configuration();
    QString id;
    if (config.type() == QNetworkConfiguration::UserChoice)
        id = Sesion_Red_Video_Decriptar->sessionProperty(QLatin1String("UserChoiceConfiguration")).toString();
    else
        id = config.identifier();

    QSettings settings(QSettings::UserScope, QLatin1String("Trolltech"));
    settings.beginGroup(QLatin1String("QtNetwork"));
    settings.setValue(QLatin1String("DefaultNetworkConfiguration"), id);
    settings.endGroup();
}

void MainWindow::Empezar_Recibir_Video_Encriptado()
{
    QDataStream in(SocketTCP_Cliente_Video_Decriptar);
    in.setVersion(QDataStream::Qt_4_0);

    if (blockSize == 0) {
        if (SocketTCP_Cliente_Video_Decriptar->bytesAvailable() < (int)sizeof(quint16))
            return;

		in >> blockSize;
    }

    if (SocketTCP_Cliente_Video_Decriptar->bytesAvailable() < blockSize)
        return;

    QString nextFortune;
    in >> nextFortune;
    QByteArray *byteArray2 = new QByteArray(nextFortune.toLocal8Bit());

	if (Imagen_Entrada_Video_Decriptar)
		cvReleaseImage(&Imagen_Entrada_Video_Decriptar);
	if (Imagen_Salida_Video_Decriptar)
		cvReleaseImage(&Imagen_Salida_Video_Decriptar);

	if (Imagen_Entrada_Video_Decriptar_Visualizar)
		cvReleaseImage(&Imagen_Entrada_Video_Decriptar_Visualizar);
	if (Imagen_Salida_Video_Decriptar_Visualizar)
		cvReleaseImage(&Imagen_Salida_Video_Decriptar_Visualizar);

	Imagen_Entrada_Video_Decriptar = cvCreateImage(cvSize(Llave_Video_Decriptar->width, Llave_Video_Decriptar->height), Llave_Video_Decriptar->depth, Llave_Video_Decriptar->nChannels);
	Imagen_Salida_Video_Decriptar = cvCreateImage(cvSize(Llave_Video_Decriptar->width, Llave_Video_Decriptar->height), Llave_Video_Decriptar->depth, Llave_Video_Decriptar->nChannels);
	Imagen_Entrada_Video_Decriptar_Visualizar = cvCreateImage(cvSize(Llave_Video_Decriptar->width, Llave_Video_Decriptar->height), 8, 1);
	Imagen_Salida_Video_Decriptar_Visualizar = cvCreateImage(cvSize(Llave_Video_Decriptar->width, Llave_Video_Decriptar->height), 8, 1);

	if(Imagen_Redimensionar_Entrada_Video_Decriptar_Visualizar)
		cvReleaseImage(&Imagen_Redimensionar_Entrada_Video_Decriptar_Visualizar);
	if(Imagen_Redimensionar_Salida_Video_Decriptar_Visualizar)
		cvReleaseImage(&Imagen_Redimensionar_Salida_Video_Decriptar_Visualizar);

	Imagen_Redimensionar_Entrada_Video_Decriptar_Visualizar = cvCreateImage(cvSize(Ancho_Visualizar_Video_Encriptar, Alto_Visualizar_Video_Encriptar), 8, 1);
	Imagen_Redimensionar_Salida_Video_Decriptar_Visualizar = cvCreateImage(cvSize(Ancho_Visualizar_Video_Encriptar, Alto_Visualizar_Video_Encriptar), 8, 1);

	Imagen_Entrada_Video_Decriptar->imageData = (char *)byteArray2->constData();
	Obtner_ENCRIPT_DESENCRIPT_2show(Imagen_Entrada_Video_Decriptar, Imagen_Entrada_Video_Decriptar_Visualizar);
	cvResize(Imagen_Entrada_Video_Decriptar_Visualizar, Imagen_Redimensionar_Entrada_Video_Decriptar_Visualizar, CV_INTER_LINEAR);
	QImage Imagen_Temp(IplImage2QImage(Imagen_Redimensionar_Entrada_Video_Decriptar_Visualizar));
	ui->labelVideoEntradaDecriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));

	if(DecriptarVideoON)
	{
		Desencriptar(Imagen_Entrada_Video_Decriptar, Llave_Video_Decriptar, Imagen_Salida_Video_Decriptar);
		Obtner_ENCRIPT_DESENCRIPT_2show(Imagen_Salida_Video_Decriptar, Imagen_Salida_Video_Decriptar_Visualizar);
		cvResize(Imagen_Salida_Video_Decriptar_Visualizar, Imagen_Redimensionar_Salida_Video_Decriptar_Visualizar, CV_INTER_LINEAR);
		QImage Imagen_Temp2(IplImage2QImage(Imagen_Redimensionar_Salida_Video_Decriptar_Visualizar));
		ui->labelVideoSalidaDecriptar->setPixmap(QPixmap::fromImage(Imagen_Temp2));
	}else{
		ui->labelVideoSalidaDecriptar->setPixmap(QPixmap::fromImage(Imagen_Temp));
	}
	
}


void MainWindow::Mostrar_Errores_Conexion_Video_Decritpar(QAbstractSocket::SocketError socketError)
{
    switch (socketError) {
    case QAbstractSocket::RemoteHostClosedError:
        break;
    case QAbstractSocket::HostNotFoundError:
        QMessageBox::information(this, tr("Fortune Client"),
                                 tr("The host was not found. Please check the "
                                    "host name and port settings."));
        break;
    case QAbstractSocket::ConnectionRefusedError:
        QMessageBox::information(this, tr("Fortune Client"),
                                 tr("The connection was refused by the peer. "
                                    "Make sure the fortune server is running, "
                                    "and check that the host name and port "
                                    "settings are correct."));
        break;
    default:
        QMessageBox::information(this, tr("Fortune Client"),
                                 tr("The following error occurred: %1.")
                                 .arg(SocketTCP_Cliente_Video_Decriptar->errorString()));
    }

    //getFortuneButton->setEnabled(true);
}

void MainWindow::Actualizar_Imagenes_Video_Decriptar()
{
	if(!RecibirVideoON)
		return;
	
	if ((!Sesion_Red_Video_Decriptar || Sesion_Red_Video_Decriptar->isOpen()) && !ui->lineEditIPCliente->text().isEmpty() && !ui->lineEditPuertoCliente->text().isEmpty())
	{
		Decritpar_Nueva_Imagen();
	}
}

void MainWindow::Decritpar_Nueva_Imagen()
{
    if(!ClienteON || !RecibirVideoON)
		return;

    blockSize = 0;
    SocketTCP_Cliente_Video_Decriptar->abort();
    SocketTCP_Cliente_Video_Decriptar->connectToHost(ui->lineEditIPCliente->text(), ui->lineEditPuertoCliente->text().toInt());
}

void MainWindow::Tomar_Foto_Video_Decriptar()
{
    QString Nombre_Archivo_Guardar_Imagen_Salida_Decriptar = QFileDialog::getSaveFileName(this, tr("Guardar Imagen Encriptada"), QDir::currentPath(), tr("Archivos de Imagen (*.png *.bmp *.jpg)"));
    if (Nombre_Archivo_Guardar_Imagen_Salida_Decriptar.isEmpty())
        return;
	if(DecriptarVideoON)
	{
		cvSaveImage(Nombre_Archivo_Guardar_Imagen_Salida_Decriptar.toLocal8Bit().constData(), Imagen_Salida_Video_Decriptar_Visualizar);
	}else{
		cvSaveImage(Nombre_Archivo_Guardar_Imagen_Salida_Decriptar.toLocal8Bit().constData(), Imagen_Entrada_Video_Decriptar_Visualizar);
	}
}
// FIN DECRIPTAR VIDEO

//FUNCIONES PARA CRIPTOGRAFÍA ÓPTICA
void MainWindow::Obtener_Histograma(IplImage *src, IplImage *dst)
{
	CvHistogram *hist;
	int hist_size = 64;
float range_0[]={0,256};
float* ranges[] = { range_0 };
	hist = cvCreateHist(1, &hist_size, CV_HIST_ARRAY, ranges, 1);

	    cvCalcHist( &src, hist, 0, NULL );
		float max_value = 0;
    //cvZero( src );
    cvGetMinMaxHistValue( hist, 0, &max_value, 0, 0 );
    cvScale( hist->bins, hist->bins, ((double)dst->height)/max_value, 0 );
    /*cvNormalizeHist( hist, 1000 );*/

    cvSet( dst, cvScalarAll(255), 0 );
    int i, bin_w = cvRound((double)dst->width/hist_size);

    for( i = 0; i < hist_size; i++ )
        cvRectangle( dst, cvPoint(i*bin_w, dst->height),
                     cvPoint((i+1)*bin_w, dst->height - cvRound(cvGetReal1D(hist->bins,i))),
                     cvScalarAll(0), -1, 8, 0 );

}

void MainWindow::cvMultiplicar(CvMat * src1, IplImage *src2, IplImage *dst)
{
    CvMat *R1, *I1, *R2, *I2, *RD, *ID;
    double r, c;
    int i, j;

    CvSize size = cvGetSize(src1);
		R1 = cvCreateMat( src2->height, src2->width, CV_64FC1);
        I1 = cvCreateMat( src2->height, src2->width, CV_64FC1);
        R2 = cvCreateMat( src2->height, src2->width, CV_64FC1);
        I2 = cvCreateMat( src2->height, src2->width, CV_64FC1);
        RD = cvCreateMat( src2->height, src2->width, CV_64FC1);
        ID = cvCreateMat( src2->height, src2->width, CV_64FC1);

		//printf("\nsrc1->width = %d, src1->height = %d, src2->width = %d, src2->height = %d", src1->width, src1->height, src2->width, src2->height);
    if ((size.height == src2->height) && (size.width == src2->width))
    {
  		//R1 = cvCreateMat( src2->height, src2->width, CV_64FC1);
    //    I1 = cvCreateMat( src2->height, src2->width, CV_64FC1);
    //    R2 = cvCreateMat( src2->height, src2->width, CV_64FC1);
    //    I2 = cvCreateMat( src2->height, src2->width, CV_64FC1);
    //    RD = cvCreateMat( src2->height, src2->width, CV_64FC1);
    //    ID = cvCreateMat( src2->height, src2->width, CV_64FC1);
      

		
        cvSplit(src1, R1, I1, NULL, NULL);
   

        cvSplit(src2, R2, I2, NULL, NULL);

		
        for (i = 0; i< src2->height; i++)
        {
            for (j = 0; j< src2->width; j++)
            {
                r = cvGet2D(R1,i,j).val[0]*cvGet2D(R2,i,j).val[0] - cvGet2D(I1,i,j).val[0]*cvGet2D(I2,i,j).val[0];
                c = cvGet2D(R1,i,j).val[0]*cvGet2D(I2,i,j).val[0] + cvGet2D(R2,i,j).val[0]*cvGet2D(I1,i,j).val[0];
                cvSet2D(RD,i,j,cvScalar(r));
                cvSet2D(ID,i,j,cvScalar(c));
            }
        }

        cvMerge(RD, ID, NULL, NULL, dst);

    }else{
		//system("pause");
        dst = NULL;

    }

    if (R1) cvReleaseMat(&R1);
    if (I1) cvReleaseMat(&I1);
    if (R2) cvReleaseMat(&R2);
    if (I2) cvReleaseMat(&I2);
    if (RD) cvReleaseMat(&RD);
    if (ID) cvReleaseMat(&ID);

}



void MainWindow::cvMultiplicar2(IplImage * src1, IplImage *src2, IplImage *dst)
{
    CvMat *R1, *I1, *R2, *I2, *RD, *ID;
    double r, c;
    int i, j;
    CvSize size = cvGetSize(src1);
	
	
    if ((size.height == src2->height) && (size.width == src2->width))
    {
        R1 = cvCreateMat( src2->height, src2->width, CV_64FC1);
        I1 = cvCreateMat( src2->height, src2->width, CV_64FC1);
        R2 = cvCreateMat( src2->height, src2->width, CV_64FC1);
        I2 = cvCreateMat( src2->height, src2->width, CV_64FC1);
        RD = cvCreateMat( src2->height, src2->width, CV_64FC1);
        ID = cvCreateMat( src2->height, src2->width, CV_64FC1);

        cvSplit(src1, R1, I1, NULL, NULL);
        cvSplit(src2, R2, I2, NULL, NULL);
		
        for (i = 0; i< src2->height; i++)
        {
            for (j = 0; j< src2->width; j++)
            {
                r = cvGet2D(R1,i,j).val[0]*cvGet2D(R2,i,j).val[0] - cvGet2D(I1,i,j).val[0]*cvGet2D(I2,i,j).val[0];
                c = cvGet2D(R1,i,j).val[0]*cvGet2D(I2,i,j).val[0] + cvGet2D(R2,i,j).val[0]*cvGet2D(I1,i,j).val[0];
                cvSet2D(RD,i,j,cvScalar(r));
                cvSet2D(ID,i,j,cvScalar(c));
            }
        }

        cvMerge(RD, ID, NULL, NULL, dst);

    }else{

        dst = NULL;

    }

    cvReleaseMat(&R1);
    cvReleaseMat(&I1);
    cvReleaseMat(&R2);
    cvReleaseMat(&I2);
    cvReleaseMat(&RD);
    cvReleaseMat(&ID);

}


void MainWindow::Generar_Mascara_Fase(IplImage *Mascara, CvRNG Numeros_Aleatorios)
{
    CvScalar Real, Imaginario;
    double Fase_Aleatoria;
    int i,j;

    IplImage *Parte_Real = cvCreateImage( cvSize(Mascara->width, Mascara->height), IPL_DEPTH_64F, 1);
    IplImage *Parte_Imaginaria = cvCreateImage( cvSize(Mascara->width, Mascara->height), IPL_DEPTH_64F, 1);

    for (i = 0; i<Mascara->height; i++)
    {
        for (j = 0; j<Mascara->width; j++)
        {
            Fase_Aleatoria = 2*CV_PI*(cvRandReal(&Numeros_Aleatorios) -0.5);
            Real = cvScalar(cos(Fase_Aleatoria));
            Imaginario = cvScalar(sin(Fase_Aleatoria));

            cvSet2D( Parte_Real, i, j, Real );
            cvSet2D( Parte_Imaginaria, i, j, Imaginario );
         }
    }
    cvMerge(Parte_Real, Parte_Imaginaria, NULL, NULL, Mascara);


    cvReleaseImage(&Parte_Real);
    cvReleaseImage(&Parte_Imaginaria);
}


void MainWindow::Encriptar(IplImage *Informacion_Imagen, IplImage *Mascara, IplImage *Informacion_Encriptada)
{
     IplImage *Parte_Real = cvCreateImage( cvSize(Informacion_Imagen->width, Informacion_Imagen->height), IPL_DEPTH_64F, 1);
     IplImage *Parte_Imaginaria = cvCreateImage( cvSize(Informacion_Imagen->width, Informacion_Imagen->height), IPL_DEPTH_64F, 1);
     IplImage *Informacion_Compleja = cvCreateImage( cvSize(Informacion_Imagen->width, Informacion_Imagen->height), IPL_DEPTH_64F, 2);

     cvScale(Informacion_Imagen, Parte_Real, 1.0, 0.0);
     cvZero(Parte_Imaginaria);
     cvMerge(Parte_Real, Parte_Imaginaria, NULL, NULL, Informacion_Compleja);

     CvMat* TD_Fourier, Auxiliar;

     int M = cvGetOptimalDFTSize( Informacion_Imagen->height - 1 );
     int N = cvGetOptimalDFTSize( Informacion_Imagen->width - 1 );

     TD_Fourier = cvCreateMat( M, N, CV_64FC2 );
     
     cvGetSubRect( TD_Fourier, &Auxiliar, cvRect(0,0, Informacion_Imagen->width, Informacion_Imagen->height));
     cvCopy( Informacion_Compleja, &Auxiliar, NULL );
     
     if ( TD_Fourier->cols > Informacion_Imagen->width )
     {
        cvGetSubRect( TD_Fourier, &Auxiliar, cvRect(Informacion_Imagen->width,0, TD_Fourier->cols - Informacion_Imagen->width, Informacion_Imagen->height));
        cvZero( &Auxiliar );
     }
     
	 
     cvDFT(TD_Fourier, TD_Fourier, CV_DXT_FORWARD, Informacion_Compleja->height );
	 
     cvMultiplicar(TD_Fourier, Mascara, Informacion_Encriptada);
	 //system("pause");
     cvDFT( Informacion_Encriptada, Informacion_Encriptada, CV_DXT_INVERSE, Informacion_Compleja->height );

	 

     cvReleaseImage(&Parte_Real);
     cvReleaseImage(&Parte_Imaginaria);

     cvReleaseImage(&Informacion_Compleja);
     cvReleaseMat(&TD_Fourier);
}


void MainWindow::Desencriptar(IplImage *Informacion_Encriptada, IplImage *Mascara, IplImage *Informacion_Desencriptada)
{

     cvDFT( Informacion_Encriptada, Informacion_Desencriptada, CV_DXT_FORWARD, Informacion_Desencriptada->height );
     Conjugar_Mascara(Mascara);
     cvMultiplicar2(Informacion_Desencriptada, Mascara, Informacion_Desencriptada);
     cvDFT( Informacion_Desencriptada, Informacion_Desencriptada, CV_DXT_INVERSE, Informacion_Desencriptada->height );
}


void MainWindow::Conjugar_Mascara(IplImage *Mascara)
{
    int i,j;
    double Imaginario;
    IplImage *Parte_Imaginaria = cvCreateImage( cvSize(Mascara->width, Mascara->height), IPL_DEPTH_64F, 1);
    IplImage *Parte_Real = cvCreateImage( cvSize(Mascara->width, Mascara->height), IPL_DEPTH_64F, 1);


    cvSplit(Mascara, Parte_Real, Parte_Imaginaria, NULL, NULL);
    for (i = 0; i<Mascara->height; i++)
    {
        for (j = 0; j<Mascara->width; j++)
        {
            Imaginario = (-1)*cvGet2D(Parte_Imaginaria, i, j).val[0];
            cvSet2D( Parte_Imaginaria, i, j, cvScalar(Imaginario) );
         }
    }
    cvMerge(Parte_Real, Parte_Imaginaria, NULL, NULL, Mascara);

    cvReleaseImage(&Parte_Real);
    cvReleaseImage(&Parte_Imaginaria);
}


void MainWindow::cvShiftDFT(CvArr * src_arr, CvArr * dst_arr )
{

    CvMat * tmp=0;
    CvMat q1stub, q2stub;
    CvMat q3stub, q4stub;
    CvMat d1stub, d2stub;
    CvMat d3stub, d4stub;
    CvMat * q1, * q2, * q3, * q4;
    CvMat * d1, * d2, * d3, * d4;

    CvSize size = cvGetSize(src_arr);
    CvSize dst_size = cvGetSize(dst_arr);
    int cx, cy;

    if(dst_size.width != size.width ||
       dst_size.height != size.height){
        cvError( CV_StsUnmatchedSizes, "cvShiftDFT", "Source and Destination arrays must have equal sizes", __FILE__, __LINE__ );
    }

    if(src_arr==dst_arr){
        tmp = cvCreateMat(size.height/2, size.width/2, cvGetElemType(src_arr));
    }

    cx = size.width/2;
    cy = size.height/2; // image center

    q1 = cvGetSubRect( src_arr, &q1stub, cvRect(0,0,cx, cy) );
    q2 = cvGetSubRect( src_arr, &q2stub, cvRect(cx,0,cx,cy) );
    q3 = cvGetSubRect( src_arr, &q3stub, cvRect(cx,cy,cx,cy) );
    q4 = cvGetSubRect( src_arr, &q4stub, cvRect(0,cy,cx,cy) );
    d1 = cvGetSubRect( src_arr, &d1stub, cvRect(0,0,cx,cy) );
    d2 = cvGetSubRect( src_arr, &d2stub, cvRect(cx,0,cx,cy) );
    d3 = cvGetSubRect( src_arr, &d3stub, cvRect(cx,cy,cx,cy) );
    d4 = cvGetSubRect( src_arr, &d4stub, cvRect(0,cy,cx,cy) );

    if(src_arr!=dst_arr){
        if( !CV_ARE_TYPES_EQ( q1, d1 )){
            cvError( CV_StsUnmatchedFormats, "cvShiftDFT", "Source and Destination arrays must have the same format", __FILE__, __LINE__ );
        }
        cvCopy(q3, d1, 0);
        cvCopy(q4, d2, 0);
        cvCopy(q1, d3, 0);
        cvCopy(q2, d4, 0);
    }
    else{
        cvCopy(q3, tmp, 0);
        cvCopy(q1, q3, 0);
        cvCopy(tmp, q1, 0);
        cvCopy(q4, tmp, 0);
        cvCopy(q2, q4, 0);
        cvCopy(tmp, q2, 0);
    }

    cvReleaseMat(&tmp);
    cvReleaseMat(&q1);
    cvReleaseMat(&q2);
    cvReleaseMat(&q3);
    cvReleaseMat(&q4);
    cvReleaseMat(&d1);
    cvReleaseMat(&d2);
    cvReleaseMat(&d3);
    cvReleaseMat(&d4);
}


void MainWindow::Obtner_Fourier_2show(CvMat *Fourier, IplImage *Fourier_2show)
{
	int ancho = Fourier->cols;
    int alto = Fourier->rows;
    IplImage *Imagen_Real = cvCreateImage( cvSize(ancho,alto), IPL_DEPTH_64F, 1);
    IplImage *Imagen_Imaginario = cvCreateImage( cvSize(ancho,alto), IPL_DEPTH_64F, 1);
    double m, M;

        cvSplit( Fourier, Imagen_Real, Imagen_Imaginario, 0, 0 );
        cvPow( Imagen_Real, Imagen_Real, 2.0);
        cvPow( Imagen_Imaginario, Imagen_Imaginario, 2.0);
        cvAdd( Imagen_Real, Imagen_Imaginario, Imagen_Real, NULL);
        cvPow( Imagen_Real, Imagen_Real, 0.5 );
        cvAddS( Imagen_Real, cvScalarAll(1.0), Imagen_Real, NULL ); // 1 + Mag
        cvLog( Imagen_Real, Imagen_Real ); // log(1 + Mag)
        cvShiftDFT( Imagen_Real, Imagen_Real );
        cvMinMaxLoc(Imagen_Real, &m, &M, NULL, NULL, NULL);
        cvScale(Imagen_Real, Imagen_Real, 1.0/(M-m), 1.0*(-m)/(M-m));
        cvConvertScaleAbs( Imagen_Real, Fourier_2show, 255, 0 );


    cvReleaseImage(&Imagen_Real);
    cvReleaseImage(&Imagen_Imaginario);
}


void MainWindow::Obtner_ENCRIPT_DESENCRIPT_2show(IplImage * ENCRIPT_DESENCRIPT, IplImage *ENCRIPT_DESENCRIPT_2show)
{
	int ancho = ENCRIPT_DESENCRIPT->width;
	int alto = ENCRIPT_DESENCRIPT->height;

    IplImage *Imagen_Real = cvCreateImage( cvSize(ancho,alto), IPL_DEPTH_64F, 1);
    IplImage *Imagen_Imaginario = cvCreateImage( cvSize(ancho,alto), IPL_DEPTH_64F, 1);
    double m, M;

        cvSplit( ENCRIPT_DESENCRIPT, Imagen_Real, Imagen_Imaginario, 0, 0 );
        cvPow( Imagen_Real, Imagen_Real, 2.0);
        cvPow( Imagen_Imaginario, Imagen_Imaginario, 2.0);
        cvAdd( Imagen_Real, Imagen_Imaginario, Imagen_Real, NULL);
        cvPow( Imagen_Real, Imagen_Real, 0.5 );
        cvAddS( Imagen_Real, cvScalarAll(1.0), Imagen_Real, NULL ); // 1 + Mag
        cvMinMaxLoc(Imagen_Real, &m, &M, NULL, NULL, NULL);
        cvScale(Imagen_Real, Imagen_Real, 1.0/(M-m), 1.0*(-m)/(M-m));
        cvConvertScaleAbs( Imagen_Real, ENCRIPT_DESENCRIPT_2show, 255, 0 );
    
    cvReleaseImage(&Imagen_Real);
    cvReleaseImage(&Imagen_Imaginario);

    
}

void MainWindow::Obtner_MASCARA_FASE_2show(IplImage * ENCRIPT_DESENCRIPT, IplImage *ENCRIPT_DESENCRIPT_2show)
{
    IplImage *Imagen_Real = cvCreateImage( cvGetSize(ENCRIPT_DESENCRIPT), IPL_DEPTH_64F, 1);
    IplImage *Imagen_Imaginario = cvCreateImage( cvGetSize(ENCRIPT_DESENCRIPT), IPL_DEPTH_64F, 1);
    double m, M, Real, Imaginario;

        cvSplit( ENCRIPT_DESENCRIPT, Imagen_Real, Imagen_Imaginario, 0, 0 );
        
        for (int i =0; i<cvGetSize(ENCRIPT_DESENCRIPT).height; i++)
        {
             for (int j =0; j<cvGetSize(ENCRIPT_DESENCRIPT).width; j++)
             {
                  Real = cvGet2D(Imagen_Real, i, j).val[0];
                  Imaginario = cvGet2D(Imagen_Imaginario, i, j).val[0];
                  Real=atan(Imaginario/Real);
                  cvSet2D( Imagen_Real, i, j, cvScalar(Real) );     
             }
        }
        cvMinMaxLoc(Imagen_Real, &m, &M, NULL, NULL, NULL);
        cvScale(Imagen_Real, Imagen_Real, 1.0/(M-m), 1.0*(-m)/(M-m));
        cvConvertScaleAbs( Imagen_Real, ENCRIPT_DESENCRIPT_2show, 255, 0 );

    cvReleaseImage(&Imagen_Real);
    cvReleaseImage(&Imagen_Imaginario);


}

//FIN FUNCIONES PARA CRIPTOGRAFÍA ÓPTICA