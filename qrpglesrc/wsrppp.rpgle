     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H alwnull(*usrctl)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRPPP: QUOM Versión 2                                       *
      *         Listado de PDFs de una póliza.                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Jul-2017            *
      * ------------------------------------------------------------ *
      * SGF 15/08/2020: Enviar a la corriente de datos todas las     *
      *                 superpolizas de la poliza para dar soporte   *
      *                 a los colectivos abiertos de Vida:           *
      *                 1 poliza - N Superpolizas                    *
      * SGF 23/09/2020: PDF de póliza versión corta                  *
      * ************************************************************ *
     Fset001    if   e           k disk
     Fpahed004  if   e           k disk    rename(p1hed004:p1hed0)
     Fpahec1    if   e           k disk
     Fpahpol    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D peBase          ds                  likeds(paramBase)
     D peErro          s                   like(paramErro)
     D peMsgs          ds                  likeds(paramMsgs)
     D x               s             10i 0
     D rc              s              1n
     D @@rama          s              2  0
     D @@poli          s              7  0
     D peRama          s              2  0
     D pePoli          s              7  0
     D @@repl          s          65535a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a
     D uri             s            512a
     D @@docu          s            128a
     D @@vsys          s            512a
     D @@femi          s              8  0
     D c1femi          s              8  0
     D url             s           3000a   varying

     D k1hed0          ds                  likerec(p1hed0 : *key)
     D k1hec1          ds                  likerec(p1hec1 : *key)
     D k1hpol          ds                  likerec(p1hpol : *key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       clear peBase;
       clear peMsgs;

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
       poli = REST_getNextPart(url);

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

       if %check( '0123456789' : %trim(poli) ) <> 0;
          %subst(@@repl:1:2) = rama;
          %subst(@@repl:3:7) = poli;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
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

       if SVPVLS_getValSys( 'HFECPDFRED' : *omit : @@vsys    ) = *off;
          @@femi = 99999999;
        else;
          @@femi = %dec(@@vsys:8:0);
       endif;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       peRama = %dec(rama:2:0);
       pePoli = %dec(poli:7:0);

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       k1hed0.d0suop = 0;
       setll %kds(k1hed0:4) pahed004;
       if not %equal;
          %subst(@@repl:01:2) = %editc(peRama:'X');
          %subst(@@repl:03:7) = %trim(%char(pePoli));
          %subst(@@repl:10:1) = %trim(%char(peBase.peNivt));
          %subst(@@repl:11:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       k1hpol.poempr = peBase.peEmpr;
       k1hpol.posucu = peBase.peSucu;
       k1hpol.ponivt = peBase.peNivt;
       k1hpol.ponivc = peBase.peNivc;
       k1hpol.porama = peRama;
       k1hpol.popoli = pePoli;
       setll %kds(k1hpol:6) pahpol;
       if not %equal;
          %subst(@@repl:01:2) = %editc(peRama:'X');
          %subst(@@repl:03:7) = %trim(%char(pePoli));
          %subst(@@repl:10:1) = %trim(%char(peBase.peNivt));
          %subst(@@repl:11:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       k1hpol.ponivt = peBase.peNit1;
       k1hpol.ponivc = peBase.peNiv1;
       setll %kds(k1hpol:6) pahpol;
       if not %equal;
          %subst(@@repl:01:2) = %editc(peRama:'X');
          %subst(@@repl:03:7) = %trim(%char(pePoli));
          %subst(@@repl:10:1) = %trim(%char(peBase.peNivt));
          %subst(@@repl:11:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       COWLOG_logcon('WSRPPP':peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray( 'documentos' );

       setll %kds(k1hed0:4) pahed004;
       reade %kds(k1hed0:4) pahed004;
       dow not %eof;
           @@docu = 'POLIZA_'
                  + %editc(d0arcd:'X')
                  + '_'
                  + %editc(d0spol:'X')
                  + '_'
                  + %editc(d0sspo:'X')
                  + '_'
                  + %editc(d0rama:'X')
                  + '_'
                  + %editc(d0poli:'X')
                  + '_'
                  + %editc(d0suop:'X')
                  + '.pdf';
           REST_startArray( 'documento' );
             REST_writeXmlLine( 'nombre' : %trim(@@docu) );
           REST_endArray  ( 'documento' );
           exsr $pdfRed;
        reade %kds(k1hed0:4) pahed004;
       enddo;

       REST_endArray  ( 'documentos' );

       REST_end();

       return;

       begsr $pdfRed;
        chain d0rama set001;
        if not %found;
           leavesr;
        endif;
        if t@rame <> 4 and d0rama <> 27;
           leavesr;
        endif;
        k1hec1.c1empr = d0empr;
        k1hec1.c1sucu = d0sucu;
        k1hec1.c1arcd = d0arcd;
        k1hec1.c1spol = d0spol;
        k1hec1.c1sspo = d0sspo;
        chain %kds(k1hec1:5) pahec1;
        if not %found;
           leavesr;
        endif;
        c1femi = (c1fema * 10000)
               + (c1femm *   100)
               +  c1femd;
        if (c1femi < @@femi);
           leavesr;
        endif;
        if (d0tiou = 1) or
           (d0tiou = 2) or
           (d0tiou = 3 and d0stos = 1);
           @@docu = 'POLIZA_'
                  + %editc(d0arcd:'X')
                  + '_'
                  + %editc(d0spol:'X')
                  + '_'
                  + %editc(d0sspo:'X')
                  + '_'
                  + %editc(d0rama:'X')
                  + '_'
                  + %editc(d0poli:'X')
                  + '_'
                  + %editc(d0suop:'X')
                  + '_RED.pdf';
           REST_startArray( 'documento' );
             REST_writeXmlLine( 'nombre' : %trim(@@docu) );
           REST_endArray  ( 'documento' );
         else;
           leavesr;
        endif;
       endsr;

      /end-free
