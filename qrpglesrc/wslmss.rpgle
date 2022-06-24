     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLMSA : WebService - Actualiza Status mensajeria Asegurados *
      * ------------------------------------------------------------ *
      * Julio Barranco                                 02/03/2016    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fgntms1    uf a e           k disk
     Fsehase    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'

     D WSLMSS          pr                  ExtPgm('WSLMSS')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peMsid                      25    const
     D   peRead                       1    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLMSS          pi
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peMsid                      25    const
     D   peRead                       1    const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @@more          s               n

     D ktms1           ds                  likerec(g1tms1:*key)

     D finArc          pr              n

     D @@cant          s             10i 0
     D @@type          s              2
     D @@fmsg          s               d
     D wrepl           s          65535a
     D
     D                sds
     D vsuser                254    263
     D
     Dspwliblc         pr                  extpgm('TAATOOL/SPWLIBLC')
     D ento                           1a   const
     D

       *inLr = *On;

       clear peErro;
       clear peMsgs;

      *- Validaciones
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

      *- Valido Existencia de Asegurado
       setll peAsen sehase;
       if not %equal ( sehase );

         %subst(wrepl:1:7) = %editC(peAsen:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;
       endif;

      *- Valido Existencia del Mensaje

       ktms1.s1empr = peEmpr;
       ktms1.s1sucu = peSucu;
       ktms1.s1Asen = peAsen;
       ktms1.s1msid = peMsid;

       setll %kds ( ktms1 : 4 ) gntms1;
       if not %equal();

         %subst(wrepl:1:7) = %editC(peAsen:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;


      *- Valido Marca del mensaje

       if peRead <> '0' and peRead <> '1';

         %subst(wrepl:1:7) = %editC(peAsen:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;

       SPWLIBLC ('P');

       ktms1.s1empr = peEmpr;
       ktms1.s1sucu = peSucu;
       ktms1.s1Asen = peAsen;
       ktms1.s1msid = peMsid;

       chain %kds ( ktms1 : 4 ) gntms1;
       if %found();

         s1Read = peRead;
         s1user = vsuser;
         s1date = udate;
         s1time = %dec(%time);

         update g1tms1;

       endif;

