      /if defined(SVPBUE_H)
      /eof
      /endif
      /define SVPBUE_H

      * Estructura
     D dsBure_t        ds                  qualified based(template)
     D   bure                         1  0
     D   desc                        30

      * ----------------------------------------------------------------- *
      * SVPBUE_chkProductorEspecial(): Retorna datos de productos especial*
      *                                                                   *
      *    peEmpr  (imput) Empresa                                        *
      *    peSucu  (imput) Sucursal                                       *
      *    peNivt  (imput) Tipo Nivel Intermed.                           *
      *    peNivc  (imput) Código Nivel Intermed.                         *
      *    peFech  (imput) Fecha de Vigencia                              *
      *                                                                   *
      * Retorna: *on / off                                                *
      *------------------------------------------------------------------ *
     D SVPBUE_chkProductorEspecial...
     D                 pr              n
     D   peEmpr                       1A   const
     D   peSucu                       5A   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peFech                       8  0 options(*nopass:*omit)

      * ----------------------------------------------------------------- *
      * SVPBUE_getListaBuenResultado(): Retorna Lista de Cod. de          *
      *                                 Buen Resultado.-                  *
      *                                                                   *
      *          peBure   (input)   Años de Buen Resultado                *
      *          peLbure  (output)  Lista de Cod. de buen resultado       *
      *          peLbureC (output)  Cantidad                              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPBUE_getListaBuenResultado...
     D                 pr              n
     D   peBure                       1  0 const
     D   peLbure                           likeds(dsBure_t) dim(99)
     D   peLbureC                    10i 0

      * ------------------------------------------------------------ *
      * SVPBUE_inz(): Inicializa módulo.                             *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPBUE_inz      pr

      * ------------------------------------------------------------ *
      * SVPBUE_End(): Finaliza módulo.                               *
      *                                                              *
      * ------------------------------------------------------------ *
     D SVPBUE_End      pr
      * ----------------------------------------------------------------- *
      * SVPBUE_getPorceBuenResultado(): Retorna Porcentaje de Buen        *
      *                                 Resultado.-                       *
      *                                                                   *
      *          peBure   (input)   Años de Buen Resultado                *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     D SVPBUE_getPorceBuenResultado...
     D                 pr             5  2
     D   peBure                       2  0 const

