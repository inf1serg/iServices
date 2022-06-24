      /if defined(COWSEP_H)
      /eof
      /endif
      /define COWSEP_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy microseg/qcpybooks,cowgrai_h
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      * ------------------------------------------------------------ *
      * Componente de Cotizacion de Sepelio
      * Cant = Cantidad de Componentes de Nomina que tendra la poliza
      * Paco = Parentesco de los componentes
      * Raed = Rango de Edad
      * Cobe = Array con coberturas
      * CobeC= Cantidad de Coberturas del array Cobe
      * Impu = Impuestos
      * Prim = Prima Total
      * Prem = Premio
      * ------------------------------------------------------------ *
     D CompSepelio_t   ds                  qualified template
     D  Cant                          6  0
     D  Paco                          3  0
     D  Raed                          1  0
     D  Cobe                               likeds(Cobprima) dim(20)
     D  Cobec                        10i 0
     D  Impu                               likeds(Impuesto)
     D  prim                         15  2
     D  prem                         15  2

     D ctwse1_t        ds                  qualified template
     D  e1empr                        1a
     D  e1sucu                        2a
     D  e1nivt                        1  0
     D  e1nivc                        5  0
     D  e1nctw                        7  0
     D  e1rama                        2  0
     D  e1arse                        2  0
     D  e1riec                        3a
     D  e1xcob                        3  0
     D  e1saco                       15  2
     D  e1ptco                       15  2
     D  e1xpri                        9  6
     D  e1prsa                        5  2
     D  e1ecob                        1a
     D  e1mar1                        1a
     D  e1mar2                        1a
     D  e1mar3                        1a
     D  e1mar4                        1a
     D  e1mar5                        1a
     D  e1strg                        1a
     D  e1user                       10a
     D  e1time                        6  0
     D  e1date                        8  0

     D ctwsep_t        ds                  qualified template
     D  epempr                        1a
     D  epsucu                        2a
     D  epnivt                        1  0
     D  epnivc                        5  0
     D  epnctw                        7  0
     D  eprama                        2  0
     D  eparse                        2  0
     D  eppaco                        3  0
     D  epxpro                        3  0
     D  epcant                        6  0
     D  epraed                        2  0
     D  epmar1                        1a
     D  epmar2                        1a
     D  epmar3                        1a
     D  epmar4                        1a
     D  epmar5                        1a
     D  epstrg                        1a
     D  epuser                       10a
     D  eptime                        6  0
     D  epdate                        8  0

      * ------------------------------------------------------------ *
      * COWSEP_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWSEP_inz      pr

      * ------------------------------------------------------------ *
      * COWSEP_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D COWSEP_end      pr

      * ------------------------------------------------------------ *
      * COWSEP_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D COWSEP_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * COWSEP_cotizarWeb : Cotiza Sepelio                           *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peNrpp (input)  Plan de Pago                          *
      *        peVdes (input)  Fecha desde                           *
      *        peXpro (input)  Código de Plan                        *
      *        peClie (input)  Datos del Cliente                     *
      *        peCsep (input)  Componente de Sepelio                 *
      *        peImpu (output) Impuestos                             *
      *        pePrim (output) Prima                                 *
      *        pePrem (output) Premio                                *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWSEP_cotizarWeb...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peCsep                            likeds(CompSepelio_t)
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * COWSEP_reCotizarWeb: Recotiza Sepelio                        *
      *                                                              *
      *        peBase (input)  Base                                  *
      *        peNctw (input)  Número de Cotización                  *
      *        peRama (input)  Rama                                  *
      *        peArse (input)  Articulo                              *
      *        peNrpp (input)  Plan de Pago                          *
      *        peVdes (input)  Fecha desde                           *
      *        peXpro (input)  Código de Plan                        *
      *        peClie (input)  Datos del Cliente                     *
      *        peCsep (input)  Componente de Sepelio                 *
      *        peImpu (output) Impuestos                             *
      *        pePrim (output) Prima                                 *
      *        pePrem (output) Premio                                *
      *        peErro (output) Indicador                             *
      *        peMsgs (output) Estructura de Error                   *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWSEP_reCotizarWeb...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peCsep                            likeds(CompSepelio_t)
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * COWSEP_delCotizacion(): Elimina todos los datos cargados de la   *
      *                         Cotizacion.                              *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     D COWSEP_delCotizacion...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ---------------------------------------------------------------- *
      * COWSEP_delCabeceraSepelio(): Elimina Cabcera Sepelio (CTWSEP)    *
      *                         Cotizacion.                              *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     D COWSEP_delCabeceraSepelio...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ---------------------------------------------------------------- *
      * COWSEP_delCoberturasSepelio: Elimina Coberturas Sepelio (CTWSE1) *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     D COWSEP_delCoberturasSepelio...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      * ---------------------------------------------------------------- *
      * COWSEP_chkCotizar ():  Valida Cotizacion                         *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       peCsep ( input )  - Componente de Sepelio                  *
      *       peTipe ( input )  - Tipo                                   *
      *       peCiva ( input )  - Condicion de IVA                       *
      *       peCfpg ( input )  - Forma de Pago                          *
      *       peVdes ( input )  - Fecha desde                            *
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
     D COWSEP_chkCotizar...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peCant                       6  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peCfpg                       3  0 const
     D   peVdes                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       1  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peCobeC                     10i 0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ---------------------------------------------------------------- *
      * COWSEP_cotizador ():  Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. de Polizas por rama              *
      *       peCsep ( input )  - Componente de Sepelio                  *
      *       peTipe ( input )  - Tipo                                   *
      *       peCiva ( input )  - Condicion de IVA                       *
      *       peNrpp ( input )  - Plan de pago                           *
      *       peCfpg ( input )  - Forma de Pago                          *
      *       peVdes ( input )  - Fecha Desde                            *
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
     D COWSEP_cotizador...
     D                 pr
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peCant                       6  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peVdes                       8  0 const
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
      * COWSEP_saveCabecera   (): Graba cabecera de la cotizacion de auto*
      *                                                                  *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                peCsep  -  Componente de Sepelio                  *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  Sufijo                                 *
      *                peXpro  -  Código de Producto                     *
      *                                                                  *
      * ---------------------------------------------------------------- *
     D COWSEP_saveCabecera...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peCant                       6  0 const
     D   peRaed                       1  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peXpro                       3  0 const

      * ------------------------------------------------------------ *
      * COWSEP_saveCoberturas():   Graba Coberturas                  *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     peCsep   (input)   Componente de Sepelio                 *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWSEP_saveCoberturas...
     D                 pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCant                        6  0 const
     D  pePaco                        3  0 const
     D  peXpro                        3  0 const
     D  peRiec                        3    const
     D  peCobe                        3  0 const
     D  peSaco                       13  2 const
     D  peRaed                        1  0 const

      * ------------------------------------------------------------ *
      * COWSEP_RecuperaTasaSumAseg...                                *
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
     D COWSEP_RecuperaTasaSumAseg...
     D                 pr
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peCant                       6  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3a   const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peSaco                      15  2 const
     D   peRaed                       1  0 const
     D   peXpri                       9  6
     D   pePtco                      15  2
     D   peTpcd                       2a
     D   peCls                        3a   dim(5)

      * ---------------------------------------------------------------- *
      * COWSEP_setPormilajePrima(): Graba Pormilajes prima               *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peActi ( input )  - Código de Actividad                    *
      *       peSecu ( input )  - Secuencia                              *
      *       peCobe ( output ) - Estructura de Cobertura                *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     D COWSEP_setPormilajePrima...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peCobeC                     10i 0 const

      * ------------------------------------------------------------ *
      * COWSEP_planesCerrados(): Calcula Planes Cerrados             *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *                                                              *
      * ------------------------------------------------------------ *
     D COWSEP_planesCerrados...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   peXpro                       3  0   const

      * ------------------------------------------------------------ *
      * COWSEP_getPremio(): Obtener Premio                           *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     D COWSEP_getPremio...
     D                 pr            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

      * ------------------------------------------------------------ *
      * COWSEP_getCoberturas(): Obtiene Coberturas                   *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *                                                              *
      * Retorna Cantidad de Coberturas                               *
      * ------------------------------------------------------------ *
     D COWSEP_getCoberturas...
     D                 pr            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peWse1                            likeds(ctwse1_t) dim(20)

      * ------------------------------------------------------------ *
      * COWSEP_getCabecera():   Obtiene Cabecera                     *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *                                                              *
      * Retorna %found                                               *
      * ------------------------------------------------------------ *
     D COWSEP_getCabecera...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peWsep                            likeds(ctwsep_t)

