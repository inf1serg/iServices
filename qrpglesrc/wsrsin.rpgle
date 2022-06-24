     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRSIN: QUOM Versión 2                                       *
      *         Establece orden de indicadores                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *05-Jun-2017            *
      * ************************************************************ *
     Fsetind    uf a e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D peBase_t        ds                  likeds(paramBase) template
     D k1tind          ds                  likerec(s1tind:*key)

     D req             ds                  qualified
     D  peBase                             likeds(peBase_t)
     D  peOrde                        3  0
     D  peIndi                       10a

     D stin            s        1000000a
     D opt             s            128a
     D x               s             10i 0
     D m               s            512a

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       x = REST_readStdInput( %addr(stin) : %len(stin) );
       if x > 10000000;
          REST_end();
          return;
       endif;

       opt = 'doc=string +
              path=wsrsin +
              case=any +
              allowextra=yes +
              allowmissing=yes';

       xml-into req %xml( %trim(stin) : opt );

       k1tind.t@empr = req.peBase.peEmpr;
       k1tind.t@sucu = req.peBase.peSucu;
       k1tind.t@nivt = req.peBase.peNivt;
       k1tind.t@nivc = req.peBase.peNivc;
       setll %kds(k1tind:4) setind;
       reade %kds(k1tind:4) setind;
       dow not %eof;
           delete s1tind;
        reade %kds(k1tind:4) setind;
       enddo;

       t@empr = req.peBase.peEmpr;
       t@sucu = req.peBase.peSucu;
       t@nivt = req.peBase.peNivt;
       t@nivc = req.peBase.peNivc;
       t@indi = req.peIndi;
       t@orde = req.peOrde;
       write s1tind;

       REST_writeHeader(204:*omit:*omit:*omit:*omit:*omit:*omit);

       close *all;

       return;

      /end-free
