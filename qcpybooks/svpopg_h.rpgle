      /if defined(SVPOPG_H)
      /eof
      /endif
      /define SVPOPG_H

      /define SVPTAB_H
      /copy './qcpybooks/svpdes_h.rpgle'
      /undefine SVPTAB_H

      * -----------------------------------------------------------
      * DS CNHOPA ( Ordenes de Pagos )
      * -----------------------------------------------------------
      /if not defined(SVPSIN_H)
     D dsCnhopa_t      ds                  qualified template
     D  paEmpr                        1a
     D  paSucu                        2a
     D  paArtc                        2s 0
     D  paPacp                        6s 0
     D  paMoas                        1a
     D  prComa                        2a
     D  prNrma                        7s 0
     D  prDvna                        9s 0
     D  prEsma                        1a
     D  paLibr                        1s 0
     D  paFasa                        4s 0
     D  paFasm                        2s 0
     D  paFasd                        2s 0
     D  paComo                        2a
     D  paTico                        2s 0
     D  paNras                        6s 0
     D  paImco                       15s 6
     D  paImme                       15s 2
     D  paImau                       15s 2
     D  paNrcm                       11s 0
     D  paDvcm                        1a
     D  paComa                        2a
     D  paNrma                        7s 0
     D  paDvna                        1a
     D  paEsma                        1s 0
     D  paFera                        4s 0
     D  paFerm                        2s 0
     D  paFerd                        2s 0
     D  paCopt                       25a
     D  pbCopt                       25a
     D  pcCopt                       25a
     D  pdCopt                       25a
     D  paCode                        3s 0
     D  pbNrcm                       11s 0
     D  pbDvcm                        1a
     D  pbComa                        2a
     D  pbNrma                        7s 0
     D  pbDvna                        1a
     D  pbEsma                        1s 0
     D  pbIvch                        6s 0
     D  pbLibr                        1s 0
     D  pbFasa                        4s 0
     D  pbFasm                        2s 0
     D  pbFasd                        2s 0
     D  pbComp                       15s 6
     D  pbTico                        2s 0
     D  pbNras                        6s 0
     D  pbImme                       15s 2
     D  pbImau                       15s 2
     D  paCfre                        1s 0
     D  paUser                       10a
     D  paAfhc                       13s 0
     D  paStop                        1a
     D  paRama                        2s 0
     D  paLiqn                        7s 0
     D  paMovt                        1a
     D  pbMonp                        2a
     D  pbImco                       15s 6
     D  paNomb                       40a
     D  paIvcv                        2s 0
     D  paInta                        1s 0
     D  paInna                        5s 0
     D  paMarp                        1a
     D  paCofa                        2a
     D  paNrve                        3s 0
     D  paMp01                        1a
     D  paMp02                        1a
     D  paMp03                        1a
     D  paMp04                        1a
     D  paMp05                        1a
     D  paMp06                        1a
     D  paMp07                        1a
     D  paMp08                        1a
     D  paMp09                        1a
     D  pbFera                        4s 0
     D  pbFerm                        2s 0
     D  pbFerd                        2s 0
      /endif

     D reteCalc_t      ds                  qualified template
     D  tiic                          3a
     D  tiid                         30a
     D  rpro                          2  0
     D  prod                         20a
     D  poim                          5  2
     D  iiau                         15  2
     D  irau                         15  2
     D  pacp                          6  0

      /if not defined(SVPSIN_H)
      * --------------------------------------------------- *
      * Estrucutura de datos CNHRET
      * --------------------------------------------------- *
     D dscnhret_t      ds                  qualified template
     D  rtEmpr                        1a
     D  rtSucu                        2a
     D  rtTiic                        3a
     D  rtFepa                        4p 0
     D  rtFepm                        2p 0
     D  rtComa                        2a
     D  rtNrma                        7p 0
     D  rtRpro                        2p 0
     D  rtIvse                        5p 0
     D  rtFepd                        2p 0
     D  rtLibr                        1p 0
     D  rtNras                        6p 0
     D  rtComo                        2a
     D  rtCome                       15p 6
     D  rtIime                       15p 2
     D  rtIrme                       15p 2
     D  rtMonp                        2a
     D  rtComp                       15p 6
     D  rtIimp                       15p 2
     D  rtIrmp                       15p 2
     D  rtIiau                       15p 2
     D  rtIrau                       15p 2
     D  rtPoim                        5p 2
     D  rtBmis                       15p 2
     D  rtNrrf                        9p 0
     D  rtCoi2                        2p 0
     D  rtCoi1                        1p 0
     D  rtMoas                        1a
     D  rtTico                        2p 0
     D  rtSucp                        4p 0
     D  rtFacn                        8p 0
     D  rtFafa                        4p 0
     D  rtFafm                        2p 0
     D  rtFafd                        2p 0
     D  rtPacp                        6p 0
     D  rtMarp                        1a
     D  rxNras                        6p 0
     D  rtRbau                       15p 2
     D  r1Marp                        1a
     D  r2Marp                        1a

      /endif

      * ------------------------------------------------------------ *
      * SVPOPG_inz(): Inicializa Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPOPG_inz      pr

      * ------------------------------------------------------------ *
      * SVPOPG_end(): Finaliza   Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPOPG_end      pr

      * ------------------------------------------------------------ *
      * SVPOPG_error(): Retornar error del módulo                    *
      *                                                              *
      *    peErrn     (input)    Número de error (opcional)          *
      *                                                              *
      * retorna: Mensaje de error                                    *
      * ------------------------------------------------------------ *
     D SVPOPG_error    pr            80a
     D  peErrn                       10i 0 options(*nopass : *omit)

      * ------------------------------------------------------------ *
      * SVPOPG_getCnhopa: Retorna datos de Ordenes de Pago           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArtc   ( input  ) Código Area Tecnica                  *
      *     pePacp   ( input  ) Nro. de Comprobante Pago  (Opcional) *
      *     peDsPa   ( output ) Estrutura de Orden de Pago(Opcional) *
      *     peDsPaC  ( output ) Cantidad de Orden de Pago (Opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPOPG_getCnhopa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 options( *nopass : *omit ) const
     D   peDsPa                            likeds( dsCnhopa_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsPaC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPOPG_getEstadoCnhopa: Retorna estado de la orden de pago   *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArtc   ( input  ) Código Area Técnica                  *
      *     pePacp   ( input  ) Nro. de Comprobante de Pago          *
      *     peEsta   ( output ) Código de Estado                     *
      *     peDest   ( output ) Descripción de Estado    (opcional)  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPOPG_getEstadoCnhopa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const
     D   peEsta                       1
     D   peDest                      40    options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPOPG_updCnhopa: Actualiza orden de pago                    *
      *                                                              *
      *     peDsPa   ( input  ) Estructura de Orden de Pago          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPOPG_updCnhopa...
     D                 pr              n
     D   peDsPa                            likeds( dsCnhopa_t ) const

      * ------------------------------------------------------------ *
      * SVPOPG_getImportes: Obtener los importes de una op           *
      *                                                              *
      * IMPORTANTE: Este procedimiento es una negrada, un parche para*
      *             zafar ahora con Varegos y no seguir dando vueltas*
      *             pero HAY QUE HACER ALGO COMO LA GENTE.           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     pePacp   ( input  ) Orden de Pago                        *
      *     peTota   ( output ) Total previo a impuestos             *
      *     peViva   ( output ) Valor de IVA                         *
      *     peSubt   ( output ) Subtotal (peTota + peViva)           *
      *     peRete   ( output ) Array con retenciones                *
      *     peNeto   ( output ) Neto (peSubt - peRete)               *
      *     pePerc   ( output ) Percepciones                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPOPG_getImportes...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArtc                       2a   const
     D   pePacp                       6  0 const
     D   peTota                      15  2
     D   peViva                      15  2
     D   peSubt                      15  2
     D   peRete                            likeds(reteCalc_t) dim(99)
     D   peNeto                      15  2
     D   pePerc                      15  2


      * ------------------------------------------------------------ *
      * SVPOPG_getRetencionesDeOrdenPago:                            *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peArtc   ( input  ) Area Tecnica                         *
      *     pePacp   ( input  ) Orden de Pago                        *
      *     peDsEt   ( output ) Estructura Cnhret                    *
      *     peDsEtC  ( output ) Ocurrencias de Cnhret                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPOPG_getRetencionesDeOrdenPago...
     D                 pr              n
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArtc                       2a   const
     D   pePacp                       6  0 const
     D   peDsEt                            likeds(DsCnhret_t) dim(999)
     D   peDsEtC                     10i 0
