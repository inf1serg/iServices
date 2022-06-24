     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRLEN: Portal de Autogestión de Asegurados.                 *
      *         Lista endosos en PDF.                                *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *10-Jul-2018            *
      * ------------------------------------------------------------ *
      * Modificaciones :                                             *
      * SGF 11/07/2019: Agrego chequera de pago y factura.           *
      * SGF 21/09/2020: PDF de póliza versión corta                  *
      * ************************************************************ *
     Fpahed004  if   e           k disk
     Fset901    if   e           k disk
     Fgnttdo    if   e           k disk
     Fpahaag    if   e           k disk
     Fpahec1    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/wslcer_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

      * ------------------------------------------------------------ *
      * URL y URI
      * ------------------------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying

      * ------------------------------------------------------------ *
      * Parámetros de URL
      * ------------------------------------------------------------ *
     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a
     D rama            s              2a
     D poli            s              7a
     D arcd            s              6a
     D spol            s              9a
     D poco            s              4a

     D x               s             10i 0
     D peTdoc          s              2  0
     D peNdoc          s             11  0
     D peMsgs          ds                  likeds(paramMsgs)
     D @@repl          s          65535a
     D peRama          s              2  0
     D pePoli          s              7  0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D femi            s              8  0
     D rc              s              1n
     D file            s            128a
     D fil1            s            128a
     D fil2            s            128a
     D fil3            s            128a

     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1haag          ds                  likerec(p1haag:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

     d @@TdocCUIT      s              2  0 inz(98)

      /free

       *inlr = *on;

       REST_getUri( psds.this : uri );
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tdoc = REST_getNextPart(url);
       ndoc = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);

       in lda;
       lda.empr = empr;
       lda.sucu = sucu;
       out lda;

       if SVPREST_chkCliente( empr
                            : sucu
                            : tdoc
                            : ndoc
                            : peMsgs ) = *Off;
          REST_writeHeader( 204
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

       if SVPREST_chkPolizaCliente( empr
                                  : sucu
                                  : arcd
                                  : spol
                                  : rama
                                  : poli
                                  : tdoc
                                  : ndoc
                                  : peMsgs ) = *off;
          REST_writeHeader( 204
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
         peRama = %dec(rama:2:0);
        on-error;
         peRama = 0;
       endmon;

       monitor;
         pePoli = %dec(poli:7:0);
        on-error;
         pePoli = 0;
       endmon;

       monitor;
         peArcd = %dec(arcd:6:0);
        on-error;
         peArcd = 0;
       endmon;

       monitor;
         peSpol = %dec(spol:9:0);
        on-error;
         peSpol = 0;
       endmon;

       monitor;
         peTdoc = %dec(tdoc:2:0);
        on-error;
         peTdoc = 0;
       endmon;

       monitor;
         peNdoc = %dec(ndoc:11:0);
        on-error;
         peNdoc = 0;
       endmon;

       rc = COWLOG_logConAutoGestion( empr
                                    : sucu
                                    : peTdoc
                                    : peNdoc
                                    : psds.this);

       setll peTdoc gnttdo;
       if not %equal and peTdoc <> @@TdocCUIT;
          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : 'AAG0001'
                               : 40
                               : 'Tipo de Documento Invalido'
                               : 'Tipo de Documento Invalido' );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       if peNdoc <= 0;
          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : 'AAG0002'
                               : 40
                               : 'Número de Documento no puede ser cero'
                               : 'Número de Documento no puede ser cero' );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       k1haag.agempr = empr;
       k1haag.agsucu = sucu;
       k1haag.agarcd = peArcd;
       k1haag.agspol = peSpol;
       k1haag.agrama = peRama;
       k1haag.agpoli = pePoli;
       k1haag.agtdoc = peTdoc;
       k1haag.agndoc = peNdoc;
       setll %kds(k1haag) pahaag;
       if not %equal;
          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : 'POL0015'
                               : 40
                               : 'La póliza no pertenece al documento'
                               : 'La póliza no pertenece al documento'  );
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'movimientos' );

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       setll %kds(k1hed0:4) pahed004;
       reade %kds(k1hed0:4) pahed004;
       dow not %eof;

           REST_startArray('movimiento');

            chain (d0tiou:d0stou) set901;
            if not %found;
               t@dsop = *blanks;
            endif;

            file = 'POLIZA_'
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
            fil1 = 'POLIZA_'
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
                 + '_FAA'
                 + '.pdf';
            fil2 = 'POLIZA_'
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
                 + '_CHE'
                 + '.pdf';
            fil3 = 'POLIZA_'
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
                 + '_RED'
                 + '.pdf';

            k1hec1.c1empr = d0empr;
            k1hec1.c1sucu = d0sucu;
            k1hec1.c1arcd = d0arcd;
            k1hec1.c1spol = d0spol;
            k1hec1.c1sspo = d0sspo;
            chain %kds(k1hec1:5) pahec1;
            femi = (c1fema * 10000) + (c1femm * 100) + c1femd;

            REST_writeXmlLine('descripcion'  : %trim(t@dsop));
            REST_writeXmlLine('archivo'      : %trim(file));
            REST_writeXmlLine('endoso'       : %editc(d0sspo:'X'));
            REST_writeXmlLine('fechaEmision' : SVPREST_editFecha(femi) );
            REST_writeXmlLine('facturaAsegurado': %trim(fil1) );
            REST_writeXmlLine('chequeraDePago': %trim(fil2) );
            REST_writeXmlLine('pdfReducido'  : %trim(fil3));


           REST_endArray('movimiento');

        reade %kds(k1hed0:4) pahed004;
       enddo;

       REST_endArray( 'movimientos' );

       return;

      /end-free

