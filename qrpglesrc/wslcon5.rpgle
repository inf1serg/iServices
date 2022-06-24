     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCON5: WebService                                          *
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                      *16-Nov-2015        *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *  JSN 02/12/2020 - Se agrega nomina externa                   *
      * ************************************************************ *
     Fpahec1    if   e           k disk
     Fpahed004  if   e           k disk
     Fpahed0    if   e           k disk
     Fpahev0    if   e           k disk
     Fpahev2    if   e           k disk
     Fgnttdo    if   e           k disk
     Fset107    if   e           k disk
     Fpahnx1    if   e           k disk
     Fpahev1    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'

     D WSLCON5         pr                  ExtPgm('WSLCON5')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peGral                            likeds(Cervgral_t)
     D   peLcob                            likeds(Cervrico_t) dim(999)
     D   peLcobC                     10i 0
     D   peNomi                            likeds(Cervnomi_t) dim(9999)
     D   peNomiC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D WSLCON5         pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peGral                            likeds(Cervgral_t)
     D   peLcob                            likeds(Cervrico_t) dim(999)
     D   peLcobC                     10i 0
     D   peNomi                            likeds(Cervnomi_t) dim(9999)
     D   peNomiC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D khec1           ds                  likerec(p1hec1:*key)
     D khed004         ds                  likerec(p1hed004:*key)
     D khed0           ds                  likerec(p1hed0:*key)
     D khev0           ds                  likerec(p1hev0:*key)
     D khev2           ds                  likerec(p1hev2:*key)
     D kt107           ds                  likerec(s1t107:*key)
     D khnx1           ds                  likerec(p1hnx1:*key)
     D khev1           ds                  likerec(p1hev1:*key)

     D rc              s               n
     D wmarca          s               n
     D wwpoco          s              6  0
     D fecegr          s              8  0
     D @rpl            s          65535a
     D @@Nomi          s              7  0
     D @@Ndni          s              8  0
     D @@Tido          s              2  0 inz(4)
     D pefdes          s              8  0
     D pefhas          s              8  0
     D NominaExt       s               n

       *inlr = *on;

       clear peMsgs;
       peErro = 0;
       peNomiC = 0;
       peLcobC = 0;

       // -------------------------------------
       // Chequeo parámetro base
       // -------------------------------------
       rc = SVPWS_chkParmBase( peBase : peMsgs );
       if rc = *off;
          peErro = -1;
          return;
       endif;

       // -------------------------------------
       // Chequeo existencia de Superpóliza
       // -------------------------------------
       khec1.c1empr = peBase.peEmpr;
       khec1.c1sucu = peBase.peSucu;
       khec1.c1arcd = peArcd;
       khec1.c1spol = peSpol;
       khec1.c1sspo = peSspo;

       setll %kds(khec1:5) pahec1;
       if not %equal(pahec1);
          %subst(@rpl:1:3)  = %editc(peSspo:'X');
          %subst(@rpl:4:6)  = %editc(peArcd:'X');
          %subst(@rpl:10:18) = %editc(peSpol:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SPO0002'
                       : peMsgs
                       : %trim(@rpl)
                       : %len(%trim(@rpl)) );
          peErro = -1;
          return;
       endif;

       // ---------------------------------------
       // Chequeo existencia de suplemento póliza
       // ---------------------------------------
       khed004.d0empr = peBase.peEmpr;
       khed004.d0sucu = peBase.peSucu;
       khed004.d0rama = peRama;
       khed004.d0poli = pePoli;
       khed004.d0suop = peSuop;

       setll %kds(khed004:5) pahed004;
       if not %equal(pahed004);
          %subst(@rpl:1:3)  = %editc(peSuop:'X');
          %subst(@rpl:4:2)  = %editc(peRama:'X');
          %subst(@rpl:6:7)  = %editc(pePoli:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0008'
                       : peMsgs
                       : %trim(@rpl)
                       : %len(%trim(@rpl)) );
          peErro = -1;
          return;
       endif;

       // ---------------------------------------
       // Chequeo existencia de póliza
       // ---------------------------------------
       khed004.d0empr = peBase.peEmpr;
       khed004.d0sucu = peBase.peSucu;
       khed004.d0rama = peRama;
       khed004.d0poli = pePoli;

       wmarca = *off;

       setll %kds(khed004:4) pahed004;
       reade %kds(khed004:4) pahed004;
       dow not %eof(pahed004);
           if d0arcd = peArcd
              and d0spol = peSpol;
              wmarca = *on;
              leave;
           endif;
           reade %kds(khed004:3) pahed004;
       enddo;

       if not wmarca;
          %subst(@rpl:1:2)  = %editc(peRama:'X');
          %subst(@rpl:3:7)  = %editc(pePoli:'X');
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0007'
                       : peMsgs
                       : %trim(@rpl)
                       : %len(%trim(@rpl)) );
          peErro = -1;
          return;
       endif;

       khed0.d0empr = peBase.peEmpr;
       khed0.d0sucu = peBase.peSucu;
       khed0.d0arcd = peArcd;
       khed0.d0spol = peSpol;
       khed0.d0sspo = peSspo;
       khed0.d0rama = peRama;

       wmarca = *off;

       setll %kds(khed0:6) pahed0;
       reade %kds(khed0:6) pahed0;
       dow not %eof(pahed0);
           if d0suop = peSuop;
              wmarca = *on;
              leave;
           endif;
           reade %kds(khed0:6) pahed0;
       enddo;

       if wmarca;
          peGral.fdes = d0fioa * 10000 + d0fiom * 100 + d0fiod;
          if peRama = 89;
            clear pefdes;
            clear pefhas;
            if SPVSPO_getFechaAnualidad( peBase.peEmpr
                                       : peBase.peSucu
                                       : peArcd
                                       : peSpol
                                       : 0
                                       : pefdes
                                       : pefhas        );

              peGral.fdes = pefdes;
              peGral.fhas = pefhas;
            endif;
          else;
            peGral.fhas = d0fhfa * 10000 + d0fhfm * 100 + d0fhfd;
          endif;
          select;
             when d0dup2 = 2;
                peGral.fact = 'BIMESTRAL';
             when d0dup2 = 3;
                peGral.fact = 'TRIMESTRAL';
             when d0dup2 = 4;
                peGral.fact = 'CUATRIMESTRAL';
             when d0dup2 = 6;
                peGral.fact = 'SEMESTRAL';
             when d0dup2 = 12;
                peGral.fact = 'ANUAL';
          endsl;
       endif;

       clear wwpoco;

       khev1.v1empr = peBase.peEmpr;
       khev1.v1sucu = peBase.peSucu;
       khev1.v1Arcd = peArcd;
       khev1.v1Spol = peSpol;
       khev1.v1Sspo = peSspo;
       khev1.v1Rama = peRama;
       chain %kds( khev1 : 6 ) pahev1;
       if %found( pahev1 );
         wwpoco = v1poco;
       endif;

       NominaExt = *off;
       if SPVSPO_isNominaExterna( peBase.peEmpr
                                : peBase.peSucu
                                : peArcd
                                : peSpol
                                : @@Nomi        );

         khnx1.n1empr = peBase.peEmpr;
         khnx1.n1sucu = peBase.peSucu;
         khnx1.n1Nomi = @@Nomi;

         setll %kds(khnx1:3) pahnx1;
         reade %kds(khnx1:3) pahnx1;
         dow not %eof(pahnx1);
           fecegr = (n1aegn * 10000)
                  + (n1megn *   100)
                  +  n1degn;
           if n1rama = peRama;
             if (n1suen = 0 and n1aegn = 0)
                 or
                (n1suen <> 0 and fecegr > %dec(%date():*iso));
               peNomiC += 1;
               peNomi(peNomiC).nomb = n1nomb;
               clear gndatd;
               clear @@Ndni;
               NominaExt = *on;
               if n1tido = 99 or n1nrdo = *all'9';
                 chain (@@Tido) gnttdo;
                   peNomi(peNomiC).datd = gndatd;
                   @@Ndni = %int(%subst(%editc(n1njub:'X'):3:8));
                   peNomi(peNomiC).nrdo = @@Ndni;
               else;
                 chain (n1tido) gnttdo;
                   peNomi(peNomiC).datd = gndatd;
                   peNomi(peNomiC).nrdo = n1nrdo;
               endif;
             endif;
           endif;
           reade %kds(khnx1:3) pahnx1;
         enddo;

         if peNomiC = *zeros;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'POL0025'
                        : peMsgs
                        : %trim(@rpl)
                        : %len(%trim(@rpl)) );
           peErro = -1;
           return;
         endif;
       else;

         khev0.v0empr = peBase.peEmpr;
         khev0.v0sucu = peBase.peSucu;
         khev0.v0arcd = peArcd;
         khev0.v0spol = peSpol;

         setll %kds(khev0:4) pahev0;
         reade %kds(khev0:4) pahev0;
         dow not %eof(pahev0);
           fecegr = (v0aegn * 10000)
                  + (v0megn *   100)
                  +  v0degn;
           if v0rama = peRama;
             if (v0suen = 0 and v0aegn = 0)
                 or
                (v0suen <> 0 and fecegr > %dec(%date():*iso));
               peNomiC += 1;
               peNomi(peNomiC).nomb = v0nomb;
               clear gndatd;
               chain (v0tido) gnttdo;
                 peNomi(peNomiC).datd = gndatd;
                 peNomi(peNomiC).nrdo = v0nrdo;
             endif;
           endif;
           reade %kds(khev0:4) pahev0;
         enddo;
       endif;

       khev2.v2empr = peBase.peEmpr;
       khev2.v2sucu = peBase.peSucu;
       khev2.v2arcd = peArcd;
       khev2.v2spol = peSpol;
       khev2.v2sspo = peSspo;
       khev2.v2rama = peRama;

       setll %kds(khev2:6) pahev2;
       reade %kds(khev2:6) pahev2;
       dow not %eof(pahev2);
           if v2suop = peSuop
              and v2poli = pePoli
              and v2poco = wwpoco;
                 peLcobC += 1;
                 clear t@cobd;
                 kt107.t@rama = peRama;
                 kt107.t@cobc = v2xcob;
                 chain %kds(kt107) set107;
                 peLcob(peLcobC).cobd = t@cobd;
                 if NominaExt;
                   peLcob(peLcobC).saco = n1suas;
                 else;
                   peLcob(peLcobC).saco = v2saco;
                 endif;
           endif;
           reade %kds(khev2:6) pahev2;
       enddo;

       return;
