      /if defined(SVPSSN_H)
      /eof
      /endif
      /define SVPSSN_H

      /copy './qcpybooks/wsstruc_h.rpgle'

      *--- Definicion de Procedimiento ----------------------------- *
      * ------------------------------------------------------------ *
      * SVPSSN_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPSSN_inz      pr

      * ------------------------------------------------------------ *
      * SVPSSN_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPSSN_End      pr

      * ------------------------------------------------------------ *
      * SVPSSN_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     D SVPSSN_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------- *
      * SVPSSN_getRamo(): Retorna Ramo.                               *
      *                                                               *
      *     peRama   ( input  ) codigo de cuestionario                *
      *                                                               *
      * Retorna: Ramo / *blanks                                       *
      * ------------------------------------------------------------- *
     D SVPSSN_getRamo...
     D                 pr             4
     D   peRama                       2  0 const

      * ------------------------------------------------------------- *
      * SVPSSN_getSubramo(): Retorna Subramo.                         *
      *                                                               *
      *     peRama   ( input  ) codigo de cuestionario                *
      *                                                               *
      * Retorna: Subramo / *blanks                                    *
      * ------------------------------------------------------------- *
     D SVPSSN_getSubramo...
     D                 pr             6
     D   peRama                       2  0 const

      * ------------------------------------------------------------- *
      * SVPSSN_getProvincia(): Retorna Codigo de Provincia SSN        *
      *                                                               *
      *     peProc   ( input  ) Código de Provincia.                  *
      *                                                               *
      * Retorna: Provincia SSN / *zeros                               *
      * ------------------------------------------------------------- *
     D SVPSSN_getProvincia...
     D                 pr             2  0
     D   peProc                       3    const

      * ------------------------------------------------------------- *
      * SVPSSN_getMoneda(): Retorna Moneda.                           *
      *                                                               *
      *     peMone   ( input  ) Código de Moneda                      *
      *                                                               *
      * Retorna: Moneda SSN / *blanks                                 *
      * ------------------------------------------------------------- *
     D SVPSSN_getMoneda...
     D                 pr             2
     D   peMone                       2    const
