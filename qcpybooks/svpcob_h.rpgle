      /if defined(SVPCOB_H)
      /eof
      /endif
      /define SVPCOB_H

      * Cobertura no asociada...
     D SVPCOB_COBNA    c                   const(0001)
     D SVPCOB_COBEX    c                   const(0002)
     D SVPCOB_COBBA    c                   const(0003)
      * Limite de cobertura inexistente...
     D SVPCOB_COBSL    c                   const(0004)

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D ListCobR        ds                  qualified based(template)
     D   cob1                         3  0
     D   cob2                         3  0
     D   cob3                         3  0

     D Cobprima        ds                  qualified based(template)
     D  riec                          3
     D  xcob                          3  0
     D  sac1                         13  2
     D  xpri                          9  6
     D  prim                         13  2

     D ListCDep        ds                  qualified based(template)
     D   xcob1                        3  0
     D   xcob2                        3  0
     D   saco                        15  2
     D   prsa                         5  2

     D ListCobe        ds                  qualified based(template)
     D   xcob                         3  0
     D   saco                        15  2

     D dsSet1031_t     ds                  qualified template
     D  t@rama                        2  0
     D  t@xpro                        3  0
     D  t@riec                        3a
     D  t@cobc                        3  0
     D  t@mone                        2a
     D  t@sacox                      15  2
     D  t@prsax                       5  2
     D  t@riecx                       3a
     D  t@cobcx                       3  0
     D  t@mx01x                       1a
     D  t@mx02x                       1a
     D  t@mx03x                       1a
     D  t@mx04x                       1a
     D  t@mx05x                       1a
     D  t@user                       10a
     D  t@time                        6  0
     D  t@date                        6  0
     D  t@lmin                       15  2

      * ------------------------------------------------------------ *
      * SVPCOB_GetListCobExcluyentes : Devuelve lista de Coberturas  *
      *                                Excluyentes.                  *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peCobc   (input)  Cobertura                              *
      *     peMone   (input)  Moneda                                 *
      *     peLCob   (output) Lista de Coberturas Excluyentes        *
      *     peLCobc  (output) Cant. Lista de Coberturas Excluyentes  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_GetListCobExcluyentes...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peLcob                       3  0 dim(20)
     D   peLcobC                     10i 0

      * ------------------------------------------------------------ *
      * SVPCOB_ValListCobExcluyentes : Valida Si coberturas son      *
      *                                Excluyentes entre Si.         *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peCobc   (input)  Cobertura                              *
      *     peMone   (input)  Moneda                                 *
      *     peLCob   (input) Lista de Coberturas Excluyentes         *
      *     peLCobc  (input) Cant. Lista de Coberturas Excluyentes   *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_ValListCobExcluyentes...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peMone                       2    const
     D   peLcob                       3  0 dim(20)
     D   peLcobC                     10i 0
      * ------------------------------------------------------------ *
      * SVPCOB_GetListCobReglas : Devuelve lista de Reglas de        *
      *                                Coberturas.                   *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peCobc   (input)  Cobertura                              *
      *     peMone   (input)  Moneda                                 *
      *     peLCobR  (output) Lista de Reglas de Coberturas          *
      *     peLCobc  (output) Cant. Lista de Reglas de Coberturas    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_GetListCobReglas...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peLcobR                           likeds(ListCobR) dim(20)
     D   peLcobC                     10i 0

      * ------------------------------------------------------------ *
      * SVPCOB_ValListCobReglas : Valida coberturas en Lista de      *
      *                                Reglas.                       *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peMone   (input)  Moneda                                 *
      *     peLCob   (output) Lista de Coberturas                    *
      *     peLCobc  (output) Cant. Lista de Reglas de Coberturas    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_ValListCobReglas...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peMone                       2    const
     D   peLcob                       3  0 dim(20)
     D   peLcobC                     10i 0
      * ------------------------------------------------------------ *
      * SVPCOB_ValReglaCob :    Valida Regla de Cobertura en Lista   *
      *                                de Cob.                       *
      *     peCobc   (input)  Cobertura                              *
      *     peLCob   (input)  Lista de Coberturas                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_ValReglaCob...
     D                 pr              n
     D   prCobc                       3  0 const
     D   peLcob                       3  0 dim(20)
      * ------------------------------------------------------------ *
      * SVPCOB_ValCoberturasBasicas: Valida si la lista contiene la  *
      *                                cobertura Básica.             *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peMone   (input)  Moneda                                 *
      *     peLCob   (output) Lista de Coberturas                    *
      *     peLCobc  (output) Cant. Lista de Reglas de Coberturas    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_ValCoberturasBasicas...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peMone                       2    const
     D   peLcob                       3  0 dim(20)
      * ------------------------------------------------------------ *
      * SVPCOB_getListaCoberturasCot:Retorna coberturas de la cotiza-*
      *                              ción.                           *
      *     peBase   (input)  Rama                                   *
      *     peNctw   (input)  Nro.de Cotización                      *
      *     peRama   (input)  Riesgo                                 *
      *     peArse   (input)  Artículo                               *
      *     pePoco   (input)  Nro.de Componente                      *
      *     peCobe   (output) Lista de Coberturas                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_getListaCoberturasCot...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   pePoco                       4  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
      * ------------------------------------------------------------ *
      * SVPCOB_getListaCoberturasSpol:Retorna coberturas de la Super *
      *                               poliza                         *
      *     peBase   (input)  Rama                                   *
      *     peNctw   (input)  Nro.de Cotización                      *
      *     peSpol   (input)  Riesgo                                 *
      *     pePoco   (input)  Artículo                               *
      *     peCobe   (input)  Nro.de Componente                      *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_getListaCoberturasSpol...
     D                 pr              n
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   pePoco                       4  0   const
     D   peCobe                            likeds(Cobprima)  dim(20)
      * ------------------------------------------------------------ *
      * SVPCOB_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPCOB_inz      pr

      * ------------------------------------------------------------ *
      * SVPCOB_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPCOB_End      pr
      * ------------------------------------------------------------ *
      * SVPCOB_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPCOB_error    pr          3000a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPCOB_GetListCobDepend : Devuelve lista de dependencias de  *
      *                           la cobertura.                      *
      *                                                              *
      *     peRama   (input)  Rama                                   *
      *     peXpro   (input)  Plan                                   *
      *     peRiec   (input)  Riesgo                                 *
      *     peCobc   (input)  Cobertura                              *
      *     peMone   (input)  Moneda                                 *
      *     peLcobD  (output) Lista de coberturas dependientes       *
      *     peLcobDC (output) Cantidad elementos de la lista         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPCOB_GetListCobDepend...
     D                 pr              n
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peLcobD                           likeds(ListCDep) dim(20)
     D   peLcobDC                    10i 0

      * ------------------------------------------------------------ *
      * SVPCOB_getCoberturasAutos : Retorna estructura de Coberturas *
      *                             de Autos.                        *
      *     peLCob   (output) Lista de Coberturas                    *
      *     peLCobc  (output) Cant. de Coberturas                    *
      *                                                              *
      * Retorna: *on = Tiene / *off = No tiene                       *
      * ------------------------------------------------------------ *
     D SVPCOB_getCoberturasAutos...
     D                 pr              n
     D   peLcob                            likeds( dsSet225_t ) dim( 9999 )
     D   peLcobC                     10i 0

      * ------------------------------------------------------------ *
      * SVPCOB_getCoberturaEquiva : Retorna Cobertura Equivalente    *
      *                             SSN.                             *
      *     peCobl  ( input ) Código de Cobertura.                   *
      *                                                              *
      * Retorna: Coss si exíste / Blanco si no exíste                *
      * ------------------------------------------------------------ *
     D SVPCOB_getCoberturaEquiva...
     D                 pr             2
     D   peCobl                       2    Const

      * ------------------------------------------------------------ *
      * SVPCOB_getLimiteCobertura: Retorna limite de cobertura de RV *
      *                                                              *
      *     peRama  ( input ) Rama.                                  *
      *     peXpro  ( input ) Codigo de producto.                    *
      *     peMone  ( input ) Codigo de moneda.                      *
      *     peRiec  ( input ) Codigo de riesgo.                      *
      *     peXcob  ( input ) Codigo de cobertura.                   *
      *     peR1031 ( input ) Registro SET1031.                      *
      *                                                              *
      * Retorna: *ON registro encontrado/*OFF registro no encontrado *
      * ------------------------------------------------------------ *
     D SVPCOB_getLimiteCobertura...
     D                 pr              n
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peMone                        2a   const
     D  peRiec                        3a   const
     D  peXcob                        3  0 const
     D  peR1031                            likeds(dsSet1031_t)

      * ------------------------------------------------------------ *
      * SVPCOB_getLimiteCoberturas:Retorna limite de coberturas de RV*
      *                                                              *
      *     peRama  ( input ) Rama.                                  *
      *     peXpro  ( input ) Codigo de producto.                    *
      *     peMone  ( input ) Codigo de moneda.                      *
      *     peRiec  ( input ) Codigo de riesgo.                      *
      *     peXcob  ( input ) Codigo de cobertura.                   *
      *     peR1031 ( input ) Registro SET1031.                      *
      *     peR1031C( input ) Cantidad de registros en peR1031.      *
      *                                                              *
      * Retorna: *ON registro encontrado/*OFF registro no encontrado *
      * ------------------------------------------------------------ *
     D SVPCOB_getLimiteCoberturas...
     D                 pr              n
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peMone                        2a   const
     D  peR1031                            likeds(dsSet1031_t) dim(999)
     D  peR1031C                     10i 0

      * ------------------------------------------------------------ *
      * SVPCOB_topearCoberturas: Fuerza suma asegurada maxima a las  *
      *                          coberturas.                         *
      *                                                              *
      *     peRama  ( input ) Rama.                                  *
      *     peXpro  ( input ) Codigo de producto.                    *
      *     peMone  ( input ) Codigo de moneda.                      *
      *     peCobe  ( input/output) Array con coberturas.            *
      *     peArcd  ( input ) Articulo (opcional).                   *
      *                                                              *
      * Retorna: *ON topea alguna/*off no topeo ninguna.             *
      * ------------------------------------------------------------ *
     D SVPCOB_topearCoberturas...
     D                 pr              n
     D  peRama                        2  0 const
     D  peXpro                        3  0 const
     D  peMone                        2a   const
     D  peCobe                             likeds(cobPrima) dim(20)
     D  peArcd                        6  0 const options(*omit:*nopass)

