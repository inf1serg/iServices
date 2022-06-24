     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRVNR: QUOM Versión 2                                       *
      *         Vencidas y no renovadas.                             *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *07-Jun-2019            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpawvnr    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)

     D k1wvnr          ds                  likerec(p1wvnr:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon(%trim(psds.this):peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'vencidasNoRenovadas' : '*BEG' );

       k1wvnr.nrempr = empr;
       k1wvnr.nrsucu = sucu;
       k1wvnr.nrnivt = peBase.peNivt;
       k1wvnr.nrnivc = peBase.peNivc;
       setll %kds(k1wvnr:4) pawvnr;
       reade %kds(k1wvnr:4) pawvnr;
       dow not %eof;

        REST_writeXmlLine( 'vencidaNoRenovada' : '*BEG' );
         REST_writeXmlLine('descripcionRama' : %trim(nrramd) );
         REST_writeXmlLine('nroPoliza' : %trim(%char(nrpoli)) );
         REST_writeXmlLine('nombreAsegurado':%trim(nrnase) );
         REST_writeXmlLine('fechaVencimiento':SVPREST_editFecha(nrfvto));
         REST_writeXmlLine('saldo':SVPREST_editImporte(nrsald));
        REST_writeXmlLine( 'vencidaNoRenovada' : '*END' );

        reade %kds(k1wvnr:4) pawvnr;
       enddo;

       REST_writeXmlLine( 'vencidasNoRenovadas' : '*END' );
       REST_end();

       close *all;

       return;

      /end-free
