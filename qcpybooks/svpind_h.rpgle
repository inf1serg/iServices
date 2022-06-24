      /if defined(SVPIND_H)
      /eof
      /endif
      /define SVPIND_H

      * Codigo de Empresa Emisora Inexistente...
     D SVPIND_ININE    c                   const(0001)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPIND_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SVPIND_chkIndice() : Valida Codigo de Empresa Emisora        *
      *                                                              *
      *     peCtcu   (input)   Codigo de Empresa Emisora             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPIND_chkIndice...
     D                 pr              n
     D   peIndi                       2    const

      * ------------------------------------------------------------ *
      * SVPIND_getIndice()     : Obtiene Indice - Descripcion y      *
      *                          Marcas.                             *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *     peNinl   (output)  Descripción Indice                    *
      *     peNinc   (output)  Descripción Indice Abreviado          *
      *     peBloq   (output)  Código de Bloqueo                     *
      *     peMar1   (output)  Obliqatorio para Reserva              *
      *                                                              *
      * Retorna: Cantidad de Digitos / 0 En caso de Error            *
      * ------------------------------------------------------------ *

     D SVPIND_getIndice...
     D                 pr              n
     D   peIndi                       2    Const
     D   peNinl                      30
     D   peNinc                       5
     D   peBloq                       1
     D   peMar1                       1


      * ------------------------------------------------------------ *
      * SVPIND_getCoefIndice(): Obtiene Coeficiente de Indice        *
      *                                                              *
      *                                                              *
      *     peIndi   (input)   Codigo de Indice                      *
      *     peFina   (input)   Fecha Año Indice                      *
      *     peFinm   (input)   Fecha Mes Indice                      *
      *     peVain   (output)  Valor Coeficiente Indice              *
      *                                                              *
      * Retorna:  / 0 En caso de Error                               *
      * ------------------------------------------------------------ *

     D SVPIND_getCoefIndice...
     D                 pr              n
     D   peIndi                       2    Const
     D   peFina                       4  0 Const
     D   peFinm                       2  0 Const
     D   peVain                      15  6

      * ------------------------------------------------------------ *
      * SVPIND_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPIND_inz      pr

      * ------------------------------------------------------------ *
      * SVPIND_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPIND_end      pr

      * ------------------------------------------------------------ *
      * SVPIND_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPIND_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
