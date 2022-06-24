     H nomain
      * ************************************************************ *
      * SVPLRC:   Programa de Servicio - Recupera Límites de RC      *
      *           para Autos.                                        *
      *                                                              *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(*LIBL/&N)                <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *> TEXT('Recupera Límites de RC')                 <*           *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez              * 24-Feb-2014                  *
      * ------------------------------------------------------------ *
      * SGF 18/06/2014: Agrego SVPLRC_getInicioDeVigeSpol().         *
      *                                                              *
      * ************************************************************ *
     Fset2271   if   e           k disk    usropn
     Fpahed004  if   e           k disk    usropn
     Fpahec0    if   e           k disk    usropn

      /copy './qcpybooks/svplrc_h.rpgle'

     D SetError        pr
     D   peErrn                      10i 0
     D   peErrm                      80a

     D PAR310X3        pr                  extpgm('PAR310X3')
     D  peEmpr                        1a   const
     D  peFema                        4  0
     D  peFemm                        2  0
     D  peFemd                        2  0

     D errn            s             10i 0
     D errm            s             80a
     D Initialized     s              1n

      * ------------------------------------------------------------ *
      * Inz():   Inicializa módulo.                                  *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPLRC_Inz      B                   export
     D SVPLRC_Inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set2271);
          open set2271;
       endif;

       if not %open(pahed004);
          open pahed004;
       endif;

       if not %open(pahec0);
          open pahec0;
       endif;

       initialized = *ON;

      /end-free

     P SVPLRC_Inz      E

      * ------------------------------------------------------------ *
      * End():   Finaliza módulo.                                    *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPLRC_End      B                   export
     D SVPLRC_End      pi

      /free

       close *all;
       Initialized = *OFF;

      /end-free

     P SVPLRC_End      E

      * ------------------------------------------------------------ *
      * Error(): Retorna último error del módulo.                    *
      *                                                              *
      *       peErrn    (output)   Código de Error (opcional)        *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPLRC_Error    B                   export
     D SVPLRC_Error    pi            80a
     D   peErrn                      10i 0 options(*nopass)

      /free

       if %parms >= 1;
          peErrn = errn;
       endif;

       return errm;

      /end-free

     P SVPLRC_Error    E

      * ------------------------------------------------------------ *
      * getLimiteRc():   Retorna límite de RC a una fecha.           *
      *                                                              *
      *       peEmpr    (input)  Empresa                             *
      *       peSucu    (input)  Sucursal                            *
      *       peFemi    (input)  Fecha de Emisión (aaammdd). Opcional*
      *                                                              *
      * retorna: Límite de RC o 0 si no encuentra.                   *
      * ------------------------------------------------------------ *
     P SVPLRC_getLimiteRc...
     P                 B                   export
     D SVPLRC_getLimiteRc...
     D                 pi            15  2
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peFemi                       8  0 const options(*nopass:*omit)

     D @femi           s              8  0
     D @rcli           s             15  2
     D peFema          s              4  0
     D peFemm          s              2  0
     D peFemd          s              2  0
     D found           s              1N

      /free

       SVPLRC_inz();

       if %parms >= 3 and %addr(peFemi) <> *NULL;
          @femi = peFemi;
          if (@femi = 0);
             PAR310X3( peEmpr: peFema: peFemm: peFemd);
             @femi = (peFema * 10000)
                   + (peFemm * 100)
                   +  peFemd;
          endif;
        else;
          PAR310X3( peEmpr: peFema: peFemm: peFemd);
          @femi = (peFema * 10000)
                + (peFemm * 100)
                +  peFemd;
       endif;

       setll *start set2271;
       read set2271;

       dow not %eof;

           if ( t@femi <= @femi);
              @rcli = t@rcli;
              found = *on;
           endif;

        read set2271;

       enddo;

       if not found;
          @rcli = 3000000;
       endif;

       return @rcli;

      /end-free

     P                 E

      * ------------------------------------------------------------ *
      * SetError():  Establece último error del módulo.              *
      *                                                              *
      *       peErrn    (input)    Código de Error                   *
      *       peErrm    (input)    Mensaje de Error                  *
      *                                                              *
      * ------------------------------------------------------------ *
     P SetError        B
     D SetError        pi
     D   peErrn                      10i 0
     D   peErrm                      80a

      /free

       errn = peErrn;
       errm = peErrm;

      /end-free

     P SetError        E

      * ------------------------------------------------------------ *
      * getInicioVigencia():  Obtiene fecha de inicio de póliza      *
      *                                                              *
      *       peEmpr    (input)  Empresa                             *
      *       peSucu    (input)  Sucursal                            *
      *       peRama    (input)  Rama                                *
      *       pePoli    (input)  Póliza                              *
      *                                                              *
      * retorna: Fecha de inicio de vigencia.                        *
      * ------------------------------------------------------------ *
     P SVPLRC_getInicioDeVigencia...
     P                 B                   export
     D SVPLRC_getInicioDeVigencia...
     D                 pi             8  0
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const

     D k1hed0          ds                  likerec(p1hed004:*key)

      /free

       SVPLRC_inz();

       k1hed0.d0empr = peEmpr;
       k1hed0.d0sucu = peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       k1hed0.d0suop = 0;
       chain %kds(k1hed0:5) pahed004;
       if not %found;
          return 0;
       endif;

       return (d0fioa * 10000) + (d0fiom * 100) + d0fiod;

      /end-free

     P SVPLRC_getInicioDeVigencia...
     P                 E

      * ------------------------------------------------------------ *
      * getInicioVigeSpol():  Obtiene fecha de inicio de superpóliza *
      *                                                              *
      *       peEmpr    (input)  Empresa                             *
      *       peSucu    (input)  Sucursal                            *
      *       peArcd    (input)  Artículo                            *
      *       peSpol    (input)  SuperPóliza                         *
      *                                                              *
      * retorna: Fecha de inicio de vigencia.                        *
      * ------------------------------------------------------------ *
     P SVPLRC_getInicioDeVigeSpol...
     P                 B                   export
     D SVPLRC_getInicioDeVigeSpol...
     D                 pi             8  0
     D   peEmpr                       1a   const
     D   peSucu                       2a   const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const

     D k1hec0          ds                  likerec(p1hec0:*key)

      /free

       SVPLRC_inz();

       k1hec0.c0empr = peEmpr;
       k1hec0.c0sucu = peSucu;
       k1hec0.c0arcd = peArcd;
       k1hec0.c0spol = peSpol;
       chain %kds(k1hec0:4) pahec0;
       if not %found;
          return 0;
       endif;

       return (c0fioa * 10000) + (c0fiom * 100) + c0fiod;

      /end-free

     P SVPLRC_getInicioDeVigeSpol...
     P                 E

