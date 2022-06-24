     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRIXS: QUOM Versión 2                                       *
      *         Inspecciones por Reclamo o Siniestro                 *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *19-Jun-2017            *
      * ************************************************************ *
     Fsehni2    if   e           k disk
     Fset001    if   e           k disk
     Fpahzin    if   e           k disk
     Fpahzde    if   e           k disk
     Fpahscd    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D tipo            s              1a
     D rama            s              2a
     D sini            s              7a
     D idre            s             18a

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @@repl          s          65535a
     D fins            s             10a
     D peErro          s             10i 0
     D x               s             10i 0
     D z               s             10i 0
     D c               s             10i 0
     D @@rama          s              2  0

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)

     D k1hni2          ds                  likerec(s1hni2:*key)
     D k1hzin          ds                  likerec(p1hzin:*key)
     D k1hzde          ds                  likerec(p1hzde:*key)
     D k1hscd          ds                  likerec(p1hscd:*key)

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
       tipo = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       if (tipo = 'S');
          sini = REST_getNextPart(url);
        else;
          idre = REST_getNextPart(url);
       endif;

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

       if %check( '0123456789' : %trim(rama) ) <> 0;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       @@rama = %dec( rama : 2 : 0 );
       setll @@rama set001;
       if not %equal;
          @@repl = rama;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'RAM0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : 'RAM0001'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if (tipo = 'S');
          if %check( '0123456789' : %trim(sini) ) <> 0;
             %subst(@@repl:1:2) = rama;
             %subst(@@repl:3:7) = sini;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SIN0001'
                          : peMsgs
                          : %trim(@@repl)
                          : %len(%trim(@@repl)) );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'SIN0001'
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
             REST_end();
             close *all;
             return;
          endif;
       endif;

       if (tipo = 'S');
          k1hscd.cdempr = empr;
          k1hscd.cdsucu = sucu;
          k1hscd.cdrama = %dec( rama : 2 : 0 );
          k1hscd.cdsini = %dec( sini : 7 : 0 );
          chain  %kds(k1hscd:4) pahscd;
          if not %found;
             %subst(@@repl:1:2) = rama;
             %subst(@@repl:3:7) = sini;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'SIN0001'
                          : peMsgs
                          : %trim(@@repl)
                          : %len(%trim(@@repl)) );
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'SIN0001'
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;
       endif;

       if (tipo = 'R');
          k1hzde.deempr = empr;
          k1hzde.desucu = sucu;
          k1hzde.denivt = %dec( nivt : 1  : 0 );
          k1hzde.denivc = %dec( nivc : 5  : 0 );
          k1hzde.deidre = %dec( idre : 18 : 0 );
          setll  %kds(k1hzde:5) pahzde;
          if not %equal;
             rc = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'SIN0001'
                                  : peMsgs.peMsev
                                  : peMsgs.peMsg1
                                  : peMsgs.peMsg2 );
            REST_end();
            close *all;
            return;
          endif;
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       COWLOG_logcon('WSRIXS':peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'inspeccionesSiniestros' : '*BEG' );

       c = 0;

       exsr inspecciones;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'inspeccionesSiniestros' : '*END' );
       REST_end();

       close *all;

       return;

       begsr inspecciones;

        k1hzin.inempr = empr;
        k1hzin.insucu = sucu;
        k1hzin.inrama = %dec(rama:2:0);
        if (tipo = 'S');
           k1hzin.insini = %dec(sini:7:0);
           setll %kds(k1hzin:4) pahzin;
           reade %kds(k1hzin:4) pahzin;
           dow not %eof;
                c += 1;
                fins = %char(%date(infins:*iso));
                if fins = '0001-01-01';
                   fins = *blanks;
                endif;
                REST_writeXmlLine( 'inspeccion' : '*BEG' );
                REST_writeXmlLine( 'fechaIns'   : fins );
                REST_writeXmlLine( 'nroReclamo': %char(inidre) );
                REST_writeXmlLine( 'responsable': ininsd );
                REST_writeXmlLine( 'estado': instin );
                REST_writeXmlLine( 'tipoDoc': intdoc );
                REST_writeXmlLine( 'inspeccion' : '*END' );
               reade %kds(k1hzin:4) pahzin;
           enddo;
         else;
           setll %kds(k1hzin:3) pahzin;
           reade %kds(k1hzin:3) pahzin;
           dow not %eof;
               if inidre = %dec(idre:18:0);
                  fins = %char(%date(infins:*iso));
                  c += 1;
                  if fins = '0001-01-01';
                     fins = *blanks;
                  endif;
                  REST_writeXmlLine( 'inspeccion' : '*BEG' );
                  REST_writeXmlLine( 'fechaIns'   : fins );
                  REST_writeXmlLine( 'nroReclamo': %char(inidre) );
                  REST_writeXmlLine( 'responsable': ininsd );
                  REST_writeXmlLine( 'estado': instin );
                  REST_writeXmlLine( 'tipoDoc': intdoc );
                  REST_writeXmlLine( 'inspeccion' : '*END' );
               endif;
               reade %kds(k1hzin:3) pahzin;
           enddo;
        endif;

       endsr;
      /end-free
