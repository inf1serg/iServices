      /if defined(CZWIMP_H)
      /eof
      /endif
      /define CZWIMP_H

      * ------------------------------------------------------------ *
      * INZ():       Incializar Módulo                               *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D CZWIMP_Inz      pr

      * ------------------------------------------------------------ *
      * End():       Finalizar Módulo                                *
      *                                                              *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D CZWIMP_End      pr

      * ------------------------------------------------------------ *
      * Error():     Retorna último error                            *
      *                                                              *
      *       peErrn    (input)   Número del error                   *
      *                                                              *
      * retorna: Mensaje del último error                            *
      * ------------------------------------------------------------ *
     D CZWIMP_Error    pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * calcImpuestos():  Cálcula impuestos                          *
      *                                                              *
      *  ATENCION: Este porcentaje es un valor ficticio calculado    *
      *            por la gente de impuestos, sobre Prima + Recargos *
      *            Si no llega ningún parámetro se asume que se trata*
      *            de una Persona Física y Consumidor Final.         *
      *                                                              *
      *       pePrim    (input)   Prima                              *
      *       peReca    (input)   Recargos                           *
      *       peRpro    (input)   Código de Provincia                *
      *       peCiva    (input)   Código de Inscripción              *
      *       peTipp    (input)   Tipo de Persona                    *
      *       peFech    (input)   Fecha a la cual calcular           *
      *                                                              *
      * retorna: Importe de Impuestos                                *
      * ------------------------------------------------------------ *
     D CZWIMP_calcImpuestos...
     D                 pr            15  2
     D   pePrim                      15  2 const
     D   peReca                      15  2 const
     D   peRpro                       2  0 const
     D   peCiva                       2  0 const options(*nopass:*omit)
     D   peTipp                       1a   const options(*nopass:*omit)
     D   peFech                       8  0 const options(*nopass:*omit)

