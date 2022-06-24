     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRDO1: QUOM Versión 2                                       *
      *         Tipos de Documento.                                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *27-Ago-2019            *
      * ************************************************************ *
     Fset08801  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D arcd            s              6a
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n

     D peMsgs          ds                  likeds(parammsgs)

     D @@rama          s              2  0
     D @@arcd          s              6  0
     D @@nit1          s              1  0

     D k1t088          ds                  likerec(s1t088:*key)

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
       rama = REST_getNextPart(url);
       arcd = REST_getNextPart(url);

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

       monitor;
           @@rama = %dec(rama:2:0);
        on-error;
           @@rama = 0;
       endmon;
       monitor;
           @@arcd = %dec(arcd:6:0);
        on-error;
           @@arcd = 0;
       endmon;
       monitor;
           @@nit1 = %dec(nit1:1:0);
        on-error;
           @@nit1 = 0;
       endmon;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'documentosPdf' : '*BEG');

       setll @@rama set08801;
       reade @@rama set08801;
       dow not %eof;

           if t@codi = 'FACOR' and @@nit1 < 3;
            else;
              REST_writeXmlLine( 'documentoPdf' : '*BEG');
               REST_writeXmlLine( 'codigo' : %trim(t@codi) );
               REST_writeXmlLine( 'descripcion' : %trim(t@desc) );
              REST_writeXmlLine( 'documentoPdf' : '*END');
           endif;

        reade @@rama set08801;
       enddo;

       REST_writeXmlLine( 'documentosPdf' : '*END');

       REST_end();

       return;

      /end-free
