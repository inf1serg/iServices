      /if defined(APIGRAI_H)
      /eof
      /endif
      /define APIGRAI_H

      *-- Estructura ------------------------------------------------*


      *-- Copy's ----------------------------------------------------*

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'

      * - Definicion de Procedimiento ------------------------------ *

      * ------------------------------------------------------------ *
      * APIGRAI_inz(): Inicializa módulo.                            *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D APIGRAI_inz     pr

      * ------------------------------------------------------------ *
      * APIGRAI_end():  Finaliza módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D APIGRAI_end     pr

      * ------------------------------------------------------------ *
      * APIGRAI_error(): Retorna el último error del servicio.       *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D APIGRAI_error   pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * -------------------------------------------------------------*
      * APIGRAI_getNroCotizacion: Retorna Nro de Cotizacion Nueva    *
      *                                                              *
      *     peEmpr   (input)   Código de Empresa                     *
      *     peSucu   (input)   Código de Sucursal                    *
      *                                                              *
      * Retorna Nro de Cotizacion                                    *
      * -------------------------------------------------------------*
     D APIGRAI_getNroCotizacion...
     D                 pr             7  0
     D   peEmpr                       1    const
     D   peSucu                       2    const

      * -------------------------------------------------------------*
      * APIGRAI_getNroCotizacionWeb: Retorna Nro de Cotizacion Nueva *
      *                                                              *
      *     peNcta   ( input  ) Nro de Cotizacion API                *
      *     peNivc   ( input  ) Codigo de Intermediario              *
      *     peArcd   ( input  ) Articulo                             *
      *     peMone   ( input  ) Moneda                               *
      *     peTiou   ( input  ) Tipo de Operacion                    *
      *     peStou   ( input  ) Sub-Tipo de Operacion Usuario        *
      *     peStos   ( input  ) Sub-Tipo de Operacion Sistema        *
      *     peSpo1   ( input  ) Poliza Anterior                      *
      *     peErro   ( output ) Indicador de Error                   *
      *     peMsgs   ( output ) Estructura de Error                  *
      *                                                              *
      * Retorna Nro de Cotizacion WEB                                *
      * -------------------------------------------------------------*
     D APIGRAI_getNroCotizacionWeb...
     D                 pr             7  0
     D   peNcta                       7  0 const
     D   peNivc                       5  0 const
     D   peArcd                       6  0 const
     D   peMone                       2    const
     D   peTiou                       1  0 const
     D   peStou                       2  0 const
     D   peStos                       2  0 const
     D   peSpo1                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIGRAI_getPolizasxPropuesta: Obtener Nro. de Poliza por rama*
      *                               asociado a una Propuesta.      *
      *      peNivc ( input  ) Codigo de Productor                   *
      *      peSoln ( input  ) Nro de Propuesta                      *
      *      pePoli ( output ) Estructura de Poliza ( RAMA/POLIZA )  *
      *      pePoliC( output ) Cantidad de Polizas                   *
      *      peErro ( output ) Indicador de Error                    *
      *      peMsgs ( output ) Estructura de Error                   *
      *      peCest ( output ) Estado de Propuesta ( opcional )      *
      *      peCses ( output ) Sub. Estado         ( opcional )      *
      *      peDest ( output ) Descripcion         ( opcional )      *
      *                                                              *
      * Retorna *On=Propuesta Correcta/*Off=Propuesta Inexistente    *
      * ------------------------------------------------------------ *
     D APIGRAI_getPolizasxPropuesta...
     D                 pr              n
     D   peNivc                       5  0 const
     D   peSoln                       7  0 const
     D   pePoli                            likeds(spolizas) Dim(100)
     D   pePoliC                     10i 0
     D   peCest                       1  0
     D   peCses                       2  0
     D   peDest                      20
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)
      * ------------------------------------------------------------ *
      * APIGRAI_getParamBase: Obtiene parametros Base desde nro de   *
      *                       Productor.                             *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peBase   ( output ) Parametros Base                 *
      *          peErro   ( output ) Cod.de Error                    *
      *          peMsgs   ( output ) Estructura de Mensajes          *
      *                                                              *
      * Retorna: *On = Armado Correcto / *off = Armado incorrecto    *
      * ------------------------------------------------------------ *
     D APIGRAI_getParamBase...
     D                 pr              n
     D   peNivc                       5  0 const
     D   peBase                            likeds( paramBase )
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIGRAI_getCotizacionApixWeb: Obtiene nro de cotizacion API  *
      *                               de un nro de cotiacion WEB     *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peNcta   ( input  ) Nro. de Cotizacion API          *
      *          peErro   ( output ) Cod.de Error                    *
      *          peMsgs   ( output ) Estructura de Mensajes          *
      *                                                              *
      * Retorna: *On = No existe / *off = Existe                     *
      * ------------------------------------------------------------ *
     D APIGRAI_getCotizacionApixWeb...
     D                 pr             7  0
     D   peNivc                       5  0 const
     D   peNcta                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIGRAI_getCotizacionWebxApi: Obtiene nro de cotizacion WEB  *
      *                               de un nro de cotiacion API     *
      *          peNivc   ( input  ) Codigo de Productor             *
      *          peNctw   ( input  ) Nro. de Cotizacion WEB          *
      *          peErro   ( output ) Cod.de Error                    *
      *          peMsgs   ( output ) Estructura de Mensajes          *
      *                                                              *
      * Retorna: Retorna: *On = No existe / *off = Existe            *
      * ------------------------------------------------------------ *
     D APIGRAI_getCotizacionWebxApi...
     D                 pr             7  0
     D   peNivc                       5  0 const
     D   peNctw                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIGRAI_setNroCotizacionAPI: Asocia Nro de cotizacion API a  *
      *                              cotizacion WEB                  *
      *           peNivc   ( input  ) Codigo de Productor            *
      *           peNctw   ( input  ) Nro. de Cotizacion WEB         *
      *           peNcta   ( input  ) Nro. de Cotizacion API         *
      *           peErro   ( output ) Cod.de Error                   *
      *           peMsgs   ( output ) Estructura de Mensajes         *
      *                                                              *
      * Retorna: *On = Actualizacion OK / *off = Error               *
      * ------------------------------------------------------------ *
     D APIGRAI_setNroCotizacionAPI...
     D                 pr              n
     D   peNivc                       5  0 const
     D   peNctw                       7  0 const
     D   peNcta                       7  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIGRAI_setCuitIntermediario: Graba CUIT de un intermediario *
      *                                                              *
      *           peNcta   ( input  ) Nro. de Cotizacion API         *
      *           peNivc   ( input  ) Codigo de Productor            *
      *           peCuii   ( input  ) Cuit del Intermediario         *
      *           peErro   ( output ) Cod.de Error                   *
      *           peMsgs   ( output ) Estructura de Mensajes         *
      *                                                              *
      * Retorna: *On = Actualizacion OK / *off = Error               *
      * ------------------------------------------------------------ *
     D APIGRAI_setCuitIntermediario...
     D                 pr
     D   peNcta                       7  0 const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIGRAI_setSitemaRemoto: Graba Nombre de Sistema Remoto.     *
      *                                                              *
      *           peNcta   ( input  ) Nro. de Cotizacion API         *
      *           peNivc   ( input  ) Codigo de Productor            *
      *           peNsys   ( input  ) Nombre de Sistema Remoto       *
      *           peErro   ( output ) Cod.de Error                   *
      *           peMsgs   ( output ) Estructura de Mensajes         *
      *                                                              *
      * Retorna: PeErro = -1 no grabo / PeErro = ' ' ok              *
      * ------------------------------------------------------------ *
     D APIGRAI_setSitemaRemoto...
     D                 pr
     D   peNcta                       7  0 const
     D   peNivc                       5  0 const
     D   peNsys                      20    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIGRAI_getCondicionesComerciales: Calcula condiciones       *
      *                                    Comerciales a partir de   *
      *                                    una Comision enviada.-    *
      *                                                              *
      *           peNcta   ( input  ) Nro. de Cotizacion API         *
      *           peNivc   ( input  ) Codigo de Productor            *
      *           peRama   ( input  ) Rama                           *
      *           pePcom   ( input  ) Comision Solicitada            *
      *           peXopr   ( output ) Comision                       *
      *           peXrea   ( output ) Extra Prima Variable           *
      *           peErro   ( output ) Cod.de Error                   *
      *           peMsgs   ( output ) Estructura de Mensajes         *
      *                                                              *
      * Retorna: PeErro = -1 no grabo / PeErro = ' ' ok              *
      * ------------------------------------------------------------ *
     D APIGRAI_getCondicionesComerciales...
     D                 pr
     D   peNcta                       7  0 const
     D   peNivc                       5  0 const
     D   peRama                       2  0 const
     D   pePcom                       5  2 const
     D   peXopr                       5  2
     D   peXrea                       5  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * APIGRAI_sndMail : Envia Mail                                 *
      *                                                              *
      *           peCprc   ( input  ) Proceso                        *
      *           peCspr   ( input  ) SubProceso                     *
      *           peDmsg   ( input  ) Descripción de Mensaje         *
      *           peNcta   ( input  ) Nro. de Cotización API         *
      *           peVapi   ( input  ) Valor Api                      *
      *           peNctw   ( input  ) Nro. de Cotización             *
      *                                                              *
      * Retorna: PeErro = -1 no envió mail/ PeErro = ' ' envió mail  *
      * ------------------------------------------------------------ *
     D APIGRAI_sndMail...
     D                 pr
     D   peCprc                      20a   const
     D   peSprc                      20a   const
     D   peDmsg                    3000a   const
     D   peVapi                      10a   options(*nopass:*omit)
     D   peNcta                       7  0 options(*nopass:*omit)
     D   peNctw                       7  0 options(*nopass:*omit)

