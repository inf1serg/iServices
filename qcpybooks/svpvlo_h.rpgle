      /if defined(SVPVLO_H)
      /eof
      /endif
      /define SVPVLO_H

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPVLO_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * Estructura DS ivt001                                         *
      * ------------------------------------------------------------ *
     D dsIvt001_t      ds                  qualified template
     D  t1empr                        1a
     D  t1sucu                        2a
     D  t1ivtm                        2p 0
     D  t1ivdt                       18a
     D  t1ivle                        1p 0
     D  t1ivlo                        1p 0
     D  t1ivr6                        1a
     D  t1ivr7                        6p 0
     D  t1ivr8                        6p 0
     D  t1ivr9                        6p 0
     D  t1ivv1                        2p 0
     D  t1ivv2                        2p 0
     D  t1ivv3                        2p 0
     D  t1ivv4                        2p 0
     D  t1ivv5                        2p 0
     D  t1ivta                        1a
     D  t1ivpa                        1a
     D  t1ivi1                       11p 0
     D  t1ivd1                        1p 0
     D  t1ivi2                       11p 0
     D  t1ivd2                        1p 0
     D  t1ivi3                       11p 0
     D  t1ivd3                        1p 0
     D  t1ivti                        1a
     D  t1ivv6                        2p 0
     D  t1ivv7                        2p 0
     D  t1ivv8                        2p 0
     D  t1ivv9                        2p 0
     D  t1cpg1                       10a
     D  t1cpg2                       10a
     D  t1opc1                        1a
     D  t1opc2                        1a
     D  t1opc3                        1a
     D  t1opc4                        1a
     D  t1opc5                        1a

      * ------------------------------------------------------------ *
      * Estructura DS ivt002                                         *
      * ------------------------------------------------------------ *
     D dsIvt002_t      ds                  qualified template
     D  t2empr                        1a
     D  t2sucu                        2a
     D  t2ic1a                        4p 0
     D  t2ic1m                        2p 0
     D  t2ic1d                        2p 0
     D  t2ic2a                        4p 0
     D  t2ic2m                        2p 0
     D  t2ic2d                        2p 0
     D  t2ic3t                        2p 0
     D  t2ivnm                        1a
     D  t2ivn1                        1a
     D  t2ivn2                        2p 0
     D  t2ivn3                        6p 0
     D  t2ivn4                        6p 0
     D  t2ivn5                        6p 0
     D  t2ivia                        4p 0
     D  t2ivim                        2p 0
     D  t2ivm1                        2p 0
     D  t2coma                        2a
     D  t2nrma                        7p 0
     D  t2dvna                        1a
     D  t2esma                        1p 0
     D  t2ivm2                       20a
     D  t2ivme                        2a
     D  t2ivmc                        2a
     D  t2ivpc                        1a
     D  t2ivpe                        1a
     D  t2ivpm                        1a
     D  t2ivpn                        1a
     D  t2ivpb                        1a
     D  t2ivpd                        1a
     D  t2ivps                        1a
     D  t2ivpl                        1a
     D  t2ivcp                        1a
     D  t2ivcl                        1a
     D  t2ivcr                        1a
     D  t2ivca                        1a
     D  t2ivna                        1a
     D  t2ivcg                        1a
     D  t2ivr3                        1a
     D  t2ivr4                       12a
     D  t2ivr5                        1a
     D  t2ivtv                        2p 0
     D  t2ivtn                        3p 0
     D  t2ivp1                        3p 0
     D  t2ivp2                        3p 0
     D  t2ivp3                        3p 0
     D  t2ivua                        4p 0
     D  t2ivum                        2p 0
     D  t2ivud                        2p 0
     D  t2ipaa                        4p 0
     D  t2ipmm                        2p 0
     D  t2ipdd                        2p 0
     D  t2ivpi                       15p 2
     D  t2fasa                        4p 0
     D  t2fasm                        2p 0
     D  t2fasd                        2p 0
     D  t2cara                        1a
     D  t2opc1                        1a
     D  t2opc2                        1a
     D  t2opc3                        1a
     D  t2opc4                        1a
     D  t2opc5                        1a
     D  t2tico                        2p 0
     D  t2feca                        4p 0
     D  t2fecm                        2p 0
     D  t2fecd                        2p 0
     D  t2imau                       15p 2
     D  t2cpgm                       10a
     D  t2cpg2                       10a
     D  t2ivpa                        1a
     D  t2opc6                        1a
     D  t2opc7                        1a
     D  t2opc8                        1a
     D  t2opc9                        1a
     D  t2cpg3                       10a
     D  t2cpg4                       10a
     D  t2cpg5                       10a
     D  t2suve                        4p 0
     D  t2facn                        8p 0
     D  t2prt1                       10a
     D  t2bnd1                        1a
     D  t2prt2                       10a
     D  t2bnd2                        1a
     D  t2ticr                        2p 0

      * ------------------------------------------------------------ *
      * Estructura DS ivhcar                                         *
      * ------------------------------------------------------------ *
     D dsIvhcar_t      ds                  qualified template
     D  caempr                        1a
     D  casucu                        2a
     D  caivop                        7p 0
     D  caivme                        2a
     D  caivni                        6p 0
     D  cafe1a                        4p 0
     D  cafe1m                        2p 0
     D  cafe1d                        2p 0
     D  caivco                       15p 6
     D  caivit                       15p 2
     D  caiviv                       15p 2
     D  catvim                       15p 2
     D  catgim                       15p 2
     D  cacoma                        2a
     D  canrma                        7p 0
     D  cadvna                        1a
     D  caesma                        1p 0
     D  canrcm                       11p 0
     D  cadvcm                        1a
     D  caivr1                        8p 0
     D  caivr2                        6p 0
     D  caivcp                        1a
     D  caivcl                        1a
     D  caivcr                        1a
     D  caivca                        1a
     D  caivna                        1a
     D  caivcg                        1a
     D  caivsi                        1a
     D  caivti                        1a
     D  caivsr                        1a
     D  caivtr                        1a
     D  caivtm                        2p 0
     D  cawdis                       10a
     D  causer                       10a
     D  canivt                        1p 0
     D  canivc                        5p 0
     D  cacbrn                        7p 0
     D  caczco                        7p 0
     D  cansoc                        5p 0
     D  camar1                        1a
     D  camar2                        1a
     D  camar3                        1a
     D  camar4                        1a
     D  camar5                        1a
     D  caivr3                        6p 0
     D  cacom2                        2a
     D  canrm2                        7p 0
     D  caesm2                        1p 0
     D  canrrf                        9p 0
     D  caimau                       15p 2
     D  cacopt                       25a
     D  caxdia                        5p 0

      * ------------------------------------------------------------ *
      * Estructura DS ivhval                                         *
      * ------------------------------------------------------------ *
     D dsIvhval_t      ds                  qualified template
     D  vaempr                        1a
     D  vasucu                        2a
     D  vaivop                        7p 0
     D  vaivse                        5p 0
     D  vaivme                        2a
     D  vaivmc                        2a
     D  vaivni                        6p 0
     D  vafe1a                        4p 0
     D  vafe1m                        2p 0
     D  vafe1d                        2p 0
     D  vaivco                       15p 6
     D  vaivie                       15p 2
     D  vaivic                       15p 2
     D  vaivau                       15p 2
     D  vaivnr                        6p 0
     D  vaivnl                        2p 0
     D  vaivda                        4p 0
     D  vaivdm                        2p 0
     D  vaivdd                        2p 0
     D  vaivhs                        3p 0
     D  vaivdp                        1p 0
     D  vaivra                        4p 0
     D  vaivrm                        2p 0
     D  vaivrd                        2p 0
     D  vaivmf                        1a
     D  vaivcv                        2p 0
     D  vaivfa                        4p 0
     D  vaivfm                        2p 0
     D  vaivfd                        2p 0
     D  vaivch                        6p 0
     D  vaivbc                        3p 0
     D  vaivcc                        2p 0
     D  vaivsu                        3p 0
     D  vacopo                        5p 0
     D  vacops                        1p 0
     D  vxfe1a                        4p 0
     D  vxfe1m                        2p 0
     D  vxfe1d                        2p 0
     D  vanras                        6p 0
     D  vac4st                        1a
     D  vacoma                        2a
     D  vanrma                        7p 0
     D  vadvna                        1a
     D  vaesma                        1p 0
     D  vacom2                        2a
     D  vanrm2                        7p 0
     D  vadvn2                        1a
     D  vaesm2                        1p 0
     D  vacom3                        2a
     D  vanrm3                        7p 0
     D  vadvn3                        1a
     D  vaesm3                        1p 0
     D  vanivt                        1p 0
     D  vanivc                        5p 0
     D  vayvbc                        3p 0
     D  vayvcc                        2p 0
     D  vayvsu                        3p 0
     D  vamar1                        1a
     D  vamar2                        1a
     D  vamar3                        1a
     D  vamar4                        1a
     D  vamar5                        1a
     D  vacbrn                        7p 0
     D  vacosu                        1a
     D  varein                        6p 0
     D  varese                        5p 0
     D  vacomd                        2a
     D  vanrmd                        7p 0
     D  vaesmd                        1p 0
     D  vaivn2                        6p 0
     D  vaivs2                        5p 0
     D  vaivo2                        7p 0
     D  vaivn3                        6p 0
     D  vaivs3                        5p 0
     D  vaivo3                        7p 0

      * ------------------------------------------------------------ *
      * SVPVLO_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPVLO_inz      pr

      * ------------------------------------------------------------ *
      * SVPVLO_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPVLO_end      pr

     * ------------------------------------------------------------ *
     * SVPVLO_chkTipoDeMovimientos: Validar tipo de movimiento      *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvtm   ( input  )   Tipo de Movimiento                 *
     *                                                              *
     * Retorna: *on = Encontró / *off = No encontró                 *
     * ------------------------------------------------------------ *
     D SVPVLO_chkTipoDeMovimientos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvtm                       2  0 const

      * ------------------------------------------------------------ *
      * SVPVLO_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPVLO_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPVLO_getTipoDeMovimientos: Retorna tipos de movimientos    *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvtm   ( input  )   Tipo de Movimiento                 *
     *     peDsT1   ( output )   Estr. T.  Movimientos ( opcional ) *
     *     peDsT1C  ( output )   Cantidad  Movimientos ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_getTipoDeMovimientos...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvtm                       2  0 options( *nopass : *omit ) const
     D   peDsT1                            likeds( dsIvt001_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsT1C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPVLO_getRegistroDeControl: Retorna informacion de Registro *
     *                              de Control                      *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peDsT2   ( output )   Estr. Reg. de Control ( opcional ) *
     *     peDsT2C  ( output )   Cantidad R.de Control ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_getRegistroDeControl...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsT2                            likeds( dsIvt002_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsT2C                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPVLO_chkCaratula : Valida Caratula de un ingreso de Valores*
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvop   ( input  )   Numero de Operacion                *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_chkCaratula...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       7  0 const

     * ------------------------------------------------------------ *
     * SVPVLO_getCaratulas:Retorna Caratula de un ingreso de Valores*
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvop   ( input  )   Numero de Operacion   ( opcional ) *
     *     peDsCa   ( output )   Estr. T.  Caratulas   ( opcional ) *
     *     peDsCaC  ( output )   Cantidad  Caratuals   ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_getCaratulas...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       7  0 options( *nopass : *omit ) const
     D   peDsCa                            likeds( dsIvhcar_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsCaC                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPVLO_setCaratula : Graba Caratula de un ingreso de Valores *
     *                                                              *
     *     peDsCa   ( input )   Estr. T.  Caratulas                 *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_setCaratula...
     D                 pr              n
     D   peDsCa                            likeds( dsIvhcar_t )

     * ------------------------------------------------------------ *
     * SVPVLO_dltCaratula : Elimina Caratula de un ingreso de       *
     *                      Valores                                 *
     *                                                              *
     *     peDsCa   ( input )   Estr. T.  Caratulas                 *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_dltCaratula...
     D                 pr              n
     D   peDsCa                            likeds( dsIvhcar_t )

     * ------------------------------------------------------------ *
     * SVPVLO_chkValor : Valida Valor                               *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvop   ( input  )   Numero de Operacion                *
     *     peIvse   ( input  )   Secuencia             ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_chkValor...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       7  0 const
     D   peIvse                       5  0 options( *nopass : *omit ) const

     * ------------------------------------------------------------ *
     * SVPVLO_getValores : Retorna Valores                          *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvop   ( input  )   Numero de Operacion   ( opcional ) *
     *     peIvse   ( input  )   Secuencia             ( opcional ) *
     *     peDsCa   ( output )   Estr. T.  Caratulas   ( opcional ) *
     *     peDsCaC  ( output )   Cantidad  Caratuals   ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_getValores...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       7  0 options( *nopass : *omit ) const
     D   peIvse                       5  0 options( *nopass : *omit ) const
     D   peDsVa                            likeds( dsIvhval_t ) dim( 9999 )
     D                                     options( *nopass : *omit )
     D   peDsVaC                     10i 0 options( *nopass : *omit )

     * ------------------------------------------------------------ *
     * SVPVLO_setValor : Graba Valor Ingresado                      *
     *                                                              *
     *     peDsVa   ( input )   Estr. T.  Caratulas                 *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_setValor...
     D                 pr              n
     D   peDsVa                            likeds( dsIvhval_t )

     * ------------------------------------------------------------ *
     * SVPVLO_dltValor : Elimina Caratula de un ingreso de Valores  *
     *                                                              *
     *     peDsVa   ( input )   Estr. T.  Caratulas                 *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_dltValor...
     D                 pr              n
     D   peDsVa                            likeds( dsIvhval_t )

     * ------------------------------------------------------------ *
     * SVPVLO_chkCaja : Valida que Caja                             *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvr2   ( input  )   Numero de Caja ( opcional )        *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_chkCaja...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvop                       6  0 const options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPVLO_chkCajaTerminal : Valida Caja por Terminal            *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peWdis   ( input  )   Nombre de Dispositivo              *
     *     peIvr2   ( input  )   Numero de Caja        ( opcional ) *
     *                                                              *
     * Retorna: *on / *off                                          *
     * ------------------------------------------------------------ *
     D SVPVLO_chkCajaTerminal...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peWdis                      10    const
     D   peIvr2                       6  0 const options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPVLO_chkUsuario : Valida Usuario                           *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peUser   ( input  )   Nombre de Usuario                  *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D SVPVLO_chkUsuario...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peUser                      10    const

     * ------------------------------------------------------------ *
     * SVPVLO_chkTipoMovPorUsuario: Valida si Tipo de movimiento    *
     *                              corresponde a un Usuario        *
     *                                                              *
     *     peEmpr   ( input  )   Empresa                            *
     *     peSucu   ( input  )   Sucursal                           *
     *     peIvtm   ( input  )   Tipo de Movimiento                 *
     *     peUser   ( input  )   Nombre de Usuario                  *
     *                                                              *
     * Retorna: *on = Encontró / *off = No Encontró                 *
     * ------------------------------------------------------------ *
     D SVPVLO_chkTipoMovPorUsuario...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peIvtm                       2  0 const
     D   peUser                      10    const

     * ------------------------------------------------------------ *
     * SVPVLO_getNumeroOperacion: Retorna número de operación       *
     *                                                              *
     * Retorna: Número de Operación                                 *
     * ------------------------------------------------------------ *
     D SVPVLO_getNumeroOperacion...
     D                 pr             7  0

     * ------------------------------------------------------------ *
     * SVPVLO_getNumeroIngreso: Retorna número de ingreso           *
     *                                                              *
     * Retorna: Número de Ingreso                                   *
     * ------------------------------------------------------------ *
     D SVPVLO_getNumeroIngreso...
     D                 pr             6  0

     * ------------------------------------------------------------ *
     * SVPVLO_getFechaDeIngreso: Retorna Fecha de ingreso           *
     *                                                              *
     * Retorna: Fecha de Ingreso                                    *
     * ------------------------------------------------------------ *
     D SVPVLO_getFechaDeIngreso...
     D                 pr             8  0
     D   peForm                       3    const

