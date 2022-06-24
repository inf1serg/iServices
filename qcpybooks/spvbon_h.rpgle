      /if defined(SPVBON_H)
      /eof
      /endif
      /define SPVBON_H

      * Código Bonificacion Inexistente...
     D SPVBON_BCDNF    c                   const(0901)
      * %.Bonificacion fuera de valores permitidos...
     D SPVBON_BPRIV    c                   const(0902)
      * Cod.Bonificacion fuera de Vigencia...
     D SPVBON_BFEIV    c                   const(0903)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SPVBON_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SPVBON_CheckBonCod():Chequea Bonificación (Codigo/Fecha,Porc)*
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peRama   (input)   Código Rama                           *
      *     peBonCod (input)   Código Bonificación                   *
      *     peBonPor (input)   Porcentaje de Bonificación            *
      *     peFecha  (input)   Fecha                                 *
      *     peMarc   (input)   Marca de Nivel                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVBON_CheckBonCod...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peBonCod                     3  0 const
     D   peBonPor                     5  2 const
     D   peFecha                      8  0 options(*nopass:*omit)
     D   peMarc                       1    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVBON_CheckBon(): Chequea Codigo de Bonificación            *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peRama   (input)   Código Rama                           *
      *     peBonCod (input)   Código Bonificación                   *
      *     peMarc   (input)   Marca de Nivel                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVBON_CheckBon...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peBonCod                     3  0 const
     D   peMarc                       1    options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVBON_CheckVigPor():Chequea Vigencia de Bonificacion y %    *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peRama   (input)   Código Rama                           *
      *     peBonCod (input)   Código Bonificación                   *
      *     peFecha  (input)   Fecha                                 *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVBON_CheckVigPor...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peBonCod                     3  0 const
     D   peFecha                      8  0 options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SPVBON_CheckPor():Chequea Porcentaje Dentro de lo Permitido  *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peArcd   (input)   Código Artículo                       *
      *     peRama   (input)   Código Rama                           *
      *     peBonCod (input)   Código Bonificación                   *
      *     peBonPor (input)   Porcentaje de Bonificación            *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SPVBON_CheckPor...
     D                 pr             1n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peArcd                       6  0 const
     D   peRama                       2  0 const
     D   peBonCod                     3  0 const
     D   peBonPor                     5  2 const

      * ------------------------------------------------------------ *
      * SPVBON_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVBON_inz      pr

      * ------------------------------------------------------------ *
      * SPVBON_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SPVBON_End      pr

      * ------------------------------------------------------------ *
      * SPVBON_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SPVBON_Error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

