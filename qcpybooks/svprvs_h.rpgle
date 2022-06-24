      /if defined(SVPRVS_H)
      /eof
      /endif
      /define SVPRVS_H

      * Rama Inexistente...
     D SVPRVS_RAMNE    c                   const(0001)
      * Rama Invalida Para Este Proceso...
     D SVPRVS_RAMIN    c                   const(0002)
      * Beneficiario Invalido Para Este Proceso...
     D SVPRVS_BENIN    c                   const(0003)
      * Fecha Invalida...
     D SVPRVS_FECIN    c                   const(0004)
      * Fecha Mayor a Hoy...
     D SVPRVS_FEMHY    c                   const(0005)
      * Importe Mayor a Permitido...
     D SVPRVS_IMMAY    c                   const(0006)
      * No se Econtro Importe para Hec. Gen. ...
     D SVPRVS_IMNOE    c                   const(0007)
      * Procesado - Se Ajusto Rva...
     D SVPRVS_AJRVA    c                   const(0008)
      * Importe en Cero...
     D SVPRVS_IMCER    c                   const(0009)

      * --------------------------------------------------- *
      * Estrucutura de datos con el último error
      * --------------------------------------------------- *
     D SVPRVS_ERDS_T   ds                  qualified
     D                                     based(template)
     D   Errno                        4s 0
     D   Msg                         80a

      * ------------------------------------------------------------ *
      * SVPRVS_chkRamaAuto(): Valida rama se automoviles             *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPRVS_chkRamaAuto...
     D                 pr              n
     D   peRama                       2  0 const

      * ------------------------------------------------------------ *
      * SVPRVS_chkTipoBenef(): Valida tipo de beneficiario           *
      *                                                              *
      *     peTipo   (input)   Tipo de Beneficiario                  *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPRVS_chkTipoBenef...
     D                 pr              n
     D   peTipo                       1    const

      * ------------------------------------------------------------ *
      * SVPRVS_chkFecEnvio(): Valida fecha de envio                  *
      *                                                              *
      *     peFech   (input)   Fecha de Envio (AAAAMMDD)             *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPRVS_chkFecEnvio...
     D                 pr              n
     D   peFech                       8  0 const

      * ------------------------------------------------------------ *
      * SVPRVS_chkTopeImp(): Controla tope de importe                *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *     peHecg   (input)   Hecho Generador                       *
      *     peImau   (input)   Importe                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPRVS_chkTopeImp...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const
     D   peHecg                       1    const
     D   peImau                      15  2 const

      * ------------------------------------------------------------ *
      * SVPRVS_chkAjustarRva(): Controla si se tiene que ajustar Rva *
      *                                                              *
      *     peTiac   (input)   Tipo de Accion                        *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPRVS_chkAjustarRva...
     D                 pr              n
     D   peTiac                       1  0 const

      * ------------------------------------------------------------ *
      * SVPRVS_chkImporte(): Controla Valor Importe                  *
      *                                                              *
      *     peTiim   (input)   Tipo Importe                          *
      *     peImau   (input)   Importe                               *
      *                                                              *
      * Retorna: *On / *Off                                          *
      * ------------------------------------------------------------ *

     D SVPRVS_chkImporte...
     D                 pr              n
     D   peTiim                       2    const
     D   peImau                      15  2 const

      * ------------------------------------------------------------ *
      * SVPRVS_getFranquicia(): Recupera importe de franquicia       *
      *                                                              *
      *     peEmpr   (input)   Empresa                               *
      *     peSucu   (input)   Sucursal                              *
      *     peRama   (input)   Rama                                  *
      *     peSini   (input)   Siniestro                             *
      *     peNops   (input)   Operacion de Siniestro                *
      *     peNrdf   (input)   Filiatorio de Beneficiario            *
      *                                                              *
      * Retorna: < 0, Franquicia desde PAHSFR (ya grabada)           *
      *          = 0, No corresponde franquicia                      *
      *          > 0, Franquicia desde PAHET0 (no grabada)           *
      * ------------------------------------------------------------ *

     D SVPRVS_getFranquicia...
     D                 pr            15  2
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peRama                       2  0 const
     D   peSini                       7  0 const
     D   peNops                       7  0 const
     D   peNrdf                       7  0 const

      * ------------------------------------------------------------ *
      * SVPRVS_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPRVS_inz      pr

      * ------------------------------------------------------------ *
      * SVPRVS_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPRVS_end      pr

      * ------------------------------------------------------------ *
      * SVPRVS_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPRVS_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)
