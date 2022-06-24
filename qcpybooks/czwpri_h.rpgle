      /if defined(CZWPRI_H)
      /eof
      /endif
      /define CZWPRI_H

     D dscot_t         ds                  qualified based(template)
     D  vhca                          2  0
     D  vhv1                          1  0
     D  vhv2                          1  0
     D  vhvu                         15  2
     D  scta                          1  0
     D  mgnc                          1a
     D  vh0k                          1a
     D  mtdf                          1a
     D  vhmc                          3a
     D  vhmo                          3a
     D  vhcs                          3a
     D  vhct                          2  0
     D  vhni                          1a
     D  dupe                          2  0
     D  vhan                          4  0
     D  arcd                          6  0
     D  rama                          2  0

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D CZWPRI_Inz      pr

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D CZWPRI_End      pr

      * ------------------------------------------------------------ *
      * Error():    Retorna último error del módulo                  *
      *                                                              *
      *         peErrn    (output)    Código de Error                *
      *                                                              *
      * retorna: Mensaje de error                                    *
      * ------------------------------------------------------------ *
     D CZWPRI_Error    pr            80a
     D   peErrn                      10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * calCobA():   Calcula cobertura A                             *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *     pePrim    (output)   Importe de Prima                    *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     D CZWPRI_calCobA  pr            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

      * ------------------------------------------------------------ *
      * calCobB():   Calcula cobertura B                             *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     D CZWPRI_calCobB  pr            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

      * ------------------------------------------------------------ *
      * calCobC():   Calcula cobertura C                             *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     D CZWPRI_calCobC  pr            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

      * ------------------------------------------------------------ *
      * calCobC1():  Calcula cobertura C+                            *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     D CZWPRI_calCobC1...
     D                 pr            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

      * ------------------------------------------------------------ *
      * calCobD():   Calcula cobertura D                             *
      *                                                              *
      *     peCot     (input)    DS con todos los datos para cotizar *
      *                                                              *
      * retorna: Importe de Prima, o -1 si no corresponde            *
      * ------------------------------------------------------------ *
     D CZWPRI_calCobD  pr            10i 0
     D   peCot                             likeds(dscot_t)
     D   pePrim                      15  2
     D   peErrn                      10i 0
     D   peErrm                      80a

      * ------------------------------------------------------------ *
      * getPrimaMinima():    Retorna Prima Mínima                    *
      *                                                              *
      *     peFech    (input)    Fecha a la cual recuperar           *
      *                                                              *
      * retorna: Prima Mínima                                        *
      * ------------------------------------------------------------ *
     D CZWPRI_getPrimaMinima...
     D                 pr            15  2
     D   peFech                       8  0 options(*nopass:*omit)

