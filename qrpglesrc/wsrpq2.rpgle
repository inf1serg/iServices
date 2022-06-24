     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRPQ2: QUOM Versión 2                                       *
      *         Preliquidación - Marcar/Desmarcar Columna            *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *17-Jul-2017            *
      * ************************************************************ *
      * NWN - 17-06-21 : Agregado de Quincena Posterior              *
      * ************************************************************ *
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehni201  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/plqweb_h.rpgle'

     D Ejecutar        pr                  ExtPgm(cpgm)
     D   peBase                            likeds(paramBase) const
     D   peNrpl                       7  0 const
     D   peImpn                      15  2
     D   peImpb                      15  2
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D acci            s              1a
     D colu            s              2a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D x               s             10i 0
     D peNrpl          s              7  0
     D peImpn          s             15  2
     D peImpb          s             15  2
     D neto            s             25a
     D brut            s             25a
     D cpgm            s             10a
     D nrpl            s              7a

     D CRLF            c                   x'0d25'

     D k1hni2          ds                  likerec(s1hni201:*key)

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
       acci = REST_getNextPart(url);
       colu = REST_getNextPart(url);

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

       if %check( '0123456789' : %trim(nrpl) ) <> 0 or
          %check( '0123456789' : %trim(nrpl) ) <> 0;
          %subst(@@repl:1:7) = nrpl;
          rc2 = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'PQW0001'
                             : peMsgs
                             : %trim(@@repl)
                             : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'PQW0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if colu <> 'DA' and
          colu <> 'QA' and
          colu <> 'QT' and
          colu <> 'QS' and
          colu <> 'QP' and
          colu <> 'SA';
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'PQW0013'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if acci <> 'M' and
          acci <> 'D';
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'PQW0012'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       clear peBase;
       clear peMsgs;
       peErro = 0;
       peImpn = 0;
       peImpb = 0;
       cpgm = *blanks;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       peNrpl = %dec(nrpl:7:0);

       select;
        when acci = 'M';
             select;
              when colu = 'DA';
                   cpgm = 'PLQWEB2';
              when colu = 'QA';
                   cpgm = 'PLQWEB4';
              when colu = 'QT';
                   cpgm = 'PLQWEB6';
              when colu = 'QS';
                   cpgm = 'PLQWEB8';
              when colu = 'SA';
                   cpgm = 'PLQWEB10';
              when colu = 'QP';
               PLQWEB_marcarQuincenaPosterior( peBase
                                             : peNrpl
                                             : peImpn
                                             : peImpb
                                             : peErro
                                             : peMsgs  );
             endsl;
        when acci = 'D';
             cpgm = 'PLQWEB11';
       endsl;

       monitor;
          peNrpl = %dec(nrpl:7:0);
        on-error;
          peNrpl = 0;
       endmon;


       if cpgm <> *blanks;
          Ejecutar( peBase
                  : peNrpl
                  : peImpb
                  : peImpn
                  : peErro
                  : peMsgs );
       endif;

       if peErro = -1;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
       endif;

       neto = %editw(peImpn:'             .  ');
       if peImpn = 0;
          neto = '.00';
       endif;
       brut = %editw(peImpb:'             .  ');
       if peImpb = 0;
          brut = '.00';
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'preliquidacion' : '*BEG' );

       REST_writeXmlLine( 'numero' : %char(peNrpl) );
       REST_writeXmlLine( 'importeNeto' : neto);
       REST_writeXmlLine( 'importeBruto' : brut);

       REST_writeXmlLine( 'preliquidacion' : '*END' );

       REST_end();
       close *all;

       return;

