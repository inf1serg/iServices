      /if defined(SVPEMP_H)
      /eof
      /endif
      /define SVPEMP_H

      * --------------------------------------------------- *
      * Estrucutura de datos GNTEMP                         *
      * --------------------------------------------------- *
     D SVPEMP_ERDS_T   ds                  qualified
     D                                     based(template)
      * --------------------------------------------------- *
      * Estrucutura de Caracteristicas
      * --------------------------------------------------- *
     D dsGntemp_t      ds                  qualified template
     D   emempr                       1
     D   emneml                      50
     D   emnemc                      20
     D   emdire                      25
     D   emcopo                       5p 0
     D   emcops                       1p 0
     D   emcuit                      11
     D   emnuib                      11p 0
     D   emsudf                       2
     D   embloq                       1
     D   emivrs                       1
     D   emciva                       2p 0
     D   emtiso                       2p 0
     D   emfdia                       2p 0
     D   emfmes                       2p 0
     D   emfaÑo                       2p 0
     D   emnier                      13p 0
     D   emcn03                       3p 0
     D   emcn05                       5p 0
     D   emmar1                       1
     D   emmar2                       1
     D   emmar3                       1
     D   emmar4                       1
     D   emmar5                       1
     D   emdir1                      30
     D   emnemm                      50
     D   emaddr                      30
     D   emcpma                       8
     D   empaid                      30
     D   emteln                      20
     D   empweb                      50

      * ---------------------------------------------------------------- *
      * SVPEMP_getDatosDeEmpresa: Retorna datos de la Empresa            *
      *                                                                  *
      *      peEmpr  (imput)  Empresa                                    *
      *      peDsEmp (output) Datos de Empresa ( opcional )              *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     D SVPEMP_getDatosDeEmpresa...
     D                 pr              n
     D   peEmpr                       1    const
     D   peDsEmp                           likeds(dsgntemp_t)
     D                                     options(*nopass:*omit)

      * ---------------------------------------------------------------- *
      * SVPEMP_getLocalidadDeEmpresa: Retorna la localidad de la empresa *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *      peCopo  (output) Código Postal                              *
      *      peCops  (output) Sufijo del Código Postal                   *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     D SVPEMP_getLocalidadDeEmpresa...
     D                 pr              n
     D   peEmpr                       1      const
     D   peCopo                       5  0
     D   peCops                       1  0

      * ------------------------------------------------------------ *
      * SVPEMP_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPEMP_inz      pr

      * ------------------------------------------------------------ *
      * SVPEMP_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPEMP_end      pr

      * ------------------------------------------------------------ *
      * SVPEMP_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPEMP_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      * ---------------------------------------------------------------- *
      * SVPEMP_getNombre: Retorna Nombre de Empresa                      *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *                                                                  *
      * Retorna Nombre de Empresa / Blanco                               *
      * ---------------------------------------------------------------- *
     D SVPEMP_getNombre...
     D                 pr            50
     D   peEmpr                       1      const

      * ---------------------------------------------------------------- *
      * SVPEMP_getPais: Retorna Pais de la Empresa                       *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *                                                                  *
      * Retorna Nombre de Empresa / Blanco                               *
      * ---------------------------------------------------------------- *
     D SVPEMP_getPais...
     D                 pr            30
     D   peEmpr                       1      const
03689 * ---------------------------------------------------------------- *
03689 * SVPEMP_getCompaniaSSN: Retorna Codigo de compañia de la SSN      *
03689 *                                                                  *
03689 *      peEmpr  (imput ) Empresa                                    *
03689 *                                                                  *
03689 * Retorna Codigo SSN / Zeros                                       *
03689 * ---------------------------------------------------------------- *
03689D SVPEMP_getCompaniaSSN...
03689D                 pr            13  0
03689D   peEmpr                       1      const
03689
03689 * ---------------------------------------------------------------- *
03689 * SVPEMP_getCUIT : Retorna CUIT de HDI                             *
03689 *                                                                  *
03689 *      peEmpr  (imput ) Empresa                                    *
03689 *                                                                  *
03689 * Retorna CUIT / blancos                                           *
03689 * ---------------------------------------------------------------- *
03689D SVPEMP_getCUIT...
03689D                 pr            11
03689D   peEmpr                       1      const
03689
