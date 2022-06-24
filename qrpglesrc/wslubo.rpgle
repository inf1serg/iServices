     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLUBO  : Tareas generales.                                  *
      *           WebService - Retorna objetos asegurados rsgo/cobert*
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *24-Abr-2015  *
      * ------------------------------------------------------------ *
      * SGF 29/05/2015: Nueva versión: todo desde GAUS.              *
      *                                                              *
      * ************************************************************ *
     Fset001    if   e           k disk
     Fpaher995  if   e           k disk
     Fpahed003  if   e           k disk
     Fpahed004  if   e           k disk
     Fpaher7    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLUBO          pr                  ExtPgm('WSLUBO')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOaco                            likeds(pahrsvs2_t) dim(100)
     D   peOacoC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLUBO          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peRiec                       3    const
     D   peXcob                       3  0 const
     D   peOaco                            likeds(pahrsvs2_t) dim(100)
     D   peOacoC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hed003        ds                  likerec(p1hed003 : *key)
     D k1hed004        ds                  likerec(p1hed004 : *key)
     D k1her7          ds                  likerec(p1her7   : *key)
     D k1her9          ds                  likerec(p1her9   : *key)

     D r4ed0           ds                  likerec( p1hed004 )
     D r7              ds                  likerec(p1her7)

     D respue          s          65536
     D longm           s             10i 0
     D poco6           s              6  0
     D hay             s              1N

       *inLr = *On;

       peOacoC = *Zeros;
       peErro  = *Zeros;
       hay     = *off;

       clear peOaco;
       clear peMsgs;
       clear r7;

       // ------------------------------------------
       // Validar Parámetro base
       // ------------------------------------------
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       // ------------------------------------------
       // Es Rama de RV?
       // ------------------------------------------
       chain (peRama) set001;
       if (t@rame = 4 or t@rame = 18 or t@rame = 21);
           %subst(respue:1:2) = %editc(peRama:'X');
           %subst(respue:3:7) = %trim(%char(pePoli));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'POL0003'
                        : peMsgs
                        : %trim(respue)
                        : %len(%trim(respue)) );
           peErro = -1;
           return;
       endif;

       // ------------------------------------------
       // Mandaron una ubicación que existe?
       // ------------------------------------------
       k1her9.r9empr = peBase.peEmpr;
       k1her9.r9sucu = peBase.peSucu;
       k1her9.r9rama = peRama;
       k1her9.r9poli = pePoli;
       k1her9.r9spol = peSpol;
       k1her9.r9poco = pePoco;
       setll %kds(k1her9:6) paher995;
       if not %equal;
           poco6 = pePoco;
           %subst(respue:1:6) = %trim(%char(poco6));
           %subst(respue:7:2) = %editc(peRama:'X');
           %subst(respue:9:7) = %trim(%char(pePoli));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'BIE0001'
                        : peMsgs
                        : %trim(respue)
                        : %len(%trim(respue)) );
           peErro = -1;
           return;
       endif;

       // ------------------------------------------
       // Busco todos los datos del PAHED0
       // ------------------------------------------
       k1hed004.d0empr = peBase.peEmpr;
       k1hed004.d0sucu = peBase.peSucu;
       k1hed004.d0rama = peRama;
       k1hed004.d0poli = pePoli;
       chain %kds(k1hed004:4) pahed004 r4ed0;
       if not %found;
           %subst(respue:1:2) = %editc(peRama:'X');
           %subst(respue:3:7) = %trim(%char(pePoli));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'POL0009'
                        : peMsgs
                        : %trim(respue)
                        : %len(%trim(respue)) );
           peErro = -1;
           return;
       endif;

       // ------------------------------------------
       // Última rama/secuencia para atriqui en ED0
       // ------------------------------------------
       k1hed003.d0empr = r4ed0.d0empr;
       k1hed003.d0sucu = r4ed0.d0sucu;
       k1hed003.d0arcd = r4ed0.d0arcd;
       k1hed003.d0spol = r4ed0.d0spol;
       k1hed003.d0rama = r4ed0.d0rama;
       k1hed003.d0arse = r4ed0.d0arse;
       setgt  %kds(k1hed003:6) pahed003;
       readpe %kds(k1hed003:6) pahed003;
       dow not %eof;
           if d0tiou = 1 or
              d0tiou = 2 or
              d0tiou = 5 or
              (d0tiou = 3 and d0stos <> 8 and d0stos <> 9);
              k1her7.r7empr = d0empr;
              k1her7.r7sucu = d0sucu;
              k1her7.r7arcd = d0arcd;
              k1her7.r7spol = d0spol;
              k1her7.r7sspo = d0sspo;
              k1her7.r7rama = d0rama;
              k1her7.r7arse = d0arse;
              k1her7.r7oper = d0oper;
              k1her7.r7poco = pePoco;
              k1her7.r7suop = d0suop;
              k1her7.r7riec = peRiec;
              k1her7.r7xcob = peXcob;
              chain %kds(k1her7:12) paher7 r7;
              if %found;
                 hay = *on;
                 leave;
              endif;
           endif;
        readpe %kds(k1hed003:6) pahed003;
       enddo;

       if ( hay = *ON );
          k1her7.r7empr = r7.r7empr;
          k1her7.r7sucu = r7.r7sucu;
          k1her7.r7arcd = r7.r7arcd;
          k1her7.r7spol = r7.r7spol;
          k1her7.r7sspo = r7.r7sspo;
          k1her7.r7rama = r7.r7rama;
          k1her7.r7arse = r7.r7arse;
          k1her7.r7oper = r7.r7oper;
          k1her7.r7poco = r7.r7Poco;
          k1her7.r7suop = r7.r7suop;
          k1her7.r7riec = r7.r7Riec;
          k1her7.r7xcob = r7.r7Xcob;
          k1her7.r7osec = 0;
          setll %kds(k1her7:13) paher7;
          reade %kds(k1her7:12) paher7;
          dow not %eof and peOacoC < 100;

              peOacoC += 1;
              peOaco(peOacoC).rsosec = r7osec;
              peOaco(peOacoC).rsobje = r7obje;
              peOaco(peOacoC).rsmarc = r7marc;
              peOaco(peOacoC).rsmode = r7mode;
              peOaco(peOacoC).rsnser = r7nser;
              peOaco(peOacoC).rssuas = r7suas;
              peOaco(peOacoC).rsdet1 = r7det1;
              peOaco(peOacoC).rsdet2 = r7det2;
              peOaco(peOacoC).rsdet3 = r7det3;
              peOaco(peOacoC).rsdet4 = r7det4;
              peOaco(peOacoC).rsdet5 = r7det5;
              peOaco(peOacoC).rsdet6 = r7det6;

           reade %kds(k1her7:12) paher7;
          enddo;
       endif;

       return;

