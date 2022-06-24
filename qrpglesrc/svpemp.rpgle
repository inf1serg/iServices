     H nomain
     H datedit(*DMY/)
      * ************************************************************ *
      * SVPEMP: Programa de Servicio.                                *
      *         Datos de Empresa                                     *
      * ------------------------------------------------------------ *
      * Gomez Luis R.                        24-01-2017              *
      *------------------------------------------------------------- *
      * Modificaciones:                                              *
      * LRG 24-01-2018 : Nuevo Procedimientos(): getNombre()         *
      *                                          getPais()           *
      * LRG 03-01-2019 : RM#03689 Requerimiento SSN                  *
      *                                                              *
      * ************************************************************ *
     Fgntemp    if   e           k disk

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/SVPEMP_H.rpgle'

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1N

      *--- Definicion de Procedimiento ----------------------------- *

      * ---------------------------------------------------------------- *
      * SVPEMP_getDatosDeEmpresa: Retorna datos de la Empresa            *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *      peDsEmp (output) Datos de Empresa ( opcional )              *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     P SVPEMP_getDatosDeEmpresa...
     P                 B                   export
     D SVPEMP_getDatosDeEmpresa...
     D                 pi              n
     D   peEmpr                       1    const
     D   peDsEmp                           likeds(dsGntemp_t)
     D                                     options(*nopass:*omit)

     D dsEmpr          ds                  likerec(g1temp:*input)

      /free

       SVPEMP_inz();
       chain peEmpr gntemp dsEmpr;
       if not %found( gntemp );
         return *off;
       endif;

       if %parms >= 2 and %addr( peDsEmp ) <> *null;
         eval-corr peDsEmp = dsEmpr;
       endif;

       return *on;

      /end-free

     P SVPEMP_getDatosDeEmpresa...
     P                 E
      * ---------------------------------------------------------------- *
      * SVPEMP_getLocalidadDeEmpresa: Retorna la localidad de la empresa *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *      peCopo  (output) Código Postal                              *
      *      peCops  (output) Sufijo del Código Postal                   *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     P SVPEMP_getLocalidadDeEmpresa...
     P                 B                   export
     D SVPEMP_getLocalidadDeEmpresa...
     D                 pi              n
     D   peEmpr                       1      const
     D   peCopo                       5  0
     D   peCops                       1  0

     D   @@DsEmp       ds                  likeds(dsGntemp_t)

      /free

       clear peCopo;
       clear peCops;

       SVPEMP_inz();
       if SVPEMP_getDatosDeEmpresa( peEmpr
                                  : @@DsEmp );

         peCopo = @@DsEmp.emcopo;
         peCops = @@DsEmp.emcops;

         return *on;
       endif;

       return *off;

      /end-free

     P SVPEMP_getLocalidadDeEmpresa...
     P                 E
      * ------------------------------------------------------------ *
      * SVPEMP_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPEMP_inz      B                   export
     D SVPEMP_inz      pi

      /free

       if not %open(gntemp);
         open gntemp;
       endif;

       initialized = *ON;
       return;

      /end-free

     P SVPEMP_inz      E

      * ------------------------------------------------------------ *
      * SVPEMP_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P SVPEMP_End      B                   export
     D SVPEMP_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPEMP_End      E

      * ------------------------------------------------------------ *
      * SVPEMP_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P SVPEMP_Error    B                   export
     D SVPEMP_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P SVPEMP_Error    E

      * ------------------------------------------------------------ *
      * SetError(): Setea último error y mensaje.                    *
      *                                                              *
      *     peErrn   (input)   Número de error a setear.             *
      *     peErrm   (input)   Texto del mensaje.                    *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *

     P SetError        B
     D SetError        pi
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

      /free

       ErrN = peErrn;
       ErrM = peErrm;

      /end-free

     P SetError...
     P                 E
      * ---------------------------------------------------------------- *
      * SVPEMP_getNombre: Retorna Nombre de Empresa                      *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *                                                                  *
      * Retorna Nombre de Empresa / Blanco                               *
      * ---------------------------------------------------------------- *
     P SVPEMP_getNombre...
     P                 B                   export
     D SVPEMP_getNombre...
     D                 pi            50
     D   peEmpr                       1    const

     D   @@DsEmp       ds                  likeds(dsGntemp_t)

      /free

       SVPEMP_inz();
       clear @@DsEmp;

       if SVPEMP_getDatosDeEmpresa( peEmpr
                                  : @@DsEmp );
         return @@DsEmp.emneml;
       endif;

       return *blanks;

      /end-free

     P SVPEMP_getNombre...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMP_getPais: Retorna Nombre de Empresa                        *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *                                                                  *
      * Retorna Nombre de Empresa / Blanco                               *
      * ---------------------------------------------------------------- *
     P SVPEMP_getPais...
     P                 B                   export
     D SVPEMP_getPais...
     D                 pi            30
     D   peEmpr                       1    const

     D   @@DsEmp       ds                  likeds(dsGntemp_t)

      /free

       SVPEMP_inz();
       clear @@DsEmp;

       if SVPEMP_getDatosDeEmpresa( peEmpr
                                  : @@DsEmp );
         return @@DsEmp.empaid;
       endif;

       return *blanks;

      /end-free

     P SVPEMP_getPais...
     P                 E

      * ---------------------------------------------------------------- *
      * SVPEMP_getCompaniaSSN: Retorna Codigo de compañia de la SSN      *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *                                                                  *
      * Retorna Codigo SSN / Zeros                                       *
      * ---------------------------------------------------------------- *
     P SVPEMP_getCompaniaSSN...
     P                 B                   export
     D SVPEMP_getCompaniaSSN...
     D                 pi            13  0
     D   peEmpr                       1    const

     D   @@DsEmp       ds                  likeds(dsGntemp_t)

      /free

       SVPEMP_inz();
       clear @@DsEmp;

       if SVPEMP_getDatosDeEmpresa( peEmpr
                                  : @@DsEmp );
         return @@DsEmp.emnier;
       endif;

       return *zeros;

      /end-free

     P SVPEMP_getCompaniaSSN...
     P                 e

      * ---------------------------------------------------------------- *
      * SVPEMP_getCUIT : Retorna CUIT de HDI                             *
      *                                                                  *
      *      peEmpr  (imput ) Empresa                                    *
      *                                                                  *
      * Retorna CUIT / blancos                                           *
      * ---------------------------------------------------------------- *
     P SVPEMP_getCUIT...
     P                 B                   export
     D SVPEMP_getCUIT...
     D                 pi            11
     D   peEmpr                       1    const

     D   @@DsEmp       ds                  likeds(dsGntemp_t)

      /free

       SVPEMP_inz();
       clear @@DsEmp;

       if SVPEMP_getDatosDeEmpresa( peEmpr
                                  : @@DsEmp );
         return @@DsEmp.emcuit;
       endif;

       return *blanks;

      /end-free

     P SVPEMP_getCUIT...
     P                 e
