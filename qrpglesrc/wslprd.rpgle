     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLPRD : WebService: Productor de un Asegurado               *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                              *01/03/2016    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fsehase    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'

     D WSLPRD          pr                  ExtPgm('WSLPRD')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peDint                            likeds(pahint_t)
     D   peMint                            likeds(dsMail_t) dim(100)
     D   peMintc                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPRD          pi
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peDint                            likeds(pahint_t)
     D   peMint                            likeds(dsMail_t) dim(100)
     D   peMintc                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLINT          pr                  ExtPgm('WSLINT')
     D   peBase                            likeds(paramBase) const
     D   peDint                            likeds(pahint_t)
     D   peMint                            likeds(dsMail_t) dim(100)
     D   peMintc                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Base          ds                  likeds(paramBase)

     D wrepl           s          65535a

       *inLr = *On;

       clear peDint;
       clear peMint;
       clear peMintC;
       clear peErro;
       clear peMsgs;

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
       chain peAsen sehase;
       if not %found ( sehase );

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

       @@Base.peEmpr = peEmpr;
       @@Base.peSucu = peSucu;
       @@Base.peNivt = asnivt;
       @@Base.peNivc = asnivc;
       @@Base.peNit1 = asnivt;
       @@Base.peNiv1 = asnivc;

       WSLINT ( @@Base : peDint : peMint : peMintC : peErro : peMsgs );

       return;
