      /if defined(SVPDAF_H)
      /eof
      /endif
      /define SVPDAF_H

      /copy './qcpybooks/svpmail_h.rpgle'

      * Numero de Dato Filiatorio Inexistente...
     D SVPDAF_DAFIN    c                   const(0001)
      * Fecha de Base de impuestos inválida...
     D SVPDAF_FEBII    c                   const(0002)
      * Ingresar Nro de Inscripcion a Ingresos Brutos
     D SVPDAF_NRIBR    c                   const(0003)
      * Estado de Registro debe ser Si=0 o No=1
     D SVPDAF_ESTRG    c                   const(0004)
      * Datos de Provincias duplicados
     D SVPDAF_DPROV    c                   const(0005)
      * Asegurado sin CBU
     D SVPDAF_DAFCB    c                   const(0006)
      * Asegurado sin CBU Activa
     D SVPDAF_DAFCA    c                   const(0007)
      * No existe CBU para Asegurado
     D SVPDAF_CBUIA    c                   const(0008)
      * Mail ya Existente...
     D SVPDAF_MAILE    c                   const(0009)
      * Mail Inexistente...
     D SVPDAF_MAILI    c                   const(0010)
      * Mail Invalido...
     D SVPDAF_MERRO    c                   const(0011)
      * Marca de Fumador invalida...
     D SVPDAF_MAFUI    c                   const(0020)
      * Marca Zurdo invalida...
     D SVPDAF_MAZUI    c                   const(0021)
      * Marca Pago Aporte Previsional invalida...
     D SVPDAF_MPAPI    c                   const(0022)
      * Marca Sujeto Exterior invalida...
     D SVPDAF_MSUEI    c                   const(0023)
      * Marca Empadronamiento AFIP invalida...
     D SVPDAF_MEMAI    c                   const(0024)
      * Marca Acreedor Prendario invalida...
     D SVPDAF_MACPI    c                   const(0025)
      * Dato Filiatorio Telefonico Inexistente...
     D SVPDAF_DATEI    c                   const(0026)
      * Dato Filiatorio Telefonico Existente...
     D SVPDAF_DATEE    c                   const(0027)
      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPDAF_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

     D dsProI_t        ds                  qualified based(template)
     D   Rpro                         2  0
     D   Fech                         8  0
     D   Nri1                        13  0
     D   Nri2                        13  0
     D   Nri3                        13  0
     D   Nri4                        13  0
     D   Iim1                        15  2
     D   Strg                         1
     D   Nnib                        14

     D dsNomb_t        ds                  qualified based(template)
     D   nomb                        40
     D   nom1                        40

     D dsDomi_t        ds                  qualified based(template)
     D   domi                        35
     D   copo                         5p 0
     D   cops                         1p 0
     D   ndom                         5p 0
     D   piso                         3p 0
     D   deto                         4
     D   dom1                        35
     D   cop1                         5p 0
     D   cos1                         1p 0
     D   dom2                        50

     D dsDocu_t        ds                  qualified based(template)
     D   tido                         2p 0
     D   nrdo                         8p 0
     D   tiso                         2p 0
     D   cuit                        11
     D   cuil                        11p 0

     D dsCont_t        ds                  qualified based(template)
     D   teln                         7p 0
     D   faxn                         7p 0
     D   tel1                         7p 0
     D   tpa1                        20
     D   tpa2                        20
     D   ttr1                        20
     D   ttr2                        20
     D   tcel                        20
     D   tpag                        20
     D   tfa1                        20
     D   tfa2                        20
     D   tfa3                        20
     D   pweb                        50

     D dsNaci_t        ds                  qualified based(template)
     D   fnac                         8p 0
     D   lnac                        30
     D   pain                         5p 0
     D   cnac                         3p 0

     D dsMarc_t        ds                  qualified based(template)
     D   mfum                         1
     D   mzur                         1
     D   mar1                         1
     D   mar2                         1
     D   mar3                         1
     D   mar4                         1

     D dsCbuS_t        ds                  qualified based(template)
     D   ncbu                        22
     D   fech                         8  0

     D dsDape_t        ds                  qualified based(template)
     D   sexo                         1p 0
     D   esci                         1p 0
     D   pesk                         5p 2
     D   estm                         3p 2
     D   cprf                         3p 0
     D   raae                         3p 0

     D dsClav_t        ds                  qualified based(template)
     D   cciu                         6p 0
     D   ccdi                        11

      * Archivo General de Datos Filiatorios
     D DsDafAseg_t     ds                  qualified template
     d   dfnrdf                       7P 0
     d   dfnomb                      40
     d   dfdomi                      35
     d   dfcopo                       5P 0
     d   dfcops                       1P 0
     d   dfteln                       7P 0
     d   dftido                       2P 0
     d   dfnrdo                       8P 0
     d   dfcuit                      11
     d   dffaxn                       7P 0
     d   dftiso                       2P 0
     d   dfrega                       1
     d   dfnjub                      11P 0
     d   dfndom                       5P 0
     d   dfpiso                       3P 0
     d   dfdeto                       4
     d   locopo                       5P 0
     d   locops                       1P 0
     d   loloca                      25
     d   loproc                       3
     d   loteld                       5
     d   loscta                       1P 0

     D DsTelPublic_t   ds                  qualified based(template)
     D   dfNrdf                       7P 0
     D   dfNtel                      20
     D   dfTipt                       2
     D   dfMar1                       1
     D   dfMar2                       1
     D   dfMar3                       1
     D   dfMar4                       1
     D   dfMar5                       1
     D   dfuser                      10p 0
     D   dfFech                       8p 0
     D   dfTime                       6

     D DsMailDa7_t     ds                  qualified based(template)
     D   dfNrdf                       7P 0
     D   dfMail                      50
     D   dfCtce                       2p 0
     D   dfMar1                       1
     D   dfMar2                       1
     D   dfMar3                       1
     D   dfMar4                       1
     D   dfMar5                       1
     D   dfMar6                       1
     D   dfMar7                       1
     D   dfMar8                       1
     D   dfMar9                       1
     D   dfMar0                       1
     D   dfuser                      10
     D   dfdate                       6P 0
     D   dftime                       6P 0

      * ------------------------------------------------------------ *
      * SVPDAF_chkDaf(): Chequea si existe Dato Filiatorio           *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDaf...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_chkDatoF: Chequea si puede grabar en GNHDAF           *
      *                                                              *
      *     peNomb   (input)   Nombre                                *
      *     peDomi   (input)   Domicilio                             *
      *     peNdom   (input)   Nro. Domicilio                        *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTiso   (input)   Tipo de Sociedad                      *
      *     peTido   (input)   Tipo Documento                        *
      *     peNrdo   (input)   Nro. Documento                        *
      *     peDocu   (input)   Estructura Documentos (opcional)      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDatoF...
     D                 pr              n
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peNdom                       5  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTiso                       2  0 const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peDocu                            likeDs(dsDocu_t) const
     D                                     options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato1:  Chequea si puede grabar en GNHDA1          *
      *                                                              *
      *     peTiso   (input)   Tipo de Sociedad                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     pePain   (input)   Código de Pais                        *
      *     peCnac   (input)   Código de Nacionalidad                *
      *     peMfum   (input)   Código de Marca Fumador               *
      *     peMzur   (input)   Código de Marca Zurdo                 *
      *     peMar1   (input)   Código de Marca Pago Aporte Prev.     *
      *     peMar2   (input)   Código de Marca Sujeto Exterior       *
      *     peMar3   (input)   Código de Marca Emp. AFIP             *
      *     peMar4   (input)   Código de Marca Acreedor Prendario    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDato1...
     D                 pr              n
     D   peTiso                       2  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   pesexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato2: Valida Datos de Provincia IIBB              *
      *                                                              *
      *     peRpro   (input)   Provincia                             *
      *     peFtia   (input)   Año                                   *
      *     peFtim   (input)   Mes                                   *
      *     peFtid   (input)   Dia                                   *
      *     peNri1   (input)   Nro Insc Ibr                          *
      *     peNri2   (input)   Nro Insc Ibr C Mult                   *
      *     peNri3   (input)   Nro Insc Ibr Nuevo                    *
      *     peNri4   (input)   Nro Insc Impuesto                     *
      *     peIim1   (input)   Importe Nri1                          *
      *     peStrg   (input)   Hacer Percepcion                      *
      *     peNnib   (input)   Nro Nuevo Ibr                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDato2...
     D                 pr              n
     D   peRpro                       2  0 const
     D   peFech                       8  0 const
     D   peNri1                      13  0 const
     D   peNri2                      13  0 const
     D   peNri3                      13  0 const
     D   peNri4                      13  0 const
     D   peIim1                      15  2 const
     D   peStrg                       1    const
     D   peNnib                      14    const

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato6:  Chequea si puede grabar en GNHDA6          *
      *                                                              *
      *     pePweb   (input)   Pagina Web                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDato6...
     D                 pr              n
     D   pePweb                      50    const

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato7: Valida para Grabar en GNHDA7                *
      *                                                              *
      *     peCtce   (input)   Tipo de Mail                          *
      *     peMail   (input)   Mail                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDato7...
     D                 pr              n
     D   peCtce                       2  0 const
     D   peMail                      50    const

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato8: Valida CBU para pago de Siniestros          *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peFech   (input)   Fecha Desde                           *
      *     peNcbu   (input)   CBU                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDato8...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peFech                       8  0 const
     D   peNcbu                      22a   const

      * ------------------------------------------------------------ *
      * SVPDAF_getNroDaf(): Retorna NUEVO Numero de Dato Filiatorio  *
      *                                                              *
      * Retorna: NUEVO Numero de Dato Filiatorio                     *
      * ------------------------------------------------------------ *
     D SVPDAF_getNroDaf...
     D                 pr             7  0

      * ------------------------------------------------------------ *
      * SVPDAF_getDaf: Retorna GNHDAF                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (output)  Nombre                                *
      *     peDomi   (output)  Domicilio                             *
      *     peNdom   (output)  Nro. Domicilio                        *
      *     pePiso   (output)  Piso                                  *
      *     peDeto   (output)  Departamento                          *
      *     peCopo   (output)  Codigo Postal                         *
      *     peCops   (output)  SubCodigo Postal                      *
      *     peTeln   (output)  Nro. Telefono                         *
      *     peFaxn   (output)  Nro. Fax                              *
      *     peTiso   (output)  Tipo de Sociedad                      *
      *     peTido   (output)  Tipo Documento                        *
      *     peNrdo   (output)  Nro. Documento                        *
      *     peCuit   ((output) CUIT                                  *
      *     peNjub   (output)  Nro. Jubilacion                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDaf...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40
     D   peDomi                      35
     D   peNdom                       5  0
     D   pePiso                       3  0
     D   peDeto                       4
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peTeln                       7  0
     D   peFaxn                       7  0
     D   peTiso                       2  0
     D   peTido                       2  0
     D   peNrdo                       8  0
     D   peCuit                      11
     D   peNjub                      11  0

      * ------------------------------------------------------------ *
      * SVPDAF_getDa1: Retorna GNDA1                                 *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (output)  Nombre Alternativo                    *
      *     peDomi   (output)  Domicilio Postal                      *
      *     peCopo   (output)  Codigo Postal                         *
      *     peCops   (output)  SubCodigo Postal                      *
      *     peTeln   (output)  Telefono                              *
      *     peFnac   (output)  Fecha de Nacimiento                   *
      *     peCprf   (output)  Codigo de Profesion                   *
      *     peSexo   (output)  Codigo de Sexo                        *
      *     peEsci   (output)  Código de estado Civil                *
      *     peRaae   (output)  Código de Rama Actividad Económica    *
      *     peCiiu   (output)  Ciiu                                  *
      *     peDom2   (output)  Domicilio                             *
      *     pePesk   (output)  Peso                                  *
      *     peEstm   (output)  Estatura                              *
      *     peMfum   (output)  Marca de Fuma                         *
      *     peMzur   (output)  Marca de Zurdo                        *
      *     peMar1   (output)  Pago Aporte Previsional               *
      *     peMar2   (output)  Sujeto Exterior                       *
      *     peMar3   (output)  Constancia Empadronamiento AFIP       *
      *     peMar4   (output)  Acreedor Prendario                    *
      *     peCcdi   (output)  Clave Tributaria                      *
      *     pePain   (output)  Pais de Nacimiento                    *
      *     peCnac   (output)  Nacionalidad                          *
      *                                                              *
      * Retorna: *On / *Off                                          *
     D SVPDAF_getDa1...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40
     D   peDomi                      35
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peTeln                       7  0
     D   peFnac                       8  0
     D   peCprf                       3  0
     D   peSexo                       1  0
     D   peEsci                       1  0
     D   peRaae                       3  0
     D   peCiiu                       6  0
     D   peDom2                      50
     D   peLnac                      30
     D   pePesk                       5  2
     D   peEstm                       3  2
     D   peMfum                       1
     D   peMzur                       1
     D   peMar1                       1
     D   peMar2                       1
     D   peMar3                       1
     D   peMar4                       1
     D   peCcdi                      11
     D   pePain                       5  0
     D   peCnac                       3  0

      * ------------------------------------------------------------ *
      * SVPDAF_getDa2: Retorna GNHDA2                                *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peLibr   (output)  Estructura GNHDA2                     *
      *     peLibrC  (output)  Cant Estructura GNHDA2                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDa2...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peLibr                            likeds( dsProI_t ) dim(999)
     D   peLibrC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDAF_getDa4(): Retorna textos de Dato Filiatorio           *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peText   (output)  Vector de Textos                      *
      *     peTextC  (output)  Cantidad Vector de Textos             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDa4...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peText                      79    dim(999)
     D   peTextC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDAF_getDa6: Retorna GNHDA6                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peTpa1   (output)  Telefono Particular #1                *
      *     peTpa2   (output)  Telefono Particular #2                *
      *     peTtr1   (output)  Telefono Trabajo #1                   *
      *     peTtr2   (output)  Telefono Trabajo #2                   *
      *     peTcel   (output)  Telefono Celular                      *
      *     peTpag   (output)  Telefono Pager                        *
      *     peTfa1   (output)  Telefono Fax #1                       *
      *     peTfa2   (output)  Telefono Fax #2                       *
      *     peTfa3   (output)  Telefono Fax #3                       *
      *     pePweb   (output)  Pagina Web                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDa6...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peTpa1                      20
     D   peTpa2                      20
     D   peTtr1                      20
     D   peTtr2                      20
     D   peTcel                      20
     D   peTpag                      20
     D   peTfa1                      20
     D   peTfa2                      20
     D   peTfa3                      20
     D   pePweb                      50

      * ------------------------------------------------------------ *
      * SVPDAF_getDa7: Retorna GNHDA7                                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (output)  DS con los mails (ver MailAddr_t en   *
      *     peMailC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDa7...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) dim(100)
     D   peMailC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDAF_getDa8: Retorna CBU de Siniestro                      *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNcbu   (input)   CBU                                   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDa8...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNcbu                      22a

      * ------------------------------------------------------------ *
      * SVPDAF_getDatoFiliatorio(): Retorna Todo el Dato Filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (output)  Estructura Nombres                    *
      *     peDomi   (output)  Estructura Domicilios                 *
      *     peDocu   (output)  Estructura Documentos                 *
      *     peCont   (output)  Estructura Telefonos/Pagina Web       *
      *     peNaci   (output)  Estructura Nacimiento                 *
      *     peMarc   (output)  Estructura Marcas Varias              *
      *     peCbuS   (output)  Estructura CBU Siniestros             *
      *     peDape   (output)  Estructura Datos Personales           *
      *     peClav   (output)  Estructura Claves Tributarias         *
      *     peText   (output)  Estructura Texto                      *
      *     peTextC  (output)  Cantidad Texto                        *
      *     peProv   (output)  Estructura Provincias IIBB            *
      *     peProvC  (output)  Cantidad Provincias IIBB              *
      *     peMail   (output)  Estructura Mails                      *
      *     peMailC  (output)  Cantidad Mails                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDatoFiliatorio...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                            likeDs(dsNomb_t)
     D   peDomi                            likeDs(dsDomi_t)
     D   peDocu                            likeDs(dsDocu_t)
     D   peCont                            likeDs(dsCont_t)
     D   peNaci                            likeDs(dsNaci_t)
     D   peMarc                            likeDs(dsMarc_t)
     D   peCbuS                            likeDs(dsCbuS_t)
     D   peDape                            likeDs(dsDape_t)
     D   peClav                            likeDs(dsClav_t)
     D   peText                      79    dim(999)
     D   peTextC                     10i 0
     D   peProv                            likeDs(dsProI_t) dim(999)
     D   peProvC                     10i 0
     D   peMail                            likeds(Mailaddr_t) dim(100)
     D   peMailC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDAF_getNombre(): Retorna Nombre de Dato Filiatorio        *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNom1   (input)   Nombre Alternativo                    *
      *                                                              *
      * Retorna: Nombre                                              *
      * ------------------------------------------------------------ *
     D SVPDAF_getNombre...
     D                 pr            40
     D   peNrdf                       7  0 const
     D   peNom1                      40    options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_getDomicilio(): Retorna Domicilio de Dato Filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDomi   (output)  Domicilio                             *
      *     peNdom   (output)  Nro de Domicilio                      *
      *     pePiso   (output)  Piso                                  *
      *     peDeto   (output)  Departamento                          *
      *     peDom1   (output)  Domicilio 1                           *
      *     peDom2   (output)  Domicilio 2                           *
      *                                                              *
      * Retorna: Domicilio                                           *
      * ------------------------------------------------------------ *
     D SVPDAF_getDomicilio...
     D                 pr            35
     D   peNrdf                       7  0 const
     D   peNdom                       5  0 options(*Omit:*Nopass)
     D   pePiso                       3  0 options(*Omit:*Nopass)
     D   peDeto                       4    options(*Omit:*Nopass)
     D   peDom1                      35    options(*Omit:*Nopass)
     D   peDom2                      50    options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_getLocalidad(): Retorna Localidad de Dato Filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peCopo   (output)  Codigo Postal                         *
      *     peCops   (output)  SubCodigo Postal                      *
      *     peLoca   (output)  Localidad                             *
      *     peCop1   (output)  Codigo Postal                         *
      *     peCos1   (output)  SubCodigo Postal                      *
      *     peLoc1   (output)  Localidad                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getLocalidad...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peLoca                      25    options(*Omit:*Nopass)
     D   peCop1                       5  0 options(*Omit:*Nopass)
     D   peCos1                       1  0 options(*Omit:*Nopass)
     D   peLoc1                      25    options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_getDocumento(): Retorna Documento de Dato Filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peTido   (output)  Tipo Documento                        *
      *     peNrdm   (output)  Nro Documento                         *
      *     peCuit   (output)  CUIT                                  *
      *     peCuil   (output)  CUIL                                  *
      *     peDtdo   (output)  Descripcion Tipo de Documento         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDocumento...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peTido                       2  0 options(*Omit:*Nopass)
     D   peNrdo                       8  0 options(*Omit:*Nopass)
     D   peCuit                      11    options(*Omit:*Nopass)
     D   peCuil                      11  0 options(*Omit:*Nopass)
     D   peDtdo                      20    options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_getFechaNac(): Retorna Fec de Nacimiento              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: Fecha de Nacimiento                                 *
      * ------------------------------------------------------------ *
     D SVPDAF_getFechaNac...
     D                 pr             8  0
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_getPaisDeNac(): Retorna Pais de Nacimiento            *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     pePaid   (output)  Descricion de Pais                    *
      *                                                              *
      * Retorna: Pais de Nacimiento                                  *
      * ------------------------------------------------------------ *
     D SVPDAF_getPaisDeNac...
     D                 pr             5  0
     D   peNrdf                       7  0 const
     D   pePaid                      30    options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_getNacionalidad(): Retorna Nacionalidad               *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDnac   (output)  Descricion de Nacionalidad            *
      *                                                              *
      * Retorna: Nacionalidad                                        *
      * ------------------------------------------------------------ *
     D SVPDAF_getNacionalidad...
     D                 pr             3  0
     D   peNrdf                       7  0 const
     D   peDnac                      30    options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_getMailValido(): Retorna PRIMER mail valido           *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peCtce   (output)  Tipo de Mail                          *
      *                                                              *
      * Retorna: Mail                                                *
      * ------------------------------------------------------------ *
     D SVPDAF_getMailValido...
     D                 pr            50
     D   peNrdf                       7  0 const
     D   peCtce                       2  0 options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_getTipoSociedad(): Retorna Tipo de Sociedad           *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDtis   (output)  Tipo de Sociedad                      *
      *                                                              *
      * Retorna: Tipo de Sociedad                                    *
      * ------------------------------------------------------------ *
     D SVPDAF_getTipoSociedad...
     D                 pr             2  0
     D   peNrdf                       7  0 const
     D   peDtis                      25    options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_getSujetoExterior(): Retorna si es Sujeto Exterior    *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: Marca                                               *
      * ------------------------------------------------------------ *
     D SVPDAF_getSujetoExterior...
     D                 pr             1
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_getProfesion(): Retorna Profesion                     *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDprf   (input)   Descripcion de Prfecion               *
      *                                                              *
      * Retorna: Tipo de Profesion                                   *
      * ------------------------------------------------------------ *
     D SVPDAF_getProfesion...
     D                 pr             3  0
     D   peNrdf                       7  0 const
     D   peDprf                      25    options(*Omit:*Nopass)

      * ------------------------------------------------------------ *
      * SVPDAF_setDaf: Graba GNHDAF                                  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre                                *
      *     peDomi   (input)   Domicilio                             *
      *     peNdom   (input)   Nro. Domicilio                        *
      *     pePiso   (input)   Piso                                  *
      *     peDeto   (input)   Departamento                          *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Nro. Telefono                         *
      *     peFaxn   (input)   Nro. Fax                              *
      *     peTiso   (input)   Tipo de Sociedad                      *
      *     peTido   (input)   Tipo Documento                        *
      *     peNrdo   (input)   Nro. Documento                        *
      *     peCuit   (input)   CUIT                                  *
      *     peNjub   (input)   Nro. Jubilacion                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDaf...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peNdom                       5  0 const
     D   pePiso                       3  0 const
     D   peDeto                       4    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFaxn                       7  0 const
     D   peTiso                       2  0 const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peCuit                      11    const
     D   peNjub                      11  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_setDa1: Graba GNHDA1                                  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre Alternativo                    *
      *     peDomi   (input)   Domicilio Postal                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Telefono                              *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     peCiiu   (input)   Ciiu                                  *
      *     peDom2   (input)   Domicilio                             *
      *     pePesk   (input)   Peso                                  *
      *     peEstm   (input)   Estatura                              *
      *     peMfum   (input)   Marca de Fuma                         *
      *     peMzur   (input)   Marca de Zurdo                        *
      *     peMar1   (input)   Pago Aporte Previsional               *
      *     peMar2   (input)   Sujeto Exterior                       *
      *     peMar3   (input)   Constancia Empadronamiento AFIP       *
      *     peMar4   (input)   Acreedor Prendario                    *
      *     peCcdi   (input)   Clave Tributaria                      *
      *     pePain   (input)   Pais de Nacimiento                    *
      *     peCnac   (input)   Codigo de Nacionalidad                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa1...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peSexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   peCiiu                       6  0 const
     D   peDom2                      50    const
     D   peLnac                      30    const
     D   pePesk                       5  2 const
     D   peEstm                       3  2 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peCcdi                      11    const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_setDa2:      Graba Dato Filiatorio por Provincia IIBB *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peRpro   (input)   Provincia                             *
      *     peFtia   (input)   Año                                   *
      *     peFtim   (input)   Mes                                   *
      *     peFtid   (input)   Dia                                   *
      *     peNri1   (input)   Nro Insc Ibr                          *
      *     peNri2   (input)   Nro Insc Ibr C Mult                   *
      *     peNri3   (input)   Nro Insc Ibr Nuevo                    *
      *     peNri4   (input)   Nro Insc Impuesto                     *
      *     peIim1   (input)   Importe Nri1                          *
      *     peStrg   (input)   Hacer Percepcion                      *
      *     peNnib   (input)   Nro Nuevo Ibr                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa2...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peRpro                       2  0 const
     D   peFech                       8  0 const
     D   peNri1                      13  0 const
     D   peNri2                      13  0 const
     D   peNri3                      13  0 const
     D   peNri4                      13  0 const
     D   peIim1                      15  2 const
     D   peStrg                       1    const
     D   peNnib                      14    const

      * ------------------------------------------------------------ *
      * SVPDAF_setDa2Lista:      Graba Lista de Datos Filiatorios    *
      *                        por Provincia IIBB                    *
      *     peNrdf   (input)   Nro de Asegurado                      *
      *     peLibr   (input)   Listado de DAF por Provinicias IBR    *
      *     peLibrC  (input)   Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa2Lista...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peLibr                            likeds( dsProI_t ) dim(999)
     D                                     const
     D   peLibrC                     10i 0 const

      * ------------------------------------------------------------ *
      * SVPDAF_setDa4():    Graba textos de Dato Filiatorio          *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peText   (input)   Vector de Textos                      *
      *     peTextC  (input)   Cantidad Vector de Textos             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa4...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peText                      79    dim(999) const
     D   peTextC                     10i 0 const

      * ------------------------------------------------------------ *
      * SVPDAF_setDa6: Graba GNHDA6                                  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peTpa1   (input)   Telefono Particular #1                *
      *     peTpa2   (input)   Telefono Particular #2                *
      *     peTtr1   (input)   Telefono Trabajo #1                   *
      *     peTtr2   (input)   Telefono Trabajo #2                   *
      *     peTcel   (input)   Telefono Celular                      *
      *     peTpag   (input)   Telefono Pager                        *
      *     peTfa1   (input)   Telefono Fax #1                       *
      *     peTfa2   (input)   Telefono Fax #2                       *
      *     peTfa3   (input)   Telefono Fax #3                       *
      *     pePweb   (input)   Pagina Web                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa6...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peTpa1                      20    const
     D   peTpa2                      20    const
     D   peTtr1                      20    const
     D   peTtr2                      20    const
     D   peTcel                      20    const
     D   peTpag                      20    const
     D   peTfa1                      20    const
     D   peTfa2                      20    const
     D   peTfa3                      20    const
     D   pePweb                      50    const

      * ------------------------------------------------------------ *
      * SVPDAF_setDa7:  Graba Mail de Dato Filiatorio                *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (input)   Mail                                  *
      *     peMar1   (input)   Publicar en la Web Mail (Si/No)       +
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa7...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) const
     D   peMar1                       1    options( *nopass : *omit  )

      * ------------------------------------------------------------ *
      * SVPDAF_setDa7Lista:  Graba Mail de Dato Filiatorio           *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (input)   Mail                                  *
      *     peMailC  (input)   Mail                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa7Lista...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) dim(100) const
     D   peMailC                     10i 0 const

      * ------------------------------------------------------------ *
      * SVPDAF_setDa8():        Graba CBU para pago de Siniestros    *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peFech   (input)   Fecha Desde                           *
      *     peNcbu   (input)   CBU                                   *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa8...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peFech                       8  0 const
     D   peNcbu                      22a   const
     D   peUser                      10a   const

      * ------------------------------------------------------------ *
      * SVPDAF_setDatoFiliatorio(): Graba   Todo el Dato Filiatorio  *
      *                                                              *
      *     peNomb   (input)   Estructura Nombres                    *
      *     peDomi   (input)   Estructura Domicilios                 *
      *     peDocu   (input)   Estructura Documentos                 *
      *     peCont   (input)   Estructura Telefonos/Pagina Web       *
      *     peNaci   (input)   Estructura Nacimiento                 *
      *     peMarc   (input)   Estructura Marcas Varias              *
      *     peCbuS   (input)   Estructura CBU Siniestros             *
      *     peDape   (input)   Estructura Datos Personales           *
      *     peClav   (input)   Estructura Claves Tributarias         *
      *     peText   (input)   Estructura Texto                      *
      *     peTextC  (input)   Cantidad Texto                        *
      *     peProv   (input)   Estructura Provincias IIBB            *
      *     peProvC  (input)   Cantidad Provincias IIBB              *
      *     peMail   (input)   Estructura Mails                      *
      *     peMailC  (input)   Cantidad Mails                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDatoFiliatorio...
     D                 pr             7  0
     D   peNomb                            likeDs(dsNomb_t) const
     D   peDomi                            likeDs(dsDomi_t) const
     D   peDocu                            likeDs(dsDocu_t) const
     D   peCont                            likeDs(dsCont_t) const
     D   peNaci                            likeDs(dsNaci_t) const
     D   peMarc                            likeDs(dsMarc_t) const
     D   peCbuS                            likeDs(dsCbuS_t) const
     D   peDape                            likeDs(dsDape_t) const
     D   peClav                            likeDs(dsClav_t) const
     D   peText                      79    dim(999) const
     D   peTextC                     10i 0 const
     D   peProv                            likeDs(dsProI_t) dim(999) const
     D   peProvC                     10i 0 const
     D   peMail                            likeds(Mailaddr_t) dim(100) const
     D   peMailC                     10i 0 const

      * ------------------------------------------------------------ *
      * SVPDAF_updDaf: Actualiza GNHDAF                              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre                                *
      *     peDomi   (input)   Domicilio                             *
      *     peNdom   (input)   Nro. Domicilio                        *
      *     pePiso   (input)   Piso                                  *
      *     peDeto   (input)   Departamento                          *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Nro. Telefono                         *
      *     peFaxn   (input)   Nro. Fax                              *
      *     peTiso   (input)   Tipo de Sociedad                      *
      *     peTido   (input)   Tipo Documento                        *
      *     peNrdo   (input)   Nro. Documento                        *
      *     peCuit   (input)   CUIT                                  *
      *     peNjub   (input)   Nro. Jubilacion                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_updDaf...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peNdom                       5  0 const
     D   pePiso                       3  0 const
     D   peDeto                       4    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFaxn                       7  0 const
     D   peTiso                       2  0 const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peCuit                      11    const
     D   peNjub                      11  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_updDa1: Actualiza GNHDA1                              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre Alternativo                    *
      *     peDomi   (input)   Domicilio Postal                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Telefono                              *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     peCiiu   (input)   Ciiu                                  *
      *     peDom2   (input)   Domicilio                             *
      *     pePesk   (input)   Peso                                  *
      *     peEstm   (input)   Estatura                              *
      *     peMfum   (input)   Marca de Fuma                         *
      *     peMzur   (input)   Marca de Zurdo                        *
      *     peMar1   (input)   Pago Aporte Previsional               *
      *     peMar2   (input)   Sujeto Exterior                       *
      *     peMar3   (input)   Constancia Empadronamiento AFIP       *
      *     peMar4   (input)   Acreedor Prendario                    *
      *     peCcdi   (input)   Clave Tributaria                      *
      *     pePain   (input)   Pais de Nacimiento                    *
      *     peCnac   (input)   Codigo de Nacionalidad                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_updDa1...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peSexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   peCiiu                       6  0 const
     D   peDom2                      50    const
     D   peLnac                      30    const
     D   pePesk                       5  2 const
     D   peEstm                       3  2 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peCcdi                      11    const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_updDa6: Actualiza GNHDA6                              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peTpa1   (input)   Telefono Particular #1                *
      *     peTpa2   (input)   Telefono Particular #2                *
      *     peTtr1   (input)   Telefono Trabajo #1                   *
      *     peTtr2   (input)   Telefono Trabajo #2                   *
      *     peTcel   (input)   Telefono Celular                      *
      *     peTpag   (input)   Telefono Pager                        *
      *     peTfa1   (input)   Telefono Fax #1                       *
      *     peTfa2   (input)   Telefono Fax #2                       *
      *     peTfa3   (input)   Telefono Fax #3                       *
      *     pePweb   (input)   Pagina Web                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_updDa6...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peTpa1                      20    const
     D   peTpa2                      20    const
     D   peTtr1                      20    const
     D   peTtr2                      20    const
     D   peTcel                      20    const
     D   peTpag                      20    const
     D   peTfa1                      20    const
     D   peTfa2                      20    const
     D   peTfa3                      20    const
     D   pePweb                      50    const

      * ------------------------------------------------------------ *
      * SVPDAF_updDa8: Actualiza CBU para Siniestros                 *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_updDa8...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peUser                      10a   const

      * ------------------------------------------------------------ *
      * SVPDAF_dltDaf(): Elimina Dato Filiatorio                     *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dltDaf...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa1(): Elimina GNHDA1                              *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dltDa1...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa2:      Elimina dato Filiatorio por Provincia    *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dltDa2...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa2Pro:   Elimina dato Filiatorio por Provincia    *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *     peRpro   (input)   Provincia                             *
      *     peFech   (input)   Fecha Base de Impusto                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dltDa2Pro...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peRpro                       2  0 const
     D   peFech                       8  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa4():    Elimina textos de Dato Filiatorio        *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dltDa4...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_dlfDa6(): Elimina GNHDA6                              *
      *                                                              *
      *     peNrdf   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dlfDa6...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa7:  Elimina Mail de Dato Filiatorio              *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dltDa7...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_dltDatoFiliatorio(): Elimina TODO el dato filiatorio  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dltDatoFiliatorio...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDAF_inz      pr

      * ------------------------------------------------------------ *
      * SVPDAF_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPDAF_end      pr

      * ------------------------------------------------------------ *
      * SVPDAF_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPDAF_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SVPDAF_FecPriPol(): Fecha de Emisión de Primera Póliza       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peFemi   (output)  Fecha Primera Póliza Emitida          *
      *                                                              *
      * Retorna: Fecha de Emisión...                                 *
      * ------------------------------------------------------------ *
     D SVPDAF_FecPriPol...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peNrdf                       7  0 const
     D   peFemi                       8  0
      * ------------------------------------------------------------ *
      * SVPDAF_getAseguradoxDoc(): Retorna Nro. de Asegurado desde   *
      *                            Nro y Tipo de Documento.-         *
      *                                                              *
      *     peTido   (input)   Tipo de Documento                     *
      *     peNrdo   (input)   Nro de docuemnto                      *
      *                                                              *
      * Retorna: Nro de Asegurado / 0 = No encontró                  *
      * ------------------------------------------------------------ *
     D SVPDAF_getAseguradoxDoc...
     D                 pr             7  0
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
      * ------------------------------------------------------------ *
      * SVPDAF_getAseguradoxCuit(): Retorna Nro. de Asegurado desde  *
      *                            Cuit.-                            *
      *                                                              *
      *     peCuit   (input)   Nro de CUIT                           *
      *                                                              *
      * Retorna: Nro de Asegurado / 0 = No encontró                  *
      * ------------------------------------------------------------ *
     D SVPDAF_getAseguradoxCuit...
     D                 pr             7  0
     D   peCuit                      11    const
      * ------------------------------------------------------------ *
      * SVPDAF_getListaAseguradoxDoc : Retorna Lista de Nro. de      *
      *                                Asegurado desde Nro y Tipo de *
      *                                Documento.-                   *
      *                                                              *
      *     peTido   (input)   Tipo de Documento                     *
      *     peNrdo   (input)   Nro de Documento                      *
      *     peNrdf   (output)  Nro de persona (Lista)                *
      *     peNrdfC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On ( Lista ) / *Off ( No encontró )                *
      * ------------------------------------------------------------ *
     D SVPDAF_getListaAseguradoxDoc...
     D                 pr              n
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peNrdf                       7  0 dim( 100 )
     D   peNrdfC                     10i 0
      * ------------------------------------------------------------ *
      * SVPDAF_getListaAseguradoxCuit : Retorna Lista de Nro. de     *
      *                                 Asegurado desde CUIT.-       *
      *                                                              *
      *     peCuit   (input)   Nro de CUIT                           *
      *     peNrdf   (output)  Nro de persona (Lista)                *
      *     peNrdfC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On ( Lista ) / *Off ( No encontró )                *
      * ------------------------------------------------------------ *
     D SVPDAF_getListaAseguradoxCuit...
     D                 pr              n
     D   peCuit                      11    const
     D   peNrdf                       7  0 dim( 100 )
     D   peNrdfC                     10i 0
      * ------------------------------------------------------------ *
      * SVPDAF_setllAseguradoxDoc: Se posiciona en archivo Datos     *
      *        Filiatorios Asegurado desde Nro y Tipo de Documento.- *
      *                                                              *
      *     peTido   (input)   Tipo de Documento ( opcional )        *
      *     peNrdo   (input)   Nro de Documento  ( opcional )        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPDAF_setllAseguradoxDoc...
     D                 pr              n
     D   peTido                       2  0 options(*nopass:*omit)
     D   peNrdo                       8  0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SVPDAF_readAseguradoxDoc : Leer un registro de Datos         *
      *        Filiatorios Asegurado desde Nro y Tipo de Documento.- *
      *                                                              *
      *     peDsDaf  (output)  Estructura DAF                        *
      *     peTido   (input)   Tipo de Documento ( opcional )        *
      *     peNrdo   (input)   Nro de Documento  ( opcional )        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPDAF_readAseguradoxDoc...
     D                 pr              n
     D   peDsDaf                           likeds( DsDafAseg_t )
     D   peTido                       2  0 options(*nopass:*omit)
     D   peNrdo                       8  0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SVPDAF_setllAseguradoxCuit: Se posiciona en archivo Datos    *
      *        Filiatorios Asegurado desde Nro CUIT.-                *
      *                                                              *
      *     peCuit   (input)   Nro CUIT          ( opcional )        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPDAF_setllAseguradoxCuit...
     D                 pr              n
     D   peCuit                      11    options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SVPDAF_readAseguradoxCuit : Leer un registro de Datos        *
      *        Filiatorios Asegurado desde Nro CUIT.-                *
      *                                                              *
      *     peDsDaf  (output)  Estructura DAF                        *
      *     peCuit   (input)   Nro CUIT          ( opcional )        *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SVPDAF_readAseguradoxCuit...
     D                 pr              n
     D   peDsDaf                           likeds( DsDafAseg_t )
     D   peCuit                      11    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPDAF_getDa9 : Retorna datos de los telefonos que se deba   *
      *                 publicar en la Web.                          *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peDsTl   (output)  Estructura de datos                   *
      *     peDsTlC  (output)  Cantidad                              *
      *     peNtel   (input)   Número Telefónico                     *
      *                                                              *
      * Retorna: *On ( Lista ) / *Off ( No encontró )                *
      * ------------------------------------------------------------ *
     D SVPDAF_getDa9...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peDsTl                            likeds ( DsTelPublic_t )
     D                                     dim(10)
     D   peDsTlC                     10i 0
     D   peNtel                      20    options( *nopass : *omit  )

      * ------------------------------------------------------------ *
      * SVPDAF_setDa9: Graba GNHDA9                                  *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNtel   (input)   Número Telefono                       *
      *     peTipt   (input)   Tipo de Telefono                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa9...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNtel                      20    const
     D   peTipt                       2    const

      * ------------------------------------------------------------ *
      * SVPDAF_chkDa9(): Chequea si existe Dato telefónico en gnhda9 *
      *                                                              *
      *     peNrdf   (input)   Dato filatorio                        *
      *     peNtel   (input)   Número Telefono                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDa9...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNtel                      20    options( *nopass : *omit  )

      * ------------------------------------------------------------ *
      * SVPDAF_delDa9(): Elimina registro en gnhda9                  *
      *                                                              *
      *     peNrdf   (input)   Dato filatorio                        *
      *     peNtel   (input)   Número Telefono                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_delDa9...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNtel                      20    options( *nopass : *omit  )

      * ------------------------------------------------------------ *
      * SVPDAF_updDa7:  Actualiza Mail de Dato Filiatorio            *
      *                                                              *
      *     peMail2  (input)   Estructura de Mail                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_updDa7...
     D                 pr              n
     D   peMail2                           likeds(DsMailDa7_t) const

      * ------------------------------------------------------------ *
      * SVPDAF_dltDa7_2: Elimina registro en gnhda7                  *
      *                                                              *
      *     peNrdf   (input)   Dato filatorio                        *
      *     peCtce   (input)   Tipo de correo                        *
      *     peMail   (input)   Dirección e-Mail                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_dltDa7_2...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peCtce                       2  0 options( *nopass : *omit  )
     D   peMail                      50    options( *nopass : *omit  )

      * ------------------------------------------------------------ *
      * SVPDAF_chkDa62 : Chequear si tiene telefono cargado.         *
      *                                                              *
      *     peNrdf   (input)   Dato filatorio                        *
      *                                                              *
      * Retorna: *On  = Si existe                                    *
      *          *Off = No existe                                    *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDa62...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_chkDato72: Valida para Grabar en GNHDA7               *
      *                                                              *
      *     peNrdf   (input)   Nro de Asegurado                      *
      *     peCtce   (input)   Tipo de Mail                          *
      *     peMail   (input)   Mail                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkDato72...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peCtce                       2  0 const
     D   peMail                      50    options(*nopass:*omit)const
     D

      * ------------------------------------------------------------ *
      * SVPDAF_getMailWeb: Retorna los mail para mostrar via WEB     *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (output)  DS con los mails                      *
      *     peMailC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getMailWeb...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) dim(100)
     D   peMailC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDAF_getMail: Retorna Mail del Asegurado                   *
      *                                                              *
      *     peNrdf   (input)   Nro de Asegurado                      *
      *     peMail   (output)  DS con los mails                      *
      *     peMailC  (output)  Cantidad                              *
      *                                                              *
      * Retorna: *On  = Existen                                      *
      *          *Off = No Existen                                   *
      * ------------------------------------------------------------ *
     D SVPDAF_getMail...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(DsMailDa7_t) dim(100)
     D   peMailC                     10i 0

      * ------------------------------------------------------------ *
      * SVPDAF_chkda1: chequea si existe registro en GNHDA1          *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkda1...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_chkAseguradoxDoc_xCUIT                                *
      *                                                              *
      *     peNrdf   (input)   Nro. de Asegurado                     *
      *     peTido   (input)   Tipo de documento                     *
      *     peNrdo   (input)   Nro. de documento                     *
      *     peCuit   (input)   CUIT                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_chkAseguradoxDoc_xCUIT...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peTido                       2  0 options(*nopass:*omit)
     D   peNrdo                       8  0 options(*nopass:*omit)
     D   peCuit                      11    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPDAF_getDa12: Retorna GNHDA1, versión 2                    *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (output)  Nombre Alternativo                    *
      *     peDomi   (output)  Domicilio Postal                      *
      *     peCopo   (output)  Codigo Postal                         *
      *     peCops   (output)  SubCodigo Postal                      *
      *     peTeln   (output)  Telefono                              *
      *     peFnac   (output)  Fecha de Nacimiento                   *
      *     peCprf   (output)  Codigo de Profesion                   *
      *     peSexo   (output)  Codigo de Sexo                        *
      *     peEsci   (output)  Código de estado Civil                *
      *     peRaae   (output)  Código de Rama Actividad Económica    *
      *     peCiiu   (output)  Ciiu                                  *
      *     peDom2   (output)  Domicilio                             *
      *     pePesk   (output)  Peso                                  *
      *     peEstm   (output)  Estatura                              *
      *     peMfum   (output)  Marca de Fuma                         *
      *     peMzur   (output)  Marca de Zurdo                        *
      *     peMar1   (output)  Pago Aporte Previsional               *
      *     peMar2   (output)  Sujeto Exterior                       *
      *     peMar3   (output)  Constancia Empadronamiento AFIP       *
      *     peMar4   (output)  Acreedor Prendario                    *
      *     peCcdi   (output)  Clave Tributaria                      *
      *     pePain   (output)  Pais de Nacimiento                    *
      *     peCnac   (output)  Nacionalidad                          *
      *     peChij   (output)  Cantidad de Hijos                     *
      *     peCnes   (output)  Código Nivel de Estudio               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_getDa12...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40
     D   peDomi                      35
     D   peCopo                       5  0
     D   peCops                       1  0
     D   peTeln                       7  0
     D   peFnac                       8  0
     D   peCprf                       3  0
     D   peSexo                       1  0
     D   peEsci                       1  0
     D   peRaae                       3  0
     D   peCiiu                       6  0
     D   peDom2                      50
     D   peLnac                      30
     D   pePesk                       5  2
     D   peEstm                       3  2
     D   peMfum                       1
     D   peMzur                       1
     D   peMar1                       1
     D   peMar2                       1
     D   peMar3                       1
     D   peMar4                       1
     D   peCcdi                      11
     D   pePain                       5  0
     D   peCnac                       3  0
     D   peChij                       2  0
     D   peCnes                       1  0

      * ------------------------------------------------------------ *
      * SVPDAF_setDa12: Graba GNHDA1, versión 2                      *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre Alternativo                    *
      *     peDomi   (input)   Domicilio Postal                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Telefono                              *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     peCiiu   (input)   Ciiu                                  *
      *     peDom2   (input)   Domicilio                             *
      *     pePesk   (input)   Peso                                  *
      *     peEstm   (input)   Estatura                              *
      *     peMfum   (input)   Marca de Fuma                         *
      *     peMzur   (input)   Marca de Zurdo                        *
      *     peMar1   (input)   Pago Aporte Previsional               *
      *     peMar2   (input)   Sujeto Exterior                       *
      *     peMar3   (input)   Constancia Empadronamiento AFIP       *
      *     peMar4   (input)   Acreedor Prendario                    *
      *     peCcdi   (input)   Clave Tributaria                      *
      *     pePain   (input)   Pais de Nacimiento                    *
      *     peCnac   (input)   Codigo de Nacionalidad                *
      *     peChij   (input)   Cantidad de Hijos                     *
      *     peCnes   (input)   Código de Nivel de Estudio            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa12...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peSexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   peCiiu                       6  0 const
     D   peDom2                      50    const
     D   peLnac                      30    const
     D   pePesk                       5  2 const
     D   peEstm                       3  2 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peCcdi                      11    const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const
     D   peChij                       2  0 const
     D   peCnes                       1  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_updDa12 Actualiza GNHDA1, versión 2                   *
      *                                                              *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peNomb   (input)   Nombre Alternativo                    *
      *     peDomi   (input)   Domicilio Postal                      *
      *     peCopo   (input)   Codigo Postal                         *
      *     peCops   (input)   SubCodigo Postal                      *
      *     peTeln   (input)   Telefono                              *
      *     peFnac   (input)   Fecha de Nacimiento                   *
      *     peCprf   (input)   Codigo de Profesion                   *
      *     peSexo   (input)   Codigo de Sexo                        *
      *     peEsci   (input)   Código de estado Civil                *
      *     peRaae   (input)   Código de Rama Actividad Económica    *
      *     peCiiu   (input)   Ciiu                                  *
      *     peDom2   (input)   Domicilio                             *
      *     pePesk   (input)   Peso                                  *
      *     peEstm   (input)   Estatura                              *
      *     peMfum   (input)   Marca de Fuma                         *
      *     peMzur   (input)   Marca de Zurdo                        *
      *     peMar1   (input)   Pago Aporte Previsional               *
      *     peMar2   (input)   Sujeto Exterior                       *
      *     peMar3   (input)   Constancia Empadronamiento AFIP       *
      *     peMar4   (input)   Acreedor Prendario                    *
      *     peCcdi   (input)   Clave Tributaria                      *
      *     pePain   (input)   Pais de Nacimiento                    *
      *     peCnac   (input)   Codigo de Nacionalidad                *
      *     peChij   (input)   Cantidad de Hijos                     *
      *     peCnes   (input)   Código de nivel de Estudio            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_updDa12...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peNomb                      40    const
     D   peDomi                      35    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peTeln                       7  0 const
     D   peFnac                       8  0 const
     D   peCprf                       3  0 const
     D   peSexo                       1  0 const
     D   peEsci                       1  0 const
     D   peRaae                       3  0 const
     D   peCiiu                       6  0 const
     D   peDom2                      50    const
     D   peLnac                      30    const
     D   pePesk                       5  2 const
     D   peEstm                       3  2 const
     D   peMfum                       1    const
     D   peMzur                       1    const
     D   peMar1                       1    const
     D   peMar2                       1    const
     D   peMar3                       1    const
     D   peMar4                       1    const
     D   peCcdi                      11    const
     D   pePain                       5  0 const
     D   peCnac                       3  0 const
     D   peChij                       2  0 const
     D   peCnes                       1  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_chkGnhDad(): Verifica existencia en GNHDAD.           *
      *                                                              *
      *     peNrdf   (input)   Número de Dato Filiatorio             *
      *     peCdep   (input)   Código de Deporte                     *
      *                                                              *
      * Retorna: *On existe / *off no existe                         *
      * ------------------------------------------------------------ *
     D SVPDAF_chkGnhDad...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peCdep                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_setGnhDad(): Graba registro en GNHDAD.                *
      *                                                              *
      *     peNrdf   (input)   Número de Dato Filiatorio             *
      *     peCdep   (input)   Código de Deporte                     *
      *                                                              *
      * Retorna: *On grabó bien/*off hubo problema                   *
      * ------------------------------------------------------------ *
     D SVPDAF_setGnhDad...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peCdep                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_dltGnhDad(): Borra registro de GNHDAD.                *
      *                                                              *
      *     peNrdf   (input)   Número de Dato Filiatorio             *
      *     peCdep   (input)   Código de Deporte                     *
      *                                                              *
      * Retorna: *On borró bien/*off hubo problema                   *
      * ------------------------------------------------------------ *
     D SVPDAF_dltGnhDad...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peCdep                       3  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_updDa72:  Actualiza Mail de Dato Filiatorio           *
      *                                                              *
      *     peMail2  (input)   Estructura de Mail                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_updDa72...
     D                 pr              n
     D   peMail2                           likeds(DsMailDa7_t) const

      * ------------------------------------------------------------ *
      * SVPDAF_dltGnhDadDaf: Elimina todos los registros de GNHDAD   *
      *                      para un DAF.                            *
      *                                                              *
      *     peNrdf   (input)   Número de Dato Filiatorio             *
      *                                                              *
      * Retorna: *On borró bien/*off hubo problema                   *
      * ------------------------------------------------------------ *
     D SVPDAF_dltGnhDadDaf...
     D                 pr              n
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPDAF_setDa7v2: Graba Mail de Dato Filiatorio V2            *
      *                  Valida Mail por codigo de Valor del Sistema *
      *     peNrdf   (input)   Dato Filiatorio                       *
      *     peMail   (input)   Mail                                  *
      *     peMar1   (input)   Publicar en la Web Mail (Si/No)       +
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPDAF_setDa7v2...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peMail                            likeds(Mailaddr_t) const
     D   peMar1                       1    options( *nopass : *omit  )

      * ------------------------------------------------------------ *
