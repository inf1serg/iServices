      /if defined(SVPVLS_H)
      /eof
      /endif
      /define SVPVLS_H

      *-- Estructura ------------------------------------------------*

      *-- Copy's ----------------------------------------------------*
      /copy './qcpybooks/svpws_h.rpgle'

      * - Definicion de Procedimiento ------------------------------ *

      * -------------------------------------------------------------*
      * SVPVLS_getValSys: Retorna Valor y descripcion del Sistema    *
      *                   GAUS solicitado.                           *
      *                                                              *
      *          peCval   ( input  ) Codigo de Valor                 *
      *          peDval   ( output ) Descripcion de Valor (opcional) *
      *          peVsys   ( output ) Valor del Sistema    (opcional) *
      *                                                              *
      * Retorna *on = Encontro / *off = No encontro                  *
      * -------------------------------------------------------------*
     D SVPVLS_getValSys...
     D                 pr              n
     D   peCval                      10    const
     D   peDval                     512    options(*nopass:*omit)
     D   peVsys                     512    options(*nopass:*omit)

      * -------------------------------------------------------------*
      * SVPVLS_updValSys: Actualiza valores del Sistema GAUS.        *
      *                                                              *
      *          peCval   ( input ) Codigo de Valor                  *
      *          peDval   ( input ) Descripcion de Valor             *
      *          peVsys   ( input ) Valor del Sistema                *
      *                                                              *
      * Retorna *on = Actualizo / *off = No Actualizo.               *
      * -------------------------------------------------------------*
     D SVPVLS_updValSys...
     D                 pr              n
     D   peCval                      10    const
     D   peDval                     512
     D   peVsys                     512

      * -------------------------------------------------------------*
      * SVPVLS_setValSys: Graba nuevo valor del Sistema GAUS.        *
      *                                                              *
      *          peCval   ( input ) Codigo de Valor                  *
      *          peDval   ( input ) Descripcion de Valor             *
      *          peVsys   ( input ) Valor del Sistema                *
      *                                                              *
      * Retorna *on = Encontro / *off = No encontro.                 *
      * -------------------------------------------------------------*
     D SVPVLS_setValSys...
     D                 pr              n
     D   peCval                      10    const
     D   peDval                     512    const
     D   peVsys                     512    const

      * -------------------------------------------------------------*
      * SVPVLS_dltValSys: Elimina Valores del Sistemas GAUS.         *
      *                                                              *
      *          peCval   ( input ) Codigo de Valor                  *
      *                                                              *
      * Retorna *on = Elimino ok / *off = No Elimino.                *
      * -------------------------------------------------------------*
     D SVPVLS_dltValSys...
     D                 pr              n
     D   peCval                      10    const

      * ------------------------------------------------------------ *
      * SVPVLS_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPVLS_inz      pr

      * ------------------------------------------------------------ *
      * SVPVLS_end():  Finaliza módulo.                              *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPVLS_end      pr

      * ------------------------------------------------------------ *
      * SVPVLS_error():  Retorna el último error del servicio.       *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPVLS_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

