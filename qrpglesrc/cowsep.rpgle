     H nomain
     H option(*noshowcpy)
     H datedit(*DMY/)
      * ************************************************************ *
      * COWSEP: Cotización SEPELIO                                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *20-Abr-2020            *
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
      *>           BNDDIR(HDIILE/HDIBDIR) -             <*           *
      *> TEXT('Programa de Servicio: Cotización Sepelio')   <*       *
      *> IGN: DLTMOD MODULE(QTEMP/&N)                   <*           *
      *> IGN: RMVBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWSEP)) <*    *
      *> ADDBNDDIRE BNDDIR(HDIILE/HDIBDIR) OBJ((COWSEP)) <*         *
      *> IGN: DLTSPLF FILE(COWSEP)                           <*     *
      *                                                              *
      * ************************************************************ *
      *                                                              *
      * ************************************************************ *
     Fctwsep    uf a e           k disk    usropn
     Fctwse1    uf a e           k disk    usropn
     Fctw000    if   e           k disk    usropn
     Fctw001    uf   e           k disk    usropn
     Fctw001c   uf   e           k disk    usropn
     Fset068    if   e           k disk    usropn
     Fset103    if   e           k disk    usropn
     Fset100    if   e           k disk    usropn
     Fset10301  if   e           k disk    usropn

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/COWSEP_h.rpgle'

     D PRO401U3        pr                  extpgm('PRO401U3')
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2

     D PRO401U1        pr                  extpgm('PRO401U1')
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2
     D                                5  2
     D                                5  2
     D                               15  2
     D                               15  2
     D                               15  2
     D                                5  2

      * --------------------------------------------------- *
      * Setea error global
      * --------------------------------------------------- *
     D SetError        pr
     D  ErrN                         10i 0 const
     D  ErrM                         80a   const

     D cleanUp         pr             1N
     D  peMsid                        7a   const

     D ErrN            s             10i 0
     D ErrM            s             80a

     D Initialized     s              1n

     D wrepl           s          65535a
     D ErrCode         s             10i 0
     D ErrText         s             80A

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

      * ------------------------------------------------------------ *
      * COWSEP_inz(): Inicializa módulo.                             *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWSEP_inz      B                   export
     D COWSEP_inz      pi

      /free

       if (initialized);
          return;
       endif;

       if not %open(ctwsep);
         open ctwsep;
       endif;

       if not %open(ctwse1);
         open ctwse1;
       endif;

       if not %open(ctw000);
         open ctw000;
       endif;

       if not %open(ctw001);
         open ctw001;
       endif;

       if not %open(ctw001c);
         open ctw001c;
       endif;

       if not %open(set068);
         open set068;
       endif;

       if not %open(set100);
         open set100;
       endif;

       if not %open(set103);
         open set103;
       endif;

       if not %open(set10301);
         open set10301;
       endif;

       initialized = *ON;
       return;

      /end-free

     P COWSEP_inz      E

      * ------------------------------------------------------------ *
      * COWSEP_End(): Finaliza módulo.                               *
      *                                                              *
      * void                                                         *
      * ------------------------------------------------------------ *
     P COWSEP_End      B                   export
     D COWSEP_End      pi

      /free

       close(E) *all;
       initialized = *OFF;

       return;

      /end-free

     P COWSEP_End      E

      * ------------------------------------------------------------ *
      * COWSEP_Error(): Retorna el último error del service program  *
      *                                                              *
      *     peEnbr   (output)  Número de error (opcional)            *
      *                                                              *
      * Retorna: Mensaje de error.                                   *
      * ------------------------------------------------------------ *

     P COWSEP_Error    B                   export
     D COWSEP_Error    pi            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

      /free

       if %parms >= 1 and %addr(peEnbr) <> *NULL;
          peEnbr = ErrN;
       endif;

       return ErrM;

      /end-free

     P COWSEP_Error    E

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
      * COWSEP_cotizarWeb():  Recibe todos los datos para la póliza de   *
      *                       SEPELIO. Retorna la prima y el premio.     *
      *                                                                  *
      *       peBase ( input )  -  Base                                  *
      *       peNctw ( input )  -  Nro. de Cotización                    *
      *       peRama ( input )  -  Rama                                  *
      *       peArse ( input )  -  Cant. Pólizas por Rama                *
      *       peNrpp ( input )  -  Plan de Pago                          *
      *       peVdes ( input )  -  Fecha desde                           *
      *       peXpro ( input )  -  Codigo de plan                        *
      *       peClie ( input )  -  Datos del Cliente                     *
      *       peCsep ( input )  -  Componente de Sepelio                 *
      *       peImpu ( input )  -  Impuestos                             *
      *       pePrim ( output ) -  Prima                                 *
      *       pePrem ( output ) -  Premio                                *
      *       peErro ( output ) -  Indicador de Error                    *
      *       peMsgs ( output ) -  Estructura de Error                   *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWSEP_cotizarWeb...
     P                 B                   export
     D COWSEP_cotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peCsep                            likeds(CompSepelio_t)
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D rc              s              1n
     D @@cfpg          s              1  0
     D @1prim          s             15  2
     D @1prem          s             15  2
     D @@impu          ds                  likeds(Impuesto)

      /free

       COWSEP_inz();

       clear peErro;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase :
                                                               peNctw )
                                       : peNrpp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrpp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       // --------------------------------------------
       // Eliminar Residual
       // --------------------------------------------
       COWSEP_delCotizacion( peBase : peNctw );

       // --------------------------------------------
       // Validaciones iniciales
       // --------------------------------------------
       COWSEP_chkCotizar ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : peCsep.paco
                         : peCsep.cant
                         : peClie.tipe
                         : peClie.civa
                         : @@Cfpg
                         : peVdes
                         : peXpro
                         : peClie.Copo
                         : peClie.Cops
                         : peCsep.Raed
                         : peCsep.Cobe
                         : peCsep.CobeC
                         : peErro
                         : peMsgs       );

       if peErro <> *Zeros;
          return;
       endif;

       COWGRAI_deleteImpuesto ( peBase : peNctw : peRama );

       COWGRAI_setCondComerciales( peBase : peNctw :peRama :peArse );

       COWSEP_cotizador( peBase
                       : peNctw
                       : peRama
                       : peArse
                       : peCsep.Paco
                       : peCsep.Cant
                       : peClie.tipe
                       : peClie.civa
                       : peNrpp
                       : @@Cfpg
                       : peVdes
                       : peXpro
                       : peClie.Copo
                       : peClie.Cops
                       : peCsep.raed
                       : peCsep.cobe
                       : peCsep.cobeC
                       : @1prim
                       : @1prem
                       : peErro
                       : peMsgs       );

       pePrim = @1prim;
       pePrem = @1Prem;
       peCsep.Prim = pePrim;
       peCsep.Prim = pePrem;

       clear @@impu;
       rc = COWGRAI_getImpuestosCotizacion( peBase
                                          : peNctw
                                          : peRama
                                          : @@impu );
       peImpu = @@impu;

       return;

      /end-free

     P COWSEP_cotizarWeb...
     P                 E

      * ---------------------------------------------------------------- *
      * COWSEP_delCotizacion(): Elimina todos los datos cargados de la   *
      *                         Cotizacion.                              *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     P COWSEP_delCotizacion...
     P                 B                   export
     D COWSEP_delCotizacion...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

      /free

       if not COWSEP_delCabeceraSepelio( peBase : peNctw );
          return *off;
       endif;

       if not COWSEP_delCoberturasSepelio( peBase : peNctw );
          return *off;
       endif;

       return *on;

      /end-free

     P COWSEP_delCotizacion...
     P                 e

      * ---------------------------------------------------------------- *
      * COWSEP_delCabeceraSepelio(): Elimina Cabcera Sepelio (CTWSEP)    *
      *                         Cotizacion.                              *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     P COWSEP_delCabeceraSepelio...
     P                 B                   export
     D COWSEP_delCabeceraSepelio...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1wsep          ds                  likerec(c1wsep:*key)

      /free

       COWSEP_inz();

       k1wsep.epempr = peBase.peEmpr;
       k1wsep.epsucu = peBase.peSucu;
       k1wsep.epnivt = peBase.peNivt;
       k1wsep.epnivc = peBase.peNivc;
       k1wsep.epnctw = peNctw;
       setll %kds(k1wsep:5) ctwsep;
       reade %kds(k1wsep:5) ctwsep;
       dow not %eof;
           delete c1wsep;
        reade %kds(k1wsep:5) ctwsep;
       enddo;

       return *on;

      /end-free

     P COWSEP_delCabeceraSepelio...
     P                 E

      * ---------------------------------------------------------------- *
      * COWSEP_delCoberturasSepelio: Elimina Coberturas Sepelio (CTWSE1) *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *                                                                  *
      * Retorna: *on / *off;                                             *
      * ---------------------------------------------------------------- *
     P COWSEP_delCoberturasSepelio...
     P                 b                   export
     D COWSEP_delCoberturasSepelio...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const

     D k1wse1          ds                  likerec(c1wse1:*key)

      /free

       COWSEP_inz();

       k1wse1.e1empr = peBase.peEmpr;
       k1wse1.e1sucu = peBase.peSucu;
       k1wse1.e1nivt = peBase.peNivt;
       k1wse1.e1nivc = peBase.peNivc;
       k1wse1.e1nctw = peNctw;
       setll %kds(k1wse1:5) ctwse1;
       reade %kds(k1wse1:5) ctwse1;
       dow not %eof;
           delete c1wse1;
        reade %kds(k1wse1:5) ctwse1;
       enddo;

       return *on;

      /end-free

     P COWSEP_delCoberturasSepelio...
     P                 e

      * ---------------------------------------------------------------- *
      * COWSEP_chkCotizar ():  Valida Cotizacion                         *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. Pólizas por Rama                 *
      *       pePaco ( input )  - Parentesco                             *
      *       peCant ( input )  - Cantidad de Componentes                *
      *       peTipe ( input )  - Tipo                                   *
      *       peCiva ( input )  - Condicion de IVA                       *
      *       peCfpg ( input )  - Forma de Pago                          *
      *       peVdes ( input )  - Fecha desde                            *
      *       peXpro ( input )  - Producto                               *
      *       peCopo ( input )  - Codigo Postal                          *
      *       peCops ( input )  - Sub. Codigo Postal                     *
      *       peRaed ( input )  - Rango de Edad                          *
      *       peCobe ( input )  - Coberturas                             *
      *       peCobeC( input )  - Cant. de Coberturas                    *
      *       peErro ( output ) - Marca de Erorr                         *
      *       peMsgs ( output ) - Mensaje de Error                       *
      *                                                                  *
      * Retorna: peErro = '0' / '-1'                                     *
      * ---------------------------------------------------------------- *
     P COWSEP_chkCotizar...
     P                 B                   export
     D COWSEP_chkCotizar...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peCant                       6  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peCfpg                       3  0 const
     D   peVdes                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       1  0 const
     D   peCobe                            likeds(Cobprima) dim(20) const
     D   peCobeC                     10i 0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D p@Tiou          s              1  0
     D p@Stou          s              2  0
     D p@Stos          s              2  0
     D x               s             10i 0
     D y               s             10i 0
     D p@Poco          s              6  0
     D @@Lcob          s              3  0 dim(20)
     D @@LcobC         s             10i 0
     D p@Lcob          s              3  0 dim(20)
     D p@LcobC         s             10i 0
     D @@fch1          s               d   datfmt(*iso) inz
     D @@fch2          s              8  0

      /free

       COWSEP_inz();

       peErro = *Zeros;

       if not SVPVAL_arcdRamaArse( COWGRAI_getArticulo ( peBase
                                                       : peNctw )
                                 : peRama
                                 : peArse );

         %subst(wrepl:1:6) = %editc( COWGRAI_getArticulo ( peBase
                                                         : peNctw ):'X');
         %subst(wrepl:7:2) = %editc(peRama:'X');
         %subst(wrepl:9:2) = %editc(peArse:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0111'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;


       if peCant > 10;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0202'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;
       endif;

       //Valido ParmBase
       if SVPWS_chkParmBase ( peBase : peMsgs ) = *off;
          peErro = -1;
          return;
       endif;

       //Valido Cotización
       if COWGRAI_chkCotizacion ( peBase : peNctw ) = *off;

         ErrText = COWGRAI_Error(ErrCode);

         if COWGRAI_COTNP = ErrCode;

           %subst(wrepl:1:7) = %editc(peNctw:'X');
           %subst(wrepl:9:1) = %editc(peBase.peNivt:'X');
           %subst(wrepl:11:5) = %editc(peBase.peNivc:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0008'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama que pueda emitir en web
       if SVPVAL_ramaWeb ( peRama ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_RAMNW = ErrCode;

           %subst(wrepl:1:2) = %editc(peRama:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0020'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       //Valido que sea una rama de Vida
       if SVPWS_getGrupoRama ( peRama ) <> 'S';

         %subst(wrepl:1:2) = %editc ( peRama : 'X' );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0067'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         peErro = -1;
         return;

       endif;

       //Valido Forma de Pago
       if SVPVAL_formaDePagoWeb ( peCfpg ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_FDPNW = ErrCode;

           %subst(wrepl:1:1) =  %editc ( peCfpg : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0026'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Tipo de Persona
       if SVPVAL_tipoPersona ( peTipe ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_TPENV = ErrCode;

           %subst(wrepl:1:1) =  peTipe;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0015'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;
       endif;

       //Valido Tipo de Iva
       if SVPVAL_ivaWeb ( peCiva ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_IVANE = ErrCode;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         elseif SVPVAL_IVANW = ErrCode;

           %subst(wrepl:1:2) =  %editc( peCiva : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0010'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
         endif;

         peErro = -1;
         return;
       endif;

       //Valido Fecha de Inicio
       test(DE) *iso peVdes;
       if %error;

         %subst(wrepl:1:8) = %editc(peVdes :'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0010'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       //Coberturas(Prima)...
       for x = 1 to peCobeC;
         if not SVPVAL_chkCobPrima( peRama
                                  : peXpro
                                  : peCobe(x).riec
                                  : peCobe(x).xcob
                                  : COWGRAI_monedaCotizacion( peBase
                                                            : peNctw));

           %subst(wrepl:1:3) =  peCobe(x).riec;
           %subst(wrepl:3:5) =  %editc( peCobe(x).xcob : 'X' );
           %subst(wrepl:6:7) =  %editc( peRama : 'X' );

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0036'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );
           peErro = -1;
           return;
        endif;
       endfor;

       // Valida la suma asegurada ingresada por cobertura
       for x = 1 to peCobeC;
         if not SVPVAL_CHKCobSumMaxMin( peRama
                                      : peXpro
                                      : peCobe(x).riec
                                      : peCobe(x).xcob
                                      : COWGRAI_monedaCotizacion( peBase
                                                                : peNctw)
                                      : peCobe(x).sac1
                                      : peCobe );

           %subst(wrepl:1:40) =  %trim( SVPDES_cobLargo ( peRama :
                                                          peCobe(x).xcob));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0021'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;
         endif;
       endfor;

       // Valida coberturas excluyentes entre si
       clear p@Lcob;

       for y = 1 to peCobeC;

          p@Lcob(y) = peCobe(y).xcob;
          p@LcobC += 1;

       endfor;

       if not SVPCOB_ValCoberturasBasicas( peRama
                                         : peXpro
                                         : peCobe(1).riec
                                         : COWGRAI_monedaCotizacion( peBase
                                                                   : peNctw)
                                         : p@Lcob  );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0123'
                      : peMsgs     );
         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;

       if not SVPCOB_ValListCobExcluyentes ( peRama :
                                             peXpro :
                                             peCobe(1).riec :
                                             COWGRAI_monedaCotizacion( peBase
                                                                     : peNctw):
                                             p@Lcob  :
                                             p@LcobC );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0121'
                      : peMsgs     );

         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;


       if not SVPCOB_ValListCobReglas ( peRama :
                                        peXpro :
                                        peCobe(1).riec :
                                        COWGRAI_monedaCotizacion( peBase
                                                                : peNctw):
                                        p@Lcob  :
                                        p@LcobC );
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0122'
                      : peMsgs     );

         peMsgs.peMsg2 = SVPCOB_Error();

         peErro = -1;
         return;

       endif;

       //Valido Código Postal
       if SVPVAL_codigoPostal ( peCopo
                              : peCops ) = *off;

         ErrText = SVPVAL_Error(ErrCode);

         if SVPVAL_COPNE = ErrCode;

           %subst(wrepl:1:5) = %editc(peCopo:'X');
           %subst(wrepl:7:1) = %editc(peCops:'X');

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0003'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

         endif;

         peErro = -1;
         return;

       endif;

       return;

      /end-free

     P COWSEP_chkCotizar...
     P                 E

      * ---------------------------------------------------------------- *
      * COWSEP_cotizador ():  Recibe todos los datos del vehículo y de - *
      *                       vuelve las posibles coberturas, primas y   *
      *                       bonificaciones                             *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro de Cotizacion                      *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Cant. de Polizas por rama              *
      *       peCsep ( input )  - Componente de Sepelio                  *
      *       peTipe ( input )  - Tipo                                   *
      *       peCiva ( input )  - Condicion de IVA                       *
      *       peNrpp ( input )  - Plan de pago                           *
      *       peCfpg ( input )  - Forma de Pago                          *
      *       peVdes ( input )  - Fecha Desde                            *
      *       peXpro ( input )  - Producto                               *
      *       peCopo ( input )  - Codigo Postal                          *
      *       peCops ( input )  - Subfijo de Codigo Postal               *
      *       peRaed ( input )  - Rango de Edad                          *
      *       peCobe ( input )  - Coberturas                             *
      *       peCobeC( input )  - Cantidad de Coberturas                 *
      *       pePrim ( output ) - Prima                                  *
      *       pePrem ( output ) - Premio                                 *
      *       peErro ( output ) - Marca de Error                         *
      *       peMsgs ( output ) - Mensaje de Error                       *
      *                                                                  *
      * Retorna: peError = '0' / '-1'                                    *
      * ---------------------------------------------------------------- *
     P COWSEP_cotizador...
     P                 B                   export
     D COWSEP_cotizador...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peCant                       6  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peNrpp                       3  0 const
     D   peCfpg                       1  0 const
     D   peVdes                       8  0 const
     D   peXpro                       3  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peRaed                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peCobeC                     10i 0
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D @@Impu          ds                  likeds(Impuesto)
     D @@xpri          s              9  6
     D @@prim          s             15  2
     D p@Seri          s             15  2
     D p@Seem          s             15  2
     D p@Impi          s             15  2
     D p@Sers          s             15  2
     D p@Tssn          s             15  2
     D p@Ipr1          s             15  2
     D p@Ipr4          s             15  2
     D p@Ipr3          s             15  2
     D p@Ipr6          s             15  2
     D p@Ipr7          s             15  2
     D p@Ipr8          s             15  2
     D p@Ipr9          s             15  2
     D x               s             10i 0

      /free

       COWSEP_inz();

       peErro = *Zeros;

       COWGRAI_updCotizacion( peBase
                            : peNctw
                            : peCiva
                            : peTipe
                            : peCopo
                            : peCops
                            : peCfpg
                            : peNrpp
                            : peVdes
                            : *omit  );

       COWSEP_saveCabecera ( peBase
                           : peNctw
                           : peRama
                           : peArse
                           : pePaco
                           : peCant
                           : peRaed
                           : peCopo
                           : peCops
                           : peXpro      );

       for x = 1 to peCobeC;
           COWSEP_saveCoberturas( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : peCant
                                : peXpro
                                : pePaco
                                : peCobe(x).riec
                                : peCobe(x).xcob
                                : peCobe(x).sac1
                                : peRaed                );
       endfor;

       // ----------------------------------------
       // Buscar pormilaje y prima
       // ----------------------------------------
        COWSEP_setPormilajePrima( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : peCobe
                                : peCobeC );

       // Graba Impuestos - CTW001
       COWGRAI_SaveImpuestos2( peBase
                             : peNctw
                             : peRama
                             : peArse );

       for x = 1 to peCobeC;
           pePrim += peCobe(x).prim;
       endfor;

       COWGRAI_setDerechoEmi( peBase
                            : peNctw
                            : peRama
                            : pePrim  );

       //Premio final
       COWGRAI_getPremioFinal ( peBase : peNctw );

       if SVPVAL_chkPlanCerrado( peRama
                               : peXpro
                               : COWGRAI_monedaCotizacion( peBase
                                                         : peNctw) );
          COWSEP_planesCerrados ( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : peXpro );
       endif;

       pePrem = COWSEP_getPremio( peBase
                                : peNctw
                                : peRama
                                : peArse );

       Return;

      /end-free

     P COWSEP_cotizador...
     P                 E

      * ---------------------------------------------------------------- *
      * COWSEP_saveCabecera   (): Graba cabecera de la cotizacion de     *
      *                           Sepelio.                               *
      *        Input :                                                   *
      *                                                                  *
      *                peBase  -  Base                                   *
      *                peNctw  -  Número de Cotización                   *
      *                peRama  -  Rama                                   *
      *                peArse  -  Cant. Pólizas por Rama                 *
      *                pePoco  -  Nro. de Componente                     *
      *                pePaco  -  Código de Parentesco                   *
      *                peCopo  -  Codigo Postal                          *
      *                peCops  -  Sufijo                                 *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWSEP_saveCabecera...
     P                 B                   export
     D COWSEP_saveCabecera...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePaco                       3  0 const
     D   peCant                       6  0 const
     D   peRaed                       1  0 const
     D   peCopo                       5  0 const
     D   peCops                       1  0 const
     D   peXpro                       3  0 const

      /free

       COWSEP_inz();

       clear c1wsep;

       epempr = PeBase.peEmpr;
       epsucu = PeBase.peSucu;
       epnivt = PeBase.peNivt;
       epnivc = PeBase.peNivc;
       epnctw = peNctw;
       eprama = peRama;
       eparse = peArse;
       eppaco = pePaco;
       epcant = peCant;
       epraed = peRaed;
       epxpro = peXpro;
       epmar1 = '0';
       epmar2 = '0';
       epmar3 = '0';
       epmar4 = '0';
       epmar5 = '0';
       epstrg = '0';
       epuser = @PsDs.CurUsr;
       eptime = %dec(%time():*iso);
       epdate = %dec(%date():*iso);

       write c1wsep;

       return *on;

      /end-free

     P COWSEP_saveCabecera...
     P                 E

      * ------------------------------------------------------------ *
      * COWSEP_saveCoberturas():   Grabar una cobertura              *
      *                                                              *
      *     peBase   (input)   Base                                  *
      *     peNctw   (input)   Número de Cotización                  *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peArse   (input)   Articulo                              *
      *     pePaco   (input)   Parentesco                            *
      *     peRiec   (input)   Riesgo                                *
      *     peCobe   (input)   Cobertura                             *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peRaed   (input)   Rango de Edad                         *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWSEP_saveCoberturas...
     P                 B                   export
     D COWSEP_saveCoberturas...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peCant                       6  0 const
     D   peXpro                       3  0 const
     D   pePaco                       3  0 const
     D   peRiec                       3    const
     D   peCobe                       3  0 const
     D   peSaco                      13  2 const
     D   peRaed                       1  0 const

     D @@Xpri          s              9  6
     D @@Ptco          s             15  2
     D @@Cls           s              3a   dim(5) inz
     D @@Tpcd          s              2a
     D @@mone          s              2a

     D k1wse1          ds                  likerec( c1wse1 : *key )

      /free

       COWSEP_inz();

       k1wse1.e1empr = peBase.peEmpr;
       k1wse1.e1sucu = peBase.peSucu;
       k1wse1.e1nivt = peBase.peNivt;
       k1wse1.e1nivc = peBase.peNivc;
       k1wse1.e1nctw = peNctw;
       k1wse1.e1rama = peRama;
       k1wse1.e1arse = peArse;
       k1wse1.e1riec = peRiec;
       k1wse1.e1xcob = peCobe;
       setll %kds( k1wse1 : 9  ) ctwse1;
       if %equal( ctwse1 );
          return;
       endif;

       @@mone = COWGRAI_monedaCotizacion( peBase : peNctw );

       e1empr = peBase.peEmpr;
       e1sucu = peBase.peSucu;
       e1nivt = peBase.peNivt;
       e1nivc = peBase.peNivc;
       e1nctw = peNctw;
       e1rama = peRama;
       e1arse = peArse;
       e1riec = peRiec;
       e1xcob = peCobe;
       e1saco = peSaco;

       COWSEP_RecuperaTasaSumAseg( peRama
                                 : peArse
                                 : peCant
                                 : peXpro
                                 : peRiec
                                 : peCobe
                                 : @@mone
                                 : peSaco
                                 : peRaed
                                 : @@Xpri
                                 : @@Ptco
                                 : @@Tpcd
                                 : @@Cls  );

       e1ptco = @@Ptco;
       e1xpri = @@Xpri;
       e1prsa = *zeros;
       e1ecob = '0';
       e1mar1 = '0';
       e1mar2 = '0';
       e1mar3 = '0';
       e1mar4 = '0';
       e1mar5 = '0';
       e1user = @PsDs.CurUsr;
       e1time = %dec(%time():*iso);
       e1date = %dec(%date():*iso);

       write c1wse1;

       return;

      /end-free

     P COWSEP_saveCoberturas...
     P                 E

      * ------------------------------------------------------------ *
      * COWSEP_RecuperaTasaSumAseg...                                *
      *                                                              *
      *     peRama   (input)   Rama                                  *
      *     peXpro   (input)   Plan                                  *
      *     peRiec   (input)   Riesgo                                *
      *     peCobc   (input)   Cobertura                             *
      *     peMone   (input)   Moneda                                *
      *     peSaco   (input)   Suma Asegurada                        *
      *     peXpri   (output)  Prima por milaje                      *
      *     pePtco   (output)  Prima                                 *
      *     peTpcd   (output)  Codigo de Texto Preseteado            *
      *     peCls    (output)  Clausula                              *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWSEP_RecuperaTasaSumAseg...
     P                 B                   export
     D COWSEP_RecuperaTasaSumAseg...
     D                 pi
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCant                        6  0 const
     D  peXpro                        3  0 const
     D  peRiec                        3a   const
     D  peCobc                        3  0 const
     D  peMone                        2    const
     D  peSaco                       15  2 const
     D  peRaed                        1  0 const
     D  peXpri                        9  6
     D  pePtco                       15  2
     D  peTpcd                        2a
     D  peCls                         3a   dim(5)

     D k1y103          ds                  likerec( s1t103 : *key )
     D k1y068          ds                  likerec( s1t068 : *key )
     D prima           s             15  2
     D coefCt          s              5  2
     D p@cate          s              2  0
     D porcen          s              9  6

      /free

       COWSEP_inz();

       k1y103.t@rama = peRama;
       k1y103.t@xpro = peXpro;
       k1y103.t@riec = peRiec;
       k1y103.t@cobc = peCobc;
       k1y103.t@mone = peMone;

       clear prima;

       chain %kds ( k1y103 : 5 ) set103;
       if %found();

         if t@xpri <> 0;
           eval(h) prima = peSaco * t@xpri / 1000;
           porcen = t@xpri;
         elseif t@ptco <> 0;
           prima = t@ptco;
         elseif t@tamu <> 0;
           k1y068.t@tamu = t@tamu;
           //rangos de edades
           if peRaed = 1;
             k1y068.t@edad = 7;
           elseif peRaed = 2;
             k1y068.t@edad = 35;
           elseif peRaed = 3;
             k1y068.t@edad = 75;
           endif;

           chain %kds ( k1y068 : 2 ) set068;
           if %found();

             eval(h) prima = peSaco * t@xpr0/1000;
             porcen = t@xpr0;

           endif;

         endif;

         peXpri = porcen;
         pePtco = prima * peCant;
         peTpcd = t@tpcd;

       endif;

       return;

      /end-free

     P COWSEP_RecuperaTasaSumAseg...
     P                 E

      * ---------------------------------------------------------------- *
      * COWSEP_setPormilajePrima(): Graba Pormilajes prima               *
      *                                                                  *
      *       peBase ( input )  - Base                                   *
      *       peNctw ( input )  - Nro. de Cotización                     *
      *       peRama ( input )  - Rama                                   *
      *       peArse ( input )  - Articulo/Rama Secuencia                *
      *       peCobe ( output ) - Estructura de Cobertura                *
      *       peCobeC( input  ) - Cantidad de peCobe                     *
      *                                                                  *
      * Retorna *on / *off                                               *
      * ---------------------------------------------------------------- *
     P COWSEP_setPormilajePrima...
     P                 b                   export
     D COWSEP_setPormilajePrima...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peCobe                            likeds(Cobprima) dim(20)
     D   peCobeC                     10i 0 const

     D   x             s             10i 0

     D k1wse1          ds                  likerec( c1wse1 : *key )
     D @@se1           ds                  likerec( c1wse1 : *input)

      /free

        COWSEP_inz();

        k1wse1.e1empr = peBase.peEmpr;
        k1wse1.e1sucu = peBase.peSucu;
        k1wse1.e1nivt = peBase.peNivt;
        k1wse1.e1nivc = peBase.peNivc;
        k1wse1.e1nctw = peNctw;
        k1wse1.e1rama = peRama;
        k1wse1.e1arse = peArse;

        for x = 1 to peCobeC;
            k1wse1.e1riec = peCobe(x).riec;
            k1wse1.e1xcob = peCobe(x).xcob;
            chain(n) %kds(k1wse1:9) ctwse1;
            if %found;
               peCobe(x).prim = e1ptco;
               peCobe(x).xpri = e1xpri;
            endif;
        endfor;

       return *on;

      /end-free

     P COWSEP_setPormilajePrima...
     P                 e

      * ------------------------------------------------------------ *
      * COWSEP_planesCerrados(): Calcula Planes Cerrados             *
      *                                                              *
      *     peBase (input)  Base                                     *
      *     peNctw (input)  Número de Cotización                     *
      *     peRama (input)  Rama                                     *
      *     peArse (input)  Cantidad de Polizas                      *
      *                                                              *
      * ------------------------------------------------------------ *
     P COWSEP_planesCerrados...
     P                 b                   export
     D COWSEP_planesCerrados...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peArse                       2  0   const
     D   peXpro                       3  0   const

     D k1y100          ds                   likerec(s1t100:*key)
     D k1y000          ds                   likerec(c1w000:*key)
     D k1y001          ds                   likerec(c1w001:*key)

     D @@prec          s              5  2
     D @@bpep          s              5  2
     D @@bpip          s              5  2
     D @@bpri          s             15  2
     D @@prim          s             15  2
     D @@subt          s             15  2
     D @@ivat          s             15  2
     D aux_prem        s             29  9

     D @@prem          s             15  2
     D @@impu          s             15  2

     D @@dere          s             15  2
     D @@refi          s             15  2
     D @@impi          s             15  2
     D @@sers          s             15  2
     D @@tssn          s             15  2
     D @@ipr1          s             15  2
     D @@ipr2          s             15  2
     D @@ipr3          s             15  2
     D @@ipr4          s             15  2
     D @@ipr5          s             15  2
     D @@ipr6          s             15  2
     D @@ipr7          s             15  2
     D @@ipr8          s             15  2
     D @@ipr9          s             15  2

     D @@form          s              1    inz ('A')

     D @@xpri          s              9  6
     D @@ptco          s             15  2
     D @@tpcd          s              2a
     D @@cls           s              3a   dim(5)
     D @1prem          s             15  2
     D @2prem          s             15  2
     D @3prem          s             15  2
     D xxprem          s             29  9
     D @@suma          s             15  2

     D veces           s             10i 0

       COWSEP_inz();

       @@suma = COWGRAI_getSumaAseguradaRamaArse( peBase
                                                : peNctw
                                                : peRama
                                                : peArse );

       k1y000.w0empr = peBase.peEmpr;
       k1y000.w0sucu = peBase.peSucu;
       k1y000.w0nivt = peBase.peNivt;
       k1y000.w0nivc = peBase.peNivc;
       k1y000.w0nctw = peNctw;
       chain(n) %kds( k1y000 ) ctw000;

       k1y100.t@rama = peRama;
       k1y100.t@xpro = peXpro;
       k1y100.t@mone = w0mone;
       chain(n) %kds( k1y100 ) set100;
       if ( t@prem = *Zeros );
          return *On;
       endif;

       @@prem = *Zeros;
       @1prem = t@prem;

       dou @1prem = @3prem or veces = 10;

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         k1y001.w1rama = peRama;
         chain %kds( k1y001 ) ctw001;

         k1y001.w1empr = peBase.peEmpr;
         k1y001.w1sucu = peBase.peSucu;
         k1y001.w1nivt = peBase.peNivt;
         k1y001.w1nivc = peBase.peNivc;
         k1y001.w1nctw = peNctw;
         k1y001.w1rama = peRama;
         chain %kds( k1y001 ) ctw001c;

         @@prec = *Zeros;
         @@bpep = *Zeros;
         @@bpip = *Zeros;
         @@bpri = *Zeros;

         @@ivat = w1ipr1 + w1ipr3 + w1ipr4;
         @@dere = w1dere;

         @@prim = COWGRAI_getPrimaRamaArse ( peBase :
                                             peNctw :
                                             peRama );

         @@subt = COWGRAI_GetPrimaSubtot ( peBase
                                         : peNctw
                                         : peRama
                                         : @@prim
                                         : @@form );

         if ( t@mar1 = 'D' );
           PRO401U3 ( @1prem : w1prem : @@prec : w1pssn : w1psso : w1pimi
                    : w1seri : w1seem : w1ipr6 : w1ipr2 : w1ipr7 : w1ipr8
                    : w1dere : w1xref : w1xrea : @@bpep : @@prim : @@subt
                    : @@ivat : @@bpip : w1refi : w1read : @@bpri );
         else;
           PRO401U1 ( @1prem : w1prem : @@prec : w1pssn : w1psso : w1pimi
                    : w1seri : w1seem : w1ipr6 : w1ipr2 : w1ipr7 : w1ipr8
                    : @@dere : w1xref : w1xrea : @@bpep : @@prim : @@subt
                    : @@ivat : @@bpip );
         endif;

         update c1w001;
         update c1w001c;

         COWGRAI_getPremioFinal ( peBase : peNctw );

         @3prem = COWSEP_getPremio( peBase
                                  : peNctw
                                  : peRama
                                  : peArse  );

         veces += 1;

       enddo;

       return *On;

     P COWSEP_planesCerrados...
     P                 e

      * ------------------------------------------------------------ *
      * COWSEP_getPremio(): Obtener Premio                           *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *                                                              *
      * Retorna *on / *off                                           *
      * ------------------------------------------------------------ *
     P COWSEP_getPremio...
     P                 B                   export
     D COWSEP_getPremio...
     D                 pi            15  2
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const

     D   k1y001        ds                    likerec( c1w001 : *key )

       COWSEP_inz();

       k1y001.w1empr = peBase.peEmpr;
       k1y001.w1sucu = peBase.peSucu;
       k1y001.w1nivt = peBase.peNivt;
       k1y001.w1nivc = peBase.peNivc;
       k1y001.w1nctw = peNctw;
       k1y001.w1rama = peRama;

       chain(n) %kds ( k1y001 : 6 ) ctw001;

       return w1prem;

     P COWSEP_getPremio...
     P                 E

      * ------------------------------------------------------------ *
      * COWSEP_getCoberturas(): Obtiene Coberturas                   *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *                                                              *
      * Retorna Cantidad de Coberturas                               *
      * ------------------------------------------------------------ *
     P COWSEP_getCoberturas...
     P                 b                   export
     D COWSEP_getCoberturas...
     D                 pi            10i 0
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peWse1                            likeds(ctwse1_t) dim(20)

     D inSe1           ds                  likerec(c1wse1:*input)
     D k1wse1          ds                  likerec(c1wse1:*key)
     D x               s             10i 0

      /free

       COWSEP_inz();

       k1wse1.e1empr = peBase.peEmpr;
       k1wse1.e1sucu = peBase.peSucu;
       k1wse1.e1nivt = peBase.peNivt;
       k1wse1.e1nivc = peBase.peNivc;
       k1wse1.e1nctw = peNctw;
       setll %kds(k1wse1:5) ctwse1;
       reade(n) %kds(k1wse1:5) ctwse1 inSe1;
       dow not %eof;
           x += 1;
           eval-corr peWse1(x) = inSe1;
        reade(n) %kds(k1wse1:5) ctwse1 inSe1;
       enddo;

       return x;

      /end-free

     P COWSEP_getCoberturas...
     P                 e

      * ------------------------------------------------------------ *
      * COWSEP_getCabecera():   Obtiene Cabecera                     *
      *                                                              *
      *     PeBase   (input)  Parametros Base                        *
      *     PeNctw   (input)  Nro de Cotizacion                      *
      *     PeRama   (input)  Rama                                   *
      *     PeArse   (input)  Cant. de Articulos                     *
      *                                                              *
      * Retorna %found                                               *
      * ------------------------------------------------------------ *
     P COWSEP_getCabecera...
     P                 b                   export
     D COWSEP_getCabecera...
     D                 pi              n
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peWsep                            likeds(ctwsep_t)

     D inSep           ds                  likerec(c1wsep:*input)
     D k1wsep          ds                  likerec(c1wsep:*key)

      /free

       COWSEP_inz();

       k1wsep.epempr = peBase.peEmpr;
       k1wsep.epsucu = peBase.peSucu;
       k1wsep.epnivt = peBase.peNivt;
       k1wsep.epnivc = peBase.peNivc;
       k1wsep.epnctw = peNctw;
       chain(n) %kds(k1wsep:5) ctwsep inSep;
       if %found;
           eval-corr peWsep = inSep;
       endif;

       return %found;

      /end-free

     P COWSEP_getCabecera...
     P                 e

      * ---------------------------------------------------------------- *
      * COWSEP_reCotizarWeb():Recibe todos los datos para la póliza de   *
      *                       SEPELIO. Retorna la prima y el premio.     *
      *                                                                  *
      *       peBase ( input )  -  Base                                  *
      *       peNctw ( input )  -  Nro. de Cotización                    *
      *       peRama ( input )  -  Rama                                  *
      *       peArse ( input )  -  Cant. Pólizas por Rama                *
      *       peNrpp ( input )  -  Plan de Pago                          *
      *       peVdes ( input )  -  Fecha desde                           *
      *       peXpro ( input )  -  Codigo de plan                        *
      *       peClie ( input )  -  Datos del Cliente                     *
      *       peCsep ( input )  -  Componente de Sepelio                 *
      *       peImpu ( input )  -  Impuestos                             *
      *       pePrim ( output ) -  Prima                                 *
      *       pePrem ( output ) -  Premio                                *
      *       peErro ( output ) -  Indicador de Error                    *
      *       peMsgs ( output ) -  Estructura de Error                   *
      *                                                                  *
      * ---------------------------------------------------------------- *
     P COWSEP_reCotizarWeb...
     P                 B                   export
     D COWSEP_reCotizarWeb...
     D                 pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peCsep                            likeds(CompSepelio_t)
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D rc              s              1n
     D @@cfpg          s              1  0
     D @1prim          s             15  2
     D @1prem          s             15  2
     D @@impu          ds                  likeds(Impuesto)

      /free

       COWSEP_inz();

       clear peErro;

       if not COWGRAI_getFormaDePagoPdP( peBase
                                       : peNctw
                                       : COWGRAI_getArticulo ( peBase :
                                                               peNctw )
                                       : peNrpp
                                       : @@Cfpg );

          %subst(wrepl:1:3) = %editc(peNrpp:'X');

          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0110'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

           peErro = -1;
           return;

       endif;

       // --------------------------------------------
       // Eliminar Residual
       // --------------------------------------------
       COWSEP_delCotizacion( peBase : peNctw );

       // --------------------------------------------
       // Validaciones iniciales
       // --------------------------------------------
       COWSEP_chkCotizar ( peBase
                         : peNctw
                         : peRama
                         : peArse
                         : peCsep.paco
                         : peCsep.cant
                         : peClie.tipe
                         : peClie.civa
                         : @@Cfpg
                         : peVdes
                         : peXpro
                         : peClie.Copo
                         : peClie.Cops
                         : peCsep.Raed
                         : peCsep.Cobe
                         : peCsep.CobeC
                         : peErro
                         : peMsgs       );

       if peErro <> *Zeros;
          return;
       endif;

       COWGRAI_deleteImpuesto ( peBase : peNctw : peRama );

       COWGRAI_updCondComerciales( peBase
                                 : peNctw
                                 : peRama
                                 : peImpu.Xrea );

       COWSEP_cotizador( peBase
                       : peNctw
                       : peRama
                       : peArse
                       : peCsep.Paco
                       : peCsep.Cant
                       : peClie.tipe
                       : peClie.civa
                       : peNrpp
                       : @@Cfpg
                       : peVdes
                       : peXpro
                       : peClie.Copo
                       : peClie.Cops
                       : peCsep.raed
                       : peCsep.cobe
                       : peCsep.cobeC
                       : @1prim
                       : @1prem
                       : peErro
                       : peMsgs       );

       pePrim = @1prim;
       pePrem = @1Prem;
       peCsep.Prim = pePrim;
       peCsep.Prim = pePrem;

       clear @@impu;
       rc = COWGRAI_getImpuestosCotizacion( peBase
                                          : peNctw
                                          : peRama
                                          : @@impu );
       peImpu = @@impu;

       return;

      /end-free

     P COWSEP_reCotizarWeb...
     P                 E

