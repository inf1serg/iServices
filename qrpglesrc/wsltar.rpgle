     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLTAR : WebService: Retorna Datos Tarjeta Mercosur          *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                              *29/12/2015    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fpahet910  if   e           k disk
     Fpahet0    if   e           k disk
     Fset225    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'

     D WSLTAR          pr                  ExtPgm('WSLTAR')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peDato                            likeds(datTarj)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLTAR          pi
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peNmat                      25    const
     D   peDato                            likeds(datTarj)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     Dspwliblc         pr                  extpgm('TAATOOL/SPWLIBLC')
     D ento                           1a   const

     Dsleep            pr            10u 0 extproc('sleep')
     D seg                           10u 0 value

     D WSLOG           pr                  ExtPgm('QUOMDATA/WSLOG')
     D  msg                         512a   const

     D @PsDs          sds                  qualified
     D   job                         10a   overlay(@PsDs:244)
     D   user                        10a   overlay(@PsDs:254)
     D   numer                        6  0 overlay(@PsDs:264)
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     D k1yet9          ds                  likerec(p1het9:*key)
     D k1yet0          ds                  likerec(p1het0:*key)

     D wrepl           s          65535a

     D @cmd            s            500a   varying

       *inLr = *On;

       WSLOG( 'Job: ' + @PsDs.job
            + ' Usuario: ' + @PsDs.user
            + ' Nro: ' + %char(@PsDs.numer)     );

       peErro = *Zeros;

       clear peMsgs;
       clear peDato;

       if not SVPVAL_empresa ( peEmpr );

         %subst(wrepl:1:1) = peEmpr;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0113'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;

       if not SVPVAL_sucursal ( peEmpr : peSucu );

         %subst(wrepl:1:1) = peEmpr;
         %subst(wrepl:2:2) = peSucu;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0114'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;

       SPWLIBLC ('P');

       k1yet9.t9empr = peEmpr;
       k1yet9.t9sucu = peSucu;
       k1yet9.t9nmat = peNmat;

       setll %kds( k1yet9 : 3 ) pahet910;
       reade %kds( k1yet9 : 3 ) pahet910;

       dow not %eof ( pahet910 );

         if SPVSPO_chkVig ( t9empr : t9sucu : t9arcd : t9spol );

           peDato.asen = SPVSPO_getAsen ( t9empr : t9sucu : t9arcd : t9spol
                                        : t9sspo );

           peDato.nomb = SVPASE_getNombre ( peDato.asen );

           peDato.poli = t9poli;
           peDato.vhct = t9vhct;

           SPVSPO_getFecVig ( t9empr : t9sucu : t9arcd : t9spol
                            : peDato.ivig : peDato.fvig );

           peDato.nmat = peNmat;

           peDato.vhan = t9vhaÑ;

           if ( t9vhca = 1 ) or ( t9vhca = 4 ) or ( t9vhca = 5 );
             peDato.asis = 'S';
           else;
             peDato.asis = 'N';
           endif;

           SPVVEH_GetDescripcion ( t9vhmc : t9vhmo : t9vhcs
                                 : peDato.vhmd : peDato.vhdm
                                 : peDato.vhcd );

           peDato.moto = t9moto;

           peDato.tel1 = '0800-333-2927';
           peDato.tel2 = '0800-666-2202';
           peDato.tel3 = '(011) 4310-8991';

           k1yet0.t0empr = t9empr;
           k1yet0.t0sucu = t9sucu;
           k1yet0.t0arcd = t9arcd;
           k1yet0.t0spol = t9spol;
           k1yet0.t0sspo = t9sspo;
           k1yet0.t0rama = t9rama;
           k1yet0.t0arse = t9arse;
           k1yet0.t0oper = t9oper;
           k1yet0.t0poco = t9poco;

           setll %kds ( k1yet0 : 9 ) pahet0;
           reade %kds ( k1yet0 : 9 ) pahet0;

           peDato.cobl = t0cobl;

           chain t0cobl set225;

           peDato.acpa = t@accp;
           peDato.acto = t@acct;
           peDato.ropa = t@robp;
           peDato.roto = t@robt;
           peDato.inpa = t@incp;
           peDato.into = t@inct;

           return;

         endif;

         reade %kds( k1yet9 : 3 ) pahet910;

       enddo;

       %subst(wrepl:1:25) = peNmat;

       SVPWS_getMsgs( '*LIBL'
                    : 'WSVMSG'
                    : 'COW0115'
                    : peMsgs
                    : %trim(wrepl)
                    : %len(%trim(wrepl))  );

       peErro = -1;

       return;

