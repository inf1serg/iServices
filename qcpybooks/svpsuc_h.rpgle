      /if defined(SVPSUC_H)
      /eof
      /endif
      /define SVPSUC_H

      /copy './qcpybooks/wsstruc_h.rpgle'

      * --------------------------------------------------- *
      * Estrucutura de datos GNTSUC                         *
      * --------------------------------------------------- *
     D SVPSUC_ERDS_T   ds                  qualified
     D                                     based(template)
      * --------------------------------------------------- *
      * Estrucutura de Caracteristicas
      * --------------------------------------------------- *
     D dsGntsuc_t      ds                  qualified template
     D   suempr                       1
     D   susucu                       2
     D   sunsul                      30
     D   sunsuc                       5
     D   sudirs                      25
     D   sucopo                       5p 0
     D   sucops                       1p 0
     D   sutisu                       2
     D   suagsu                       2
     D   subloq                       1
     D   suemp1                       1
     D   susuc1                       2
     D   sunbi1                      10
     D   sufdia                       2p 0
     D   sufmes                       2p 0
     D   sufaÑo                       2p 0
     D   sucn03                       3p 0
     D   sucn05                       5p 0
     D   sumar1                       1
     D   sumar2                       1
     D   sumar3                       1
     D   sumar4                       1
     D   sumar5                       1
     D   suipg1                      10
     D   suipg2                      10

      * ---------------------------------------------------------------- *
      * SVPSUC_getDatosDeSucursal: Retorna datos de la Empresa/Sucursal  *
      *                                                                  *
      *      peEmpr  (imput)  Empresa                                    *
      *      peSucu  (imput)  Sucursal                                   *
      *      peDsSUC (output) Datos de SUCresa ( opcional )              *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     D SVPSUC_getDatosDeSucursal...
     D                 pr              n
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peDsSuc                           likeds(dsgntsuc_t)
     D                                     options(*nopass:*omit)

      * ------------------------------------------------------------ *
      * SVPSUC_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPSUC_inz      pr

      * ------------------------------------------------------------ *
      * SVPSUC_end(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     D SVPSUC_end      pr

      * ------------------------------------------------------------ *
      * SVPSUC_error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *
     D SVPSUC_error    pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

