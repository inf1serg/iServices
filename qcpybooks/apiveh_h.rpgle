      /if defined(APIVEH_H)
      /eof
      /endif
      /define APIVEH_H

      *-- Estructura ------------------------------------------------*
     D AccVehaAPI_t    ds                  qualified based(template)
     D   desc                        20
     D   valor                       15  2

     D CobVehAPI_t     ds                  qualified based(template)
     D   cobl                         2
     D   cobd                        40
     D   rast                         1
     D   insp                         1
     D   prim                        15  2
     D   prem                        15  2
     D   ifra                        15  2
     D   rcle                        15  2
     D   rcco                        15  2
     D   rcac                        15  2
     D   lrce                        15  2
     D   claj                         5  2
     D   copr                        15  2
     D   read                        15  2
     D   dere                        15  2
     D   epva                        15  2
     D   impu                        15  2
     D   vase                        15  2
      *-- Copy's ----------------------------------------------------*

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/apigrai_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/czwutl_h.rpgle'
      /copy './qcpybooks/svpiau_h.rpgle'
      /copy './qcpybooks/svpdau_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'

      * - Definicion de Procedimiento ------------------------------ *

      * ------------------------------------------------------------ *
      * APIVEH_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D APIVEH_inz      pr

      * ------------------------------------------------------------ *
      * APIVEH_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D APIVEH_end      pr

      * ------------------------------------------------------------ *
      * APIVEH_error():  Retorna el último error del servicio.       *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D APIVEH_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * -------------------------------------------------------------*
      * APIVEH_cotizar : Cotiza Vehiculo API.                        *
      *                                                              *
      *          peNcta   ( input  ) Nro. Cotizacion Api             *
      *          peNsys   ( input  ) Nombre del Sistema Remoto       *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peCuii   ( input  ) Cuit del Intermediario          *
      *          peinfo   ( input  ) Codigo de Infoauto              *
      *          peVhan   ( input  ) Año del vehiculo                *
      *          peVhvu   ( input  ) Valor del vehiculo              *
      *          peMgnc   ( input  ) Marca de G.N.C                  *
      *          peRgnc   ( input  ) Valor de G.N.C                  *
      *          peLoca   ( input  ) Localidad                       *
      *          peCfpg   ( input  ) Forma de Pago                   *
      *          peTipe   ( input  ) Tipo de Persona                 *
      *          peCiva   ( input  ) Condicion de I.V.A              *
      *          peTdoc   ( input  ) Tipo de Documento               *
      *          peNdoc   ( input  ) Nro. de Documento               *
      *          peAcce   ( input  ) Estructura de Accesorios        *
      *          pePcom   ( output ) Porcentaje de Comision          *
      *          pePbon   ( output ) Porecntaje de Bonificacion      *
      *          pePreb   ( output ) Porcentaje de Rebaja            *
      *          pePrec   ( output ) Porcentaje de Recargo           *
      *          pePaxc   ( output ) Coberturas Prima a Premio       *
      *          pePaxcC  ( output ) Cantidad Coberturas             *
      *          peErro   ( output ) Marca de Error                  *
      *          peMsgs   ( output ) Estructura de Mensaje           *
      *                                                              *
      * Retorna peErro = ' '  Cotizacion Correcta                    *
      *         peErro = '-1' Cotizacion Erronea                     *
      * -------------------------------------------------------------*
     D APIVEH_cotizar...
     D                 pr
     D   peNcta                       7  0 const
     D   peNsys                      20    const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peinfo                       7  0 const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peLoca                       6  0 const
     D   peCfpg                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peTdoc                       3  0 const
     D   peNdoc                      11  0 const
     D   peAcce                            likeds(AccVehaAPI_t)dim(10) const
     D   pePcom                       5  2 const
     D   pePbon                       5  2 const
     D   pePreb                       5  2 const
     D   pePrec                       5  2 const
     D   pePaxc                            likeds(CobVehAPI_t) dim(20)
     D   pePaxcC                     10i 0
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * -------------------------------------------------------------*
      * APIVEH_getValoresDelSistema: Obtener valores del sistema     *
      *                              para APIVEH                     *
      *                                                              *
      *          peNivc   ( input  ) Codigo Intermediario            *
      *          peErro   ( output ) Marca de Error                  *
      *          peMsgs   ( output ) Estr. de Mensaje                *
      *          peBase   ( output ) Parametros Base     ( opcional )*
      *          peRama   ( output ) Rama                ( opcional )*
      *          peArse   ( output ) Cant.Ramas x poliza ( opcional )*
      *          peArcd   ( output ) Articulo            ( opcional )*
      *          pePoco   ( output ) Cant. de Componentes( opcional )*
      *          peMone   ( output ) Moneda              ( opcional )*
      *          peTiou   ( output ) Tipo Operacion      ( opcional )*
      *          peStou   ( output ) SubTipo Oper.Usuario( opcional )*
      *          peStos   ( output ) SubTipo Oper.Sistema( opcional )*
      *          peMbon   ( output ) Maximo % de Bonific.( opcional )*
      *                                                              *
      * Retorna peErro = ' '  Devuelve Valor ok                      *
      *         peErro = '-1' Problemas con los valores              *
      * -------------------------------------------------------------*
     D APIVEH_getValoresDelSistema...
     D                 pr
     D   peNivc                       5  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds ( paramMsgs )
     D   peBase                            likeds ( paramBase)
     D                                     options( *nopass : *omit )
     D   peRama                       2  0 options( *nopass : *omit )
     D   peArse                       2  0 options( *nopass : *omit )
     D   peArcd                       6  0 options( *nopass : *omit )
     D   pePoco                       4  0 options( *nopass : *omit )
     D   peMone                       2    options( *nopass : *omit )
     D   peTiou                       1  0 options( *nopass : *omit )
     D   peStou                       2  0 options( *nopass : *omit )
     D   peStos                       2  0 options( *nopass : *omit )
     D   peMbon                       5  2 options( *nopass : *omit )

      * -------------------------------------------------------------*
      * APIVEH_chkCotizacion: Valida datos de entrada para           *
      *                       cotizacion.                            *
      *                                                              *
      *          peNcta   ( input  ) Nro de Cotizacion Api           *
      *          peNsys   ( input  ) Nombre del Sistema Remoto       *
      *          peNivc   ( input  ) Còdigo Intermediario            *
      *          peCuii   ( input  ) Cuit del Intermediario          *
      *          peInfo   ( input  ) Codigo infoauto.                *
      *          peVhan   ( input  ) Año del Vehiculo                *
      *          peTipe   ( input  ) Tipo de persona.                *
      *          peTdoc   ( input  ) Tipo de Documento.              *
      *          peNdoc   ( input  ) Nro de doc/cuit.                *
      *          pePcom   ( input  ) Porcentaje de Comisión          *
      *          peErro   ( output ) Marca de Error                  *
      *          peMsgs   ( output ) Estructura de Mensaje           *
      *                                                              *
      * Retorna peErro = ' '  Validacion ok                          *
      *         peErro = '-1' Encontro un error                      *
      * -------------------------------------------------------------*
     D APIVEH_chkCotizacion...
     D                 pr
     D   peNcta                       7  0 const
     D   peNsys                      20    const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peInfo                       7  0 const
     D   peVhan                       4    const
     D   peTipe                       1    const
     D   peTdoc                       3  0 const
     D   peNdoc                      11  0 const
     D   pePcom                       5  2 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIVEH_chk0km: Validar si campo de entrada es 0km            *
      *                                                              *
      *          peVhna   ( input  ) Año del Vehículo                *
      *                                                              *
      * Retorna : *on = 0km / *off = No 0km                          *
      * ------------------------------------------------------------ *
     D APIVEH_chk0km   pr              n
     D peVhan                         4    const

      * ------------------------------------------------------------ *
      * Proceso(): Retorna proceso que realiza la llamada            *
      *                                                              *
      * retorna  Nombre del Proceso invocador                        *
      *          "APIVEH1"    = Cotizador 1203                       *
      *          "APIVEH2"    = Cotizador Scoring                    *
      *          "ERROR"      = Llamada inesperada                   *
      * ------------------------------------------------------------ *
     D proceso         pr            20a

      * -------------------------------------------------------------*
      * APIVEH_cotizar2 : Cotiza Vehiculo API                        *
      *                                                              *
      *          peNcta   ( input  ) Nro. Cotizacion Api             *
      *          peNsys   ( input  ) Nombre del Sistema Remoto       *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peCuii   ( input  ) Cuit del Intermediario          *
      *          peArcd   ( input  ) Código de Artículo              *
      *          peinfo   ( input  ) Codigo de Infoauto              *
      *          peVhan   ( input  ) Año del vehiculo                *
      *          peVhvu   ( input  ) Valor del vehiculo              *
      *          peMgnc   ( input  ) Marca de G.N.C                  *
      *          peRgnc   ( input  ) Valor de G.N.C                  *
      *          peLoca   ( input  ) Localidad                       *
      *          peCfpg   ( input  ) Forma de Pago                   *
      *          peTipe   ( input  ) Tipo de Persona                 *
      *          peCiva   ( input  ) Condicion de I.V.A              *
      *          peTdoc   ( input  ) Tipo de Documento               *
      *          peNdoc   ( input  ) Nro. de Documento               *
      *          peAcce   ( input  ) Estructura de Accesorios        *
      *          pePcom   ( input  ) Porcentaje de Comisión          *
      *          pePbon   ( input  ) Porcentaje de Bonificacion      *
      *          pePreb   ( input  ) Porcentaje de Rebaja            *
      *          pePrec   ( input  ) Porcentaje de Recargo           *
      *          peTaaj   ( input  ) Código de Cuestionario          *
      *          peScor   ( input  ) Estructura de Preguntas         *
      *          pePaxc   ( output ) Coberturas Prima a Premio       *
      *          pePaxcC  ( output ) Cantidad de Coberturas          *
      *          peErro   ( output ) Marca de Error                  *
      *          peMsgs   ( output ) Estructura de Mensaje           *
      *                                                              *
      * Retorna peErro = ' '  Cotizacion Correcta                    *
      *         peErro = '-1' Cotizacion Erronea                     *
      * -------------------------------------------------------------*
     D APIVEH_cotizar2...
     D                 pr
     D   peNcta                       7  0 const
     D   peNsys                      20    const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peArcd                       6  0 const
     D   peinfo                       7  0 const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peLoca                       6  0 const
     D   peCfpg                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peTdoc                       3  0 const
     D   peNdoc                      11  0 const
     D   peAcce                            likeds(AccVehaAPI_t)dim(10) const
     D   pePcom                       5  2 const
     D   pePbon                       5  2 const
     D   pePreb                       5  2 const
     D   pePrec                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t) dim(200) const
     D   pePaxc                            likeds(CobVehAPI_t) dim(20)
     D   pePaxcC                     10i 0
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

