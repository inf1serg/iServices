      /if defined(SVPREN_H)
      /eof
      /endif
      /define SVPREN_H

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/svpvreno_h.rpgle'
      /copy './qcpybooks/svpepv_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/czwutl_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/svpavr_h.rpgle'

      * Componente inexistente...
     D SVPREN_CMPNE    c                   const(0001)
      * Suma Asegurada en Cero...
     D SVPREN_SUMNE    c                   const(0002)
      * Sin Datos en Tabla RC/AIR...
     D SVPREN_NOAIR    c                   const(0003)
      * SuperPoliza Inhibida...
     D SVPREN_SPINH    c                   const(0004)
      * Poliza Con Cuotas Pendientes...
     D SVPREN_PCUOP    c                   const(0005)
      * Asegurado con IVA Invalido...
     D SVPREN_ASIVA    c                   const(0006)
      * Articulo Inxistente...
     D SVPREN_ARTNE    c                   const(0006)
      * Articulo No Web...
     D SVPREN_ARTNW    c                   const(0007)
      * Articulo No Renovacion...
     D SVPREN_ARNOR    c                   const(0008)
      * SuperPoliza Renovada...
     D SVPREN_SPYRE    c                   const(0009)
      * SuperPoliza Suspendida...
     D SVPREN_SPSUS    c                   const(0010)
      * SuperPoliza Movimiento Pendiente Speedway...
     D SVPREN_SPPSP    c                   const(0011)
      * Productor Bloqueado para Renovaciones...
     D SVPREN_PRBLO    c                   const(0012)
      * Productor Bloqueado para Renovaciones Automaticas...
     D SVPREN_PRNOR    c                   const(0013)
      * Productor Cba / Mza ...
     D SVPREN_PCBMZ    c                   const(0014)
      * Extra Prima Variable Fuera de los Limites...
     D SVPREN_EPVFL    c                   const(0015)
      * Relacion Rama/Capitulo/Variante Inexistente...
     D SVPREN_RCVIN    c                   const(0016)
      * Vehiculo Plan Promo...
     D SVPREN_PLANP    c                   const(0017)
      * Poliza con Siniestros con Causa...
     D SVPREN_POLSI    c                   const(0018)
      * AIR sin Tarifa...
     D SVPREN_VAIRS    c                   const(0019)
      * Vehiculo con Patente Duplicada...
     D SVPREN_VANDU    c                   const(0020)
      * Asegurado Cba / Mza ...
     D SVPREN_ACBMZ    c                   const(0021)
      * Franquicia Manual...
     D SVPREN_FRAMA    c                   const(0022)
      * SuperPoliza Inexistente...
     D SVPREN_SPINE    c                   const(0023)
      * Suma Asegurada Mayor a la Permitida...
     D SVPREN_SUMPE    c                   const(0024)
      * Patente no Habilitada parta WEB...
     D SVPREN_PTNWB    c                   const(0025)
      * Formato de Patente invalida...
     D SVPREN_FMTPA    c                   const(0026)
      * Articulo no acepta Scoring...
     D SVPREN_VARCD    c                   const(0027)
      * No existen preguntas para el cuestionario...
     D SVPREN_VPREG    c                   const(0028)
      * Forma de pago de la poliza no habilitada para renovar por WEB
     D SVPREN_FPNWB    c                   const(0029)
      * Plan de pagos de la poliza no habilitada para renovar por WEB
     D SVPREN_PLNWB    c                   const(0030)
      * IVA no valido para la Web...
     D SVPREN_IVANW    c                   const(0031)
      * Forma de Pago no Valida Para Web...
     D SVPREN_FDPNW    c                   const(0032)

     D ds603_t         ds                  qualified template
     D  t@3arcd                       6  0
     D  t@3ldff                       3  0
     D  t@3prsa                       5  2
     D  t@3ccuo                       2  0
     D  t@3sdxp                       7  2
     D  t@3mar2                       1a
     D  t@3mar3                       1a
     D  t@3mar4                       1a
     D  t@3mar5                       1a
     D  t@3mar6                       1a
     D  t@3mar7                       1a
     D  t@3mar8                       1a
     D  t@3user                      10a
     D  t@3date                       6  0
     D  t@3time                       6  0
     D  t@3darf                       3  0
     D  t@3getz                       1a
     D  t@3pgnc                       2  0
     D  t@3pacc                       2  0

     D dsErro_t        ds                  qualified template
     D  errN                         10i 0
     D  errM                         80

     D dsDescuentos_t  ds                  qualified template
     D  t4empr                        1a
     D  t4sucu                        2a
     D  t4arcd                        6  0
     D  t4spol                        9  0
     D  t4sspo                        3  0
     D  t4rama                        2  0
     D  t4arse                        2  0
     D  t4oper                        7  0
     D  t4suop                        3  0
     D  t4poco                        4  0
     D  t4ccbp                        3  0
     D  t4cert                        9  0
     D  t4poli                        7  0
     D  t4prim                       15  2
     D  t4pcbp                        5  2
     D  t4pori                        5  2
     D  t4mcbp                        1a

      * ------------------------------------------------------------ *
      * SVPREN_chkArticulo(): Validaciones Sobre Articulo.           *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkArticulo...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkSuperPoliza(): Validaciones Sobre SuperPoliza      *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkSuperPoliza...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkProductor(): Validaciones Sobre Productor          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkProductor...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkAsegurado(): Validaciones Sobre Asegurado          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkAsegurado...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkPolizas(): Valida Polizas para Renovacion          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkPolizas...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SVPREN_chkPolizaAuto(): Validaciones sobre Poliza de Autos   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkPolizaAuto...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkPolizaHogar(): Validaciones sobre Poliza de Hogar  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkPolizaHogar...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkComponentes(): Valida Componentes                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkComponentes...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SVPREN_chkComponenteAuto(): Validaciones sobre Poco de Autos *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkComponenteAuto...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkComponenteHogar():Validaciones sobre Poco de Hogar *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkComponenteHogar...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkRenovacion(): Validacion Renovacion Automatica     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkRenovacion...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SVPREN_chkGeneral(): Validaciones Generales                  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkGeneral...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_getConfiguracion(): Configuracion de Articulo         *
      *                                                              *
      *     peArcd   (input)   Articulo                              *
      *     peConf   (output)  Configuracion                         *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_getConfiguracion...
     D                 pr              n
     D   peArcd                       6  0 const
     D   peConf                            likeDs(ds603_t)

      * ------------------------------------------------------------ *
      * SVPREN_getComponente(): Retorna Numero de Componente         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Numero de Componente                                *
      * ------------------------------------------------------------ *
     D SVPREN_getComponente...
     D                 pr             4  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SVPREN_getSumaAseguradaVehiculo(): Retorna Suma Asegurada    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Suma Asegurada de Vehiculo                          *
      * ------------------------------------------------------------ *
     D SVPREN_getSumaAseguradaVehiculo...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SVPREN_getImporteGnc(): Retorna Valor de Gnc                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Valor de GNC                                        *
      * ------------------------------------------------------------ *
     D SVPREN_getImporteGnc...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SVPREN_getClienteIntegral(): Retorna si es Cliente Integral  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Retorna si es Cliente Integral                      *
      * ------------------------------------------------------------ *
     D SVPREN_getClienteIntegral...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SVPREN_getTarifa(): Retorna Tarifa                           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Retorna Codigo de Tarifa                            *
      * ------------------------------------------------------------ *
     D SVPREN_getTarifa...
     D                 pr             5  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      * ------------------------------------------------------------ *
      * SVPREN_getZona(): Retorna Zona                               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Arse                                  *
      *     pePoco   (input)   Componente                            *
      *                                                              *
      * Retorna: Retorna Codigo de Zona                              *
      * ------------------------------------------------------------ *
     D SVPREN_getZona...
     D                 pr             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      *--------------------------------------------------------------*
      * SVPREN_getBuenResultado(): Retorna  Buen Resultado           *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cantidad de Polizas                   *
      *     pePoco   (input)   Nro de componentes                    *
      *                                                              *
      * Retorna: Buen Resultado                                      *
      * ------------------------------------------------------------ *
     D SVPREN_getBuenResultado...
     D                 pr             1  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const

      *--------------------------------------------------------------*
      * SVPREN_getDescuentosComponente(): Retorna Descuentos         *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cantidad de Polizas                   *
      *     pePoco   (input)   Nro de componentes                    *
      *     peDesc   (input)   Ds de Descuentos                      *
      *     peDescC  (input)   Cantidad                              *
      *                                                              *
      * Retorna: Retorna Descuentos de Componente                    *
      * ------------------------------------------------------------ *
     D SVPREN_getDescuentosComponente...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peDesc                            likeds(dsDescuentos_t) dim(20)
     D   peDescC                     10i 0

      *--------------------------------------------------------------*
      * SVPREN_getAccesoriosComponente() Retorna Accesorios          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peRama   (input)   Rama                                  *
      *     peArse   (input)   Cantidad de Polizas                   *
      *     pePoco   (input)   Nro de componentes                    *
      *     peAcce   (input)   Ds de Accesorios                      *
      *     peAcceC  (input)   Cantidad                              *
      *                                                              *
      * Retorna: Retorna Accesorios de Componente                    *
      * ------------------------------------------------------------ *
     D SVPREN_getAccesoriosComponente...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peAcce                            likeds(AccVeh_t) dim(100)
     D   peAcceC                     10i 0

      * ------------------------------------------------------------ *
      * SVPREN_chkCobMayorVeh(): Verifica si cobertura ingresada es  *
      *                          Mayor a la que se va a renovar.-    *
      *                                                              *
      *          peEmpr   ( input  )  Parámetros Base                *
      *          peSucu   ( input  )  Número de Cotizacion           *
      *          peArcd   ( input  )  Articulo                       *
      *          peArse   ( input  )  Cant. de Polizas x Rama        *
      *          peRama   ( input  )  Rama                           *
      *          peCobA   ( input  )  Cobertura Anterior             *
      *          peCobS   ( input  )  Cpbertura Seleccionada.        *
      *                                                              *
      * Retorna *on = Es Mayor / *off = No es Mayor                  *
      * ------------------------------------------------------------ *
     D SVPREN_chkCobMayorVeh...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peArse                       2  0 const
     D   peRama                       2  0 const
     D   peCobA                       2    const
     D   peCobS                       2    const

      * ------------------------------------------------------------ *
      * SVPREN_getListaCobMayorVeh(): Retorna Lista Coberturas       *
      *                               Mayores de un Vehiculo         *
      *                                                              *
      *          peEmpr   ( input  )  Parámetros Base                *
      *          peSucu   ( input  )  Número de Cotizacion           *
      *          peArcd   ( input  )  Articulo                       *
      *          peArse   ( input  )  Cant. de Polizas x Rama        *
      *          peRama   ( input  )  Rama                           *
      *          peCobe   ( input  )  Coberturas                     *
      *          peLcob   ( output )  Lista de Coberturas Mayores    *
      *          peLcobC  ( output )  Cantidad de Coberturas Mayores *
      *                                                              *
      * Retorna *on = Contiene / *off = No contiene                  *
      * ------------------------------------------------------------ *
     D SVPREN_getListaCobMayorVeh...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peArse                       2  0 const
     D   peRama                       2  0 const
     D   peCobe                       2    const
     D   peLcob                       2    dim( 20 )
     D   peLcobC                     10i 0

      * ------------------------------------------------------------ *
      * SVPREN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPREN_inz      pr

      * ------------------------------------------------------------ *
      * SVPREN_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPREN_end      pr

      * ------------------------------------------------------------ *
      * SVPREN_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPREN_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPREN_chkMarcaTecCobRen(): Chequea que las marcas de Técni- *
      *                             ca y Cobranzas estan habilitadas *
      *                             para renovación                  *
      *                                                              *
      *          peArcd   ( input  )  Articulo                       *
      *          peSpol   ( input  )  Superpoliza                    *
      *          peRama   ( input  )  Rama                           *
      *          peArse   ( input  )  Cant. de Ramas Por Polizas     *
      *          peOper   ( input  )  Nro. de Operación              *
      *                                                              *
      * Retorna *on = Habilitado / *off = No Habilitado              *
      * ------------------------------------------------------------ *
     D SVPREN_chkMarcaTecCobRen...
     D                 pr             1a
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 options(*nopass:*omit)
     D   peOper                       7  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPREN_aumentoSumaAsegurada(): Retorna importe de aumento de *
      *                                suma asegurada por cobertura. *
      *                                                              *
      *          peRama   ( input  )  Rama                           *
      *          peXpro   ( input  )  Código de Producto             *
      *          peRiec   ( input  )  Código de Riesgo               *
      *          peCobc   ( input  )  Código de Cobertura            *
      *          peMone   ( input  )  Código de Moneda de Emisión    *
      *          peSuas   ( input  )  Suma Asegurada por Cobertura   *
      *                                                              *
      * Retorna Importe de aumento de suma asegurada                 *
      * ------------------------------------------------------------ *
     D SVPREN_aumentoSumaAsegurada...
     D                 pr            15  2
     D   peRama                       2  0 const
     D   peXpro                       3  0 const
     D   peRiec                       3    const
     D   peCobc                       3  0 const
     D   peMone                       2    const
     D   peSuas                      15  2 const

      * ------------------------------------------------------------ *
      * SVPREN_getScoring(): Retorna Datos del Scoring.              *
      *                                                              *
      *     peEmpr  ( input  ) Empresa                               *
      *     peSucu  ( input  ) Sucursal                              *
      *     peArcd  ( input  ) Articulo                              *
      *     peSpol  ( input  ) SuperPoliza                           *
      *     peRama  ( input  ) Rama                                  *
      *     peArse  ( input  ) Arse                                  *
      *     pePoco  ( input  ) Componente                            *
      *     peSspo  ( input  ) Suplemento de SuperPoliza  (Opcional) *
      *     peSuop  ( input  ) Suplemento de la Operación (Opcional) *
      *     peOper  ( input  ) Operación                  (Opcional) *
      *     peTaaj  ( output ) Código de Cuestionario                *
      *     peScor  ( output ) Estructura de Scoring                 *
      *     peScorC ( output ) Cant. de Scoring                      *
      *                                                              *
      * Retorna: *on = Si hay registro / *off = no hay registro      *
      * ------------------------------------------------------------ *
     D SVPREN_getScoring...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peSspo                       3  0 options(*nopass:*omit) const
     D   peSuop                       3  0 options(*nopass:*omit) const
     D   peOper                       7  0 options(*nopass:*omit) const
     D   peTaaj                       2  0 options(*nopass:*omit)
     D   peScor                            likeds (preguntas_t) dim(200)
     D                                     options(*nopass:*omit)
     D   peScorC                     10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPREN_getPlanDePago(): Retorna Plan de Pago                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peTipo   (input)   Tipo de Solicitud                     *
      *     peSspo   (input)   Numero de Suplemento SuperPoliza      *
      *                                                              *
      * Retorna: Plan de Pago                                        *
      * ------------------------------------------------------------ *
     D SVPREN_getPlanDePago...
     D                 pr             3  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peTipo                       1    const
     D   peSspo                       3  0 options(*Omit:*NoPass)

      * ------------------------------------------------------------ *
      * SVPREN_chkGeneralWeb(): Validaciones Generales               *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peErro   (output)  Vector de Errores                     *
      *     peErroC  (output)  Cant. Vector de Errores               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SVPREN_chkGeneralWeb...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peErro                            likeDs(dsErro_t) dim(20)
     D                                     options(*Omit:*NoPass)
     D   peErroC                     10i 0 options(*Omit:*NoPass)


