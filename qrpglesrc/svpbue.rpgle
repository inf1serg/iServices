     H nomain
      * ************************************************************ *
      * SVPBUE: exportación SVPBUE                                   *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     06-Ene-2017             *
      * ------------------------------------------------------------ *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: DLTSRVPGM SRVPGM(&L/&N)                   <*           *
      *> CRTRPGMOD MODULE(QTEMP/&N) -                   <*           *
      *>           SRCFILE(&L/&F) SRCMBR(*MODULE) -     <*           *
      *>           DBGVIEW(&DV)                         <*           *
      *> CRTSRVPGM SRVPGM(&O/&ON) -                     <*           *
      *>           MODULE(QTEMP/&N) -                   <*           *
      *>           EXPORT(*SRCFILE) -                   <*           *
      *>           SRCFILE(HDIILE/QSRVSRC) -            <*           *
      *> TEXT('Programa de Servicio: Buen Resultado') <*        *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPBUE)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((SVPBUE)) <*         *
      *> IGN: DLTSPLF FILE(SVPBUE)                           <*     *
      * ----------------------------------------------------------- *
      * Modificaciones:                                             *
      *   JSN 27/01/2020 - Se agrega nuevo procedimiento:           *
      *                    SVPBUE_getPorceBuenResultado.-           *
      *                                                             *
      ***************************************************************
     Fset245    if   e           k disk    usropn
     Fsetbre    if   e           k disk    usropn
      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpbue_h.rpgle'

     D Initialized     s              1n
     D wrepl           s          65535a
     D ErrN            s             10i 0
     D ErrM            s             80a


     D WSLOG           pr                  extpgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

     D SetError        pr
     D  peErrn                       10i 0 const
     D  peErrm                       80a   const

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

      *--- Definicion de Procedimiento ----------------------------- *
      * ----------------------------------------------------------------- *
      * SVPBUE_chkProductorEspecial(): Retorna datos de productos especial*
      *                                                                   *
      *    peEmpr  (imput) Empresa                                        *
      *    peSucu  (imput) Sucursal                                       *
      *    peNivt  (imput) Tipo Nivel Intermed.                           *
      *    peNivc  (imput) Código Nivel Intermed.                         *
      *    peFech  (imput) Fecha de Vigencia                              *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPBUE_chkProductorEspecial...
     P                 B                   export
     D SVPBUE_chkProductorEspecial...
     D                 pi              n
     D   peEmpr                       1A   const
     D   peSucu                       5A   const
     D   peNivt                       1  0 const
     D   peNivc                       5  0 const
     D   peFech                       8  0 options(*nopass:*omit)

     D   @@dd          s              2  0
     D   @@mm          s              2  0
     D   @@aa          s              4  0
     D   @@fech        s              8  0
      *
     D k1y245          ds                  likerec(c1s245:*key)

      /Free

       SVPBUE_inz();

       if %parms >= 5 and %addr( peFech ) <> *Null;
         @@fech = peFech;
       else;
         PAR310X3 ( peEmpr : @@aa : @@mm : @@dd );
         @@fech = (@@aa * 10000) + (@@mm * 100) + @@dd;
       endif;

       k1y245.t@empr = peEmpr;
       k1y245.t@sucu = peSucu;
       k1y245.t@nivt = peNivt;
       k1y245.t@nivc = peNivc;
       k1y245.t@fvig = @@fech;
       setll %kds(k1y245:5) set245;
       reade %kds(k1y245:4) set245;
         if not %eof( set245 ) and t@aplc = '1';
           return *on;
         endif;

       return *off;

       SVPBUE_End();

      /end-free

     P SVPBUE_chkProductorEspecial...
     P                 E
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
     P SVPBUE_getListaBuenResultado...
     P                 B                   export
     D SVPBUE_getListaBuenResultado...
     D                 pi              n
     D   peBure                       1  0 const
     D   peLbure                           likeds(dsBure_t) dim(99)
     D   peLbureC                    10i 0

     D   x             s             10i 0
     D   z             s             10i 0

      /free

       clear peLbure;
       peLbureC = peBure +1;
       if peLbureC > 4;
          peLbureC = 4;
       endif;

       x = 1;
       peLbure( x ).bure = 0;
       peLbure( x ).desc = 'Ninguno';

       z = 0;

       for x = 2 to peLbureC;
         peLbure( x ).bure = x - 1 ;
         z += 1;
         if x - 1 = 1;
           peLbure( x ).desc = '1 Año Sin Siniestros';
         else;
           peLbure( x ).desc = %trim(%char(z)) + ' Años Sin Siniestros';
         endif;
       endfor;

       return *on;

      /end-free
     P SVPBUE_getListaBuenResultado...
     P                 E
      * ------------------------------------------------------------ *
      * SVPBUE_inz(): Inicializa módulo.                             *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPBUE_inz      B                   export
     D SVPBUE_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(set245);
          open set245;
       endif;

       if not %open(setbre);
          open setbre;
       endif;

      /end-free

     P SVPBUE_inz      E
      * ------------------------------------------------------------ *
      * SVPBUE_End(): Finaliza módulo.                               *
      *                                                              *
      * ------------------------------------------------------------ *
     P SVPBUE_End      B                   export
     D SVPBUE_End      pi

      /free

       close *all;
       initialized = *OFF;

       return;

      /end-free

     P SVPBUE_End      E
      * ----------------------------------------------------------------- *
      * SVPBUE_getPorceBuenResultado(): Retorna Porcentaje de Buen        *
      *                                 Resultado.-                       *
      *                                                                   *
      *          peBure   (input)   Años de Buen Resultado                *
      *                                                                   *
      * retorna *on / *off                                                *
      * ----------------------------------------------------------------- *
     P SVPBUE_getPorceBuenResultado...
     P                 B                   export
     D SVPBUE_getPorceBuenResultado...
     D                 pi             5  2
     D   peBure                       2  0 const

      /free

       SVPBUE_inz();

       setll peBure setbre;
       if %equal(setbre);
         reade peBure setbre;
       else;
         setgt *loval setbre;
         readp setbre;
       endif;

       if not %eof(setbre);
         return sepbon;
       endif;

      /end-free

     P SVPBUE_getPorceBuenResultado...
     P                 E
