     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRSXI: QUOM Versión 2                                       *
      *         Lista de siniestros por intermediario                *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *01-Jun-2017            *
      * ------------------------------------------------------------ *
      * SGF 13/04/2021: Agrego tag para ramas no vida que indica si  *
      *                 se puede o no obtener un PDF con la denuncia.*
      *                                                              *
      * ************************************************************ *
     Fpahstr102 if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehase01  if   e           k disk
     Fsehni201  if   e           k disk    prefix(n2:2)
     Fpahscd    if   e           k disk
     Fset001    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D WSXSIN          pr                  ExtPgm('WSXSIN')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peSini                        7  0 const
     D  peNops                        7  0 const
     D  peSini                             likeds(pahstro_t)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D fden            s             10d
     D fsin            s             10d
     D c               s             10i 0
     D rc2             s             10i 0
     D @@den           s             10a
     D @@ocu           s             10a
     D @@vsys          s            512a

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peSini          ds                  likeds(pahstro_t)
     D peErro          s             10i 0
     D k1hstr          ds                  likerec(p1hstr1:*key)
     D k1hscd          ds                  likerec(p1hscd:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       if SVPVLS_getValSys( 'HPDFDENHAB' : *omit : @@vsys) = *off;
          @@vsys = 'S';
       endif;

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

       k1hstr.stempr = empr;
       k1hstr.stsucu = sucu;
       k1hstr.stnivt = %dec( nivt : 1 : 0 );
       k1hstr.stnivc = %dec( nivc : 5 : 0 );

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       COWLOG_logcon('WSRSXI':peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'siniestros' : '*BEG');

       c = 0;

       setll %kds(k1hstr:4) pahstr102;
       reade %kds(k1hstr:4) pahstr102;
       dow not %eof;

           c += 1;

           fden = %date(stfden:*iso);
           fsin = %date(stfsin:*iso);

           k1hscd.cdempr = stempr;
           k1hscd.cdsucu = stsucu;
           k1hscd.cdrama = strama;
           k1hscd.cdsini = stsini;
           chain %kds(k1hscd:4) pahscd;
           if not %found;
              cdnops = 0;
           endif;

           WSXSIN( stempr
                 : stsucu
                 : strama
                 : stsini
                 : cdnops
                 : peSini );

           @@den = %trim(%char(fden:*iso));
           @@ocu = %trim(%char(fsin:*iso));

           REST_writeXmlLine( 'siniestro' : '*BEG' );
            REST_writeXmlLine( 'rama'               : %trim(%char(strama)) );
            REST_writeXmlLine( 'poliza'             : %trim(%char(stpoli)) );
            REST_writeXmlLine( 'nroSiniestro'       : %trim(%char(stsini)) );
            REST_writeXmlLine( 'asegurado'          : %trim(peSini.stasno) );
            REST_writeXmlLine('fechaDenuncia'       :@@den);
            REST_writeXmlLine('fechaSiniestro'      :@@ocu);
            REST_writeXmlLine( 'causa'              : %trim(peSini.stcaud) );
            REST_writeXmlLine( 'estado'             : %trim(peSini.stdesi) );
            REST_writeXmlLine( 'enJuicio' : peSini.stjuic );
            REST_writeXmlLine( 'bienSiniestrado' : peSini.stbiensin);
            if @@vsys = 'S';
               chain peSini.strama set001;
               if %found;
                  if t@rame <> 18 and t@rame <> 21;
                     REST_writeXmlLine('denunciaPdf' : 'S' );
                   else;
                     REST_writeXmlLine('denunciaPdf' : 'N' );
                  endif;
                else;
                  REST_writeXmlLine('denunciaPdf' : 'N' );
               endif;
             else;
               REST_writeXmlLine('denunciaPdf' : 'N' );
            endif;
           REST_writeXmlLine( 'siniestro' : '*END' );

        reade %kds(k1hstr:4) pahstr102;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'siniestros' : '*END' );

       close *all;

       return;

