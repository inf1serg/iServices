     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPDS: QUOM Versión 2                                       *
      *         Lista de Predenuncias de un intermediario            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Sep-2017            *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *   JSN 01/02/2019 - Nuevos tag: <tipoDeVoucher>               *
      *                                <numeroDeVoucher>             *
      *                                                              *
      * ************************************************************ *
     Fpds000    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D url             s           3000a   varying
     D rc              s              1n
     D c               s             10i 0
     D focu            s             10a
     D hocu            s              8a

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D k1s000          ds                  likerec(p1ds00:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

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
          return;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRPDS':peBase);

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'predenuncias' : '*BEG');

       c = 0;

       k1s000.p0empr = empr;
       k1s000.p0sucu = sucu;
       k1s000.p0nivt = %dec(nivt:1:0);
       k1s000.p0nivc = %dec(nivc:5:0);
       setgt %kds(k1s000:4) pds000;
       readpe %kds(k1s000:4) pds000;
       dow not %eof;

           c += 1;
           monitor;
             focu = %char(%date(p0focu):*Iso);
            on-error;
             focu = *blanks;
           endmon;
           monitor;
             hocu = %char(%time(p0hocu):*Iso);
            on-error;
             hocu = *blanks;
           endmon;
           hocu = %scanrpl( '.' : ':' : hocu);

           REST_writeXmlLine('predenuncia':'*BEG');
           REST_writeXmlLine('nroPreDenuncia':%char(p0npds));
           REST_writeXmlLine('codigoAsegurado':%char(p0nrdf));
           REST_writeXmlLine('nombreAsegurado':%trim(p0Nomb));
           REST_writeXmlLine('rama':%char(p0rama));
           REST_writeXmlLine('poliza':%char(p0poli));
           REST_writeXmlLine('patente':%trim(p0Pate));
           REST_writeXmlLine('documentoPdf':%trim(p0Fpdf));
           REST_writeXmlLine('codigoCausa':%char(p0caus));
           REST_writeXmlLine('nroSiniestro':%char(p0sini));
           REST_writeXmlLine('fechaOcurrencia':focu);
           REST_writeXmlLine('horaOcurrencia':hocu);
           REST_writeXmlLine('tipoDeVoucher' :p0Mar1);
           REST_writeXmlLine('numeroDeVoucher':%char(p0Nore));
           REST_writeXmlLine('predenuncia':'*END');

        readpe %kds(k1s000:4) pds000;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'predenuncias' : '*END' );

       return;

