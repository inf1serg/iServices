     H option(*nodebugio: *srcstmt: *noshowcpy)
     H dftactgrp(*no) actgrp(*caller)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCXA:  WebService                                          *
      *          Retorna Cuentas de un DAF                           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                   *02-Ene-2017              *
      * ------------------------------------------------------------ *
      * Valores posibles para peTipo:                                *
      *         - *ALL: Todas las tarjetas (defecto)                 *
      *         - *ACT: Sólo tarjetas activas                        *
      *         - *BLQ: Sólo tarjetas con algún bloqueo              *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahas1    if   e           k disk
     Fgnhdcb    if   e           k disk
     Fcntbco    if   e           k disk
     Fcntbcs    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'

     D WSLCXA          pr                  ExtPgm('WSLCXA')
     D  peBase                             likeds(paramBase) const
     D  peAsen                        7  0 const
     D  peTipo                       10a   const
     D  peDcbu                             likeds(AsegCbus_t) dim(100)
     D  peDcbuC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D WSLCXA          pi
     D  peBase                             likeds(paramBase) const
     D  peAsen                        7  0 const
     D  peTipo                       10a   const
     D  peDcbu                             likeds(AsegCbus_t) dim(100)
     D  peDcbuC                      10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D k1hdcb          ds                  likerec(g1hdcb:*key)
     D k1hase          ds                  likerec(p1has1:*key)
     D k1tbcs          ds                  likerec(c1tbcs:*key)
     D @tipo           s             10a

      /free

       *inlr = *on;

       clear peDcbu;
       peDcbuC = 0;
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

       setll peAsen gnhdcb;
       reade peAsen gnhdcb;
       dow not %eof;

           if peDcbuC = 100;
              leave;
           endif;

        if @tipo = '*ALL' or
           (@tipo = '*BLQ' and dfbloq = 'F') or
           (@tipo = '*ACT' and dfbloq = 'N') or
           (@tipo = '*ACT' and dfbloq = 'R');

           peDcbuC += 1;

           peDcbu(peDcbuC).ncbu = %trim(SPVCBU_getCbuEntero( dfivbc
                                                           : dfivsu
                                                           : dftcta
                                                           : dfncta ) );
           peDcbu(peDcbuC).ivbc = %editc(dfivbc:'X');
           peDcbu(peDcbuC).ivsu = %editc(dfivsu:'X');
           peDcbu(peDcbuC).tcta = %editc(dftcta:'X');
           peDcbu(peDcbuC).ncta = %trim(dfncta);
           peDcbu(peDcbuC).bloq = dfbloq;
           if dffbta = 0;
              peDcbu(peDcbuC).fbta = *blanks;
            else;
              peDcbu(peDcbuC).fbta = %editc(dffbta:'X');
           endif;
           if dffbtm = 0;
              peDcbu(peDcbuC).fbtm = *blanks;
            else;
              peDcbu(peDcbuC).fbtm = %editc(dffbtm:'X');
           endif;
           if dffbtd = 0;
              peDcbu(peDcbuC).fbtd = *blanks;
            else;
              peDcbu(peDcbuC).fbtd = %editc(dffbtd:'X');
           endif;
           select;
            when dfbloq = 'N';
                 peDcbu(peDcbuC).blod = 'ACTIVA';
            when dfbloq = 'F';
                 peDcbu(peDcbuC).blod = 'BLOQUEADA';
            when dfbloq = 'R';
                 peDcbu(peDcbuC).blod = 'ACTIVA';
            other;
                 peDcbu(peDcbuC).blod = *blanks;
           endsl;

           chain dfivbc cntbco;
           if %found;
              peDcbu(peDcbuC).nomb = bcnomb;
            else;
              peDcbu(peDcbuC).nomb = *blanks;
           endif;
           k1tbcs.sbivbc = dfivbc;
           k1tbcs.sbivsu = dfivsu;
           chain %kds(k1tbcs) cntbcs;
           if %found;
              peDcbu(peDcbuC).nom1 = sbnomb;
            else;
              peDcbu(peDcbuC).nom1 = *blanks;
           endif;

           if dffbta > 0 and
              dffbtm > 0 and
              dffbtd > 0;
              peDcbu(peDcbuC).fblo = %editc(dffbtd:'X')
                                   + '/'
                                   + %editc(dffbtm:'X')
                                   + '/'
                                   + %editc(dffbta:'X');
              peDcbu(peDcbuC).fbl1 = %editc(dffbta:'X')
                                   + '/'
                                   + %editc(dffbtm:'X')
                                   + '/'
                                   + %editc(dffbtd:'X');
            else;
              peDcbu(peDcbuC).fblo = *blanks;
              peDcbu(peDcbuC).fbl1 = *blanks;
           endif;

        endif;

        reade peAsen gnhdcb;
       enddo;

       return;

      /end-free
