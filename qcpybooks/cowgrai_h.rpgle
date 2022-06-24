      /if defined(COWGRAI_H)
      /eof
      /endif
      /define COWGRAI_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/svpepv_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'

      * Cotizaión no Pertenece a Productor...
     D COWGRAI_COTNP   c                   const(0001)
      * Número de Componente ya Existe...
     D COWGRAI_POCOEX  c                   const(0002)
      * Cotización en Tramite...
     D COWGRAI_COTTR   c                   const(0003)
      * La cotizacion ya contiene planes, no se permiten ingresar -
      * planes cerrado
     D COWGRAI_PLANCP  c                   const(0004)
      * La cotizacion contiene un plane cerrado, no se permite ingresar -
      * mas planes
     D COWGRAI_PLANCE  c                   const(0005)

     D spolizas        ds                  qualified based(template)
     D   rama                         2  0
     D   poliza                       7  0
     D
     D Impuesto        ds                  qualified based(template)
     D   cobl                         2
     D   xrea                         5  2
     D   read                        15  2
     D   xopr                         5  2
     D   copr                        15  2
     D   xref                         5  2
     D   refi                        15  2
     D   dere                        15  2
     D   seri                        15  2
     D   seem                        15  2
     D   pimi                         5  2
     D   impi                        15  2
     D   psso                         5  2
     D   sers                        15  2
     D   pssn                         5  2
     D   tssn                        15  2
     D   pivi                         5  2
     D   ipr1                        15  2
     D   pivn                         5  2
     D   ipr4                        15  2
     D   pivr                         5  2
     D   ipr3                        15  2
     D   ipr6                        15  2
     D   ipr7                        15  2
     D   ipr8                        15  2
     D
     D bonVeh          ds                  qualified based(template)
     D   cobl                         2
     D   ccbp                         3  0
     D   dcbp                        25
     D   pcbp                         5  2
     D   pcbm                         5  2
     D   pcbx                         5  2
     D   modi                         1

     D ImpEg3          ds                  qualified based(template)
     D   rpro                         2  0
     D   prim                        15  2
     D   bpri                        15  2
     D   refi                        15  2
     D   read                        15  2
     D   dere                        15  2
     D   seri                        15  2
     D   seem                        15  2
     D   ipr6                        15  2
     D   ipr7                        15  2
     D   ipr8                        15  2
     D   prem                        15  2
     D   ipr1                        15  2
     D   ipr3                        15  2
     D   ipr4                        15  2
     D   sefr                        15  2
     D   sefe                        15  2

      * ------------------------------------------------------------ *
      * Estructura DS ctw000                                         *
      * ------------------------------------------------------------ *
     D dsctw000_t      ds                  qualified template
     D   w0empr                       1
     D   w0sucu                       2
     D   w0nivt                       1p 0
     D   w0nivc                       5p 0
     D   w0nctw                       7p 0
     D   w0nit1                       1p 0
     D   w0niv1                       5p 0
     D   w0fctw                       8p 0
     D   w0nomb                      40
     D   w0soln                       7p 0
     D   w0fpro                       8p 0
     D   w0mone                       2
     D   w0noml                      30
     D   w0come                      15p 6
     D   w0copo                       5p 0
     D   w0cops                       1p 0
     D   w0loca                      25
     D   w0arcd                       6p 0
     D   w0arno                      30
     D   w0spol                       9p 0
     D   w0sspo                       3p 0
     D   w0tipe                       1
     D   w0civa                       2p 0
     D   w0ncil                      30
     D   w0tiou                       1p 0
     D   w0stou                       2p 0
     D   w0stos                       2p 0
     D   w0dsop                      20
     D   w0spo1                       9p 0
     D   w0cest                       1p 0
     D   w0cses                       2p 0
     D   w0dest                      20
     D   w0vdes                       8p 0
     D   w0vhas                       8p 0
     D   w0cfpg                       1p 0
     D   w0defp                      20
     D   w0ncbu                      22p 0
     D   w0ctcu                       3p 0
     D   w0nrtc                      20p 0
     D   w0fvtc                       6p 0
     D   w0mp01                       1
     D   w0mp02                       1
     D   w0mp03                       1
     D   w0mp04                       1
     D   w0mp05                       1
     D   w0mp06                       1
     D   w0mp07                       1
     D   w0mp08                       1
     D   w0mp09                       1
     D   w0mp10                       1
     D   w0nrpp                       3p 0
     D   w0asen                       7p 0
     D   w0ncta                       7p 0
     D   w0nsys                      20
     D   w0cuii                      11
     D   w0nuse                      40

     D dsctwtim_t      ds                  qualified template
     D   w0empr                       1
     D   w0sucu                       2
     D   w0nivt                       1p 0
     D   w0nivc                       5p 0
     D   w0nctw                       7p 0
     D   w0nit1                       1p 0
     D   w0niv1                       5p 0
     D   w0hcct                       6p 0
     D   w0fcot                       8p 0
     D   w0hcot                       6p 0
     D   w0frct                       8p 0
     D   w0hrct                       6p 0
     D   w0hpro                       6p 0

      * ------------------------------------------------------------ *
      * Estructura DS ctweg3                                         *
      * ------------------------------------------------------------ *
     D dsctweg3_t      ds                  qualified template
     D  g3empr                        1
     D  g3sucu                        2
     D  g3nivt                        1p 0
     D  g3nivc                        5p 0
     D  g3nctw                        7p 0
     D  g3rama                        2p 0
     D  g3arse                        2p 0
     D  g3rpro                        2p 0
     D  g3mone                        2
     D  g3come                       15p 6
     D  g3suas                       13p 0
     D  g3saca                       13p 0
     D  g3sacr                       13p 0
     D  g3sast                       13p 0
     D  g3prim                       15p 2
     D  g3bpri                       15p 2
     D  g3refi                       15p 2
     D  g3read                       15p 2
     D  g3dere                       15p 2
     D  g3seri                       15p 2
     D  g3seem                       15p 2
     D  g3ipr6                       15p 2
     D  g3ipr7                       15p 2
     D  g3ipr8                       15p 2
     D  g3prem                       15p 2
     D  g3mar1                        1
     D  g3mar2                        1
     D  g3mar3                        1
     D  g3mar4                        1
     D  g3mar5                        1
     D  g3strg                        1
     D  g3ipr1                       15p 2
     D  g3ipr3                       15p 2
     D  g3ipr4                       15p 2
     D  g3sefr                       15p 2
     D  g3sefe                       15p 2

      * ------------------------------------------------------------ *
      * Estructura DS ctw001                                         *
      * ------------------------------------------------------------ *
     D dsCtw001_t      ds                  qualified template
     D  w1empr                        1a
     D  w1sucu                        2a
     D  w1nivt                        1p 0
     D  w1nivc                        5p 0
     D  w1nctw                        7p 0
     D  w1rama                        2p 0
     D  w1dere                       15p 2
     D  w1xref                        5p 2
     D  w1refi                       15p 2
     D  w1seri                       15p 2
     D  w1seem                       15p 2
     D  w1pimi                        5p 2
     D  w1impi                       15p 2
     D  w1psso                        5p 2
     D  w1sers                       15p 2
     D  w1pssn                        5p 2
     D  w1tssn                       15p 2
     D  w1pivi                        5p 2
     D  w1ipr1                       15p 2
     D  w1pivn                        5p 2
     D  w1ipr4                       15p 2
     D  w1pivr                        5p 2
     D  w1ipr3                       15p 2
     D  w1ipr6                       15p 2
     D  w1ipr7                       15p 2
     D  w1ipr8                       15p 2
     D  w1ipr9                       15p 2
     D  w1ipr2                       15p 2
     D  w1ipr5                       15p 2
     D  w1prem                       15p 2
     D  w1vacc                       15p 2

      * ------------------------------------------------------------ *
      * Estructura DS ctw001c                                        *
      * ------------------------------------------------------------ *
     D dsCtw001c_t     ds                  qualified template
     D  w1empr                        1a
     D  w1sucu                        2a
     D  w1nivt                        1p 0
     D  w1nivc                        5p 0
     D  w1nctw                        7p 0
     D  w1rama                        2p 0
     D  w1xrea                        5p 2
     D  w1read                       15p 2
     D  w1xopr                        5p 2
     D  w1copr                       15p 2

      * ------------------------------------------------------------ *
      * COWGRAI_getNroCotizacion():   Obtiene el numero de cotización*
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peEmpr  -  Empresa                            *
      *                peSucu  -  Sucursal                           *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getNroCotizacion...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
      * ------------------------------------------------------------ *
      * COWGRAI_getChkCotizacion(): Verificar que exista el número de*
      *                             cotización.                      *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getChkCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCabecera(): Elimina registro de cabecera.      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_deleteCabecera...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_deleteAsegurados(): Elimina registro de asegurado    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_deleteAsegurados...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_deleteAseguradosMails():Eliminar Mails Asegurados    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_deleteAseguradosMails...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getNuevaCotizacion(): Obtiene el número de cotización*
      *                               usada para el resto de los ser-*
      *                               vicios.                        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peArcd  -  Código de Artículo                 *
      *                peMone  -  Código de Moneda                   *
      *                peTiou  -  Tipo de Operación                  *
      *                peStou  -  SubTipo de Operación de Usuario    *
      *                peStos  -  SubTipo de Operación de Sistema    *
      *                peSpo1  -  SuperPoliza Relacionada            *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peNctw  -  Número de Cotización               *
      *                peErro  -  Indicador de Error                 *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getNuevaCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peMone                       2    const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D   peSpo1                       7  0 const
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCotizacion(): Permite eliminar cotización solo *
      *                             solo si se encuentran en etapa   *
      *                             de cotización.                   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peNctw  -  Número de Cotización               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peErro  -  Indicador de Error                 *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_deleteCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWGRAI_saveCotizacion():   Salva cotización que se recibe   *
      *                             por parametros.                  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Parametro Base                     *
      *                peNctw  -  Número de Cotización               *
      *                peAsen  -  Código de Cliente (puede ser 0)    *
      *                peNomb  -  Nombre del Cliente                 *
      *                peCiva  -  Código de Iva del Cliente          *
      *                peTipe  -  Tipo de Persona                    *
      *                peCopo  -  Código Postal                      *
      *                peCops  -  Sufijo Código Postal               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peErro  -  Indicador de Error                 *
      *                peMsgs  -  Mensaje de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_saveCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peAsen                       7  0 const
     D   peNomb                      40    const
     D   peCiva                       2  0 const
     D   peTipe                       1    const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peCuit                      11a   const
     D   peTido                       1  0 const
     D   peNrdo                       8  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ---------------------------------------------------------------*
      * COWGRAI_deleteBienAsegurado():Eliminar bien asegurado recibido *
      *                               por parametro.                   *
      *                                                                *
      *        Input :                                                 *
      *                                                                *
      *                peBase  -  Parametro Base                       *
      *                peNctw  -  Número de Cotización                 *
      *                peRama  -  Rama                                 *
      *                pePoco  -  Número de Bien asegurado             *
      *                                                                *
      *        Output:                                                 *
      *                                                                *
      *                peErro  -  Indicador de Error                   *
      *                peMsgs  -  Mensaje de Error                     *
      *                                                                *
      * -------------------------------------------------------------- *
     D COWGRAI_deleteBienAsegurado...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * COWGRAI_getPolizasDeSuperpoliza (): Obtiene el listado de polizas*
      *                                     de una superpoliza.          *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Parametro Base                         *
      *                peArcd  -  Número de Artículo                     *
      *                peSpol  -  SuperPoliza                            *
      *                                                                  *
      *        Output:                                                   *
      *                                                                  *
      *                pePoli  -  Pólizas                                *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Mensaje de Error                       *
      *                pePoliC -  Cantidad de Polizas                    *
      *                                                                  *
      * --------------------------------------------------------------   *
     D COWGRAI_getPolizasDeSuperpoliza...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pePoli                            likeds(spolizas) Dim(100)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D   pePoliC                     10i 0 options( *omit : *nopass )
      * -----------------------------------------------------------------*
      * COWGRAI_chkCotizacion() Verifica el número de cotización.        *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     D COWGRAI_chkCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * -----------------------------------------------------------------*
      * COWGRAI_personaIsValid(): validar que sea una persona valida     *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peTipe  -  Tipo de Persona                        *
      *                peTido  -  Código Tipo Documento                  *
      *                peNrdo  -  Número de Documento                    *
      *                peCuit  -  CUIT                                   *
      *                peCuil  -  CUIL                                   *
      *                                                                  *
      *        Output:                                                   *
      *                peErro  - Indicador de Error                      *
      *                peMsgs  - Mensaje de Error                        *
      * --------------------------------------------------------------   *
     D COWGRAI_personaIsValid...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTipe                       1    const
     D   peTido                       2  0 const
     D   peNrdo                       9  0 const
     D   peCuit                      11  0 const
     D   peCuil                      11  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * -----------------------------------------------------------------*
      * COWGRAI_monedaCotizacion() Verifica el número de cotización. *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     D COWGRAI_monedaCotizacion...
     D                 pr             2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ---------------------------------------------------------------- *
      *  COWGRAI_chkComponente():Valida que el componete no se repita    *
      *                                                                  *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cantidad de Polizas                    *
      *                pePoco  -  Número de Componente                   *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_chkComponente...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_SaveImpuestos():Graba Impuestos                          *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peArse (input) Cant. de Articulos                           *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     D COWGRAI_SaveImpuestos...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetSelladosprovinciales(): Obtener Sellados Provinciales *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Codigo de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      pePrim (input)  Prima                                       *
      *      peBpri (input)  Bonificaciones                              *
      *      peRead (input)  Recargo Administrativo                      *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *      peSub1 (input)  Subtotal                                    *
      *      peSaop (input)  Suma Asegurada                              *
      *      peImpi (input)  Impuestos Internos                          *
      *      peSers (input)  Servicios Sociales                          *
      *      peTssn (input)  Tasa SSN                                    *
      *      peIpr1 (input)  Impuesto Valor Agregado                     *
      *      peIpr2 (input)  Acciones                                    *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peIpr5 (input)  Recargo de Capital                          *
      *      peIpr6 (input)  Componente Premio 6                         *
      *      peIpr7 (input)  Ing.Brutos Riesgo                           *
      *      peIpr8 (input)  Ing.Brutos Empresa                          *
      *      pePorc (input)  Porcentaje                                  *
      *      pePor1 (input)  Porcentaje 1                                *
      *      peTiso (input)  Tipo de Sociedad                            *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetSelladosprovinciales...
     D                 pr            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   pePrim                      15  2 const
     D   peBpri                      15  2 const
     D   peRead                      15  2 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peSub1                      15  2 const
     D   peSaop                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   pePorc                       9  6 options(*nopass)
     D   pePor1                       9  6 options(*nopass)
     D   peTiso                       2  0 options(*nopass)
     D   peimfo                      15  2 options(*nopass)

      * ---------------------------------------------------------------- *
      * COWGRAI_GetSelladodelaEmpresa: Obtener Sellados de La Empresa    *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Codigo de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      pePrim (input)  Prima                                       *
      *      peBpri (input)  Bonificaciones                              *
      *      peRead (input)  Recargo Administrativo                      *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *      peSub1 (input)  Subtotal                                    *
      *      peSaop (input)  Suma Asegurada                              *
      *      peImpi (input)  Impuestos Internos                          *
      *      peSers (input)  Servicios Sociales                          *
      *      peTssn (input)  Tasa SSN                                    *
      *      peIpr1 (input)  Impuesto Valor Agregado                     *
      *      peIpr2 (input)  Acciones                                    *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peIpr5 (input)  Recargo de Capital                          *
      *      peIpr6 (input)  Componente Premio 6                         *
      *      peIpr7 (input)  Ing.Brutos Riesgo                           *
      *      peIpr8 (input)  Ing.Brutos Empresa                          *
      *      pePorc (input)  Porcentaje                                  *
      *      pePor1 (input)  Porcentaje 1                                *
      *      peTiso (input)  Tipo de Sociedad                            *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetSelladodelaEmpresa...
     D                 pr            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   pePrim                      15  2 const
     D   peBpri                      15  2 const
     D   peRead                      15  2 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peSub1                      15  2 const
     D   peSaop                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   pePorc                       9  6 options(*nopass)
     D   pePor1                       9  6 options(*nopass)
     D   peTiso                       2  0 options(*nopass)
     D   peimfo                      15  2 options(*nopass)
      * ---------------------------------------------------------------- *
      * COWGRAI_GetIngBrutosConvMultilateral: Obtener Ingresos Brutos    *
      *                                                                  *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peTipo (input)  Tipo de Impuesto                            *
      *      peNeto (input)  Prima                                       *
      *      peRead (input)  Recargo Administrativo                      *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetIngBrutosConvMultilateral...
     D                 pr            15  2
     D peRpro                         2  0  const
     D peRama                         2  0  const
     D peTipo                         1     const
     D peNeto                        15  2  const
     D peRead                        15  2  const
     D peRefi                        15  2  const
     D peDere                        15  2  const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetDerechoEmision(): retorna el impuesto de derecho de   *
      *                             emision.                             *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetDerechoEmision...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetRecargoFinanc():  % Recargo Financiero                *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetRecargoFinanc...
     D                 pr             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImpuestosInte(): % Impuestos Internos                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetImpuestosInte...
     D                 pr             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetServiciosSoci(): % Servicios Sociales                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetServiciosSoci...
     D                 pr             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetTasaSsn(): % Tasa SSN                                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetTasaSsn...
     D                 pr             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetIvaInscripto(): % Iva Inscripto                       *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetIvaInscripto...
     D                 pr             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetIvaRes(): % Iva Res.3125                              *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetIvaRes...
     D                 pr             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetIvaNoInscripto(): % Iva No Inscripto                  *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetIvaNoInscripto...
     D                 pr             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetCodProInd(): Código Pcia. del Inder                   *
      *                                                                  *
      *      peCopo (input)  Código Postal                               *
      *      peCops (input)  Sufijo del Código Postal                    *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetCodProInd...
     D                 pr             2  0
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteImpi(): Retorna Importe Impuesto interno       *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                                  *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetImporteImpi...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteTssn(): Retorna Importe Tasa Ssn.              *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetImporteTssn...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteIins(): Retorna Importe de IVA.                *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetImporteIins...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteIres(): Retorna Importe de IVA Rnl             *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetImporteIres...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteInoi(): Retorna Importe de IVA no Inscripto    *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetImporteInoi...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetPrimaSubtot(): Retorna prima SubTotal                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetPrimaSubtot...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
     D   peForm                       1     options(*omit:*nopass)
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteRefi(): Retorna Importe de Recargo Financiero  *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetImporteRefi...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetImporteSers(): Retorna Importe Servicios Sociales     *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima SubTotal                              *
      *                                                             o    *
      * Retorna Premio                                                   *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetImporteSers...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ------------------------------------------------------------ *
      * COWGRAI_cotizaMoneda(): devuelve cotización de la moneda.    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peComo  -  Código de Moneda                   *
      *                peFcot  -  Fecha de Cotización (aaaammdd)     *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_cotizaMoneda...
     D                 pr            15  6
     D   peComo                       2      const
     D   peFcot                       8  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_getArticulo():Recupera el articulo asociado en la cabecera*
      *                      de la cotización                            *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_getArticulo...
     D                 pr             6  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_GetPremioBruto():Obtiene Premi                           *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      pePrim (input)  Prima Total Cobertura                       *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetPremioBruto...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_getCalculosimpuestos(): devuelve la suma total de los    *
      *                                 impuestos                        *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Número de Cotización                        *
      *      peRama (input)  Rama                                        *
      *      peCopo (input)  Código Postal                               *
      *      peCops (input)  Sufijo del Código Postal                    *
      *      peSaop (input)  Suma Asegurada                              *
      *      pePrim (input)  Prima total Cobertura                       *
      *      peTipe (input)  Tipo de Persona                             *
      *      peMone (input)  Moneda                                      *
      *                                                                  *
      * Retorna Premio / -1                                              *
      * ---------------------------------------------------------------- *
     D COWGRAI_getCalculosimpuestos...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peSaop                      15  2   const
     D   pePrim                      15  2   const
     D   peTipe                       1      const
     D   peMone                       2      const
      * ------------------------------------------------------------ *
      * COWGRAI_getCodigoIva(): Devuelve el codigo de Iva.           *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getCodigoIva...
     D                 pr             2  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------- *
      * COWGRAI_updCotizacion():  Actualizar registro de cotización   *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peCiva   (input)   Código de Iva del Cliente              *
      *     peTipe   (input)   Tipo de Persona                        *
      *     peCopo   (input)   Código Postal                          *
      *     peCops   (input)   Sufijo Código Postal                   *
      *     peCfpg   (input)   Código de Forma de pago                *
      *     peNrpp   (input)   Plan de Pago                           *
      *     peVdes   (input)   Vigencia desde                         *
      *     peVhas   (input)   Vigencia Hasta                         *
      *                                                               *
      * ------------------------------------------------------------- *
     D COWGRAI_updCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peCiva                       2  0   const
     D   peTipe                       1      const
     D   peCopo                       5  0   const
     D   peCops                       1  0   const
     D   peCfpg                       1  0   const
     D   peNrrp                       3  0   const
     D   peVdes                       8  0 const options(*omit:*nopass)
     D   peVhas                       8  0 const options(*omit:*nopass)
      * ------------------------------------------------------------ **
      * COWGRAI_chkEstCotizacion() Verifica si se puede cotizar      **
      *                                                              **
      *     peBase   (input)   Base                                  **
      *     peNctw   (input)   Número de Cotización                  **
      *                                                              **
      * ------------------------------------------------------------ **
     D COWGRAI_chkEstCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------- *
      * COWGRAI_getImportesTot (): Recupera los importes de los       *
      *                            impuestos por componente           *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peRama   (input)   Rama                                   *
      *     peArse   (input)   cant.polizas por rama/art              *
      *     peSeri   (output)  sellado riesgo                         *
      *     peSeem   (output)  sellado de la empresa                  *
      *     peImpi   (output)  impuestos internos                     *
      *     peSers   (output)  servicios sociales                     *
      *     peTssn   (output)  tasa super. seg. nacion.               *
      *     peIpr1   (output)  impuesto valor agregado                *
      *     peIpr4   (output)  iva-resp.no inscripto                  *
      *     peIpr3   (output)  iva-importe percepcion                 *
      *     peIpr6   (output)  componente premio 6                    *
      *     peIpr7   (output)  componente premio 7                    *
      *     peIpr8   (output)  componente del premio 8                *
      *     peIpr9   (output)  componente del premio 9                *
      *                                                               *
      * ------------------------------------------------------------- *
     D COWGRAI_getImportesTot...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   peSeri                      15  2
     D   peSeem                      15  2
     D   peImpi                      15  2
     D   peSers                      15  2
     D   peTssn                      15  2
     D   peIpr1                      15  2
     D   peIpr2                      15  2
     D   peIpr3                      15  2
     D   peIpr4                      15  2
     D   peIpr5                      15  2
     D   peIpr6                      15  2
     D   peIpr7                      15  2
     D   peIpr8                      15  2
     D   peIpr9                      15  2
      * ------------------------------------------------------------- *
      * COWGRAI_saveImportes   (): Recupera los importes de los       *
      *                            impuestos por componente           *
      *                                                               *
      *     peBase   (input)   Base                                   *
      *     peNctw   (input)   Número de Cotización                   *
      *     peRama   (input)   Rama                                   *
      *     peArse   (input)   cant.polizas por rama/art              *
      *     pePoco   (input)   nro. de componente                     *
      *     peSeri   (output)  sellado riesgo                         *
      *     peSeem   (output)  sellado de la empresa                  *
      *     peImpi   (output)  impuestos internos                     *
      *     peSers   (output)  servicios sociales                     *
      *     peTssn   (output)  tasa super. seg. nacion.               *
      *     peIpr1   (output)  impuesto valor agregado                *
      *     peIpr4   (output)  iva-resp.no inscripto                  *
      *     peIpr3   (output)  iva-importe percepcion                 *
      *     peIpr6   (output)  componente premio 6                    *
      *     peIpr7   (output)  componente premio 7                    *
      *     peIpr8   (output)  componente del premio 8                *
      *     peIpr9   (output)  componente del premio 9                *
      *                                                               *
      *                                                               *
      * ------------------------------------------------------------- *
     D COWGRAI_saveImportes...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const
     D   peSeri                      15  2   const
     D   peSeem                      15  2   const
     D   peImpi                      15  2   const
     D   peSers                      15  2   const
     D   peTssn                      15  2   const
     D   peIpr1                      15  2   const
     D   peIpr4                      15  2   const
     D   peIpr3                      15  2   const
     D   peIpr6                      15  2   const
     D   peIpr7                      15  2   const
     D   peIpr8                      15  2   const
     D   peIpr9                      15  2   const
      * ------------------------------------------------------------ *
      * COWGRAI_deleteImportes(): Elimina los importes generados por *
      *                           los impuestos                      *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteImportes...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_deleteImpuestos():Elimina los impuestos generados    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteImpuestos...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_deleteImpuesto():Elimina los impuestos para rama     *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteImpuesto...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getImpuestos(): devuelve estructuras de impuestos e  *
      *                         importes                             *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                pePrim  -  Prima                              *
      *                peSuma  -  Suma Asegurada                     *
      *                peCopo  -  Código Postal                      *
      *                peCops  -  Sufijo Código Postal               *
      *                                                              *
      *        Output:                                               *
      *                                                              *
      *                peImpu  -  Estructura de Impuestos            *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_getImpuestos...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   pePrim                      15  2 const
     D   peSuma                      15  2 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peImpu                            likeds(Impuesto)
      * ------------------------------------------------------------ *
      * COWGRAI_getTipoPersona(): Retorna el tipo de persona que esta*
      *                           en la cabecera de la cotización.   *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getTipoPersona...
     D                 pr             1
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getSumaAseguradaRamaArse(): retorna la suma suma ase-*
      *                                     gurada por rama y arse.  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Código de Rama                         *
      *     peArse   (input)   Cant. Pólizas por Rama                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getSumaAseguradaRamaArse...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getSumaAsSiniRamaArse() Retorna la suma asegurada si-*
      *                                 niestrable por rama y arse.  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Código de Rama                         *
      *     peArse   (input)   Cant. Pólizas por Rama                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getSumaAsSiniRamaArse...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getPrimaRamaArse() : retorna prima por rama y arse   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                                                              *
      * -------------------------------------------------------------*
     D COWGRAI_getPrimaRamaArse...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const options(*omit:*nopass)
      * ------------------------------------------------------------ *
      * COWGRAI_SavePrimasPorProvincia:Importes por provincias       *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Pólizas por Rama                *
      *     pePoco   (input)   Nro Componente                        *
      *     peProI   (input)   Provincia Inder                       *
      *     peSuas   (input)   Suma Asegurada                        *
      *     peSast   (input)   Suma asegurada Siniestrada            *
      *     pePrim   (input)   Prima                                 *
      *     pePrem   (input)   Premio                                *
      *                                                              *
      * -------------------------------------------------------------*
     D COWGRAI_SavePrimasPorProvincia...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peProI                       2  0 const
     D   peSuas                      15  2 const
     D   peSast                      15  2 const
     D   pePrim                      15  2 const
     D   pePrem                      15  2 const
      * ------------------------------------------------------------ *
      * COWGRAI_DeletePrimasPorProvincia: Importes por provincias    *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cant. Pólizas por Rama                *
      *     pePoco   (input)   Nro Componente                        *
      *     peProI   (input)   Provincia Inder                       *
      *     peSuas   (input)   Suma Asegurada                        *
      *     peSast   (input)   Suma asegurada Siniestrada            *
      *     pePrim   (input)   Prima                                 *
      *     pePrem   (input)   Premio                                *
      *                                                              *
      * -------------------------------------------------------------*
     D COWGRAI_DeletePrimasPorProvincia...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peProI                       2  0 const
     D   peSuas                      15  2 const
     D   peSast                      15  2 const
     D   pePrim                      15  2 const
     D   pePrem                      15  2 const
      * ------------------------------------------------------------ *
      * COWGRAI_GetCopoCops: Obtiene Codigo Postal y Sufijo          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de cotización                  *
      *     peCopo   (output)  Código Postal                         *
      *     peCops   (output)  Sufijo Código Postal                  *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_GetCopoCops...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   pecopo                       5  0
     D   pecops                       1  0
      * ------------------------------------------------------------ *
      * COWGRAI_getPrimaSPoliza () : retorna prima por SuperPoliza   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * -------------------------------------------------------------*
     D COWGRAI_getPrimaSPoliza...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * -----------------------------------------------------------------*
      * COWGRAI_getDerechoEmi() Retorna Derecho de Emision               *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     D COWGRAI_setDerechoEmi...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   pePrim                      15  2 const

      * ------------------------------------------------------------ *
      *4COWGRAI_deletePoco(): Elimina los componentes de autos aso-  *
      *                      ciados a la cotización.                 *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deletePoco...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_deleteCarac:Elimina caracterizticas del bien         *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteCarac...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_deleteImpImpu(): Elimina importes de impuestos       *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteImpImpu...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * -----------------------------------------------------------------*
      * COWGRAI_getPremioFinal() Retorna el Premio Final                 *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     D COWGRAI_getPremioFinal...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * -----------------------------------------------------------------*
      * COWGRAI_getCantProvIn() Cantidad de Registros en EG3             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     D COWGRAI_getCantProvIn...
     D                 pr            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

      * -----------------------------------------------------------------*
      * COWGRAI_getPrimaIn() Retorna Prima por Inder                     *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                                                                  *
      * --------------------------------------------------------------   *
     D COWGRAI_getPrimaIn...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peRpro                       2  0 const

      * ---------------------------------------------------------------- *
      * COWGRAI_setImportesImpuestos(): Graba los importes de Impuestos  *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peRefi (input)  Recargo Financiero                          *
      *      peDere (input)  Derecho de Emision                          *
      *      peImpi (input)  Impuestos Internos                          *
      *      peSers (input)  Servicios Sociales                          *
      *      peTssn (input)  Tasa SSN                                    *
      *      peIpr1 (input)  Impuesto Valor Agregado                     *
      *      peIpr2 (input)  Acciones                                    *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peIpr5 (input)  Recargo de Capital                          *
      *      peIpr6 (input)  Componente Premio 6                         *
      *      peIpr7 (input)  Ing.Brutos Riesgo                           *
      *      peIpr8 (input)  Ing.Brutos Empresa                          *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_setImportesImpuestos...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peRefi                      15  2 const
     D   peDere                      15  2 const
     D   peImpi                      15  2 const
     D   peSers                      15  2 const
     D   peTssn                      15  2 const
     D   peIpr1                      15  2 const
     D   peIpr2                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peIpr5                      15  2 const
     D   peIpr6                      15  2 const
     D   peIpr7                      15  2 const
     D   peIpr8                      15  2 const
     D   peIpr9                      15  2 const
     D   pePrem                      15  2 const

      * ---------------------------------------------------------------- *
      * COWGRAI_dltEg3(): Elimina los registros CTWEG3                   *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peArse (input)  Arse                                        *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_dltEg3...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

      * ---------------------------------------------------------------- *
      * COWGRAI_setCabeceraEg3(): Graba Cabecera CTWEG3                  *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peArse (input)  Arse                                        *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_setCabeceraEg3...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

      * ---------------------------------------------------------------- *
      * COWGRAI_updEg3(): Actualiza los registros CTWEG3                 *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peArse (input)  Arse                                        *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_updEg3...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peCant                      10i 0 const

      * ---------------------------------------------------------------- *
      * COWGRAI_updPremio() Actualiza Premio                             *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peSubt (input)  Subtotal                                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_updPremio...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSubt                      15  2 const
      * -----------------------------------------------------------------*
      * COWGRAI_getSuperPoliza(): Obtiene Numero de SuperPoliza de una   *
      *                           cotización.                            *
      *                                                                  *
      *     peBase   (input)   Parametro Base                            *
      *     peNctw   (input)   Número de Cotizacion                      *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_getSuperPoliza...
     D                 pr             9  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * -----------------------------------------------------------------*
      * COWGRAI_getXref(): Obtiene Recargo Financiero                    *
      *                                                                  *
      *     peBase   (input)   Parametro Base                            *
      *     peNctw   (input)   Número de Cotizacion                      *
      *     peRama   (input)   Rama                                      *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_getXref...
     D                 pr             5  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

      * -----------------------------------------------------------------*
      * COWGRAI_getTipodeOperacion(): devuelve el tipo de operacion de   *
      *                               la cotización                      *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peTiou  -  Tipo de Operación                      *
      *                peStou  -  SubTipo de Operación de Usuario        *
      *                peStos  -  SubTipo de Operación de Sistema        *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_getTipodeOperacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peTiou                       1  0
     D   peStou                       2  0
     D   peStos                       2  0
      * -----------------------------------------------------------------*
      * COWGRAI_sumaDeAccesorios(): Devuelve suma de los accesorios por  *
      *                             componente                           *
      *        Input :                                                   *
      *                                                                  *
      *                peCobl  -  Cobertura                              *
      *                peVhan  -  Año del Vehículo                       *
      *                peTiou  -  Tipo operacion usuario                 *
      *                peStou  -  Subtipo operacion usuario              *
      *                peStos  -  Subtipo operacion sistema              *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_sumaDeAccesorios...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ---------------------------------------------------------------- *
      * COWGRAI_SumaInfoPro(): devuelve la suma asegurada que corresponde*
      *                        de infopro.                               *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peArcd  -  código de Artículo                     *
      *                peVhmc  -  marca del vehiculo                     *
      *                pevhmo  -  codigo de modelo                       *
      *                pevhcs  -  codigo de submodelo                    *
      *                pevhcr  -  codigo de carroceria                   *
      *                pevhan  -  año del vehiculo                       *
      *                pevhvu  -  Suma Asegurada                         *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_SumaInfoPro...
     D                 pr            15  2
     D   peArcd                       6  0 const
     D   peVhmc                       3    const
     D   pevhmo                       3    const
     D   pevhcs                       3    const
     D   pevhcr                       3    const
     D   pevhan                       4  0 const
     D   pevhvu                      15  2 const
      * ---------------------------------------------------------------- *
      * COWGRAI_bloqueoProd(): Verifica que el productor no este bloquea-*
      *                        do para el tipo de operación.             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peTiou  -  Tipo de Operación                      *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_bloqueoProd...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peTiou                       1  0   const
      * ------------------------------------------------------------ *
      * COWGRAI_getSumaAseguradaCobertura():retorna la suma suma ase-*
      *                                     gurada de la cobertura.  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Cant. Pólizas por Rama                *
      *     pePoco   (input)   Nro de Componente                     *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getSumaAseguradaCobertura...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getSumaAsegAsegurados(): retorna la suma sum ase-    *
      *                                 gurada que se ha cargado     *
      *                                 para los asegurados          *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Código de Rama                        *
      *     peArse   (input)   Cant. Pólizas por Rama                *
      *     pePoco   (input)   Nro de Componente                     *
      *     peRiec   (input)   Riesgo                                *
      *     peXcob   (input)   Cobertura                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getSumaAsegAsegurados...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getDatosCapituloHogar ():retorna la clasificación    *
      *                                 del riesgo.                  *
      *                                                              *
      *     peRama   (input)   Código de Rama                        *
      *     peXpro   (input)   Plan                                  *
      *     peCtar   (output)  capitulo de tarifa                    *
      *     peCta1   (output)  capitulo tarifa inciso 1              *
      *     peCeta   (output)  capitulo tarifa sistema               *
      *     peCagr   (output)  agravaciones de Riesgos               *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getDatosCapituloHogar...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peCtar                       4  0
     D   peCta1                       2
     D   peCeta                       4
     D   peCagr                       2  0
      * ------------------------------------------------------------ *
      * COWGRAI_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWGRAI_inz     pr
      * ------------------------------------------------------------ *
      * COWGRAI_end(): Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWGRAI_end     pr
      * ------------------------------------------------------------ *
      * COWGRAI_error(): Retorna el último error del service program *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D COWGRAI_error   pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * COWGRAI_getFormaDePagoPdP(): Obtiene Forma de Pago desde un  *
      *                              Plan de Pagos.                  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peArcd   (input)   Código de Artículo                    *
      *     peNrpp   (input)   Número de Plan de Pagos               *
      *     peCfpg   (output)  Forma de Pago                         *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getFormaDePagoPdP...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peArcd                       6  0 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0

      * ------------------------------------------------------------ *
      * COWGRAI_updFormaDePagoCot(): Actualiza forma de pago en la   *
      *                              cabecera de la cotización       *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peNrpp   (input)   Plan de Pago                          *
      *                                                              *
      * Retorna: *on si OK, *OFF si no.                              *
      * ------------------------------------------------------------ *
     D COWGRAI_updFormaDePagoCot...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getCategoria(): Obtiene la categoria a partir de la  *
      *                         actividad                            *
      *                                                              *
      *     peCact   (input)   Código de actividad                   *
      *                                                              *
      * Retorna: Codigo de Categoría                                 *
      * ------------------------------------------------------------ *
     D COWGRAI_getCategoria...
     D                 pr             2  0
     D   peCact                       5  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_deleteCategoria:Elimina archivo de categorias        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                peActi  -  Actividad                          *
      *                peSecu  -  Secuencia                          *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteCategoria...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_deleteSecuAct() Elimina por Secuencia y Actividad    *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                peActi  -  Actividad                          *
      *                peSecu  -  Secuencia                          *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteSecuAct...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
      * ---------------------------------------------------------------- *
      * COWGRAI_setImpConcComer() Graba condiciones comerciales          *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      pePrim (output)Prima                                        *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     D COWGRAI_setImpConcComer...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePrim                      15  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_getCondComerciales() Retorna condiciones comerciales     *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peXrea (output)Epv                                          *
      *      peCopr (output)Comision                                     *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     D COWGRAI_getCondComerciales...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXrea                       5  2
     D   peXopr                       5  2
      * ---------------------------------------------------------------- *
      * COWGRAI_getCondComercialesA() Retorna condiciones comerciales    *
      *                               desde archivo CTW001               *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peXrea (output)Epv                                          *
      *      peCopr (output)Comision                                     *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ------------------------------------------------------------ *
     D COWGRAI_getCondComercialesA...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXrea                       5  2
     D   peCopr                       5  2

      * ---------------------------------------------------------------- *
      * COWGRAI_getRead() Retorna Read                                   *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ------------------------------------------------------------ *
     D COWGRAI_getRead...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_ValPlanCerradoUnico(): Valida que plan cerrado tengo un  *
      *                                único compronente                 *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peArse (input) Artículo                                     *
      *      pePoco (input) Nro. de Componente                           *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ------------------------------------------------------------ *
     D COWGRAI_ValPlanCerradoUnico...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   pePoco                       4  0   const
     D   peXpro                       3  0   const
      * ---------------------------------------------------------------- *
      * COWGRAI_getTopesEpv(): Obtiene topes de Extra Prima Variable     *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peRama (input)  Rama                                        *
      *      peEpvm (output) Tope mínimo                                 *
      *      peEpvx (output) Tope máximo                                 *
      *      peErro (output) Código de Error                             *
      *      peMsgs (output) Mensaje de Error                            *
      *                                                                  *
      * ---------------------------------------------------------------  *
     D COWGRAI_getTopesEpv...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   peEpvm                       3  0
     D   peEpvx                       3  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ---------------------------------------------------------------- *
      * COWGRAI_updImpConcComer() Actualiza condiciones comerciales      *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peXrea (output)Recargo Administrativo                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     D COWGRAI_updImpConcComer...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXrea                       5  2   const
      * ---------------------------------------------------------------- *
      * COWGRAI_cpyCotizacion() Copiar una cotización en una nueva       *
      *                                                                  *
      *      peBase (input)  Parámetro Base                              *
      *      peNctw (input)  Número de Cotización a copiar               *
      *      peNct1 (output) Nuevo Número de Cotización                  *
      *      peErro (output) Indicador de Error                          *
      *      peMsgs (output) Indicador de Error                          *
      *                                                                  *
      * Retorna 0 si OK, -1 si error (verificar con _error() ).          *
      * ---------------------------------------------------------------- *
     D COWGRAI_cpyCotizacion...
     D                 pr            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNct1                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs) const
      * ---------------------------------------------------------------- *
      * COWGRAI_getSuperPolizaReno(): Recupera SuperPoliza Relacionada   **
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_getSuperPolizaReno...
     D                 pr             9  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const

      * ------------------------------------------------------------ *
      * COWGRAI_deleteAccesorios: Elimina caracterizticas del bien   *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteAccesorios...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_chkTarjCredito: Valida Tarjeta de Credito.           *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peCtcu  -  Código TC                          *
      *                peNrtc  -  Número TC                          *
      *                                                              *
      * Retorna: 0 OK                                                *
      *         -1 Empresa inválida                                  *
      *         -2 Cantidad de Dígitos Inválida                      *
      *         -3 Primer dígito significativo 0                     *
      * -------------------------------------------------------------*
     D COWGRAI_chkTarjCredito...
     D                 pr            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
      * ---------------------------------------------------------------- *
      * COWGRAI_getMinimoRes3125: Retorna Importe Mínimo de Resolucion   *
      *                           3125                                   *
      *      peRama (input)  Rama                                        *
      *                                                                  *
      * Retorna Importe.-                                                *
      * ---------------------------------------------------------------- *
     D COWGRAI_getMinimoRes3125...
     D                 pr            15  2
     D   peRama                       2  0 const

      * ---------------------------------------------------------------- *
      * COWGRAI_setSellados (): Graba Importes de Sellados               *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peRama (input)  Rama                                        *
      *      peSeri (input)  Sellado Riesgos                             *
      *      peSeem (input)  Sellado Empresa                             *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     D COWGRAI_setSellados...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peSeri                      15  2 const
     D   peSeem                      15  2 const

      * ---------------------------------------------------------------- *
      * COWGRAI_updTablaDeImpuestos: Elimina porcentajes con monto en    *
      *                              Cero                                *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     D COWGRAI_updTablaDeImpuestos...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ----------------------------------------------------------------- *
      * COWGRAI_getCtw000():Retorna todos los datos de la Cabecera de     *
      *                     una Cotización                                *
      *                                                                   *
      *    peBase  (imput)  Base                                          *
      *    peNctw  (imput)  Nro. Cotización                               *
      *    peDsCtw (output) Registro con ctw000 ( opcional )              *
      *                                                                   *
      * Retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D COWGRAI_getCtw000...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peDsCtw                           likeds(dsctw000_t)
     D                                     options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWGRAI_deleteCompVida(): Elimina Componentes de Vida        *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                peRama  -  Rama                               *
      *                peArse  -  Cant. Pólizas por Rama             *
      *                pePoco  -  Numero de componente               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_deleteCompVida...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      *  COWGRAI_GetImpuestosEg3 : Retorna Impuestos x Prov.         *
      *                                                              *
      *     peBase    (input)  Base                                  *
      *     peNctw    (input)  Número de cotización                  *
      *     peRama    (input)  Rama                                  *
      *     peArse    (input)  Cant. Pólizas por Rama                *
      *     peImpEg3  (output) Estructura de Impuestos x Prov        *
      *     peImpEg3C (output) Cantidad de Prov.                     *
      *     peRpro    (input)  Cod. de Provincia ( opcional )        *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_GetImpuestosEg3...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peImpEg3                          likeds( ImpEg3 ) dim( 99 )
     D   peImpEg3C                   10i 0
     D   peRpro                       2  0 options( *omit : *nopass )

      * ------------------------------------------------------------ *
      *  COWGRAI_GetImpuestosTotalesEg3 : Retorna Total de Impuestos *
      *                                                              *
      *     peBase    (input)  Base                                  *
      *     peNctw    (input)  Número de cotización                  *
      *     peRama    (input)  Rama                                  *
      *     peArse    (input)  Cant. Pólizas por Rama                *
      *     peImpEg3  (output) Estructura de Impuestos x Prov        *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_GetImpuestosTotalesEg3...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peImpEg3                          likeds( ImpEg3 )

      * ---------------------------------------------------------------- *
      * COWGRAI_UpdPremioEg3: Actualiza Premio x Provincia               *
      *                                                                  *
      *      peBase (input)  Base                                        *
      *      peNctw (input)  Nro de Cotizacion                           *
      *      peSubt (input)  Subtotal                                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_updPremioEg3...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSubt                      15  2 const

      * ---------------------------------------------------------------- *
      * COWGRAI_GetCalculoPercepcion(): obtiene el IPR6 (Calculo de      *
      *                                                  percepción)     *
      *      peRpro (input)  Provincia IDER                              *
      *      peRama (input)  Rama                                        *
      *      peMone (input)  Codigo de Moneda de Emision                 *
      *      peCome (input)  Cotizacion Moneda Emision                   *
      *      peSubp (input)  Prima subtotal                              *
      *      peSuma (input)  Suma Asegurada                              *
      *      peCiva (input)  Códidgo de IVA                              *
      *      peIpr1 (input)  Impuesto Valor Agregado                     *
      *      peIpr3 (input)  IVA-Importe Percepcion                      *
      *      peIpr4 (input)  IVA-Resp.No Inscripto                       *
      *      peCuit (input)  Cuit                           ( opcional ) *
      *      peAsen (input)  Asegurado                      ( opcional ) *
      *      pePorc (input)  Porcentaje                     ( opcional ) *
      *      pePpr1 (output) Impuesto Valor Agregado x Porc ( opcional ) *
      *      pePpr3 (output) IVA-Importe Percepcion x Porc  ( opcional ) *
      *      pePpr4 (output) IVA-Resp.No Inscripto x Porc   ( opcional ) *
      *                                                                  *
      * Retorna Importe                                                  *
      * ---------------------------------------------------------------- *
     D COWGRAI_GetCalculoPercepcion...
     D                 pr            15  2
     D   peRpro                       2  0 const
     D   peRama                       2  0 const
     D   peMone                       2    const
     D   peCome                      15  6 const
     D   peSubp                      15  2 const
     D   peSuma                      15  2 const
     D   peCiva                       2  0 const
     D   peIpr1                      15  2 const
     D   peIpr3                      15  2 const
     D   peIpr4                      15  2 const
     D   peCuit                      11    options( *omit : *nopass )
     D   peAsen                       7  0 options( *omit : *nopass )
     D   pePorc                       9  6 options( *omit : *nopass )
     D   pePpr1                      15  2 options( *omit : *nopass )
     D   pePpr3                      15  2 options( *omit : *nopass )
     D   pePpr4                      15  2 options( *omit : *nopass )

      * ------------------------------------------------------------ *
      *  COWGRAI_setAjustaPremio(): Se ajusta premio segùn tabla     *
      *                                                              *
      *     peBase    (input)  Base                                  *
      *     peNctw    (input)  Número de cotización                  *
      *     peRama    (input)  Rama                                  *
      *     peArse    (input)  Cant. Pólizas por Rama                *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_setAjustaPremio...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

      * ------------------------------------------------------------ *
      *  COWGRAI_getImpPrimaMinima: Obtiene Prima Minima             *
      *                                                              *
      *     peBase    (input)  Parametros Base                       *
      *     peNctw    (input)  Nro. Cotizacion                       *
      *     peRama    (input)  Rama                                  *
      *     peArcd    (input)  Artículo                              *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_getImpPrimaMinima...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArcd                       6  0 const
      * ---------------------------------------------------------------- *
      * COWGRAI_setCondComerciales: Graba Condiciones Comerciales        *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peArse (input) Cant. Pólizas por Rama                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *

     D COWGRAI_setCondComerciales...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const

      * ---------------------------------------------------------------- *
      * COWGRAI_updCondComerciales: Recalcula Condiciones Comerciales    *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peXrea (output)Recargo Administrativo                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *
     D COWGRAI_updCondComerciales...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peXrea                       5  2   const
      * ------------------------------------------------------------ *
      * COWGRAI_delCondComerciales: Elimina Condiciones Comerciales  *
      *                                                              *
      *        Input :                                               *
      *                                                              *
      *                peBase  -  Base                               *
      *                peNctw  -  Número de cotización               *
      *                                                              *
      * Retorna *on / *off                                           *
      * -------------------------------------------------------------*
     D COWGRAI_delCondComerciales...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ---------------------------------------------------------------- *
      * COWGRAI_SaveImpuestos2():Graba Impuestos                         *
      *                                                                  *
      *      peBase (input) Base                                         *
      *      peNctw (input) Número de Cotización                         *
      *      peRama (input) Rama                                         *
      *      peArse (input) Cant. Pólizas por Rama                       *
      *                                                                  *
      * Retorna *on / Off                                                *
      * ---------------------------------------------------------------- *

     D COWGRAI_SaveImpuestos2...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const

      * ---------------------------------------------------------------- *
      * COWGRAI_getAuditoria(): Devuelve datos de Auditoria              *
      *                                                                  *
      *      peBase  (input) Parametros Base                             *
      *      peNctw  (input) Numero de Cotizacion                        *
      *      peDstim (input) Esructura de Archivo CTWTIM                 *
      *                                                                  *
      * Return *on = Ok / *off = No encontro                             *
      * ---------------------------------------------------------------- *
     D COWGRAI_getAuditoria...
     D                 pr              n
     D   peBase                            likeds(parambase)const
     D   peNctw                       7  0 const
     D   peDstim                           likeds(dsctwtim_t)

      * ---------------------------------------------------------------- *
      * COWGRAI_setAduditoria(): Gaba/actualiza Datos de auditoria       *
      *                                                                  *
      *      peDsTim (input) Esructura de Archivo CTWTIM                 *
      *                                                                  *
      * VOID                                                             *
      * ---------------------------------------------------------------- *

     D COWGRAI_setAuditoria...
     D                 pr
     D   peDsTim                           likeds(dsctwtim_t)const

      * ---------------------------------------------------------------- *
      * COWGRAI_getPolizasxPropuesta: Obtener Nro. de Poliza por rama    *
      *                               asociado a una Propuesta.          *
      *      peBase ( input  ) Base                                      *
      *      peSoln ( input  ) Nro de Propuesta                          *
      *      pePoli ( output ) Estructura de Poliza ( RAMA/POLIZA )      *
      *      pePoliC( input  ) Cantidad de Polizas                       *
      *      peErro ( output ) Indicador de Error                        *
      *      peMsgs ( output ) Estructura de Error                       *
      *      peCest ( output ) Estado de Propuesta ( opcional )          *
      *      peCses ( output ) Sub. Estado         ( opcional )          *
      *      peDest ( output ) Descripcion         ( opcional )          *
      *                                                                  *
      *                                                                  *
      * Retorna *On = Propuesta Correcta / *Off = Propuesta Inexistente  *
      * ---------------------------------------------------------------- *

     D COWGRAI_getPolizasxPropuesta...
     D                 pr              n
     D   peBase                            likeds( paramBase ) const
     D   peSoln                       7  0   const
     D   pePoli                            likeds( spolizas ) Dim( 100 )
     D   pePoliC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds( paramMsgs )
     D   peCest                       1  0 options( *omit : *nopass )
     D   peCses                       2  0 options( *omit : *nopass )
     D   peDest                      20    options( *omit : *nopass )

      * ---------------------------------------------------------------- *
      * COWGRAI_setNroCotizacionAPI:  Asocia Nro de cotizacion API a     *
      *                               cotizacion WEB                     *
      *      peBase ( input  ) Base                                      *
      *      peNctw ( input  ) Nro. de Cotizacion WEB                    *
      *      peNcta ( input  ) Nro. de Cotizacion API                    *
      *      peErro ( output ) Cod.de Error                              *
      *      peMsgs ( output ) Estructura de Mensajes                    *
      *                                                                  *
      *                                                                  *
      * Retorna: *On = Actualizacion OK / *off = Error                   *
      * ---------------------------------------------------------------- *

     D COWGRAI_setNroCotizacionAPI...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNcta                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWGRAI_updCabecera: Actualiza datos de Cabecera.            *
      *                                                              *
      *    peBase ( input  ) Base                                    *
      *    peNctw ( input  ) Nro. de Cotizacion WEB                  *
      *    peErro ( output ) Cod.de Error                            *
      *    peMsgs ( output ) Estructura de Mensajes                  *
      *    peNcta ( input  ) Nro. de Cotizacion API    ( opcional )  *
      *    peCuii ( input  ) Cuit del Intermediario    ( opcional )  *
      *    peNsys ( input  ) Nombre del Sistema Remoto ( opcional )  *
      *    peNuse ( input  ) Nombre del Usuario        ( opcional )  *
      *    peCest ( input  ) Estado                    ( opcional )  *
      *    peCses ( input  ) SubEstado                 ( opcional )  *
      *                                                              *
      * Retorna: PeErro '-1' No se actualizo / '0' Ok                *
      * ------------------------------------------------------------ *
     D COWGRAI_updCabecera...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
     D   peNcta                       7  0 options( *omit : *nopass )
     D   peCuii                      11    options( *omit : *nopass )
     D   peNsys                      20    options( *omit : *nopass )
     D   peNuse                      50    options( *omit : *nopass )
     D   peCest                       1  0 options( *omit : *nopass ) const
     D   peCses                       2  0 options( *omit : *nopass ) const

      * ------------------------------------------------------------ *
      * COWGRAI_chkCotizacionApi: Verifica si la cotizacion vino por *
      *                           API                                *
      *          peBase   ( input  ) Base                            *
      *          peNctw   ( input  ) Nro. de Cotizacion WEB          *
      *                                                              *
      * Retorna: *On = Si vino de API / *off = Caso contrario        *
      * ------------------------------------------------------------ *
     D COWGRAI_chkCotizacionApi...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_chkRenovProcGuarEm: Verifica si existe cotización de *
      *                             renovación en proceso o guardada *
      *                                                              *
      *          peBase   ( input  ) Parametros Base                 *
      *          peArcd   ( input  ) Código de Articulo              *
      *          peSpol   ( input  ) Número de SuperPoliza
      *                                                              *
      * Retorna: *On = Si existe / *off = No existe                  *
      * ------------------------------------------------------------ *
     D COWGRAI_chkRenovProcGuarEm...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------------ *
      * COWGRAI_chkPlandePagoHabWeb(): Chequea que el plan de pago de la   *
      *                                póliza este habilitado para la web  *
      *                                                                    *
      *     peEmpr ( input )  Código de Empresa                            *
      *     peSucu ( input )  Código de Sucursal                           *
      *     peArcd ( input )  Código de Articulo                           *
      *     peSpol ( input )  Nro. de Superpoliza                          *
      *     peSspo ( input )  Suplemento de Superpoliza                    *
      *                                                                    *
      * Retorna *on = Habilitado / *off = No habilitado                    *
      * ------------------------------------------------------------------ *
     D COWGRAI_chkPlandePagoHabWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWGRAI_updEstado: Actualiza el estado del ctw000            *
      *                                                              *
      *          peBase   ( input  ) Base                            *
      *          peNctw   ( input  ) Nro. de Cotizacion WEB          *
      *          peCest   ( input  ) Cód. Estado Cot/Prop            *
      *          peCses   ( input  ) Cod. Subestado Cot/Prop         *
      *                                                              *
      * Retorna: *On = Actualizo / *off = No actualizo               *
      * ------------------------------------------------------------ *
     D COWGRAI_updEstado...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCest                       1  0 const
     D   peCses                       2  0 const

      * ----------------------------------------------------------------- *
      * COWGRAI_updCtw000(): Actualiza todos los datos de la Cabecera de  *
      *                      una Cotización                               *
      *                                                                   *
      *    peDsCtw ( input  )  Registro con ctw000                        *
      *                                                                   *
      * Retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D COWGRAI_updCtw000...
     D                 pr              n
     D   peDsCtw                           likeds( dsctw000_t )
     D                                     options( *nopass : *omit ) const

      * ----------------------------------------------------------------- *
      * COWGRAI_setCtw000(): Graba todos los datos de la Cabecera de      *
      *                      una Cotización                               *
      *                                                                   *
      *    peDsCtw ( input  )  Registro con ctw000                        *
      *                                                                   *
      * Retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D COWGRAI_setCtw000...
     D                 pr              n
     D   peDsCtw                           likeds( dsctw000_t )
     D                                     options( *nopass : *omit ) const

      * ------------------------------------------------------------ *
      * COWGRAI_vencerCotizacion: Actualiza estado en ctw000 a       *
      *                           vencida                            *
      *                                                              *
      *          peBase   ( input  ) Base                            *
      *          peNctw   ( input  ) Nro. de Cotizacion WEB          *
      *                                                              *
      * Retorna: *On = Actualizo / *off = No actualizo               *
      * ------------------------------------------------------------ *
     D COWGRAI_vencerCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_getCotizacionMoneda(): Retorna la cotización de mone-*
      *                           da usada en la cotización.         *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getCotizacionDeMoneda...
     D                 pr            15  6
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_setFlota(): Graba si la cotización es una Flota.     *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * Retorna: *On = Actualizo / *off = No actualizo               *
      * ------------------------------------------------------------ *
     D COWGRAI_setFlota...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_isFlota(): Retorna si la cotización es de Flota.     *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * Retorna: *On = Es flota / *off = No es Flota                 *
      * ------------------------------------------------------------ *
     D COWGRAI_isFlota...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_setExtraComision(): Graba Extra Comisión x rama      *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_setExtraComision...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_getVacc(): Obtener Importe de Extra Comision x rama  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      * Retorna Importe de Vacc                                      *
      * ------------------------------------------------------------ *
     D COWGRAI_getVacc...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_getFechaCotizacion(): Retorna fecha de cotización    *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *                                                              *
      * Retorna: AAAAMMDD = OK / -1 = Error                          *
      * ------------------------------------------------------------ *
     D COWGRAI_getFechaCotizacion...
     D                 pr             8  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_getComision(): Retorna Comision                      *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peXopr   ( output ) % de Comisión                        *
      *     peCopr   ( output ) Importe de comisión                  *
      *                                                              *
      * Retorna: *on = encontró / *off = No encontró                 *
      * ------------------------------------------------------------ *
     D COWGRAI_getComision...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXopr                       5  2
     D   peCopr                      15  2

      * ------------------------------------------------------------ *
      * COWGRAI_deletePocoScoring(): Elimina registro en ctwet3      *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cant. Pólizas por Rama               *
      *     pePoco   ( input  ) Número de Bien Asegurado             *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_deletePocoScoring...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_getDatosCapituloRGV:  Retorna la clasificación       *
      *                                 del riesgo.                  *
      *                                                              *
      *     peRama   (input)   Código de Rama                        *
      *     peXpro   (input)   Plan                                  *
      *     peCtar   (output)  capitulo de tarifa                    *
      *     peCta1   (output)  capitulo tarifa inciso 1              *
      *     peCeta   (output)  capitulo tarifa sistema               *
      *     peCagr   (output)  agravaciones de Riesgos               *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_getDatosCapituloRGV...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peCtar                       4  0
     D   peCta1                       2
     D   peCeta                       4
     D   peCagr                       2  0

      * ------------------------------------------------------------ *
      * COWGRAI_getEstadoCotizacion : Retorna estado de una          *
      *                               Cotizacion.                    *
      *                                                              *
      *     peBase ( input  ) Parametros Base                        *
      *     peNctw ( input  ) Nro. de Cotización                     *
      *     peCest ( output ) Estado de Propuesta                    *
      *     peCses ( output ) Sub. Estado                            *
      *                                                              *
      * Retorna: *on = Encontro / *off = No Encontro                 *
      * ------------------------------------------------------------ *
     D COWGRAI_getEstadoCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peCest                       1  0
     D   peCses                       2  0

      * ------------------------------------------------------------ *
      * COWGRAI_getNroPropuesta: Retorna nro de propusta WEB.        *
      *                                                              *
      *     peBase ( input  ) Parametros Base                        *
      *     peNctw ( input  ) Nro. de Cotización                     *
      *     peSoln ( output ) Nro. de Propuesta                      *
      *                                                              *
      * Retorna: *on = Encontro / *off = No Encontro                 *
      * ------------------------------------------------------------ *
     D COWGRAI_getNroPropuesta...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSoln                       7  0

      * ------------------------------------------------------------ *
      * COWGRAI_setNroPropuesta: Retorna nro de propusta WEB nuevo.  *
      *                                                              *
      *     peBase ( input  ) Parametros Base                        *
      *     peNctw ( input  ) Nro. de Cotización                     *
      *     peSoln ( output ) Nro. de Propuesta                      *
      *                                                              *
      * Retorna: 0 = Error /  >0 = Ok                                *
      * ------------------------------------------------------------ *
     D COWGRAI_setNroPropuesta...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peSoln                       1  0

      * ------------------------------------------------------------ *
      * COWGRAI_chkCotizacionEnviada: Retorna si la Cotizacion fue   *
      *                               enviada a emitir.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *                                                              *
      * Retorna: *on = Envida / *off = No Enviada                    *
      * ------------------------------------------------------------ *
     D COWGRAI_chkCotizacionEnviada...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_chkCotizacionVencida: Retorna si la Cotizacion se    *
      *                               encuentra vencida.             *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *                                                              *
      * Retorna: *on = Vencida / *off = No Vencida                   *
      * ------------------------------------------------------------ *
     D COWGRAI_chkCotizacionVencida...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_chkTieneAseguradoPrincipal : Retorna si cotizacion   *
      *                                      tiene asegurado         *
      *                                      principal.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *                                                              *
      * Retorna: *on = Tiene / *off = No tiene                       *
      * ------------------------------------------------------------ *
     D COWGRAI_chkTieneAseguradoPrincipal...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_chktodasLasRamasCotizadas: Validar si se cotizaron   *
      *                                    todas las ramas asociadas *
      *                                    al artículo.              *
      *                                                              *
      *     peBase   (input)   Parametros Base                       *
      *     peNctw   (input)   Nro. de Cotización                    *
      *     peErro   (output)  Indicador de Error                    *
      *     peMsgs   (output)  Estructura de Error                   *
      *                                                              *
      * Retorna: *on = Ok / *off = Error                             *
      * ------------------------------------------------------------ *
     D COWGRAI_chktodasLasRamasCotizadas...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWGRAI_getCtweg3(): Retorna datos de Primas por provincia   *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                         ( opc ) *
      *    peArse   ( imput  )  Cant. de articulos por rama  ( opc ) *
      *    peRpro   ( imput  )  Provincia                    ( opc ) *
      *    peDsEg3  ( output )  Registro con ctweg3          ( opc ) *
      *    peDsEg3C ( output )  Cantidad de registros        ( opc ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     D COWGRAI_getCtweg3...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   peRpro                       2  0 options( *omit : *nopass ) const
     D   peDsEg3                           likeds(dsctweg3_t) dim( 9999 )
     D                                     options( *omit : *nopass )
     D   peDsEg3C                    10i 0 options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * COWGRAI_chkCtweg3(): Valida si existen Primas por provincia  *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                         ( opc ) *
      *    peArse   ( imput  )  Cant. de articulos por rama  ( opc ) *
      *    peRpro   ( imput  )  Provincia                    ( opc ) *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     D COWGRAI_chkCtweg3...
     D                 pr              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 options( *omit : *nopass ) const
     D   peArse                       2  0 options( *omit : *nopass ) const
     D   peRpro                       2  0 options( *omit : *nopass ) const

      * ------------------------------------------------------------ *
      * COWGRAI_setCtweg3(): Graba Primas por provincia              *
      *                                                              *
      *    peDsEg3  ( output )  Registro con ctweg3   ( opcional )   *
      *                                                              *
      * Retorna *on = Grabo ok / *off = No grabo                     *
      * ------------------------------------------------------------ *
     D COWGRAI_setCtweg3...
     D                 pr              n
     D   peDsEg3                           likeds(dsctweg3_t)
     D                                     options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * COWGRAI_updCtweg3(): Actualiza Primas por provincia          *
      *                                                              *
      *    peDsEg3  ( output )  Registro con ctweg3   ( opcional )   *
      *                                                              *
      * Retorna *on = Actualizo ok / *off = No actualizo             *
      * ------------------------------------------------------------ *
     D COWGRAI_updCtweg3...
     D                 pr              n
     D   peDsEg3                           likeds(dsctweg3_t)
     D                                     options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * COWGRAI_getCtw001(): Retorna datos de Impuestos %            *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *    peDs001  ( output )  Registro con ctw001                  *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     D COWGRAI_getCtw001...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peDs001                           likeds(dsCtw001_t) dim( 999 )

      * ------------------------------------------------------------ *
      * COWGRAI_chkCtw001(): Valida si existen Impuestos %           *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     D COWGRAI_chkCtw001...
     D                 pr              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_setCtw001(): Graba Impuestos %                       *
      *                                                              *
      *    peDs001  ( output )  Registro con ctweg3   ( opcional )   *
      *                                                              *
      * Retorna *on = Grabo ok / *off = No grabo                     *
      * ------------------------------------------------------------ *
     D COWGRAI_setCtw001...
     D                 pr              n
     D   peDs001                           likeds(dsCtw001_t)
     D                                     options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * COWGRAI_getCtw001C(): Retorna datos de Impuestos %           *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *    peDs01C  ( output )  Registro con ctw001C                 *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     D COWGRAI_getCtw001C...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peDs01C                           likeds(dsCtw001C_t) dim( 999 )

      * ------------------------------------------------------------ *
      * COWGRAI_chkCtw001C(): Valida si existen Impuestos %          *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     D COWGRAI_chkCtw001C...
     D                 pr              n
     D   peBase                            likeds(paramBase)
     D   peNctw                       7  0 const
     D   peRama                       2  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_setCtw001C(): Graba Impuestos %                      *
      *                                                              *
      *    peDs01C  ( output )  Registro con ctw001C  ( opcional )   *
      *                                                              *
      * Retorna *on = Grabo ok / *off = No grabo                     *
      * ------------------------------------------------------------ *
     D COWGRAI_setCtw001C...
     D                 pr              n
     D   peDs01C                           likeds(dsCtw001C_t)
     D                                     options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * COWGRAI_getImpuestosCotizacion(): Retorna Impuestos de una   *
      *                                   cotizacion.                *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peNctw   ( imput  )  Nro. Cotización                      *
      *    peRama   ( imput  )  Rama                                 *
      *    peImpu   ( output )  Ds con los impuestos                 *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     D COWGRAI_getImpuestosCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peImpu                            likeds(Impuesto)

      * ------------------------------------------------------------ *
      * COWGRAI_getPendientes(): Retorna si tiene movimientos        *
      *                          pendientes en ctw00003              *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peArcd   ( imput  )  Número de Artículo                   *
      *    peSpol   ( imput  )  SuperPoliza                          *
      *                                                              *
      * Retorna *on = Encontró / *off = No encontró                  *
      * ------------------------------------------------------------ *
     D COWGRAI_getPendientes...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_getPremio(): Obtener Premio                          *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWGRAI_getPremio...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_getCliente(): Retorna datos del cliente              *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     peClie   (output) Estructura de Cliente                  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWGRAI_getCliente...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peClie                            likeds(ClienteCot_t)
      * ------------------------------------------------------------ *
      * COWGRAI_setRelacion(): Graba relación de cotización AP y RC  *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peArcd   (input)  Artículo                               *
      *     peNctw   (input)  Nro de Cotización Robo                 *
      *     peNctx   (input)  Nro de Cotización AP                   *
      *     peNcty   (input)  Nro de Cotización RC                   *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWGRAI_setRelacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peNctw                       7  0 const
     D   peNctx                       7  0 const
     D   peNcty                       7  0 const
      * ------------------------------------------------------------ *
      * COWGRAI_chkRelacionAP(): Chequea si la cotizacion AP esta    *
      *                          relacionada                         *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNctx   (input)  Nro de Cotización AP                   *
      *     peArcd   (output) Artículo de Superpoliza de Robo (opc)  *
      *     peNctw   (output) Nro. de cotización de Robo      (opc)  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWGRAI_chkRelacionAP...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctx                       7  0 const
     D   peArcd                       6  0 options( *omit : *nopass )
     D   peNctw                       7  0 options( *omit : *nopass )
      * ------------------------------------------------------------ *
      * COWGRAI_chkRelacionRC(): Chequea si la cotizacion RC esta    *
      *                          relacionada                         *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNcty   (input)  Nro de Cotización AP                   *
      *     peArcd   (output) Artículo de Superpoliza de Robo (opc)  *
      *     peNctw   (output) Nro. de cotización de Robo      (opc)  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWGRAI_chkRelacionRC...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNcty                       7  0 const
     D   peArcd                       6  0 options( *omit : *nopass )
     D   peNctw                       7  0 options( *omit : *nopass )

      * ------------------------------------------------------------ *
      * COWGRAI_getNroCotiXSpol(): Retorna Número de Cotización      *
      *                                                              *
      *    peBase   ( imput  )  Base                                 *
      *    peArcd   ( imput  )  Número de Artículo                   *
      *    peSpol   ( imput  )  SuperPoliza                          *
      *                                                              *
      * Retorna W0NCTW                                               *
      * ------------------------------------------------------------ *
     D COWGRAI_getNroCotiXSpol...
     D                 pr             7  0
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * COWGRAI_getNroCotiAPRC(): Retorna Nro de cotización de AP y  *
      *                           RC                                 *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peArcd   (input)  Artículo                               *
      *     peNctw   (input)  Nro de Cotización Robo                 *
      *     peNctx   (input)  Nro de Cotización AP                   *
      *     peNcty   (input)  Nro de Cotización RC                   *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWGRAI_getNroCotiAPRC...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peNctw                       7  0 const
     D   peNctx                       7  0
     D   peNcty                       7  0

      * ------------------------------------------------------------ *
      * COWGRAI_deletePocoFactores(): Elimina registro de CTWET7     *
      *                                                              *
      *     peBase   ( input  ) Base                                 *
      *     peNctw   ( input  ) Número de Cotización                 *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Cant. Pólizas por Rama               *
      *     pePoco   ( input  ) Número de Bien Asegurado             *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWGRAI_deletePocoFactores...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

