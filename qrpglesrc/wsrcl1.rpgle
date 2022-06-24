     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRCL1: QUOM Versión 2                                       *
      *         Lista de asegurados por intermediario                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *08-Ago-2017            *
      * ************************************************************ *
     Fpahas104  if   e           k disk
     Fsehase01  if   e           k disk
     Fgntiv1    if   e           k disk
     Fgnttdo    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@cuit          s             11  0

     D k1has1          ds                  likerec(p1has1:*key)
     D peMsgs          ds                  likeds(paramMsgs)

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

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'asegurados' : '*BEG' );

       k1has1.assucu = sucu;
       k1has1.asnivt = %dec(nivt:1:0);
       k1has1.asnivc = %dec(nivc:5:0);

       setll %kds(k1has1:3) pahas104;
       reade %kds(k1has1:3) pahas104;
       dow not %eof;
       chain asasen sehase01;
       if %found;
          chain asciva gntiv1;
          if not %found;
             i1ncil = *blanks;
          endif;
          chain dftido gnttdo;
          if not %found;
             gndtdo = *blanks;
          endif;
          @@cuit = 0;
          monitor;
            @@cuit = %dec(dfcuit:11:0);
           on-error;
            @@cuit = 0;
          endmon;
          if (dftido <> 99 and asbloq = '0') or
             (dftido = 99 and @@cuit > 0 and asbloq = '0');
             REST_writeXmlLine('asegurado':'*BEG');
             REST_writeXmlLine('codigo':%trim(%char(asasen)));
             REST_writeXmlLine('nombre':%trim(dfnomb));
             REST_writeXmlLine('tipoDeDocumento':%trim(gndtdo));
             REST_writeXmlLine('numeroDeDocumento':%trim(%char(dfnrdo)));
             REST_writeXmlLine('numeroDeCuit':%trim(dfcuit));
             REST_writeXmlLine('descripcionIva':%trim(i1ncil));
             REST_writeXmlLine('asegurado':'*END');
          endif;
       endif;

       reade %kds(k1has1:3) pahas104;
       enddo;

       REST_writeXmlLine( 'asegurados' : '*END' );

       return;

