      /if defined(SVPLVD_H)
      /eof
      /endif
      /define SVPLVD_H

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/jdbc_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpviv_h.rpgle'
      /copy './qcpybooks/hssf_h.rpgle'

      * ------------------------------------------------------------ *
      * Registro de configuración                                    *
      * ------------------------------------------------------------ *
     D SVPLVD_Conf_t   ds                  qualified based(template)
     D  fini                          8  0
     D  secu                          3  0
     D  driv                         50a
     D  durl                         50a
     D  bddu                         50a
     D  pass                         50a
     D  bddn                         50a
     D  tabx                         50a
     D  tabc                         50a
     D  tabp                         50a
     D  tabo                         50a
     D  tabd                         50a
     D  taba                         50a
     D  tabr                         50a
     D  tabv                         50a
     D  tabh                         50a
     D  tabt                         50a

      * ------------------------------------------------------------ *
      * SVPLVD_setCliente: Inserta cliente en Base                   *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     D SVPLVD_setCliente...
     D                 pr            10i 0
     D   peAsen                       7  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPLVD_setPolizas: Inserta Polizas en Base                   *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     D SVPLVD_setPolizas...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

      * ------------------------------------------------------------ *
      * SVPLVD_setOperacionEmision: Inserta Oper. Emision            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento de SuperPóliza             *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     D SVPLVD_setOperacionEmision...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ------------------------------------------------------------ *
      * SVPLVD_setOperacionCobranza: Inserta Oper. Cobranza          *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   nro de poliza                         *
      *     peFope   (input)   Fecha asiento                         *
      *     peNrcu   (input)   Nro de Cuota                          *
      *     peNrsc   (input)   Sub Nro de Cuota                      *
      *     peImau   (input)   Monto de la cuota                     *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     D SVPLVD_setOperacionCobranza...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFope                       8  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   peImau                      15  2 const

      * ------------------------------------------------------------ *
      * SVPLVD_setOperacionSiniestroPago: Inserta Pago de Siniestro  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Nro de Siniestro                      *
      *     peNops   (input)   Nro de Operacion                      *
      *     peFmov   (input)   Fecha de movimiento                   *
      *     peImau   (input)   Importe Pago                          *
      *     peTben   (input)   Tipo de Beneficiario                  *
      *     peTmov   (input)   Tipo de Movimiento                    *
      *     peNrdf   (input)   Nro de Persona                        *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     D SVPLVD_setOperacionSiniestroPago...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peFmov                       8  0 const
     D   peImau                      15  2 const
     D   peTben                       1    const
     D   peTmov                       1    const
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPLVD_setOperacionSiniestroEstimacion:  Inserta Estimacion  *
      *                                          de siniestro        *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     perama   (input)   Articulo                              *
      *     pesini   (input)   Nro de siniestro                      *
      *     penops   (input)   Nro de operacion Siniestro            *
      *     pepoco   (input)   Nro de componente                     *
      *     pepaco   (input)   Código de Parentesco                  *
      *     penrdf   (input)   Nro de Persona                        *
      *     pesebe   (input)   Sec. Benef. Siniestros                *
      *     periec   (input)   Riesgo                                *
      *     pexcob   (input)   Codigo de Cobertura                   *
      *     pefmoa   (input)   Año del movimiento                    *
      *     pefmom   (input)   Mes del movimiento                    *
      *     pefmod   (input)   Dia del movimiento                    *
      *     pepsec   (input)   Nro de Secuencia                      *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     D SVPLVD_setOperacionSiniestroEstimacion...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   perama                       2  0 const
     D   pesini                       7  0 const
     D   penops                       7  0 const
     D   pepoco                       6  0 const
     D   pepaco                       3  0 const
     D   penrdf                       7  0 const
     D   pesebe                       6  0 const
     D   periec                       3    const
     D   pexcob                       3  0 const
     D   pefmoa                       4  0 const
     D   pefmom                       2  0 const
     D   pefmod                       2  0 const
     D   pepsec                       2  0 const

      * ------------------------------------------------------------ *
      * SVPLVD_setOperacion: Inserta Operacion                       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   Super Poliza                          *
      *     peSspo   (input)   Suplemento                            *
      *     peRama   (input)   Rama                                  *
      *     pePoli   (input)   Nro de Poliza                         *
      *     peTipo   (input)   Tipo de Operacion                     *
      *     peFope   (input)   Fecha de Operacion                    *
      *     peNrcu   (input)   Numero de cuota                       *
      *     peNrsc   (input)   Numero de Sub - Cuota                 *
      *     peSini   (input)   Nro de Siniestro                      *
      *     peImau   (input)   Importe Pago                          *
      *     peTben   (input)   Tipo de Beneficiario                  *
      *     peNrdf   (input)   Nro de Persona                        *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     D SVPLVD_setOperacion...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       8  0 const
     D   pePoli                       7  0 const
     D   peTipo                      15    const
     D   peFope                       8  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   peSini                       7  0 const
     D   peImau                      15  2 const
     D   peTben                       1    const
     D   peNrdf                       7  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPLVD_setSiniestroDenuncia:  Inserta Denuncia de Siniestro  *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Nro de Siniestro                      *
      *     peFden   (input)   Fecha de denunca                      *
      *     peFsin   (input)   Fecha de sinietro                     *
      *     pePoli   (input)   Nro de Poliza                         *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *

     D SVPLVD_setSiniestroDenuncia...
     D                 pr            10i 0
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peFden                       8  0 const
     D   peFsin                       8  0 const
     D   pePoli                       7  0 const

      * ------------------------------------------------------------ *
      * SVPLVD_delCliente: Elimina cliente en Base                   *
      *                                                              *
      *     peAsen   (input)   Asegurado                             *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas eliminadas              *
      * ------------------------------------------------------------ *

     D SVPLVD_delCliente...
     D                 pr            10i 0
     D   peAsen                       7  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPLVD_getLlamada: Retorna si se ejecutó desde PAX340%       *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPLVD_getLlamada...
     D                 pr              n

      * ------------------------------------------------------------ *
      * SVPLVD_setEstadoInicio: Graba Estado Inicio - Control        *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPLVD_setEstadoInicio...
     D                 pr              n

      * ------------------------------------------------------------ *
      * SVPLVD_setEstadoFin: Graba Estado Fin - Control              *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPLVD_setEstadoFin...
     D                 pr              n

      * ------------------------------------------------------------ *
      * SVPLVD_getEstadoControl: Retorna ultima Estado Control       *
      *                                                              *
      *     peEsta   (input)   Estado                                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPLVD_getEstadoControl...
     D                 pr             1

      * ------------------------------------------------------------ *
      * SVPLVD_updEstadoControl: Actualiza Estado Control            *
      *                                                              *
      *        peEstado (input)  Estado                              *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPLVD_updEstadoControl...
     D                 pr              n
     D   peEsta                       1    const

      * ------------------------------------------------------------ *
      * SVPLVD_setEstadControl: Graba Estado Control                 *
      *                                                              *
      *        peEstado (input)  Estado                              *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SVPLVD_setEstadoControl...
     D                 pr              n
     D   peEsta                       1    const

      * ------------------------------------------------------------ *
      * SVPLVD_setBienesAseguradosAuto: Insertar BS Autos            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     D SVPLVD_setBienesAseguradosAuto...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ------------------------------------------------------------ *
      * SVPLVD_setBienesAseguradosRV: Insertar BS RV                 *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     D SVPLVD_setBienesAseguradosRV...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ------------------------------------------------------------ *
      * SVPLVD_setBienesAseguradosVida: Insertar BS Vida             *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peSspo   (input)   Suplemento                            *
      *                                                              *
      * Retorna: 0 / -1 / cantidad de lineas insertadas              *
      * ------------------------------------------------------------ *
     D SVPLVD_setBienesAseguradosVida...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const

      * ------------------------------------------------------------ *
      * SPLVD_chkNominaExterna: Retorna si tiene Nomina              *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArcd   (input)   Articulo                              *
      *     peSpol   (input)   SuperPoliza                           *
      *     peNomi   (output)  Nomina                                *
      *                                                              *
      * Retorna: *on / *off                                          *
      * ------------------------------------------------------------ *
     D SPLVD_chkNominaExterna...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peNomi                       7  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPLVD_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPLVD_inz      pr

      * ------------------------------------------------------------ *
      * SVPLVD_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPLVD_End      pr

      * ------------------------------------------------------------ *
      * SVPLVD_getConfiguracion(): Obtiene configuración de conexión *
      *                                                              *
      *     peConf (output)   Registro de Configuración a hoy        *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPLVD_getConfiguracion...
     D                 pr            10i 0
     D   peConf                            likeds(SVPLVD_Conf_t)

      * ------------------------------------------------------------ *
      * SVPLVD_getConfiguracionPorFecha(): Obtiene configuración a   *
      *                       una fecha determinada                  *
      *                                                              *
      *     peFech (input)    Fecha a la cual retornar configuración *
      *     peConf (output)   Registro de Configuración              *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPLVD_getConfiguracionPorFecha...
     D                 pr            10i 0
     D   peFech                       8  0 const
     D   peConf                            likeds(SVPLVD_Conf_t)

      * ------------------------------------------------------------ *
      * SVPLVD_getConfiguracionExacta():   Obtiene configuración a   *
      *                       una fecha determinada.                 *
      *                       Secuencia exacta.                      *
      *                                                              *
      *     peFech (input)    Fecha a la cual retornar configuración *
      *     peSecu (input)    Secuencia                              *
      *     peConf (output)   Registro de Configuración              *
      *                                                              *
      * Retorna: 0 si OK, -1 si error                                *
      * ------------------------------------------------------------ *
     D SVPLVD_getConfiguracionExacta...
     D                 pr            10i 0
     D   peFech                       8  0 const
     D   peSecu                       3  0 const
     D   peConf                            likeds(SVPLVD_Conf_t)

      * ------------------------------------------------------------ *
      * SVPLVD_Connect: Conexión a base SQL                          *
      *                                                              *
      *     peConf   (input)   Configuracion                         *
      *     peConn   (output)  Objeto Conexion                       *
      *                                                              *
      * Return 0 / -1                                                *
      * ------------------------------------------------------------ *
     D SVPLVD_Connect...
     D                 pr             1  0
     D peConn                              like(Connection)
     D peConf                              likeds(SVPLVD_Conf_t)
      * ------------------------------------------------------------ *
      * SVPLVD_Close: Cierra conexion                                *
      *                                                              *
      *     peConn   (input)  Objeto Conexion                        *
      *                                                              *
      * Return *on / *off                                            *
      * ------------------------------------------------------------ *
     D SVPLVD_Close...
     D                 pr              n
     D peConn                              like(Connection)

      * ------------------------------------------------------------ *
      * SVPLVD_cleanUp(): Elimina mensajes controlados del Joblog.   *
      *                                                              *
      *     peMsid (input)  ID de mensaje a eliminar.                *
      *                                                              *
      * retorna: *void                                               *
      * ------------------------------------------------------------ *
     D SVPLVD_cleanUp  pr             1N
     D  peMsid                        7a   const

      * ------------------------------------------------------------ *
      * SVPLVD_setPagosTesoreria                                     *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   sucursal                              *
      *     peArtc   (input)   Codigo Area Tecnica                   *
      *     pePacp   (input)   Nro. Comprobante Pago                 *
      *                                                              *
      * Retorna: 0 / -1                                              *
      * ------------------------------------------------------------ *
     D SVPLVD_setPagosTesoreria...
     D                 pr            10i 0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArtc                       2  0 const
     D   pePacp                       6  0 const

