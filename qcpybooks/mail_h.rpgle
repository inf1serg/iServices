      /if defined(MAIL_H)
      /eof
      /endif
      /define MAIL_H

      * ---------------------------------------------- *
      * Template para QtmmSendMail
      * ---------------------------------------------- *
     D ADDT00100       ds                  qualified
     D                                     Based(Template)
     D   NextOffSet                  10i 0
     D   AddrLen                     10i 0
     D   AddrFormat                   8a
     D   DistType                    10i 0
     D   Reserved                    10i 0
     D   SmtpAddr                   256a

      * ---------------------------------------------- *
      * Estructura de datos de error:
      * ---------------------------------------------- *
     D MAIL_ERDS_T     ds                  qualified
     D                                     based(template)
     D   MAIL_Emid                    4s 0
     D   MAIL_Eml1                  132a
     D   MAIL_Eml2                 3000a

      /if not defined(qusec_h)
      * ---------------------------------------------- *
      * Estructura de datos de error para APIs
      * ---------------------------------------------- *
     D QUsec_t         ds                  qualified
     D                                     based(template)
     D   BytesProvided...
     D                               10i 0
     D   BytesAvailables...
     D                               10i 0
     D   MessageID                    7a
     D   Reserved                     1a
     D   ApiEcExDt                  127a
      /define qusec_h
      /endif

      * ---------------------------------------------- *
      * Estructura de datos trabajo calificado.
      * ---------------------------------------------- *
     D QualJobName_t   ds                  qualified
     D                                     based(template)
     D   JobName                     10a
     D   JobUser                     10a
     D   JobNbr                       6a

      * ---------------------------------------------- *
      * Estructura de datos objeto calificado.
      * ---------------------------------------------- *
     D QualObjName_t   ds                  qualified
     D                                     based(template)
     D   ObjName                     10a
     D   ObjLibr                     10a

      * ---------------------------------------------- *
      * Estructura de datos archivo calificado.
      * ---------------------------------------------- *
     D QualDBName_t    ds                  qualified
     D                                     based(template)
     D   DBFile                      10a
     D   DBFileLib                   10a

      * ---------------------------------------------- *
      * Estructura de datos archivo de spool.
      * ---------------------------------------------- *
     D DsSpool_t       ds                  qualified
     D                                     based(template)
     D   Splf                        10a
     D   Splfnbr                     10i 0
     D   Jobname                     10a
     D   JobUser                     10a
     D   JobNbr                       6a

      * ---------------------------------------------- *
      * Estructura de datos Destinatarios.
      * ---------------------------------------------- *
     D RecipDs_t       ds                  qualified
     D                                     based(template)
     D   ToName                      50a
     D   ToAddr                     256a

      * ---------------------------------------------- *
      * Estructura de datos Entradas de directorio.
      * ---------------------------------------------- *
     D DireEnt_t       ds                  qualified
     D                                     based(template)
     D   Fuln                        64a   varying
     D   Post                        40a   varying
     D   Dept                        50a   varying
     D   Mail                       255a   varying

     D RecPrp_t        ds                  qualified based(TEMPLATE)
     D  rpcprc                       20a
     D  rpcspr                       20a
     D  rpmail                       70a
     D  rpnomb                       50a
     D  rpma01                        1a
     D  rpma02                        1a
     D  rpma03                        1a
     D  rpma04                        1a
     D  rpma05                        1a
     D  rpma06                        1a
     D  rpma07                        1a
     D  rpma08                        1a
     D  rpma09                        1a
     D  rpma10                        1a
     D  rpstrg                        1a
     D  rpuser                       10a
     D  rpdate                        6  0
     D  rptime                        6  0

     D Remitente_t     ds                  qualified based(template)
     D  From                         64a   varying
     D  Fadr                        256a   varying

     D MailOpts_t      ds                  qualified based(template)
     D  impo                          1  0 overlay(MailOpts_t:1)
     D  sens                          1  0 overlay(MailOpts_t:*next)
     D  prio                          1  0 overlay(MailOpts_t:*next)
     D  notf                          4a   overlay(MailOpts_t:*next)
     D  ma01                          1a   overlay(MailOpts_t:*next)
     D  ma02                          4a   overlay(MailOpts_t:*next)

      * ---------------------------------------------- *
      * Constantes de error
      * ---------------------------------------------- *
      * No se ha indicado directorio
     D MAIL_E_NODIR    c                   const(0001)
      * No tiene autorización necesaria sobre el directorio
     D MAIL_E_AUTDIR   c                   const(0002)
      * No se ha indicado asunto
     D MAIL_E_NOSUBJ   c                   const(0003)
      * No se ha indicado nombre del remitente
     D MAIL_E_NOFRM    c                   const(0004)
      * No se ha indicado direccion remitente
     D MAIL_E_NOFRMA   c                   const(0005)
      * Dirección del remitente invalida
     D MAIL_E_FRMAIV   c                   const(0006)
      * Dirección destinatario invalida
     D MAIL_E_TOADIV   c                   const(0007)
      * Objeto IFS inexistente
     D MAIL_E_IFSOIX   c                   const(0008)
      * Sin autorización Objeto IFS
     D MAIL_E_IFSOAU   c                   const(0009)
      * No se pudo cerrar el archivo IFS
     D MAIL_E_NOCLS    c                   const(0010)
      * No se pudo eliminar el link
     D MAIL_E_NOUNLK   c                   const(0011)
      * No se pudo crear la nota MIME
     D MAIL_E_CRTMIME  c                   const(0012)
      * La nota MIME no existe
     D MAIL_E_NOMIMEX  c                   const(0013)
      * No se han especificado destinatarios
     D MAIL_E_NORECIP  c                   const(0014)
      * Cerrar Boundary blanco
     D MAIL_E_BLKBNDY  c                   const(0015)
      * No existe/No tiene autorización archivo adjunto
     D MAIL_E_NOATT    c                   const(0016)
      * El archivo adjunto supera el tamaño permitido
     D MAIL_E_ATTSIZE  c                   const(0017)
      * El archivo adjunto no es un directorio
     D MAIL_E_ATTDIR   c                   const(0018)
      * Error al abrir adjunto (se está usando?, etc etc)
     D MAIL_E_ATTOPN   c                   const(0019)
      * No se especificó nombre de att para namefile
     D MAIL_E_ATTNAM   c                   const(0020)
      * No se especificó boundary para adjunto
     D MAIL_E_NOATTBD  c                   const(0021)
      * ZIP = *YES y no se especificó nombre
     D MAIL_E_NOZIPNM  c                   const(0022)
      * ZIP = *YES y el archivo ya existe
     D MAIL_E_ZIPEXST  c                   const(0023)
      * No se ha encontrado autofirma
     D MAIL_E_NOAUTFR  c                   const(0024)
      * No se ha encontrado archivo IFS con la firma
     D MAIL_E_NOAFFIL  c                   const(0025)
      * No se ha encontrado el spool solicitado
     D MAIL_E_SPLNEX   c                   const(0026)
      * Estado del spool incorrecto
     D MAIL_E_SPLSTS   c                   const(0027)
      * Archivo i no encontrado
     D MAIL_E_NOIFILE  c                   const(0028)
      * Error al inicializar el módulo
     D MAIL_E_INZ      c                   const(0029)
      * Tamaño máximo permitido múltiples attachs
     D MAIL_E_ASIZ     c                   const(0030)
      * No se ha informado Content-ID
     D MAIL_E_NOCTID   c                   const(0031)
      * No existe/No tiene autorización imagen
     D MAIL_E_NOIMG    c                   const(0032)
      * La imagen es un directorio
     D MAIL_E_IMGDIR   c                   const(0033)
      * No se especificó nombre de imagen para namefile
     D MAIL_E_IMGNAM   c                   const(0034)
      * No se especificó boundary para imagen
     D MAIL_E_NOIMGBD  c                   const(0035)
      * No se especificó una dirección válida para Sender
     D MAIL_E_ADRSNDR  c                   const(0036)
      * No se especificó nombre para notification
     D MAIL_E_NONTNAM  c                   const(0037)
      * No se especificó dirección para notification
     D MAIL_E_NONTADR  c                   const(0038)
      * La dirección para notification es inválida
     D MAIL_E_IVNTADR  c                   const(0039)
      * Key Word personalizada incorrecta
     D MAIL_E_KEYW     c                   const(0040)
      * Error en QtmmSendMail
     D MAIL_E_QTMM     c                   const(0041)
      * Archivo a adjuntar no existe
     D MAIL_E_ATTNE    c                   const(0042)
      * No existe proceso
     D MAIL_E_NOPRC    c                   const(0043)
      * No existe subproceso
     D MAIL_E_NOSPR    c                   const(0044)
      * No hay mail para un subproceso tipo *SPRDFN
     D MAIL_E_NOADR    c                   const(0045)
      * Tipo de From no definido en SubProceso
     D MAIL_E_SPRUREF  c                   const(0046)

      * ---------------------------------------------- *
      * Constantes resultado del envío
      * ---------------------------------------------- *
     D MAIL_SUCCESS    c                   const(0)
     D MAIL_FAILED     c                   const(-1)

      * ---------------------------------------------- *
      * Constantes Importancia del mail
      * ---------------------------------------------- *
     D MAIL_IMPL       c                   const(0)
     D MAIL_IMPM       c                   const(1)
     D MAIL_IMPH       c                   const(2)

      * ---------------------------------------------- *
      * Constantes Prioridad
      * ---------------------------------------------- *
     D MAIL_PTYT       c                   const(0)
     D MAIL_PTYN       c                   const(1)
     D MAIL_PTYU       c                   const(2)

      * ---------------------------------------------- *
      * Constantes Sensibilidad
      * ---------------------------------------------- *
     D MAIL_SENN       c                   const(0)
     D MAIL_SENP       c                   const(1)
     D MAIL_SENV       c                   const(2)
     D MAIL_SENC       c                   const(3)

      * ---------------------------------------------- *
      * Constantes Content-Type del body
      * ---------------------------------------------- *
     D MAIL_CNTH       c                   'H'
     D MAIL_CNTT       c                   'T'
     D MAIL_CNTA       c                   'A'

      * ---------------------------------------------- *
      * Constantes varias
      * ---------------------------------------------- *
     D MAIL_MYES       c                   '*YES'
     D MAIL_MNO        c                   '*NO'
     D VALID           c                   const(*ON)
     D NOTVALID        c                   const(*OFF)
     D EXIST           c                   const(*ON)
     D NOEXIST         c                   const(*OFF)
     D ISDIR           c                   const(*ON)
     D NOTDIR          c                   const(*OFF)

      * ---------------------------------------------- *
      * Constantes Tipo de Mail
      * ---------------------------------------------- *
     D MAIL_NORMAL     c                   0
     D MAIL_CC         c                   1
     D MAIL_CCO        c                   2

      * --------------------------------------------------- *
      * MAIL_Inz(): Inicializa módulo.                      *
      *                                                     *
      * --------------------------------------------------- *
     D MAIL_Inz        pr            10i 0

      * --------------------------------------------------- *
      * MAIL_CrtMime(): Crea archivo MIME vacío en el IFS   *
      *                                                     *
      *   peMimf (i/o)  = Archivo MIME a generar/generado.  *
      *                                                     *
      * retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_CrtMime    pr            10i 0
     D   peMime                     256a   varying

      * --------------------------------------------------- *
      * MAIL_Subject(): Crea asunto del Mail.               *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peSubj (input) = Asunto del mail                  *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error               *
      * --------------------------------------------------- *
     D MAIL_Subject    pr            10i 0
     D   peMime                     256a   const varying
     D   peSubj                      84a   const varying

      * --------------------------------------------------- *
      * MAIL_Date():   Genera fecha actual en formato mail. *
      *                                                     *
      *   'Jue, 03 Ene 1950 14:30:06 -0300'                 *
      *                                                     *
      * Retorna String con la fecha                         *
      * --------------------------------------------------- *
     D MAIL_Date       pr            31a

      * --------------------------------------------------- *
      * MAIL_From(): Genera Remitente.                      *
      *              Este procedimiento también agrega la   *
      *              Versión MIME.                          *
      *              Fecha en formato mail.                 *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peFrom (input) = Nombre del remitente.            *
      *                   *SYSTEM  = Toma de Configuración. *
      *                   *CURRENT = Usuario Job.           *
      *   peFAdr (input) = Dirección de correo de prFrom    *
      *                   *SYSTEM  = Toma de Configuración. *
      *                   *CURRENT = Usuario Job.           *
      *   peRpyt (input) = Responder a...                   *
      *                   Si no llega, usa de configuración.*
      *                                                     *
      * Retorna 0 si todo ok, -1 si error.                  *
      * --------------------------------------------------- *
     D MAIL_From       pr            10i 0
     D   peMime                     256a   const varying
     D   peFrom                      64a   const varying
     D   peFAdr                     256a   const varying
     D   peRpyt                     256a   const varying
     D                                     options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_To():   Genera Destinatarios.                  *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peTonm (input) = Nombre destinatario.             *
      *                  *SYSTEM: Usuario de configuración. *
      *                  *REQUESTER: Usuario del Job.       *
      *   peToad (input) = Dirección destinatario.          *
      *   peToty (input) = Tipo de destinatario.            *
      *                                                     *
      * Retorna 0 si todo bien, -1 por error.               *
      * --------------------------------------------------- *
     D MAIL_To         pr            10i 0
     D   peMime                     256a   const varying
     D   peTonm                      50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)

      * --------------------------------------------------- *
      * MAIL_Importance(): Agrega Importancia.              *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peImpo (input) = Imporancia:                      *
      *                    0 = low                          *
      *                    1 = medium                       *
      *                    2 = high                         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     D MAIL_Importance...
     D                 pr            10i 0
     D   peMime                     256a   const varying
     D   peImpo                      10i 0 const

      * --------------------------------------------------- *
      * MAIL_Priority(): Agrega Prioridad.                  *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMpty (input) = Prioridad:                       *
      *                    0 = non-urgent                   *
      *                    1 = normal                       *
      *                    2 = urgent                       *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_Priority   pr            10i 0
     D   peMime                     256a   const varying
     D   peMpty                      10i 0 const

      * --------------------------------------------------- *
      * MAIL_MSens():  Agrega Sensibilidad de mensaje.      *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMsen (input) = Sesibilidad:                     *
      *                    0 = normal                       *
      *                    1 = personal                     *
      *                    2 = private                      *
      *                    3 = Company-Confidential         *
      *                                                     *
      * Nota 1: Un mail con sensibilidad 2 no podrá ser     *
      *         impreso ni reenviado.                       *
      * Nota 2: Sensibilidad 3, agrega al asunto el mensaje *
      *         definido en tabla de configuración.         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     D MAIL_MSens      pr            10i 0
     D   peMime                     256a   const varying
     D   peMsen                      10i 0 const

      * --------------------------------------------------- *
      * MAIL_GenBnyStr(): Genera String random para usar co-*
      *                   mo BOUNDARY.                      *
      *                                                     *
      * Retorna String para Boundary.                       *
      * --------------------------------------------------- *
     D MAIL_GenBnyStr  pr            36a

      * --------------------------------------------------- *
      * MAIL_MultiP(): Genera el tipo de contenido:         *
      *                MULTIPART/MIXED; BOUNDARY:"..."      *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_MultiP     pr            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a   const varying
     D                                     options(*nopass)

      * --------------------------------------------------- *
      * MAIL_CrtBody(): Crea un cuerpo de MAIL.             *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *   peCntt (input) = Tipo de contenido                *
      *                    T = text/plain (default)         *
      *                    H = text/html.                   *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     D MAIL_CrtBody    pr            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a   const varying
     D   peCntt                       1a   const options(*nopass)

      * --------------------------------------------------- *
      * MAIL_Body(): Graba mensaje.                         *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMsgd (input) = Mensaje.                         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     D MAIL_Body       pr            10i 0
     D   peMime                     256a   const varying
     D   peMsgd                     512a   const varying

      * --------------------------------------------------- *
      * MAIL_Lbody(): Graba mensaje "largo".                *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMsgd (input) = Mensaje.                         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     D MAIL_Lbody      pr            10i 0
     D   peMime                     256a   const varying
     D   peMsgd                    5000a   const

      * --------------------------------------------------- *
      * MAIL_Bbody(): Graba mensaje "largo".                *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peMsgd (input) = Mensaje.                         *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error                 *
      * --------------------------------------------------- *
     D MAIL_Bbody      pr            10i 0
     D   peMime                     256a   const varying
     D   peMsgd                   65535a   const

      * --------------------------------------------------- *
      * MAIL_Att(): Genera Attachment (base64).             *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *   peAttf (input) = Path IFS del archivo a adjuntar. *
      *   peAttn (input) = Nombre para el archivo.          *
      *                    *FILE = Pone nombre del archivo. *
      *   peAtfd (input) = Borrar archivo.                  *
      *                    *YES = Borra el archivo luego de *
      *                           adjuntar.                 *
      *                    *NO  = No borra el archivo.      *
      *                           Este es el valor x default*
      *                                                     *
      * Retorna 0 si todo bien, o -1 si hay error.          *
      * --------------------------------------------------- *
     D MAIL_Att        pr            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a   const varying
     D   peAttf                     255a   const varying
     D   peAttn                     256a   const
     D   peAtfd                       4a   options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_Keyw(): Agrega palabras claves personalizadas. *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peKeyw (input) = Nombre de la palabra clave.      *
      *                    "X-aaaaaaa:".                    *
      *   peKeyv (input) = Valor para la palabra clave.     *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si hay error.          *
      * --------------------------------------------------- *
     D MAIL_Keyw       pr            10i 0
     D   peMime                     256a   const varying
     D   peKeyw                     256a   const varying
     D   peKeyv                     256a   const varying

      * --------------------------------------------------- *
      * MAIL_Send(): Wrapper para la QtmmSendMail.          *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peFrom (input) = Nombre del remitente.            *
      *   peFAdr (input) = Dirección de correo de prFrom    *
      *   peTonm (input) = Nombre destinatario.             *
      *   peToad (input) = Dirección destinatario.          *
      *   peToty (input) = Tipo de destinatario.            *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si hay error.          *
      * --------------------------------------------------- *
     D MAIL_Send       pr            10i 0
     D   peMime                     256a   const varying
     D   peFrom                      64a   const varying
     D   peFAdr                     256a   const varying
     D   peTonm                      50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)

      * --------------------------------------------------- *
      * MAIL_ClsBndy(): Cierra Boundary.                    *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si hay error.          *
      * --------------------------------------------------- *
     D MAIL_ClsBndy    pr            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a

      * --------------------------------------------------- *
      * MAIL_Error():  Retorna la descripción del último    *
      *                  error del programa.                *
      *                                                     *
      * Retorna *NONE                                       *
      * --------------------------------------------------- *
     D MAIL_Error      pr                  likeds(MAIL_ERDS_T)

      * --------------------------------------------------- *
      * MAIL_IsValid(): Determina si una dirección es valida*
      *                 o no.                               *
      *                                                     *
      *   peAddr  (input) Dirección de mail.                *
      *                                                     *
      * Retorna *on si es válida, *off si no.               *
      * --------------------------------------------------- *
     D MAIL_IsValid    pr             1N
     D   peAddr                     256a   const varying

      * --------------------------------------------------- *
      * MAIL_ChkIfsO(): Chequea existencia de objeto en el  *
      *                 IFS.                                *
      *                                                     *
      *   peIfso (input)  = Objeto a chequear.              *
      *                     "/home/.../.../xxx.eee"         *
      *   peIfsa (input)  = Tipo de Chequeo:                *
      *                     *NONE: Existencia (default)     *
      *                     *R   : Read                     *
      *                     *RW  : Read/Write               *
      *                     *RX  : Read/Execute             *
      *                     *RWX : Read/Write/Execute       *
      *                     *W   : Write                    *
      *                     *WX  : Write/Execute            *
      *                     *X   : Execute                  *
      *                                                     *
      * Retorna *on si existe, *off si no.                  *
      * --------------------------------------------------- *
     D MAIL_ChkIfsO    pr             1N
     D   peIfso                     256a   const varying
     D   peIfsa                       5a   const options(*nopass)

      * --------------------------------------------------- *
      * MAIL_IsDir(): Chequea si un objeto IFS es un directo*
      *               rio o es un archivo.                  *
      *                                                     *
      *   peIfso (input)  = Objeto a chequear.              *
      *                     "/home/.../.../xxx.eee"         *
      *   peSize (output) = Tamaño de peIfso si no es DIR.  *
      *                                                     *
      * Retorna *on si es DIR, *off si no.                  *
      * --------------------------------------------------- *
     D MAIL_IsDir      pr             1N
     D   peIfso                     256a   const varying
     D   peSize                      10i 0 options(*nopass)

      * --------------------------------------------------- *
      * MAIL_ChkObj(): Chequea existencia de objeto.        *
      *                                                     *
      *   peObjn (input)  = Objeto a chequear.              *
      *   peObjl (input)  = Biblioteca. Valores especiales: *
      *                     *LIBL (default)                 *
      *                     *CURLIB                         *
      *   peObjt (input)  = Tipo de Objeto.                 *
      *   peObjm (input)  = Miembro (en caso de archivo)    *
      *                     *NONE (default)                 *
      *                     *FIRST                          *
      *                                                     *
      * Retorna *on si existe, *off si no.                  *
      * --------------------------------------------------- *
     D MAIL_ChkObj     pr             1N
     D   peObjn                      10a   const
     D   peObjl                      10a   const
     D   peObjt                      10a   const
     D   peObjm                      10a   const options(*nopass)

      * --------------------------------------------------- *
      * MAIL_ChkSplf(): Chequear existencia de Splf.        *
      *                                                     *
      *   peJobn (input)  = Nombre del trabajo del spool.   *
      *   peJobU (input)  = Usuario del trabajo del spool.  *
      *   peJobr (input)  = Número de trabajo del spool.    *
      *   peSplf (input)  = Nombre del spool.               *
      *   peSplN (input)  = Número del spool:               *
      *                     0001-9999                       *
      *                     *ZEROS = *ONLY (default)        *
      *                     -1     = *LAST                  *
      *   peStat (input)  = Status.                         *
      *                                                     *
      * Retorna *on si existe, *off si no.                  *
      * --------------------------------------------------- *
     D MAIL_ChkSplf    pr             1N
     D   peJobn                      10a   const
     D   peJobU                      10a   const
     D   peJobr                       6a   const
     D   peSplf                      10a   const
     D   peSplN                      10i 0 const options(*nopass)
     D   peStat                      10a   options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_GetIfsFile(): Obtiene nombre de archivo desde  *
      *                    un path IFS.                     *
      *                                                     *
      *   pePath (input)  = Path completo.                  *
      *                   /home/xxx/zzz/.../fff.xxx         *
      *   peFile (output) = Nombre de archivo.              *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error.              *
      * --------------------------------------------------- *
     D MAIL_GetIfsFile...
     D                 pr            10i 0
     D   pePath                     256a   const varying
     D   peFile                     256a   varying

      * --------------------------------------------------- *
      * MAIL_EmbebImg(): Enbeber imagen.                    *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peBndy (input) = Boundary.                        *
      *                    Retorno de: MAIL_GenBnyStr().    *
      *   peImgp (input) = Path IFS del archivo a adjuntar. *
      *   peImgn (input) = Nombre de la imagen.             *
      *                    *FILE = Extrae.                  *
      *   peCtid (input) = Content-ID.                      *
      *   peImgt (input) = Tipo de imagen.                  *
      *                    "J" = Jpeg.                      *
      *                    "G" = Gif. (default)             *
      *                    "P" = Png.                       *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error.              *
      * --------------------------------------------------- *
     D MAIL_EmbebImg   pr            10i 0
     D   peMime                     256a   const varying
     D   peBndy                      36a   const varying
     D   peImgp                     256a   const varying
     D   peImgn                      50a   const
     D   peCtid                     100a   const
     D   peImgt                       1a   const
     D                                     options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_AutoFirma(): Genera autofirma.                 *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peFrom (input) = Nombre del remitente.            *
      *                 *SYSTEM  = Toma de configuración.   *
      *                 *CURRENT = Usuario del job.         *
      *   peFAdr (input) = Dirección de correo de peFrom.   *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error.              *
      * --------------------------------------------------- *
     D MAIL_AutoFirma  pr            10i 0
     D   peMime                     256a   const varying
     D   peFrom                      64a   const varying
     D   peFAdr                     256a   const varying
     D   peBndy                      36a   const varying
     D   peCntt                       1a   const
     D                                     options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_RtnPth():   Agrega Return-path.                *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peAddr (input) = Dirección de correo para Return  *
      *                    Path. Si no llega pone desde la  *
      *                    configuración.                   *
      *                  *SYSTEM  = Configuración.          *
      *                  *CURRENT = Usuario del Job.        *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error.              *
      * --------------------------------------------------- *
     D MAIL_RtnPth     pr            10i 0
     D   peMime                     256a   const varying
     D   peAddr                     256a   const varying
     D                                     options(*nopass)

      * --------------------------------------------------- *
      * MAIL_Sender(): Agrega el Sender:                    *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peAddr (input) = Dirección de correo de prFrom    *
      *                    *SYSTEM = Saca de configuración. *
      *                    *CURRENT= Usuario del Job.       *
      *                                                     *
      * Retorna 0 si todo ok, -1 si error.                  *
      * --------------------------------------------------- *
     D MAIL_Sender     pr            10i 0
     D   peMime                     256a   const varying
     D   peAddr                     256a   const varying

      * --------------------------------------------------- *
      * MAIL_Notif(): Genera Content-Notification-To        *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peFrom (input) = Nombre del remitente.            *
      *   peFAdr (input) = Dirección de correo de peFrom    *
      *                  *SYSTEM = Usa configuración        *
      *                  *CURRENT= Usario del job.          *
      *                                                     *
      * Retorna 0 si todo ok, -1 si error.                  *
      * --------------------------------------------------- *
     D MAIL_Notif      pr            10i 0
     D   peMime                     256a   const varying
     D   peFAdr                     256a   const varying

      * --------------------------------------------------- *
      * MAIL_doCmd(): Ejecuta comando.                      *
      *                                                     *
      *   peCmd  (input) = Comando a ejecutar.              *
      *                                                     *
      * Retorna *zeros si ok, -1 si error.                  *
      * --------------------------------------------------- *
     D MAIL_doCmd      pr            10i 0
     D   peCmd                     5000a   const

      * --------------------------------------------------- *
      * MAIL_SplfNam(): Obtiene nombre de pdf para un spool.*
      *                                                     *
      *   peSplf (input) = Archivo Spool a buscar.          *
      *                                                     *
      * Retorna nombre encontrado o nombre spool + '.pdf'   *
      * --------------------------------------------------- *
     D MAIL_SplfNam    pr           256a
     D   peSplf                      10a   const

      * --------------------------------------------------- *
      * MAIL_GetDire(): Obtiene entrada de directorio.      *
      *                                                     *
      *   peUser (input) = Usuario.                         *
      *                                                     *
      * Retorna ds like(DireEnt_t).                         *
      * --------------------------------------------------- *
     D MAIL_GetDire    pr                  likeds(DireEnt_t)
     D   peUser                      10a   const

      * *************************************************** *
      *             W  R  A  P  P  E  R  S                  *
      * *************************************************** *

      * --------------------------------------------------- *
      * MAIL_SndSplf():   Enviar múltiples archivos de spool*
      *                   en PDF.                           *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                  *SYSTEM = Toma de configuración.   *
      *                  *CURRENT= Usuario del Job.         *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peSplf (input)  = Archivo de spool.               *
      *                     Ver DS DsSpool_t.               *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peZip  (input)  = Zipear si/no.                   *
      *   peZipn (input)  = Nombre Zip.                     *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_SndSplf    pr            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                     512a   const varying
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peSplf                            likeds(DsSpool_t)
     D                                     dim(9999)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peZip                        4a   const
     D                                     options(*nopass:*omit)
     D   peZipn                      50a   options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_SndiFile(): Enviar un archivo i (en csv).      *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                 *SYSTEM = Toma de configuración.    *
      *                 *CURRENT= Usuario del Job.          *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peFile (input)  = Nombre de archivo.              *
      *   peLibr (input)  = Nombre del spool.               *
      *   peMbrn (input)  = Miembro para LIBR/FILE.         *
      *                     Nombre.                         *
      *                     *FIRST (omisión).               *
      *                     *LAST.                          *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peZip  (input)  = Zipear.                         *
      *   peNotf (input)  = Acuse de recibo.                *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_SndiFile   pr            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                     512a   const varying
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peFile                      10a   const
     D   peLibr                      10a   const
     D   peMbrn                      10a   const
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peZip                        4a   const
     D                                     options(*nopass:*omit)
     D   peNotf                       4a   const
     D                                     options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_SndEmail(): Procedimiento wrapper para los     *
      *                  demás procedimientos.              *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                 *SYSTEM = Usuario de configuración. *
      *                 *CURRENT= Usuario del Job.          *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peRply (input)  = Responder a.                    *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peAttf (input)  = Archivos a adjuntar.            *
      *   peAttd (input)  = Borrar los archivos adjuntos.   *
      *   peZip  (input)  = Zipear todos juntos.            *
      *   peZipn (input)  = Nombre archivo Zip.             *
      *   peNotf (input)  = Acuse de recibo.                *
      *   peAttn (input)  = Nombres de los adjuntos.        *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_SndEmail   pr            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                     512a   const varying
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peRply                     256a   const varying
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peAttf                     255a   dim(10)
     D                                     options(*nopass:*omit)
     D   peAttd                       4a   options(*nopass:*omit)
     D   peZip                        4a   options(*nopass:*omit)
     D   peZipn                      50a   options(*nopass:*omit)
     D   peNotf                       4a   options(*nopass:*omit)
     D   peAttn                     256a   dim(10) options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_SndLmail(): Envia correo con mensaje "largo"   *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                 *SYSTEM = Usuario de configuración. *
      *                 *CURRENT= Usuario del Job.          *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peRply (input)  = Responder a.                    *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peAttf (input)  = Archivos a adjuntar.            *
      *   peAttd (input)  = Borrar los archivos adjuntos.   *
      *   peZip  (input)  = Zipear todos juntos.            *
      *   peZipn (input)  = Nombre archivo Zip.             *
      *   peNotf (input)  = Acuse de recibo.                *
      *   peSub2 (input)  = Asunto largo.                   *
      *   peAttn (input)  = Nombres de los adjuntos.        *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_SndLmail   pr            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                    5000a   const
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peRply                     256a   const varying
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peAttf                     255a   dim(10)
     D                                     options(*nopass:*omit)
     D   peAttd                       4a   options(*nopass:*omit)
     D   peZip                        4a   options(*nopass:*omit)
     D   peZipn                      50a   options(*nopass:*omit)
     D   peNotf                       4a   options(*nopass:*omit)
     D   peSub2                     270a   const varying
     D                                     options(*nopass:*omit)
     D   peAttn                     256a   dim(10) options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_SndBmail(): Envia correo con mensaje "largo"   *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *                 *SYSTEM = Usuario de configuración. *
      *                 *CURRENT= Usuario del Job.          *
      *   peFadr (input)  = Dirección remitente.            *
      *   peSubj (input)  = Asunto del mensaje.             *
      *                   Si Sensitivity = 3, agrega la pala*
      *                   bra "*Confidencial'.              *
      *   peMens (input)  = Mensaje.                        *
      *                   Esto se copia TAL CUAL llega, por *
      *                   lo tanto el usuario debe formatear*
      *                   lo previamente.                   *
      *   peCntt (input)  = Tipo de Contenido del cuerpo.   *
      *                   T = text/plain.                   *
      *                   H = text/html.                    *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peRply (input)  = Responder a.                    *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *   peAttf (input)  = Archivos a adjuntar.            *
      *   peAttd (input)  = Borrar los archivos adjuntos.   *
      *   peZip  (input)  = Zipear todos juntos.            *
      *   peZipn (input)  = Nombre archivo Zip.             *
      *   peNotf (input)  = Acuse de recibo.                *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_SndBmail   pr            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peSubj                      70a   const varying
     D   peMens                   65535a   const
     D   peCntt                       1a   const
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peRply                     256a   const varying
     D                                     options(*nopass:*omit)
     D   peImpo                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peSens                      10i 0 const
     D                                     options(*nopass:*omit)
     D   pePrio                      10i 0 const
     D                                     options(*nopass:*omit)
     D   peAttf                     255a   dim(10)
     D                                     options(*nopass:*omit)
     D   peAttd                       4a   options(*nopass:*omit)
     D   peZip                        4a   options(*nopass:*omit)
     D   peZipn                      50a   options(*nopass:*omit)
     D   peNotf                       4a   options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_SndFdsg(): Envía diseño de archivo.            *
      *                                                     *
      *   peFrom (input)  = Nombre remitente.               *
      *   peFadr (input)  = Dirección remitente.            *
      *   peTo   (input)  = Nombres de Destinatarios.       *
      *   peToad (input)  = Direcciones destinatarios.      *
      *   peToty (input)  = Tipo de Destinatarios.          *
      *   peFile (input)  = Archivo.                        *
      *   peImpo (input)  = Importancia.                    *
      *   peSens (input)  = Sensibilidad.                   *
      *   pePrio (input)  = Prioridad.                      *
      *                                                     *
      * Retorna 0 si todo ok, o -1 si error.                *
      * --------------------------------------------------- *
     D MAIL_SndFdsg    pr            10i 0
     D   peFrom                      64a   const varying
     D   peFadr                     256a   const varying
     D   peTo                        50a   dim(100)
     D   peToad                     256a   dim(100)
     D   peToty                      10i 0 dim(100)
     D   peFile                            likeds(QualDBName_t)

      * --------------------------------------------------- *
      * MAIL_Domain():  Retornar dominio.                   *
      *                                                     *
      *   peDomi (output) = Dominio.                        *
      *                                                     *
      * Retorna 0 si OK, -1 si error.                       *
      * --------------------------------------------------- *
     D MAIL_Domain     pr            10i 0
     D   peDomi                      50a

      * --------------------------------------------------- *
      * MAIL_chkUsrAddr(): Retorna si un perfil tiene o no  *
      *                    cargado mail.                    *
      *                                                     *
      *   peUser (input)  = Perfil de Usuario.              *
      *   peDire (output) = Entrada de directorio (opcional)*
      *                                                     *
      * Retorna *ON si tiene, *OFF si no tiene              *
      * --------------------------------------------------- *
     D MAIL_chkUsrAddr...
     D                 pr             1N
     D  peUser                       10a   const
     D  peDire                             likeds(DireEnt_t)
     D                                     options(*nopass)

      * --------------------------------------------------- *
      * MAIL_LSubject():Crea asunto largo del Mail.         *
      *                                                     *
      *   peMime (input) = Archivo MIME (parámetro retornado*
      *                    por CrtMime(). En este momento,  *
      *                    debe existir.                    *
      *   peSubj (input) = Asunto del mail                  *
      *                                                     *
      * Retorna 0 si todo bien, o -1 si error               *
      * --------------------------------------------------- *
     D MAIL_LSubject   pr            10i 0
     D   peMime                     256a   const varying
     D   peSubj                     270a   const varying

      * --------------------------------------------------- *
      * MAIL_getReceipt(): Obtiene destinatarios de un      *
      *                    proceso/subproceso.              *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso (opcional).          *
      *   peRprp (output) = Registro GNTPRP.                *
      *   peActi (input)  = Recuperar solo activos.         *
      *                                                     *
      * Retorna cantidad de destinatarios.                  *
      * --------------------------------------------------- *
     D MAIL_getReceipt...
     D                 pr            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const options(*omit)
     D   peRprp                            likeds(recprp_t) dim(100)
     D   peActi                       1N   const options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_getFrom():  Obtiene FROM de un proceso/subproce*
      *                  so.                                *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peRemi (output) = Remitente.                      *
      *                                                     *
      * Retorna: 1 si OK                                    *
      *         -1 si NO OK                                 *
      * --------------------------------------------------- *
     D MAIL_getFrom    pr            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peRemi                            likeds(Remitente_t)

      * --------------------------------------------------- *
      * MAIL_getAttList(): Obtiene lista de adjuntos de un  *
      *                    proceso/subproceso.              *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peAttl (output) = Lista de archivos.              *
      *                                                     *
      * Retorna: <> -1 Cantidad de adjuntos                 *
      *         -1 si NO OK                                 *
      * --------------------------------------------------- *
     D MAIL_getAttList...
     D                 pr            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peAttl                     255a   dim(10)

      * --------------------------------------------------- *
      * MAIL_getBody():  Obtiene el body de un proceso/sub- *
      *                    proceso.                         *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peBody (output) = Body.                           *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *         -1 si NO OK                                 *
      * --------------------------------------------------- *
     D MAIL_getBody    pr            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peBody                     512a   varying

      * --------------------------------------------------- *
      * MAIL_getLBody(): Obtiene el body de un proceso/sub- *
      *                    proceso.                         *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peBody (output) = Body.                           *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *         -1 si NO OK                                 *
      * --------------------------------------------------- *
     D MAIL_getLBody   pr            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peBody                    5000a

      * --------------------------------------------------- *
      * MAIL_isLongBody(): Retorna si un proceso/subproceso *
      *                    tiene body largo o no.           *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *                                                     *
      * Retorna: *ON es Long Body                           *
      *          *OFF no lo es    (omisión)                 *
      * --------------------------------------------------- *
     D MAIL_isLongBody...
     D                 pr             1N
     D   peCprc                      20a   const
     D   peCspr                      20a   const

      * --------------------------------------------------- *
      * MAIL_mustZip(): Retorna si un proceso/subproceso    *
      *                 debe zipear sus adjuntos.           *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peZipn (output) = Nombre de zip (opcional)        *
      *                                                     *
      * Retorna: *ON debe zipear  (omisión)                 *
      *          *OFF no debe zipear                        *
      * --------------------------------------------------- *
     D MAIL_mustZip    pr             1N
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peZipn                      50a   options(*nopass:*omit)

      * --------------------------------------------------- *
      * MAIL_getOptions(): Retorna las opciones de un proce-*
      *                    so/subproceso.                   *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peOpti (output) = Opciones                        *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *          -1 si error                                *
      * --------------------------------------------------- *
     D MAIL_getOptions...
     D                 pr            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peOpti                            likeds(MailOpts_t)

      * --------------------------------------------------- *
      * MAIL_getSubject(): Retorna asunto de un proceso/sub-*
      *                    proceso.                         *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peSubj (output) = Asunto.                         *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *          -1 si error                                *
      * --------------------------------------------------- *
     D MAIL_getSubject...
     D                 pr            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peSubj                      70a   varying

      * --------------------------------------------------- *
      * MAIL_getReplyTo(): Retorna mail de destinatario     *
      *                    Reply-To                         *
      *                                                     *
      *   peCprc (input)  = Proceso.                        *
      *   peCspr (input)  = SubProceso.                     *
      *   peRpyt (output) = Mail Reply-To                   *
      *                                                     *
      * Retorna: 0 si OK                                    *
      *          -1 si error                                *
      * --------------------------------------------------- *
     D MAIL_getReplyTo...
     D                 pr            10i 0
     D   peCprc                      20a   const
     D   peCspr                      20a   const
     D   peRpyt                      50a   varying

