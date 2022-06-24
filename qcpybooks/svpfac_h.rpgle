      /if defined(SVPFAC_H)
      /eof
      /endif
      /define SVPFAC_H

      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'

      * -----------------------------------------------------------
      * DS PAHIVA ( IVA Productores )
      * -----------------------------------------------------------
     D dsPahiva_t      ds                  qualified template
     D  ivempr                        1a
     D  ivsucu                        2a
     D  ivcoma                        2a
     D  ivnrma                        7s 0
     D  ivfe1a                        4s 0
     D  ivfe1m                        2s 0
     D  ivfe1d                        2s 0
     D  ivc4s2                        3s 0
     D  ivfasa                        4s 0
     D  ivfasm                        2s 0
     D  ivfasd                        2s 0
     D  ivlibr                        1s 0
     D  ivtico                        2s 0
     D  ivnras                        6s 0
     D  ivcomo                        2a
     D  ivmoas                        1a
     D  ivmarp                        1a
     D  ivticp                        2s 0
     D  ivsucp                        4s 0
     D  ivfacn                        8s 0
     D  ivfafa                        4s 0
     D  ivfafm                        2s 0
     D  ivfafd                        2s 0
     D  ivitot                       15s 2
     D  ivigra                       15s 2
     D  iviiva                       15s 2
     D  iviret                       15s 2
     D  ivpiva                        5s 2
     D  ivcomn                        2s 0
     D  ivimco                       15s 6
     D  ivmar1                        1a
     D  ivmar2                        1a
     D  ivmar3                        1a
     D  ivmar4                        1a
     D  ivmar5                        1a
     D  ivuser                       10a
     D  ivtime                        6s 0
     D  ivdate                        6s 0

      * -----------------------------------------------------------
      * DS PAHIVW ( Auditoria Facturas Web )
      * -----------------------------------------------------------
     D dsPahivw_t      ds                  qualified template
     D  pwempr                        1a
     D  pwsucu                        2a
     D  pwcoma                        2a
     D  pwnrma                        7s 0
     D  pwfe1a                        4s 0
     D  pwfe1m                        2s 0
     D  pwfe1d                        2s 0
     D  pwc4s2                        3s 0
     D  pwfing                        8s 0
     D  pwhing                        6s 0
     D  pwuing                       10a
     D  pwfifs                        8s 0
     D  pwhifs                        6s 0
     D  pwuifs                       10a
     D  pwfvue                        8s 0
     D  pwhvue                        6s 0
     D  pwuvue                       10a
     D  pwesta                        1a
     D  pwmar1                        1a
     D  pwmar2                        1a
     D  pwmar3                        1a
     D  pwmar4                        1a
     D  pwmar5                        1a
     D  pwobse                      100a
     D  pwtfac                        2s 0
     D  pwpvta                        4s 0
     D  pwnfac                        8s 0
     D  pwffac                        8s 0
     D  pwfven                        8s 0
     D  pwimau                       15s 2
     D  pwvarc                      300a
     D  pwcarp                      128a
     D  pwcuit                       11a

      * ------------------------------------------------------------ *
      * SVPFAC_inz(): Inicializa Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPFAC_inz      pr

      * ------------------------------------------------------------ *
      * SVPFAC_end(): Finaliza   Módulo                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPFAC_end      pr

      * ------------------------------------------------------------ *
      * SVPFAC_error(): Retornar error del módulo                    *
      *                                                              *
      *    peErrn     (input)    Número de error (opcional)          *
      *                                                              *
      * retorna: Mensaje de error                                    *
      * ------------------------------------------------------------ *
     D SVPFAC_error    pr            80a
     D  peErrn                       10i 0 options(*nopass : *omit)

      * ------------------------------------------------------------ *
      * SVPFAC_chkFactura: Chequea facturacion                       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_chkFactura...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const

      * ------------------------------------------------------------ *
      * SVPFAC_getPahivw: Retorna Auditoria de Facturas Web          *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso            (Opcional) *
      *     peFe1m   ( input  ) Mes de Proceso            (Opcional) *
      *     peFe1d   ( input  ) Dia de Proceso            (Opcional) *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peDsVw   ( output ) Estrutura de Facturas Web (Opcional) *
      *     peDsVwC  ( output ) Cantidad de Facturas Web  (Opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_getPahivw...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 options( *nopass : *omit ) const
     D   peFe1m                       2  0 options( *nopass : *omit ) const
     D   peFe1d                       2  0 options( *nopass : *omit ) const
     D   peC4s2                       3  0 options( *nopass : *omit ) const
     D   peDsVw                            likeds( dsPahivw_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsVwC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPFAC_chkIngreso: Chequea Ingreso de Facturas Web           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_chkIngreso...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const

      * ------------------------------------------------------------ *
      * SVPFAC_getEstadoPahivw: Retorna estado de Facturas Web       *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peEsta   ( output ) Código de Estado                     *
      *     peDest   ( output ) Descripción de Estado    (opcional)  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_getEstadoPahivw...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peEsta                       1
     D   peDest                      40    options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPFAC_setIngreso: Graba estado de Facturas Web              *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peVarc   ( input  ) Nombre del Archivo                   *
      *     peErro   ( output ) Indicador de Error                   *
      *     PeMsgs   ( output ) Estructura de Error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_setIngreso...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peVarc                     300    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * SVPFAC_setDescarga: Graba Descarga de Facturas Web           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peCarp   ( input  ) Carpeta de descarga                  *
      *     peErro   ( output ) Indicador de Error        (opcional) *
      *     PeMsgs   ( output ) Estructura de Error       (opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_setDescarga...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peCarp                     128    const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * SVPFAC_setVuelta: Graba Vuelta de Facturas Web               *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peErro   ( output ) Indicador de Error                   *
      *     PeMsgs   ( output ) Estructura de Error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_setVuelta...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      * ------------------------------------------------------------ *
      * SVPFAC_setErrorPahivw: Graba Error en Facturas Web           *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peMsgs   ( input  ) Estructura de Error
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_setErrorPahivw...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peMsge                     100    const

      * ------------------------------------------------------------ *
      * SVPFAC_updFactura: Actualiza Facturas Web                    *
      *                                                              *
      *     peDsVw   ( input  ) Estructura de Facturas Web           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_updFactura...
     D                 pr              n
     D   peDsVw                            likeds( dsPahivw_t ) const

      * ------------------------------------------------------------ *
      * SVPFAC_getTipoDeComprobante: Retorna datos del tipo de       *
      *                              comprobante                     *
      *                                                              *
      *     peTifa   ( input  ) Tipo de Comprobante (Opcional)       *
      *     peDsTc   ( output ) Estructura de Tipo de Comprobante    *
      *     peDsTcC  ( output ) Cantidad de Tipos                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_getTipoDeComprobante...
     D                 pr              n
     D   peTifa                       2  0 options( *nopass : *omit ) const
     D   peDsTc                            options( *nopass : *omit )
     D                                     likeds( dsGnttfc_t ) dim( 99 )
     D   peDsTc                      10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPFAC_chkTipoDeFactura: Chequea que exista el tipo de       *
      *                          comprobante                         *
      *                                                              *
      *     peTifa   ( input  ) Tipo de Comprobante                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_chkTipoDeFactura...
     D                 pr              n
     D   peTifa                       2  0 const

      * ------------------------------------------------------------ *
      * SVPFAC_getPahivwXArchivo: Retorna Datos de la factura Web    *
      *                           por nombre del archivo             *
      *                                                              *
      *     peVarc   ( input  ) Nombre del Archivo        (opcional) *
      *     peDsVw   ( output ) Estrutura de Facturas Web (opcional) *
      *     peDsVwC  ( output ) Cantidad de Facturas Web  (opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_getPahivwXArchivo...
     D                 pr              n
     D   peVarc                     300    options( *nopass : *omit ) const
     D   peDsVw                            likeds( dsPahivw_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsVwC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPFAC_updPahiva: Actualiza datos en el archivo pahiva       *
      *                                                              *
      *     peDsIv   ( input  ) Estrutura de Pahiva                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_updPahiva...
     D                 pr              n
     D   peDsIv                            likeds( dsPahiva_t ) const

      * ------------------------------------------------------------ *
      * SVPFAC_getPahiva: Retorna datos de Pahiva                    *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso            (Opcional) *
      *     beFe1m   ( input  ) Mes de Proceso            (Opcional) *
      *     peFe1d   ( input  ) Dia de Proceso            (Opcional) *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza   (Opcional) *
      *     peDsVa   ( output ) Estrutura de Pahiva       (Opcional) *
      *     peDsVaC  ( output ) Cantidad de registros     (Opcional) *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_getPahiva...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 options( *nopass : *omit ) const
     D   peFe1m                       2  0 options( *nopass : *omit ) const
     D   peFe1d                       2  0 options( *nopass : *omit ) const
     D   peC4s2                       3  0 options( *nopass : *omit ) const
     D   peDsVa                            likeds( dsPahiva_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsVaC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SVPFAC_getPahivwXArcFnet: Retorna Datos de la factura Web    *
      *                           por nombre del archivo de Filenet  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucursal                             *
      *     peVarc   ( input  ) Nombre del Archivo                   *
      *     peDsVw   ( output ) Estrutura de Facturas Web            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_getPahivwXArcFnet...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peVarc                     300    const
     D   peDsVw                            likeds( dsPahivw_t )

      * ------------------------------------------------------------ *
      * SVPFAC_getEstadoAnterior: Retorna estado de Facturas Web     *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peComa   ( input  ) Código de Mayor Auxiliar             *
      *     peNrma   ( input  ) Número de Mayor Auxiliar             *
      *     peFe1a   ( input  ) Año de Proceso                       *
      *     peFe1m   ( input  ) Mes de Proceso                       *
      *     peFe1d   ( input  ) Dia de Proceso                       *
      *     peC4s2   ( input  ) Secuencia 2 de Cobranza              *
      *     peEsta   ( output ) Código de Estado                     *
      *     peDest   ( output ) Descripción de Estado    (opcional)  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPFAC_getEstadoAnterior...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peComa                       2    const
     D   peNrma                       7  0 const
     D   peFe1a                       4  0 const
     D   peFe1m                       2  0 const
     D   peFe1d                       2  0 const
     D   peC4s2                       3  0 const
     D   peEsta                       1
     D   peDest                      40    options( *nopass : *omit )
