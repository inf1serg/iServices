      /if defined(SPVFEC_H)
      /eof
      /endif
      /define SPVFEC_H

      * Tipo de Giro Invalido...
     D SPVFEC_TGINV    c                   const(0001)
      * Fecha Invalida...
     D SPVFEC_FEINV    c                   const(0002)
      * Fecha No Habil...
     D SPVFEC_FENHA    c                   const(0003)
      * Fecha Fuera de rango...
     D SPVFEC_FEFRA    c                   const(0004)
      * Signo Invalido...
     D SPVFEC_SGINV    c                   const(0005)
      * Tiempo Invalido...
     D SPVFEC_TIINV    c                   const(0006)
      * Cantidad Invalida...
     D SPVFEC_CAINV    c                   const(0007)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SPVFEC_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SPVFEC_FecDeHoy8(): Fecha de Hoy 8 Digitos                   *
      *                                                              *
      *     peTipo   (input)   Tipo de Giro (AMD/DMA)                *
      *                                                              *
      * Retorna: Fecha de Hoy 8 Digitos                              *
      * ------------------------------------------------------------ *

     D SPVFEC_FecDeHoy8...
     D                 pr             8  0
     D   peTipo                       3a   const options(*RIGHTADJ)

      * ------------------------------------------------------------ *
      * SPVFEC_FecDeHoy6(): Fecha de Hoy 6 Digitos                   *
      *                                                              *
      *     peTipo   (input)   Tipo de Giro (AMD/DMA)                *
      *                                                              *
      * Retorna: Fecha de Hoy 6 Digitos                              *
      * ------------------------------------------------------------ *

     D SPVFEC_FecDeHoy6...
     D                 pr             6  0
     D   peTipo                       3a   const options(*RIGHTADJ)

      * ------------------------------------------------------------ *
      * SPVFEC_GiroFecha8(): Gira Fecha de 8 Digitos a AMD/DMA       *
      *                                                              *
      *     peFein   (input)   Fecha Input (AAAAMMDD/DDMMAAAA)       *
      *     peTipo   (input)   Tipo de Giro (DMA/AMD)                *
      *                                                              *
      * Retorna: Fecha modificada                                    *
      * ------------------------------------------------------------ *

     D SPVFEC_GiroFecha8...
     D                 pr             8  0
     D   peFein                       8  0 const
     D   peTipo                       3a   const options(*RIGHTADJ)

      * ------------------------------------------------------------ *
      * SPVFEC_GiroFecha6(): Gira Fecha de 6 Digitos a AMD/DMA       *
      *                                                              *
      *     peFein   (input)   Fecha Input (AAMMDD/DDMMAA)           *
      *     peTipo   (input)   Tipo de Giro (DMA/AMD)                *
      *                                                              *
      * Retorna: Fecha modificada                                    *
      * ------------------------------------------------------------ *

     D SPVFEC_GiroFecha6...
     D                 pr             6  0
     D   peFein                       6  0 const
     D   peTipo                       3a   const options(*RIGHTADJ)

      * ------------------------------------------------------------ *
      * SPVFEC_Convert8a6(): Modifica Fecha de 8 Digitos a 6         *
      *                                                              *
      *     peFech   (input)   Fecha 8 Digitos AAAAMMDD              *
      *                                                              *
      * Retorna: Fecha modificada                                    *
      * ------------------------------------------------------------ *

     D SPVFEC_Convert8a6...
     D                 pr             6  0
     D   peFech                       8  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_Convert6a8(): Modifica Fecha de 6 Digitos a 8         *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha 6 Digitos AAMMDD                *
      *                                                              *
      * Retorna: Fecha modificada                                    *
      * ------------------------------------------------------------ *

     D SPVFEC_Convert6a8...
     D                 pr             8  0
     D   peFech                       6  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_DiasEntreFecha8(): Calcula Dias Entre Fechas 8 Digitos*
      *                                                              *
      *     peFecd   (input)   Fecha Desde (AAAAMMDD)                *
      *     peFech   (input)   Fecha Hasta (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Dias entre las fechas                               *
      * ------------------------------------------------------------ *

     D SPVFEC_DiasEntreFecha8...
     D                 pr             5  0
     D   peFecd                       8  0 const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_DiasEntreFecha6(): Calcula Dias Entre Fechas 6 Digitos*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFecd   (input)   Fecha Desde (AAMMDD)                  *
      *     peFech   (input)   Fecha Hasta (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Dias entre las fechas                               *
      * ------------------------------------------------------------ *

     D SPVFEC_DiasEntreFecha6...
     D                 pr             5  0
     D   peFecd                       6  0 const
     D   peFech                       6  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_DiasEntreHabFecha8(): Calcula Dias Habiles Entre      *
      *                             Fechas de 8 Digitos              *
      *                                                              *
      *     peFecd   (input)   Fecha Desde (AAAAMMDD)                *
      *     peFech   (input)   Fecha Hasta (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Dias habiles entre las fechas                       *
      * ------------------------------------------------------------ *

     D SPVFEC_DiasEntreHabFecha8...
     D                 pr             6  0
     D   peFecd                       8  0 const
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_DiasEntreHabFecha6(): Calcula Dias Habiles Entre      *
      *                             Fechas de 6 Digitos              *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFecd   (input)   Fecha Desde (AAMMDD)                  *
      *     peFech   (input)   Fecha Hasta (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Dias habiles entre las fechas                       *
      * ------------------------------------------------------------ *

     D SPVFEC_DiasEntreHabFecha6...
     D                 pr             6  0
     D   peFecd                       6  0 const
     D   peFech                       6  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_FechaValida8(): Valida Fecha 8                        *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD)                *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaValida8...
     D                 pr              n
     D   peFech                       8  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_FechaValida6(): Valida Fecha 6                        *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD)                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaValida6...
     D                 pr              n
     D   peFech                       6  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_FechaHabil8(): Valida si la Fecha es Habil            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *     peHabi   (input)   Prox. Habil (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaHabil8...
     D                 pr              n
     D   peFech                       8  0 options(*nopass:*omit)
     D   peHabi                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_FechaHabil6(): Valida si la Fecha es Habil            *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD) (Opcional)       *
      *     peHabi   (input)   Prox. Habil (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaHabil6...
     D                 pr              n
     D   peFech                       6  0 options(*nopass:*omit)
     D   peHabi                       6  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_FechaRango8(): Valida Fecha 8 Digitos Dentro del Rango*
      *                                                              *
      *     peDesd   (input)   Fecha Desde (AAAAMMDD)                *
      *     peFech   (input)   Fecha (AAAAMMDD)                      *
      *     peHast   (input)   Fecha Hasta (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaRango8...
     D                 pr              n
     D   peDesd                       8  0 const
     D   peFech                       8  0 const
     D   peHast                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_FechaRango6(): Valida Fecha 6 Digitos Dentro del Rango*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peDesd   (input)   Fecha Desde (AAMMDD)                  *
      *     peFech   (input)   Fecha (AAMMDD)                        *
      *     peHast   (input)   Fecha Hasta (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaRango6...
     D                 pr              n
     D   peDesd                       6  0 const
     D   peFech                       6  0 const
     D   peHast                       6  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_FechaMayor8(): Devuelve Fecha 8 Digitos Mayor el Rango*
      *                                                              *
      *     peFec1   (input)   Fecha 1 (AAAAMMDD)                    *
      *     peFec2   (input)   Fecha 2 (AAAAMMDD)                    *
      *                                                              *
      * Retorna: 0 = Iguales / 1 = Fecha 1 Mayor / 2 = Fecha 2 Mayor *
      *          3 = Error, Fechas Invalidas                         *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaMayor8...
     D                 pr             1  0
     D   peFec1                       8  0 const
     D   peFec2                       8  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_FechaMayor6(): Devuelve Fecha 6 Digitos Mayor el Rango*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFec1   (input)   Fecha 1 (AAMMDD)                      *
      *     peFec2   (input)   Fecha 2 (AAMMDD)                      *
      *                                                              *
      * Retorna: 0 = Iguales / 1 = Fecha 1 Mayor / 2 = Fecha 2 Mayor *
      *          3 = Error, Fechas Invalidas                         *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaMayor6...
     D                 pr             1  0
     D   peFec1                       6  0 const
     D   peFec2                       6  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_FechaMenor8(): Devuelve Fecha 8 Digitos Menor el Rango*
      *                                                              *
      *     peFec1   (input)   Fecha 1 (AAAAMMDD)                    *
      *     peFec2   (input)   Fecha 2 (AAAAMMDD)                    *
      *                                                              *
      * Retorna: 0 = Iguales / 1 = Fecha 1 Menor / 2 = Fecha 2 Menor *
      *          3 = Error, Fechas Invalidas                         *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaMenor8...
     D                 pr             1  0
     D   peFec1                       8  0 const
     D   peFec2                       8  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_FechaMenor6(): Devuelve Fecha 6 Digitos Menor el Rango*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFec1   (input)   Fecha 1 (AAMMDD)                      *
      *     peFec2   (input)   Fecha 2 (AAMMDD)                      *
      *                                                              *
      * Retorna: 0 = Iguales / 1 = Fecha 1 Menor / 2 = Fecha 2 Menor *
      *          3 = Error, Fechas Invalidas                         *
      * ------------------------------------------------------------ *

     D SPVFEC_FechaMenor6...
     D                 pr             1  0
     D   peFec1                       6  0 const
     D   peFec2                       6  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_SumResFecha8(): Suma/Resta Años/Meses/Días a una Fecha*
      *                                                              *
      *     peFech   (input)   Fecha (AAAAMMDD)                      *
      *     peSign   (input)   Signo (+ = Sumar/- = Restar)          *
      *     peTipo   (input)   Tiempo (A = Años/M = Meses/D = Días)  *
      *     peCant   (input)   Cantidad a Sumar/Restar               *
      *                                                              *
      * Retorna: Fecha Resultante  / 0 en caso de error              *
      * ------------------------------------------------------------ *

     D SPVFEC_SumResFecha8...
     D                 pr             8  0
     D   peFech                       8  0 const
     D   peSign                       1a   const
     D   peTipo                       1a   const
     D   peCant                       5  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_SumResFecha6(): Suma/Resta Años/Meses/Días a una Fecha*
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha (AAMMDD)                        *
      *     peSign   (input)   Signo (+ = Sumar/- = Restar)          *
      *     peTipo   (input)   Tiempo (A = Años/M = Meses/D = Días)  *
      *     peCant   (input)   Cantidad a Sumar/Restar               *
      *                                                              *
      * Retorna: Fecha Resultante  / 0 en caso de error              *
      * ------------------------------------------------------------ *

     D SPVFEC_SumResFecha6...
     D                 pr             6  0
     D   peFech                       6  0 const
     D   peSign                       1a   const
     D   peTipo                       1a   const
     D   peCant                       5  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_SumResDiaHabF8(): Suma/Resta Dias Habiles             *
      *                                                              *
      *     peFech   (input)   Fecha (AAAAMMDD)                      *
      *     peSign   (input)   Signo (+ = Sumar/- = Restar)          *
      *     peCant   (input)   Cantidad a Sumar/Restar               *
      *                                                              *
      * Retorna: Fecha Resultante  / 0 en caso de error              *
      * ------------------------------------------------------------ *

     D SPVFEC_SumResDiaHabF8...
     D                 pr             8  0
     D   peFech                       8  0 const
     D   peSign                       1a   const
     D   peCant                       3  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_SumResDiaHabF6(): Suma/Resta Dias Habiles             *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha (AAMMDD)                        *
      *     peSign   (input)   Signo (+ = Sumar/- = Restar)          *
      *     peCant   (input)   Cantidad a Sumar/Restar               *
      *                                                              *
      * Retorna: Fecha Resultante  / 0 en caso de error              *
      * ------------------------------------------------------------ *

     D SPVFEC_SumResDiaHabF6...
     D                 pr             6  0
     D   peFech                       6  0 const
     D   peSign                       1a   const
     D   peCant                       3  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_ObtDiaFecha8(): Obtiene el dia de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Dia                                                 *
      * ------------------------------------------------------------ *

     D SPVFEC_ObtDiaFecha8...
     D                 pr             2  0
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_ObtDiaFecha6(): Obtiene el dia de la fecha            *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Dia                                                 *
      * ------------------------------------------------------------ *

     D SPVFEC_ObtDiaFecha6...
     D                 pr             2  0
     D   peFech                       6  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_ObtMesFecha8(): Obtiene el Mes de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Mes                                                 *
      * ------------------------------------------------------------ *

     D SPVFEC_ObtMesFecha8...
     D                 pr             2  0
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_ObtMesFecha6(): Obtiene el Mes de la fecha            *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Mes                                                 *
      * ------------------------------------------------------------ *

     D SPVFEC_ObtMesFecha6...
     D                 pr             2  0
     D   peFech                       6  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_ObtAÑoFecha8(): Obtiene el aÑo de la fecha            *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: Mes                                                 *
      * ------------------------------------------------------------ *

     D SPVFEC_ObtAÑoFecha8...
     D                 pr             4  0
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_ObtAÑoFecha6(): Obtiene el aÑo de la fecha            *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD) (Opcional)       *
      *                                                              *
      * Retorna: Mes                                                 *
      * ------------------------------------------------------------ *

     D SPVFEC_ObtAÑoFecha6...
     D                 pr             2  0
     D   peFech                       6  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_AÑoBisiestoFecha8(): Obtiene si aÑo Bisiesto          *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAAAMMDD) (Opcional)     *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFEC_AÑoBisiestoFecha8...
     D                 pr              n
     D   peFech                       8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVFEC_AÑoBisiestoFecha6(): Obtiene si aÑo Bisiesto          *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peFech   (input)   Fecha Desde (AAMMDD)                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVFEC_AÑoBisiestoFecha6...
     D                 pr              n
     D   peFech                       6  0 const

      * ------------------------------------------------------------ *
      * SPVFEC_ArmarFecha8(): Arma la Fecha AAAAMMDD/DDMMAAAA        *
      *                                                              *
      *     peAÑo    (input)   AÑo                                   *
      *     peMes    (input)   Mes                                   *
      *     peDia    (input)   Dia                                   *
      *     peTipo   (input)   Tipo de Giro (AMD/DMA)                *
      *                                                              *
      * Retorna: Fecha AAAAMMDD/DDMMAAAA                             *
      * ------------------------------------------------------------ *

     D SPVFEC_ArmarFecha8...
     D                 pr             8  0
     D   peAÑo                        4  0 const
     D   peMes                        2  0 const
     D   peDia                        2  0 const
     D   peTipo                       3a   const options(*RIGHTADJ)

      * ------------------------------------------------------------ *
      * SPVFEC_ArmarFecha6(): Arma la Fecha AAMMDD/DDMMAA            *
      *                          Solo Para Fechas Mayores a Año 2000 *
      *                                                              *
      *     peAÑo    (input)   AÑo                                   *
      *     peMes    (input)   Mes                                   *
      *     peDia    (input)   Dia                                   *
      *     peTipo   (input)   Tipo de Giro (AMD/DMA)                *
      *                                                              *
      * Retorna: Fecha AAMMDD/DDMMAA                                 *
      * ------------------------------------------------------------ *

     D SPVFEC_ArmarFecha6...
     D                 pr             6  0
     D   peAÑo                        2  0 const
     D   peMes                        2  0 const
     D   peDia                        2  0 const
     D   peTipo                       3a   const options(*RIGHTADJ)

      * ------------------------------------------------------------ *
      * SPVFEC_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVFEC_inz      pr

      * ------------------------------------------------------------ *
      * SPVFEC_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVFEC_End      pr

      * ------------------------------------------------------------ *
      * SPVFEC_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SPVFEC_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

