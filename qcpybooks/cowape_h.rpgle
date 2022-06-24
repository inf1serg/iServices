      /if defined(COWAPE_H)
      /eof
      /endif
      /define COWAPE_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/wsltab_h.rpgle'

      * ------------------------------------------------------------ *
      * Estructura de Actividades
      * ------------------------------------------------------------ *
     D Activ_t         ds                  qualified template
     D  Acti                          5  0
     D  Cant                          2  0
     D  paco                          3  0
     D  Secu                          2  0
     D  Cate                          2  0
     D  Raed                          2  0
     D  Cobe                               likeds(Cobprima) dim(20)
     D  Cobec                        10i 0
     D  Impu                               likeds(Impuesto)
     D  prim                         15  2
     D  prem                         15  2
      * ------------------------------------------------------------ *
      * COWAPE_cotizarWeb: Cotiza un Bien Asegurado de una Rama de   *
      *                    Hogar.                                    *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePaco (input)  Código de Parentesco                  *
      *        peActi (input)  Actividad                             *
      *        peSecu (input)  Secuencia                             *
      *        peCant (input)  Cantidad                              *
      *        peTipe (input)  Tipo de Persona                       *
      *        peCiva (input)  Condicion de IVA                      *
      *        peNrpp (input)  Plan de Pago                          *
      *        peVdes (input)  Fecha desde                           *
      *        peVhas (input)  Fecha Hasta                           *
      *        peXpro (input)  Código de Plan                        *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peRaed (output) Rango de Edad                         *
      *        peCobe (output) Coberturas (Primas)                   *
      *        peImpu (output) Impuestos                             *
      *        pePrim (output) Prima                                 *
      *        pePrem (output) Premio                                *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWAPE_cotizarWeb...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWAPE_reCotizarWeb: Cotiza un Bien Asegurado de una Rama de *
      *                    Hogar.                                    *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        pePaco (input)  Código de Parentesco                  *
      *        peActi (input)  Actividad                             *
      *        peSecu (input)  Secuencia                             *
      *        peCant (input)  Cantidad                              *
      *        peTipe (input)  Tipo de Persona                       *
      *        peCiva (input)  Condicion de IVA                      *
      *        peNrpp (input)  Plan de Pago                          *
      *        peVdes (input)  Fecha desde                           *
      *        peVhas (input)  Fecha Hasta                           *
      *        peXpro (input)  Código de Plan                        *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peRaed (output) Rango de Edad                         *
      *        peCobe (output) Coberturas (Primas)                   *
      *        peImpu (output) Impuestos                             *
      *        pePrim (output) Prima                                 *
      *        pePrem (output) Premio                                *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWAPE_reCotizarWeb...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peImpu                            likeds(Impuesto) dim(99)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWAPE_chkcotizar() : Chequear datos ingresados en una solic-*
      *                        itud de Cotizacion de Hogar.          *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peXpro (input)  Código de Plan(Producto)              *
      *        peTviv (input)  Tipo de Vivienda                      *
      *        peCara (input)  Características de Bien               *
      *        peCopo (input)  Código Postal                         *
      *        peCops (input)  Sufijo Código Postal                  *
      *        peScta (input)  Zona de Riesgo                        *
      *        peBure (input)  Código de Buen Resultado              *
      *        peCfpg (input)  Código de Forma de pago               *
      *        peTipe (input)  Tipo de Forma de Pago                 *
      *        peCiva (input)  Condicion de IVA                      *
      *        peCobe (input)  Coberturas (Primas)                   *
      *        peError(output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWAPE_chkcotizar...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peCfpg                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ---------------------------------------------------------------- *
      * COWAPE_cotizador ():  Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                peActi  -  Actividad                              *
      *                peSecu  -  Secuencia                              *
      *                peCant  -  Cantidad                               *
      *                peTipe  -  Tipo de persona                        *
      *                peCiva  -  Codigo de Iva                          *
      *                peNrpp  -  Plan de Pago                           *
      *                peCfpg  -  Codigo de forma de pago                *
      *                peVdes  -  Fecha desde                            *
      *                peVhas  -  Fecha hasta                            *
      *                peXpro  -  Codigo de plan                         *
      *                peCopo  -  Código Postal                          *
      *                peCops  -  Sufijo Código Postal                   *
      *                peRaed  -  Rango de Edad                          *
      *                peCobe  -  Coberturas                             *
      *        Output:                                                   *
      *                pePrim  -  Prima                                  *
      *                pePrem  -  Premio                                 *
      *                peErro  -  Indicador de Error                     *
      *                peMsgs  -  Estructura de Error                    *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWAPE_cotizador...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ---------------------------------------------------------------- *
      * COWAPE_saveCabecera   (): Graba cabecera de la cotizacion de auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                pePaco  -  Código de Parentesco                   *
      *                peActi  -  Actividad                              *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  Sufijo                                 *
      *                peXpro  -  Código de Producto                     *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWAPE_saveCabecera...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peXpro                       3  0 const
      * ---------------------------------------------------------------- *
      * COWAPE_saveCategorias (): Graba cabecera de la cotizacion de auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                peSecu  -  Secuencia                              *
      *                peActi  -  Actividad                              *
      *                peCant  -  Categoria                              *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  Sufijo                                 *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWAPE_saveCategorias...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peSecu                       2  0 const
     D   peActi                       5  0 const
     D   peCant                       2  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * COWAPE_saveCoberturasAp(): Graba Coberturas                  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     pePaco   (input)   Parentesco                            *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peRaed   (input)   Rango de Edad                         *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWAPE_saveCoberturasAp...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   peSecu                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peSaco                      13  2 const
     D   peRaed                       2  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
      * ------------------------------------------------------------ *
      * COWAPE_RecuperaTasaSumAseg...                                *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura                             *
      *     peMone   (input)   Moneda                                *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peXpri   (output)  Prima por milaje                      *
      *     pePtco   (output)  Prima                                 *
      *     peTpcd   (output)  Codigo de Texto Preseteado            *
      *     peCls    (output)  Clausula                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWAPE_RecuperaTasaSumAseg...
     D                 pr
     D   peRama                       3  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3a   const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peActi                       5  0 const
     D   peSaco                      15  2 const
     D   peRaed                       2  0 const
     D   peXpri                       9  6
     D   pePtco                      15  2
     D   peTpcd                       2a
     D   peCls                        3a   dim(5)
      * ------------------------------------------------------------ *
      * COWAPE_GetPormilajePrima(): Graba Coberturas Riesgos Varios  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePoco   (input)   Nro. de Componente                    *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peXpri   (output)  Pormilaje                             *
      *     pePrim   (output)  Prima                                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWAPE_GetPormilajePrima...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peXpri                       9  6
     D   pePrim                      15  2
      * ------------------------------------------------------------ *
      * COWAPE_GetSumaAsegCobertura...                               *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWAPE_GetSumaAsegCobertura...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
      * ------------------------------------------------------------ *
      * COWAPE_GetPrima()...                                         *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *     PePoco   (input)  Componente                             *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWAPE_GetPrima...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
      * ------------------------------------------------------------ *
      * COWAPE_GetPremio()                                           *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWAPE_GetPremio...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
      * ------------------------------------------------------------ *
      * COWAPE_getporcperiodo()                                      *
      *                                                              *
      *     PeRama   (input)  Parametros Base                        *
      *     PeXpro   (input)  Nro de Cotizacion                      *
      *     PeMone   (input)  Moneda                                 *
      *     PeDias   (input)  Cantidad de Días                       *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWAPE_getporcperiodo...
     D                 pr             7  4
     D   PeRama                       2  0 const
     D   PeXpro                       3  0 const
     D   PeMone                       2    const
     D   PeDias                       5  0 const
      * ------------------------------------------------------------ *
      * COWAPE_getporcencat():                                       *
      *                                                              *
      *     PeCate   (input)  Categoria                              *
      *     peFech   (input)  Fecha                                  *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWAPE_getporcencat...
     D                 pr             5  2
     D   PeCate                       2  0 const
     D   peFech                       8  0 const
      * ------------------------------------------------------------ *
      * COWAPE_GetSecuenciaPoco()                                    *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWAPE_GetSecuenciaPoco...
     D                 pr             6  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
      * ------------------------------------------------------------ *
      * COWAPE_ordenaComponentes():                                  *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWAPE_ordenaComponentes...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ------------------------------------------------------------ *
      * COWAPE_listaComPorActi(): Lista los componentes de una       *
      *                           actividad/secuencia                *
      *                                                              *
      *     peBase   (input)  Parametros Base                        *
      *     peNctw   (input)  Nro de Cotizacion                      *
      *     peActi   (input)  Actividad                              *
      *     peSecu   (input)  Secuencia para la actividad            *
      *     peLcom   (input)  Listado de componentes                 *
      *     peLcomC  (input)  Cantidad para peLcom                   *
      *     peErro   (input)  Código de Error                        *
      *     peMsgs   (input)  Mensajes                               *
      *                                                              *
      * Void                                                         *
      * ------------------------------------------------------------ *
     D COWAPE_listaComPorActi...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peActi                        5  0 const
     D  peSecu                        2  0 const
     D  peLcom                             likeds(compActi_t) dim(999999)
     D  peLcomC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)


      * ------------------------------------------------------------ *
      * COWAPE_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWAPE_inz      pr
      * ------------------------------------------------------------ *
      * COWAPE_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWAPE_end      pr
      * ------------------------------------------------------------ *
      * COWAPE_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D COWAPE_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * COWAPE_cotizarWeb2: Cotiza un Bien Asegurado de una Rama de  *
      *                     Hogar.                                   *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peNrpp (input)  Plan de Pago                          *
      *        peVdes (input)  Fecha desde                           *
      *        peVhas (input)  Fecha Hasta                           *
      *        peXpro (input)  Código de Plan                        *
      *        peClie (input)  Datos del Cliente                     *
      *        peActi (input)  Actividad                             *
      *        peActiC(input)  cantidad de Actividades               *
      *        peImpu (output) Impuestos                             *
      *        pePrim (output) Prima                                 *
      *        pePrem (output) Premio                                *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWAPE_cotizarWeb2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peActi                            likeds(Activ_t ) dim(99)
     D   peActiC                     10i 0
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * COWAPE_reCotizarWeb2: Cotiza un Bien Asegurado de una Rama   *
      *                       de Hogar.                              *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peNrpp (input)  Plan de Pago                          *
      *        peVdes (input)  Fecha desde                           *
      *        peVhas (input)  Fecha Hasta                           *
      *        peXpro (input)  Código de Plan                        *
      *        peClie (input)  datos del cliente                     *
      *        peActi (input)  Actividad                             *
      *        peActiC(input)  Cantidad de Actividades               *
      *        peImpu (output) Impuestos                             *
      *        pePrim (output) Prima                                 *
      *        pePrem (output) Premio                                *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWAPE_reCotizarWeb2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peActi                            likeds(Activ_t ) dim(99)
     D   peActiC                     10i 0
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * COWAPE_setPrimaMinima(): Graba prima mínima                      *
      *                          Inicialmente solo aplica a Cobertura de *
      *                          Muerte ( 28 )                           *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *

     D COWAPE_setPrimaMinima...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                            likeds( activ_t ) dim( 99 )
     D   peActiC                     10i 0

      * ---------------------------------------------------------------- *
      * COWAPE_setPormilajePrima(): Graba Pormilajes prima               *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *       peCobe ( output ) - Estructura de Cobertura                *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *

     D COWAPE_setPormilajePrima...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)

      * ---------------------------------------------------------------- *
      * COWAPE_getPrimaActividad(): Obtiene Prima de una determinada     *
      *                             Actividad                            *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *                                                                  *
      * Retorna Prima / *Zeros                                           *
      * ---------------------------------------------------------------- *

     D COWAPE_getPrimaActividad...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const

      * ---------------------------------------------------------------- *
      * COWAPE_getPremioctividad(): Obtiene Premio de una determinada    *
      *                             Actividad                            *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *                                                                  *
      * Retorna Premio / *zeros                                          *
      * ---------------------------------------------------------------- *

     D COWAPE_getPremioActividad...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const

      * ---------------------------------------------------------------- *
      * COWAPE_GetSumaAsegActividad() : Obtiene Suma Asegurada de una    *
      *                                 determinada Actividad            *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *                                                                  *
      * Retorna Suma / *Zeros                                            *
      * ---------------------------------------------------------------- *

     D COWAPE_GetSumaAsegActividad...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const

      * ---------------------------------------------------------------- *
      * COWAPE_getCantidadTotalDePersonas(): Retorna cantidad total de   *
      *                                      personas a cotizar          *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *

     D COWAPE_getCantidadTotalDePersonas...
     D                 pr            10  0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

      * ---------------------------------------------------------------- *
      * COWAPE_chkCotizar2():  Valida Cotizacion                         *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peActi ( input )  - Actividades                            *
      *       peSecu ( input )  - Secuencia                              *
      *       peCant ( input )  - Cantidad                               *
      *       peTipe ( input )  - Tipo                                   *
      *       peCiva ( input )  - Condicion de IVA                       *
      *       peCfpg ( input )  - Forma de Pago                          *
      *       peVdes ( input )  - Fecha desde                            *
      *       peVhas ( input )  - Fecha Hasta                            *
      *       peXpro ( input )  - Producto                               *
      *       peCopo ( input )  - Codigo Postal                          *
      *       peCops ( input )  - Sub. Codigo Postal                     *
      *       peRaed ( input )  - Rango de Edad                          *
      *       peCobe ( input )  - Coberturas                             *
      *       peCobeC( input )  - Cant. de Coberturas                    *
      *       peErro ( output ) - Marca de Erorr                         *
      *       peMsgs ( output ) - Mensaje de Error                       *
      *                                                                  *
      * Retorna: peErro = '0' / '-1'                                     *
      * ---------------------------------------------------------------- *
     D COWAPE_chkCotizar2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peCfpg                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peCobeC                     10i 0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * COWAPE_cotizador2():  Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. de Polizas por rama              *
      *       pePaco ( input )  - Parentesco                             *
      *       peActi ( input )  - Actividad                              *
      *       peSecu ( input )  - Secuencia                              *
      *       peCant ( input )  - Cantidad                               *
      *       peTipe ( input )  - Tipo                                   *
      *       peCiva ( input )  - Condicion de IVA                       *
      *       peNrpp ( input )  - Plan de pago                           *
      *       peCfpg ( input )  - Forma de Pago                          *
      *       peVdes ( input )  - Fecha Desde                            *
      *       peVhas ( input )  - Fechas Hasta                           *
      *       peXpro ( input )  - Producto                               *
      *       peCopo ( input )  - Codigo Postal                          *
      *       peCops ( input )  - Subfijo de Codigo Postal               *
      *       peRaed ( input )  - Rango de Edad                          *
      *       peCobe ( input )  - Coberturas                             *
      *       peCobeC( input )  - Cantidad de Coberturas                 *
      *       pePrim ( output ) - Prima                                  *
      *       pePrem ( output ) - Premio                                 *
      *       peErro ( output ) - Marca de Error                         *
      *       peMsgs ( output ) - Mensaje de Error                       *
      *                                                                  *
      * Retorna: peError = '0' / '-1'                                    *
      * ---------------------------------------------------------------- *

     D COWAPE_cotizador2...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peActi                       5  0 const
     D   peSecu                       2  0 const
     D   peCant                       2  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peCobeC                     10i 0
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * COWAPE_delCotizacion(): Elimina todos los datos cargados de la   *
      *                         Cotizacion.                              *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     D COWAPE_delCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ---------------------------------------------------------------- *
      * COWAPE_delCobertura(): Elimina coberturas de una cotizacion.     *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                      ( opcional ) *
      *       peArse ( input )  - Cant. de Polizas por Rama ( opcional ) *
      *       pePoco ( input )  - Nro de Componente         ( opcional ) *
      *       pePaco ( input )  - Parentesco                ( opcional ) *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     D COWAPE_delCobertura...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   pePoco                       6  0 const options(*nopass:*omit)
     D   pePaco                       3  0 const options(*nopass:*omit)

      * ---------------------------------------------------------------- *
      * COWAPE_delCategoria(): Elimina categorias de una cotizacion.     *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                      ( opcional ) *
      *       peArse ( input )  - Cant. de Polizas por Rama ( opcional ) *
      *       peActi ( input )  - Actividad                 ( opcional ) *
      *       peSecu ( input )  - Secuencia                 ( opcional ) *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     D COWAPE_delCategoria...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   peActi                       5  0 const options(*nopass:*omit)
     D   peSecu                       2  0 const options(*nopass:*omit)

      * ---------------------------------------------------------------- *
      * COWAPE_delCabecera(): Elimina cabecera de una cotizacion.        *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                      ( opcional ) *
      *       peArse ( input )  - Cant. de Polizas por Rama ( opcional ) *
      *       pePoco ( input )  - Nro de Componente         ( opcional ) *
      *       pePaco ( input )  - Parentesco                ( opcional ) *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     D COWAPE_delCabecera...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const options(*nopass:*omit)
     D   peArse                       2  0 const options(*nopass:*omit)
     D   pePoco                       6  0 const options(*nopass:*omit)
     D   pePaco                       3  0 const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWAPE_planesCerrados(): Calcula Planes Cerrados             *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *     pePoco (input)  Número de Bien asegurado                 *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWAPE_planesCerrados...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       6  0   const
      * ---------------------------------------------------------------- *
      * COWAPE_cargaActividad(): Carga y retorna actividad para AP       *
      *                                                                  *
      *       peRama  ( input  )  - Rama                                 *
      *       peXpro  ( input  )  - Producto/Plan                        *
      *       peMone  ( input  )  - Moneda                               *
      *       peActi  ( output )  - Estructura de Actividad              *
      *       peActiC ( output )  - Cantidad de Actividad                *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     D COWAPE_cargaActividad...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peMone                       2    const
     D   peActi                            likeds(Activ_t) dim(99)
     D   peActiC                     10i 0
