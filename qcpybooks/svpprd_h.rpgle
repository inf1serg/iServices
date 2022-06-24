      /if defined(SVPPRD_H)
      /eof
      /endif
      /define SVPPRD_H

      * ------------------------------------------------------------ *
      * Registro de SET102
      * ------------------------------------------------------------ *
     D regPlan_t       ds                  qualified
     D  t@xpro                        3  0
     D  t@prds                       20a
     D  t@1021                        1a
     D  t@1022                        1a
     D  t@1023                        1a
     D  t@ctar                        4  0
     D  t@cta1                        2a
     D  t@cta2                        2a
     D  t@cagr                        2  0
     D  t@prdl                       60a
     D  t@psua                        2  0
     D  t@mar1                        1a
     D  t@mar2                        1a
     D  t@mar3                        1a
     D  t@mar4                        1a
     D  t@mar5                        1a

      * ------------------------------------------------------------ *
      * SVPPRD_planesPorProductor(): Listado de planes por Productor *
      *                                                              *
      *    peEmpr  (input)   Empresa                                 *
      *    peSucu  (input)   Sucursal                                *
      *    peRama  (input)   Rama                                    *
      *    peArcd  (input)   Artículo                                *
      *    peNivt  (input)   Tipo de Intermediario                   *
      *    peNivc  (input)   Código de Intermediario                 *
      *    pePlan  (output)  Array de Planes (registro SET102)       *
      *    peFweb  (input)   Filtrar habilitados para web            *
      *                                                              *
      * retorna: cantidad de planes especiales o 0 si no hay         *
      * ------------------------------------------------------------ *
     D SVPPRD_planesPorProductor...
     D                 pr            10i 0
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peArcd                        6  0 const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  pePlan                             likeds(regPlan_t) dim(999)
     D  peFweb                        1N   const options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPPRD_chkPlanPorProductor(): Verifica si un plan es válido  *
      *                               para un productor.             *
      *                                                              *
      *    peEmpr  (input)   Empresa                                 *
      *    peSucu  (input)   Sucursal                                *
      *    peRama  (input)   Rama                                    *
      *    peArcd  (input)   Artículo                                *
      *    peNivt  (input)   Tipo de Intermediario                   *
      *    peNivc  (input)   Código de Intermediario                 *
      *    peXpro  (input)   Código de Plan                          *
      *                                                              *
      * retorna: *ON si es válido, *OFF si no lo es.                 *
      * ------------------------------------------------------------ *
     D SVPPRD_chkPlanPorProductor...
     D                 pr             1N
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peArcd                        6  0 const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peXpro                        3  0 const

      * ------------------------------------------------------------ *
      * SVPPRD_inz(): Inicializa módulo.                             *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPPRD_inz      pr

      * ------------------------------------------------------------ *
      * SVPPRD_end(): Finaliza Módulo.                               *
      *                                                              *
      * retorna: void                                                *
      * ------------------------------------------------------------ *
     D SVPPRD_end      pr

      * ------------------------------------------------------------ *
      * SVPPRD_error(): Retorna último error del módulo.             *
      *                                                              *
      *      peErrn   (output)   Código de Error.                    *
      *                                                              *
      * retorna: Mensaje                                             *
      * ------------------------------------------------------------ *
     D SVPPRD_error    pr            80a
     D  peErrn                       10i 0 options(*nopass:*omit)

