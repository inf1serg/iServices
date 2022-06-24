     H option(*nodebugio: *srcstmt: *noshowcpy)
     H dftactgrp(*no) actgrp(*caller)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLTXA:  WebService                                          *
      *          Retorna Tarjetas de Crédito de un DAF               *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                   *26-Oct-2015              *
      * ------------------------------------------------------------ *
      * Valores posibles para peTipo:                                *
      *         - *ALL: Todas las tarjetas (defecto)                 *
      *         - *ACT: Sólo tarjetas activas                        *
      *         - *BLQ: Sólo tarjetas con algún bloqueo              *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahas1    if   e           k disk
     Fgnhdtc    if   e           k disk
     Fgnttc101  if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLTXA          pr                  ExtPgm('WSLTXA')
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0 const
     D   peTipo                      10a   const
     D   peDtar                            likeds(AsegTarj_t) dim(100)
     D   peDtarC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLTXA          pi
     D   peBase                            likeds(paramBase) const
     D   peAsen                       7  0 const
     D   peTipo                      10a   const
     D   peDtar                            likeds(AsegTarj_t) dim(100)
     D   peDtarC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPEDI1          pr                  ExtPgm('SPEDI1')
     D  peNrtc                       70a

     D k1hdtc          ds                  likerec(g1hdtc:*key)
     D k1hase          ds                  likerec(p1has1:*key)
     D @tipo           s             10a
     D c70             s             70a
     D x               s             10i 0
     D q               s             10i 0

      /free

       *inlr = *on;

       clear peDtar;
       peDtarC = 0;
       peErro  = 0;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       k1hase.asempr = peBase.peEmpr;
       k1hase.assucu = peBase.peSucu;
       k1hase.asnivt = peBase.peNivt;
       k1hase.asnivc = peBase.peNivc;
       k1hase.asasen = peAsen;
       setll %kds ( k1hase ) pahas1;
       if not %equal ( pahas1 );
          return;
       endif;

       @tipo = peTipo;
       if @tipo <> '*ALL' and
          @tipo <> '*ACT' and
          @tipo <> '*BLQ';
          @tipo = '*ALL';
       endif;

       setll peAsen gnhdtc;
       reade peAsen gnhdtc;
       dow not %eof;

           if peDtarC = 100;
              leave;
           endif;

        if @tipo = '*ALL' or
           (@tipo = '*BLQ' and dfbloq <> 'N' and dfbloq <> 'R') or
           (@tipo = '*ACT' and dfbloq = 'N') or
           (@tipo = '*ACT' and dfbloq = 'R');

           peDtarC += 1;

           peDtar(peDtarC).ctcu = %trim(%char(dfctcu));
           chain dfctcu gnttc101;
           if %found;
              peDtar(peDtarC).nomb = dfnomb;
            else;
              peDtar(peDtarC).nomb = *blanks;
           endif;
           peDtar(peDtarC).nrtc = %trim(%char(dfnrtc));
           c70 = %editc(dfnrtc:'X');
           %subst(c70:21) = t1ment;
           SPEDI1(c70);
           peDtar(peDtarC).nrte = %subst(c70:52);
           peDtar(peDtarC).grab = dfgrab;
           peDtar(peDtarC).bloq = dfbloq;

           if dffita <= 0 or dffitm <= 0;
              peDtar(peDtarC).fita = *blanks;
              peDtar(peDtarC).fitm = *blanks;
              peDtar(peDtarC).fini = *blanks;
              peDtar(peDtarC).fin2 = *blanks;
            else;
              peDtar(peDtarC).fita = %editc(dffita:'X');
              peDtar(peDtarC).fitm = %editc(dffitm:'X');
              peDtar(peDtarC).fini = %editc(dffita:'X')
                                   + '/'
                                   + %editc(dffitm:'X');
              peDtar(peDtarC).fin2 = %editc(dffitm:'X')
                                   + '/'
                                   + %editc(dffita:'X');
           endif;

           if dfffta <= 0 or dffftm <= 0;
              peDtar(peDtarC).ffta = *blanks;
              peDtar(peDtarC).fftm = *blanks;
              peDtar(peDtarC).ffin = *blanks;
              peDtar(peDtarC).ffi2 = *blanks;
            else;
              peDtar(peDtarC).ffta = %editc(dfffta:'X');
              peDtar(peDtarC).fftm = %editc(dffftm:'X');
              peDtar(peDtarC).ffin = %editc(dfffta:'X')
                                   + '/'
                                   + %editc(dffftm:'X');
              peDtar(peDtarC).ffi2 = %editc(dffftm:'X')
                                   + '/'
                                   + %editc(dfffta:'X');
           endif;

           if dffbta <= 0 or dffbtm <= 0 or dffbtd <= 0;
              peDtar(peDtarC).fbta = *blanks;
              peDtar(peDtarC).fbtm = *blanks;
              peDtar(peDtarC).fbtd = *blanks;
              peDtar(peDtarC).fbaj = *blanks;
            else;
              peDtar(peDtarC).fbta = %editc(dffbta:'X');
              peDtar(peDtarC).fbtm = %editc(dffbtm:'X');
              peDtar(peDtarC).fbtd = %editc(dffbtd:'X');
              peDtar(peDtarC).fbaj = %editc(dffbtd:'X')
                                   + '/'
                                   + %editc(dffbtm:'X')
                                   + '/'
                                   + %editc(dffbta:'X');
           endif;

           // ----------------------------------------
           // Enmascarar tarjeta de crédito con "*"
           // Dejo sólo los últimos 4 dígitos
           // ----------------------------------------
           peDtar(peDtarC).nrty = peDtar(peDtarC).nrte;
           q = 0;
           for x = 20 downto 1;
               if %subst(peDtar(peDtarC).nrty:x:1) <> ' ';
                  q += 1;
                  if q > 4;
                     %subst(peDtar(peDtarC).nrty:x:1) = '*';
                  endif;
               endif;
           endfor;

           select;
            when dfbloq = 'N';
                 peDtar(peDtarC).blod = 'ACTIVA';
            when dfbloq = 'F';
                 peDtar(peDtarC).blod = 'BLOQUEADA';
            when dfbloq = 'R';
                 peDtar(peDtarC).blod = 'ACTIVA';
            other;
                 peDtar(peDtarC).blod = *blanks;
           endsl;

        endif;

        reade peAsen gnhdtc;
       enddo;

       return;

      /end-free
