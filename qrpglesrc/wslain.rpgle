     H option(*nodebugio:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLAIN:  WebService                                          *
      *          Inscripcion de Productores en LDAP                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *12-Sep-2019        *
      * ------------------------------------------------------------ *
      * ************************************************************ *

     Fsehni296  if   e           k disk

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D WSLAIN          pr                  extpgm('WSLAIN')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peMatr                        6  0 const
     D  peCuit                       11  0 const
     D  peMail                       50a   const
     D  peNomb                       40a
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D WSLAIN          pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peMatr                        6  0 const
     D  peCuit                       11  0 const
     D  peMail                       50a   const
     D  peNomb                       40a
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D k1hni2          ds                  likerec(s1hni2:*key)
     D @@DsInte        ds                  likeds( DsSehni2_t )
     D peMadd          ds                  likeds(Mailaddr_t) dim(100)
     D @@cuit          s             11a
     D @1cuit          s             11  0
     D si              s              1n
     D x               s             10i 0
     D z               s             10i 0
     D @@mail          s             50a
     D @@vsys          s            512a
     D @@vmat          s              1a

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       *inlr = *on;

       @@vmat = 'S';
       if SVPVLS_getValSys( 'HVALMATBLO' : *omit : @@vsys );
          @@vmat = @@vsys;
       endif;

       clear peMsgs;
       peErro = 0;
       peNomb = *blanks;

       if peMail = *blanks;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AIN0003'
                       : peMsgs    );
          peErro = -1;
          return;
       endif;

       @@mail = %xlate( min : may : peMail );

       k1hni2.n2empr = peEmpr;
       k1hni2.n2sucu = peSucu;
       k1hni2.n2matr = peMatr;

       setll %kds(k1hni2:3) sehni296;
       if not %equal;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AIN0007'
                       : peMsgs    );
          peErro = -1;
          return;
       endif;

       reade %kds(k1hni2:3) sehni296;
       dow not %eof;
           if n2bloq = '3' and @@vmat = 'S';
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'AIN0005'
                           : peMsgs    );
              peErro = -1;
              return;
           endif;
           @@cuit = SVPINT_getCuit( n2empr
                                  : n2sucu
                                  : n2nivt
                                  : n2nivc );
           monitor;
            @1cuit = %dec(@@cuit:11:0);
            on-error;
            @1cuit = 0;
           endmon;
           if @1cuit <> peCuit;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'AIN0004'
                           : peMsgs    );
              peErro = -1;
              return;
           endif;
           si = *off;
           z = SVPMAIL_xNrdaf( n2nrdf : peMadd : 5 );
           for x = 1 to z;
               peMadd(x).mail = %xlate( min : may : peMadd(x).mail );
               if peMadd(x).mail = @@mail;
                  si = *on;
                  leave;
               endif;
           endfor;
           if si = *off;
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'AIN0006'
                           : peMsgs    );
              peErro = -1;
              return;
           endif;
        reade %kds(k1hni2:3) sehni296;
       enddo;

       peNomb = SVPINT_getNombre( n2empr : n2sucu : n2nivt : n2nivc );

       return;

      /end-free

