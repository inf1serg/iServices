      /if defined(SVPAXI_H)
      /eof
      /endif
      /define SVPAXI_H

      * Indice Inexistente...
     D SVPAXI_NOIND    c                   const(0001)

     * ------------------------------------------------------------ *
     * SVPAXI_inz(): Inicializa módulo.                             *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPAXI_inz      pr

     * ------------------------------------------------------------ *
     * SVPAXI_End(): Finaliza módulo.                               *
     *                                                              *
     * void                                                         *
     * ------------------------------------------------------------ *
     D SVPAXI_End      pr

     * ------------------------------------------------------------ *
     * SVPAXI_Error(): Retorna el último error del service program  *
     *                                                              *
     *     peErrn   (output)  Número de error (opcional)            *
     *                                                              *
     * Retorna: Mensaje de error.                                   *
     * ------------------------------------------------------------ *
     D SVPAXI_Error    pr            80a
     D   peErrn                      10i 0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPAXI_chkIndice(): Verifica existencia de indice.           *
     *                                                              *
     *     peIndi   (input)   Codigo de Indice                      *
     *     peNinl   (output)  Descripcion de Indice                 *
     *                                                              *
     * Retorna: ON existe, OFF no existe                            *
     * ------------------------------------------------------------ *
     D SVPAXI_chkIndice...
     D                 pr             1n
     D   peIndi                       2a   const
     D   peNinl                      30a   options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPAXI_getIndice(): Recupera valor de indice.                *
     *                                                              *
     *     peIndi   (input)   Codigo de Indice                      *
     *     peFech   (input)   Fecha a la cual recuperar             *
     *                                                              *
     * Retorna: 0 por error, valor del indice si ok                 *
     * ------------------------------------------------------------ *
     D SVPAXI_getIndice...
     D                 pr            15  6
     D   peIndi                       2a   const
     D   peFech                       8  0 const options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPAXI_getCocienteEntreIndices(): Obtiene cociente entre dos *
     *                          valores de un indice.               *
     *                                                              *
     *     peIndi   (input)   Codigo de Indice                      *
     *     peFeba   (input)   Fecha base                            *
     *     peFeac   (input)   Fecha ajuste                          *
     *                                                              *
     * Retorna: 0 por error, cociente si ok                         *
     * ------------------------------------------------------------ *
     D SVPAXI_getCocienteEntreIndices...
     D                 pr            15  6
     D   peIndi                       2a   const
     D   peFeba                       8  0 const options(*nopass:*omit)
     D   peFeac                       8  0 const options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPAXI_ajustarPorInflacion(): Ajustar por inflación cualquier*
     *                          importe.                            *
     *                                                              *
     *     peIndi   (input)   Codigo de Indice                      *
     *     peImpo   (input)   Importe a ajustar                     *
     *     peFeba   (input)   Fecha base                            *
     *     peFeac   (input)   Fecha ajuste                          *
     *                                                              *
     * Retorna: 0 por error, importe ajustado si ok                 *
     * ------------------------------------------------------------ *
     D SVPAXI_ajustarPorInflacion...
     D                 pr            15  2
     D   peIndi                       2a   const
     D   peImpo                      15  2 const
     D   peFeba                       8  0 const options(*nopass:*omit)
     D   peFeac                       8  0 const options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPAXI_ajusteRamaSecuencia(): Ajustar por inflación una      *
     *                               rama/secuencia.                *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Artículo                              *
     *     peSpol   (input)   Superpoliza                           *
     *     peSspo   (input)   Suplemento de Superpoliza             *
     *     peRama   (input)   Rama                                  *
     *     peArse   (input)   Secuencia Artículo/Rama               *
     *     peOper   (input)   Operacion                             *
     *     peSuop   (input)   Suplemento                            *
     *     peImpo   (input)   Importe a ajustar                     *
     *     peFeac   (input)   Fecha ajuste                          *
     *     peIndi   (input)   Codigo de Indice (opc)                *
     *     peFeba   (input)   Fecha Base (opc)                      *
     *                                                              *
     * Retorna: Importe ajustado o mismo importe                    *
     * ------------------------------------------------------------ *
     D SVPAXI_ajusteRamaSecuencia...
     D                 pr            15  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peFeac                       8  0 const
     D   peImpo                      15  2 const
     D   peIndi                       2a   const options(*nopass:*omit)
     D   peViba                      15  6 options(*nopass:*omit)
     D   peViaj                      15  6 options(*nopass:*omit)
     D   pxFeba                       8  0 options(*nopass:*omit)

     * ------------------------------------------------------------ *
     * SVPAXI_ajusteRamaSecuenciaVida(): Ajustar por inflación una  *
     *                               rama/secuencia.                *
     *                                                              *
     *     peEmpr   (input)   Empresa                               *
     *     peSucu   (input)   Sucursal                              *
     *     peArcd   (input)   Artículo                              *
     *     peSpol   (input)   Superpoliza                           *
     *     peSspo   (input)   Suplemento de Superpoliza             *
     *     peRama   (input)   Rama                                  *
     *     peArse   (input)   Secuencia Artículo/Rama               *
     *     peOper   (input)   Operacion                             *
     *     peSuop   (input)   Suplemento                            *
     *     peImpo   (input)   Importe a ajustar                     *
     *     peFeac   (input)   Fecha ajuste                          *
     *     peIndi   (input)   Codigo de Indice (opc)                *
     *     peFeba   (input)   Fecha Base (opc)                      *
     *                                                              *
     * Retorna: Importe ajustado o mismo importe                    *
     * ------------------------------------------------------------ *
     D SVPAXI_ajusteRamaSecuenciaVida...
     D                 pr            15  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peOper                       7  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peFeac                       8  0 const
     D   peImpo                      15  2 const
     D   peIndi                       2a   const options(*nopass:*omit)
     D   peViba                      15  6 options(*nopass:*omit)
     D   peViaj                      15  6 options(*nopass:*omit)
     D   pxFeba                       8  0 options(*nopass:*omit)

