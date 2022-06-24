      /if defined(SVPCUO_H)
      /eof
      /endif
      /define SVPCUO_H

      /copy './qcpybooks/wsstruc_h.rpgle'

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPCUO_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SVPCUO_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPCUO_inz      pr

      * ------------------------------------------------------------ *
      * SVPCUO_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPCUO_end      pr

      * ------------------------------------------------------------ *
      * SVPCUO_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPCUO_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPCUO_getNumeroAsiento() : Retorna Número de Asiento del    *
      *                             Archivo PAHCD6.                  *
      *                                                              *
      *     peEmpr   ( input  ) Empresa                              *
      *     peSucu   ( input  ) Sucusal                              *
      *     peArcd   ( input  ) Artículo                             *
      *     peSpol   ( input  ) Superpóliza                          *
      *     peSspo   ( input  ) Suplemento Superpóliza               *
      *     peRama   ( input  ) Rama                                 *
      *     peArse   ( input  ) Secuencia                            *
      *     peOper   ( input  ) Operación                            *
      *     peSuop   ( input  ) Suplemento Operación                 *
      *     peNrcu   ( input  ) Número de Cuota                      *
      *     peNrsc   ( input  ) Número de Sub-Cuota                  *
      *     pePsec   ( input  ) Secuencia de Pago.                   *
      *                                                              *
      * Retorna: Numero de Asiento  / *zeros                         *
      * ------------------------------------------------------------ *
     D SVPCUO_getNumeroAsiento...
     D                 pr             6  0
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   peSuop                       3  0 const
     D   peNrcu                       2  0 const
     D   peNrsc                       2  0 const
     D   pePsec                       2  0 const options(*nopass:*omit)

