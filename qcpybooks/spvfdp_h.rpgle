      /if defined(SPVFDP_H)
      /eof
      /endif
      /define SPVFDP_H

      * Error en Parseo de Ds...
     D SPVFDP_ERRPA    c                   const(0001)
      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SPVFDP_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * --------------------------------------------------- *
      * Estrucutura DS Variables de Formas de Pago
      * --------------------------------------------------- *
     D SPVFDP_PDS_T    ds                  qualified
     D                                     based(template)
     D wcfpgx                         1  0
     D wctcux                         3  0
     D wnrtcx                        20  0
     D wivbcx                         3  0
     D wivsux                         3  0
     D wtctax                         2  0
     D wnctax                        25
     D wivr2x                         6  0
     D wnrrtx                         7  0
     D wnrlox                         4s 0
     D wnrlax                         7
     D wnrlnx                         9p 0
     D wcbrnx                         7  0
     D wczcox                         7p 0
     D wmar4x                         1
     D wcocpx                         1
     D wconrx                         7  0
     D wstrgx                         1
     D wsttcx                         1
     D wnrctx                         7  0

      * --------------------------------------------------- *
      * Estrucutura DS Para Cambios de Formas de Pago desde WS
      * --------------------------------------------------- *
     D DSFMTTCR        ds                  qualified template
     D   tcCtcu                       3  0
     D   tcNrtc                      20  0

     D DSFMTDEB        ds                  qualified template
     D   deNcbu                      22

     D DSFMTCOB        ds                  qualified template
     D   coCobr                       7  0
     D   coZona                       7p 0

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioTarjCred(): Cambia a Tarjeta de Credito        *
      *                           cfpg = 1                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peCfpa   (input)   Codigo de Forma de Pago Anterior      *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setCbioTarjCred...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peCfpa                       1  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioDebitBco(): Cambia a Debito Bancario           *
      *                           cfpg = 2 o 3                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peCfpa   (input)   Codigo de Forma de Pago Anterior      *
      *     peNcbu   (input)   CBU                                   *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setCbioDebitBco...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peCfpa                       1  0 const
     D   peNcbu                      25    const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioDebitBcoSe(): Cambia a Debito Bancario         *
      *                             cfpg = 2 o 3 (con CBU separado)  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peCfpa   (input)   Codigo de Forma de Pago Anterior      *
      *     peIvbc   (input)   Codigo de Banco                       *
      *     peIvsu   (input)   Codigo de Sucursal                    *
      *     peTcta   (input)   Tipo de Cuenta                        *
      *     peNcta   (input)   Numero de CBU                         *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setCbioDebitBcoSe...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peCfpa                       1  0 const
     D   peIvbc                       3  0 const
     D   peIvsu                       3  0 const
     D   peTcta                       2  0 const
     D   peNcta                      25    const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioCobrador(): Cambia a Efectivo                  *
      *                           cfpg = 4 o 5 o 6                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peCobr   (input)   Cobrador                              *
      *     peZona   (input)   Zona                                  *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setCbioCobrador...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peCobr                       7  0 const
     D   peZona                       7p 0 const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVFDP_chkPoliCbio(): Chequea Poliza en Condiciones de       *
      *                         Realizar Cambio                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_chkPoliCbio...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peAsen                       7  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFDP_updEc0(): Actualiza Pahec0                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_updEc0...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

      * ------------------------------------------------------------ *
      * SPVFDP_updEc1(): Actualiza Pahec1                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_updEc1...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

      * ------------------------------------------------------------ *
      * SPVFDP_updCc2(): Actualiza Pahcc2                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_updCc2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

      * ------------------------------------------------------------ *
      * SPVFDP_updCd5(): Actualiza Pahcd5                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_updCd5...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

      * ------------------------------------------------------------ *
      * SPVFDP_updCfp(): Actualiza Pahcd5                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peUser   (input)   Usuario                               *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_updCfp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peUser                      10    const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

      * ------------------------------------------------------------ *
      * SPVFDP_setSpy(): Actualiza Pahcd5                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peUser   (input)   Usuario                               *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setSpy...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peUser                      10    const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

      * ------------------------------------------------------------ *
      * SPVFDP_setFdp(): Actualiza Pahcd5                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *     peUser   (input)   Usuario                               *
      *     peDfdp   (input)   Ds Variables de Froma de Pago         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setFdp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peUser                      10    const
     D   peDfdp                            likeds(SPVFDP_PDS_T)

      * ------------------------------------------------------------ *
      * SPVFDP_deletec2(): Elimina Pahcc2                            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_deleteCc2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ------------------------------------------------------------ *
      * SPVFDP_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVFDP_inz      pr

      * ------------------------------------------------------------ *
      * SPVFDP_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVFDP_end      pr

      * ------------------------------------------------------------ *
      * SPVFDP_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SPVFDP_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFDP_chkIntFdpWeb(): Chequea si el intermediario esta      *
      *                     esta habilitado para cambiar la forma de *
      *                     pago desde la web                        *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peNivt   (input)   Tipo de Intermediario                 *
      *     peNivc   (input)   Codigo de Intermediario               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_chkIntFdpWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const

      * ------------------------------------------------------------ *
      * SPVFDP_chkNuevaFDP(): Chequea la forma de pago es valida para*
      *                       la web                                 *
      *                                                              *
      *     peNfdp   (input)   Codigo de Forma de Pago               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_chkNuevaFDP...
     D                 pr              n
     D   peNfdp                       1  0 const

      * ------------------------------------------------------------ *
      * SPVFDP_setDsTcr(): Parsea parametros para cambio a tarjeta   *
      *                                                              *
      *     peInfo   (input)   Informacion                           *
      *     peDsTc   (output)  Ds Tarjeta de Credito                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setDsTcr...
     D                 pr              n
     D   peInfo                     256a   const
     D   peDsTc                            likeds ( DSFMTTCR )

      * ------------------------------------------------------------ *
      * SPVFDP_setDsDeb(): Parsea parametros para cambio a debito    *
      *                                                              *
      *     peInfo   (input)   Informacion                           *
      *     peDsDe   (output)  Ds Debito                             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setDsDeb...
     D                 pr              n
     D   peInfo                     256a   const
     D   peDsDe                            likeds ( DSFMTDEB )

      * ------------------------------------------------------------ *
      * SPVFDP_setDsCob(): Parsea parametros para cambio a efectivo  *
      *                                                              *
      *     peInfo   (input)   Informacion                           *
      *     peDsEf   (output)  Ds Efectivo                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setDsCob...
     D                 pr              n
     D   peInfo                     256a   const
     D   peDsEf                            likeds ( DSFMTCOB )

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioTarjCredV2(): Cambia a Tarjeta de Credito      *
      *                             cfpg = 1                         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setCbioTarjCredV2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioDebitBcoV2(): Cambia a Debito Bancario         *
      *                             cfpg = 2 o 3                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peNcbu   (input)   CBU                                   *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setCbioDebitBcoV2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNcbu                      25    const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVFDP_setCbioCobradorV2(): Cambia a Efectivo                *
      *                             cfpg = 4 o 5 o 6                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peCobr   (input)   Cobrador                              *
      *     peZona   (input)   Zona                                  *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_setCbioCobradorV2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peCobr                       7  0 const
     D   peZona                       7p 0 const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVFDP_chkPoliCbioV2(): Chequea Poliza en Condiciones de     *
      *                         Realizar Cambio                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (output)  Suplemento con error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_chkPoliCbioV2...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFDP_chkPlanDePago(): Chequea que existe Plan de Pago aso- *
      *                         ciado al Artículo y Forma de Pago    *
      *                                                              *
      *     peArcd   (input)   Código de Artículo                    *
      *     peCfpg   (input)   Código de Forma de Pago               *
      *     peNrpp   (input)   Número de Plan de Pago                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFDP_chkPlanDePago...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const
     D   peNrpp                       3  0 const

      * ------------------------------------------------------------ *
      * SPVFDP_chkPoliCbioV3(): Chequea Poliza en Condiciones de     *
      *                         Realizar Cambio                      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Codigo de Articulo                    *
      *     peSpol   (input)   Numero de SuperPoliza                 *
      *     peSspo   (output)  Suplemento con error                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVFDP_chkPoliCbioV3...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFDP_getPlanDePago(): Retorna el Plan de Pago asociado al  *
      *                         Artículo y Forma de Pago.            *
      *                                                              *
      *     peArcd  ( input  )  Código de Artículo                   *
      *     peCfpg  ( input  )  Código de Forma de Pago              *
      *                                                              *
      * Retorna: NRPP                                                *
      * ------------------------------------------------------------ *
     D SPVFDP_getPlanDePago...
     D                 pr             3  0
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const

      * ------------------------------------------------------------ *
      * SPVFDP_getPlanDePagoWeb(): Retorna el Plan de Pago asociado  *
      *                            al Artículo y la Forma de Pago,   *
      *                            habilitado para la web.           *
      *                                                              *
      *     peArcd  ( input  )  Código de Artículo                   *
      *     peCfpg  ( input  )  Código de Forma de Pago              *
      *                                                              *
      * Retorna: NRPP                                                *
      * ------------------------------------------------------------ *

     D SPVFDP_getPlanDePagoWeb...
     D                 pr             3  0
     D   peArcd                       6  0 const
     D   peCfpg                       1  0 const
