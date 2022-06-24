      /if defined(SPVTCR_H)
      /eof
      /endif
      /define SPVTCR_H

      /copy './qcpybooks/svpdaf_h.rpgle'

      * Codigo de Empresa Emisora Inexistente...
     D SPVTCR_EMINE    c                   const(0001)
      * Codigo de Empresa Emisora Bloqueado...
     D SPVTCR_EMBLO    c                   const(0002)
      * Numero de Tarjeta de Credito en Cero...
     D SPVTCR_NROCE    c                   const(0003)
      * Primer Numero de Tarjeta de Credito en Cero...
     D SPVTCR_PNROC    c                   const(0004)
      * No Existe Tarjeta de Credito para Asegurado...
     D SPVTCR_TCIAS    c                   const(0005)
      * Tarjeta de Credito Bloqueada para Asegurado...
     D SPVTCR_TCBAS    c                   const(0006)
      * Ya Existe Tarjeta de Credito para Asegurado...
     D SPVTCR_TCEAS    c                   const(0007)
      * Fecha de Inicio debe ser Menor a la de Fin...
     D SPVTCR_FTCIM    c                   const(0008)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SPVTCR_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * --------------------------------------------------- *
      * Estrucutura de archivos
      * --------------------------------------------------- *
     D dsGnhdtc_t      ds                  qualified based(template)
     D   dfnrdf                       7  0
     D   dfctcu                       3  0
     D   dfnrtc                      20  0
     D   dffita                       4  0
     D   dffitm                       2  0
     D   dfffta                       4  0
     D   dffftm                       2  0
     D   dfgrab                      15
     D   dfbloq                       1
     D   dffbta                       4  0
     D   dffbtm                       2  0
     D   dffbtd                       2  0
     D   dfuser                      10

      * ------------------------------------------------------------ *
      * SPVTCR_chkEmpresa(): Valida Codigo de Empresa Emisora        *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVTCR_chkEmpresa...
     D                 pr              n
     D   peCtcu                       3  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_getCantDigitos(): Obtiene Cantidad de Digitos de      *
      *                          Tarjeta de Credito                  *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *                                                              *
      * Retorna: Cantidad de Digitos / 0 En caso de Error            *
      * ------------------------------------------------------------ *

     D SPVTCR_getCantDigitos...
     D                 pr             2  0
     D   peCtcu                       3  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_getMascTc(): Obtiene Mascara de Tarjeta de Credito    *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *                                                              *
      * Retorna: Mascara / 0 En caso de Error                        *
      * ------------------------------------------------------------ *

     D SPVTCR_getMascTc...
     D                 pr            25
     D   peCtcu                       3  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_getNroTcEdit(): Obtiene Numero de Tarjeta de Credito  *
      *                        en Formato                            *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *                                                              *
      * Retorna: Numeroo Editado / 0 En caso de Error                *
      * ------------------------------------------------------------ *

     D SPVTCR_getNroTcEdit...
     D                 pr            20  0
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_chkNoCero(): Valida Numero de Tarjeta de Credito <>0  *
      *                                                              *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVTCR_chkNoCero...
     D                 pr              n
     D   peNrtc                      20  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_chk1erNro(): Valida Primer Numero de Tarjeta de       *
      *                       Credito <> 0                           *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVTCR_chk1erNro...
     D                 pr              n
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_chkNroTcr(): Valida Numero de Tarjeta de Credito      *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVTCR_chkNroTcr...
     D                 pr              n
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_chkTcrAse(): Valida si Existe Tarjeta de Credito      *
      *                                                              *
      *     peAsen   (input)   Codigo de Asegurado                   *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVTCR_chkTcrAsen...
     D                 pr              n
     D   peAsen                       7  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_chkTcr(): Valida Tarjeta de Credito                   *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVTCR_chkTcr...
     D                 pr              n
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_setTcr(): Graba Tarjeta de Credito                    *
      *                                                              *
      *     peAsen   (input)   Codigo de Asegurado                   *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *     peFitc   (input)   Fecha Inicio Tarjeta de Credito(MMAAAA)*
      *     peFftc   (input)   Fecha Fin Tarjeta de Credito   (MMAAAA)*
      *     peUser   (input)   Usuario                               *
      *     peVali   (input)   Marca si Debe Validar Datos Recibidos *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVTCR_setTcr...
     D                 pr              n
     D   peAsen                       7  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peFitc                       6  0 const
     D   peFftc                       6  0 const
     D   peUser                      10    const
     D   peVali                       1n   options(*omit:*nopass)

      * ------------------------------------------------------------ *
      * SPVTCR_setBloqTc(): Bloquea Tarjeta de Credito               *
      *                                                              *
      *     peAsen   (input)   Codigo de Asegurado                   *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVTCR_setBloqTc...
     D                 pr              n
     D   peAsen                       7  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVTCR_getNroTcPant(): Obtiene Numero de Tarjeta de Credito  *
      *                        para mostrar en pantalla              *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *                                                              *
      * Retorna: Numero Editado / 0 En caso de Error                 *
      * ------------------------------------------------------------ *

     D SPVTCR_getNroTcPant...
     D                 pr            25
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVTCR_inz      pr

      * ------------------------------------------------------------ *
      * SPVTCR_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVTCR_end      pr

      * ------------------------------------------------------------ *
      * SPVTCR_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SPVTCR_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
      * ------------------------------------------------------------ *
      * SPVTCR_chkTarjCredito: Valida Tarjeta de Credito.            *
      *                                                              *
      *        Input :                                               *
      *                peCtcu  -  Código TC                          *
      *                peNrtc  -  Número TC                          *
      *                                                              *
      * Retorna: 0 OK                                                *
      *                                                              *
      *         -1 Empresa inválida                                  *
      *         -2 Cantidad de Dígitos Inválida                      *
      *         -3 Primer dígito significativo 0                     *
      *         -4 Primer dígito segun tabla GNTTC9                  *
      * -------------------------------------------------------------*
     D SPVTCR_chkTarjCredito...
     D                 pr            10i 0
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const

      * ------------------------------------------------------------ *
      * SPVTCR_fechaVencimientoTDC: Retorna fecha de Vencimiento de  *
      *                             la Tarjeta de Credito            *
      *                                                              *
      *     peAsen   (input)   Codigo de Asegurado                   *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *     peFfta   (output)  Año de Vencimiento                    *
      *     peFftm   (output)  Mes de Vencimiento                    *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVTCR_fechaVencimientoTcr...
     D                 pr              n
     D   peAsen                       7  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peFfta                       4  0
     D   peFftm                       2  0

      * ------------------------------------------------------------ *
      * SPVTCR_getGnhdtc : Retorna Tarjetas de un Asegurado          *
      *                                                              *
      *     peNrdf   ( input  ) Asegurado                            *
      *     peCtcu   ( input  ) Empresa Emisora           (opcional) *
      *     peNrtc   ( input  ) Numero de Tarjeta         (opcional) *
      *     peDsTc   ( output ) Esrtuctura de Tarjetas    (opcional) *
      *     peDsTcC  ( output ) Cantidad de Tarjetas      (opcional) *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SPVTCR_getGnhdtc...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peCtcu                       3  0 options( *nopass : *omit )const
     D   peNrtc                      20  0 options( *nopass : *omit )const
     D   peDsTc                            options( *nopass : *omit )
     D                                     likeds ( dsGnhdtc_t ) dim( 99 )
     D   peDsTcC                     10i 0 options( *nopass : *omit )

      * ------------------------------------------------------------ *
      * SPVTCR_getDesbloqueadas: Retornas Tarjetas Habilitadas para  *
      *                          un asegurado                        *
      *     peNrdf   ( input  ) Asegurado                            *
      *     peDsTc   ( output ) Esrtuctura de Tarjetas               *
      *     peDsTcC  ( output ) Cantidad de Tarjetas                 *
      *                                                              *
      * Retorna: *on = Si coincide le Clave / *off = Si no coincide  *
      * ------------------------------------------------------------ *
     D SPVTCR_getDesbloqueadas...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peDsTc                            likeds ( dsGnhdtc_t ) dim( 99 )
     D   peDsTcC                     10i 0

      * ------------------------------------------------------------ *
      * SPVTCR_setDesbloqueo: Desbloquea Tarjeta del asegurado       *
      *                                                              *
      *     peNrdf   ( input  ) Asegurado                            *
      *     peCtcu   ( input  ) Empresa Emisora                      *
      *     peNrtc   ( input  ) Numero de Tarjeta                    *
      *     peUser   ( input  ) Usuario                              *
      *                                                              *
      * Retorna: *on = Si desbloqueo / *off = No debloqueo           *
      * ------------------------------------------------------------ *
     D SPVTCR_setDesbloqueo...
     D                 pr              n
     D   peNrdf                       7  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVTCR_updFechaVencimiento: Actualiza fecha de Vencimiento   *
      *                             de la Tarjeta de Credito         *
      *                                                              *
      *     peAsen   (input)   Codigo de Asegurado                   *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Numero de Tarjeta de Credito          *
      *     peFfta   (input)   Año de Vencimiento                    *
      *     peFftm   (input)   Mes de Vencimiento                    *
      *     peUser   (input)   Usuario                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVTCR_updFechaVencimiento...
     D                 pr              n
     D   peAsen                       7  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peFfta                       4  0 const
     D   peFftm                       2  0 const
     D   peUser                      10    const

      * ------------------------------------------------------------ *
      * SPVTCR_getNombre: Retorna Nombre de Tarjeta Credito          *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *
     D SPVTCR_getNombre...
     D                 pr            40
     D   peCtcu                       3  0 const

      * ------------------------------------------------------------ *
      * SVPTCR_enmascararNumero: Retorna Numero con mascara          *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *     peNrtc   (input)   Número de Tarjeta                     *
      *     peCara   (input)   Caracter a usar                       *
      *     peCant   (input)   Cantidad de Nros. visibles            *
      *                                                              *
      * Retorna: Número con mascara                                  *
      * ------------------------------------------------------------ *
     D SPVTCR_enmascararNumero...
     D                 pr            20
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   peCara                       1    const
     D   peCant                      20  0 const
