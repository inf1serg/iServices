     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRP12: QUOM Versión 2                                       *
      *         Preliquidación - Listar Valores Ingresados           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *10-Nov-2017            *
      * ------------------------------------------------------------ *
      * SGF 14/07/2020: Nueva version.                               *
      * SGF 27/08/2020: Cobranza integrada.                          *
      *                                                              *
      * ************************************************************ *
     Fcntbco    if   e           k disk
     Fcntbcw    if   e           k disk
     Fcntfpp    if   e           k disk
     Fpahpqv    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D nrpl            s              7a
     D tipo            s              1a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D x               s             10i 0
     D peNrpl          s              7  0
     D fech            s             10a
     D imcu            s             30a
     D @@nban          s             40a

     D CRLF            c                   x'0d25'

     D k1hpqv          ds                  likerec(p1hpqv:*key)
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0

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
       nrpl = REST_getNextPart(url);

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

       monitor;
          peNrpl = %dec(nrpl:7:0);
        on-error;
          peNrpl = 0;
       endmon;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray('Valores');

       k1hpqv.qvempr = empr;
       k1hpqv.qvsucu = sucu;
       k1hpqv.qvnivt = %dec(nivt:1:0);
       k1hpqv.qvnivc = %dec(nivc:5:0);
       k1hpqv.qvnrpl = peNrpl;
       setll %kds(k1hpqv:5) pahpqv;
       reade %kds(k1hpqv:5) pahpqv;
       dow not %eof;
        if qvarch = 'NULL';
           qvarch = *blanks;
        endif;
        chain qvivcv cntfpp;
        if not %found;
           pfivdv = *blanks;
           pfivce = *blanks;
        endif;
        @@nban = *blanks;
        select;
         when pfivce = 'CI'                   // Cobranza Integrada
           or pfivce = 'CH'                   // Cheque
           or pfivce = 'EC' ;                 // Echeq
              chain qvivbc cntbco;
              if %found;
                 @@nban = bcnomb;
              endif;
         when pfivce = 'DB';                  // Debito Bancario
              chain qvivbc cntbcw;
              if %found;
                 @@nban = bwnomb;
              endif;
        endsl;

        REST_startArray( 'Valor' );
         REST_writeXmlLine( 'fecha'   : SVPREST_editFecha(qvfech) );
         REST_writeXmlLine( 'importe' : SVPREST_editImporte(qvimcu) );
         REST_writeXmlLine( 'nroCheque' : %trim(qvivch) );
         REST_writeXmlLine( 'formaDePago':pfivdv         );
         REST_writeXmlLine( 'banco'      :@@nban         );
         REST_writeXmlLine( 'archivo'    : qvarch        );
         REST_writeXmlLine( 'codigoFormaDePago':%char(qvivcv));
        REST_endArray( 'Valor' );
        reade %kds(k1hpqv:5) pahpqv;
       enddo;

       REST_endArray('Valores');

       REST_end();

       return;

