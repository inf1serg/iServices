     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAGC: Portal de Autogestión de Asegurados.                 *
      *         Lista siniestros de póliza.                          *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *27-Jul-2018            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SGF 14/06/19: Solo mostrar las próximas tres impagas.        *
      * SGF 18/06/19: Mal la PTF anterior. Mostraba las pagas.       *
      *                                                              *
      * ************************************************************ *
     Fpahcd501  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
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

     D x               s             10i 0
     D peTdoc          s              2  0
     D peNdoc          s             11  0
     D peRepl          s          65535a
     D peRama          s              2  0
     D pePoli          s              7  0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D rc              s              1n
     D fvto            s              8  0
     D @fvto           s             10a
     D stat            s              3a

     D peMsgs          ds                  likeds(paramMsgs)

     D k1hcd5          ds                  likerec(p1hcd501:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

     D cuotas          ds                  qualified dim(256)
     D  fvto                          8  0
     D  imcu                         15  2

     D i               s             10i 0
     D z               s             10i 0

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

       k1hcd5.d5empr = empr;
       k1hcd5.d5sucu = sucu;
       k1hcd5.d5rama = peRama;
       k1hcd5.d5poli = pePoli;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'cuotas' );

       clear cuotas;

       setll %kds(k1hcd5:4) pahcd501;
       reade %kds(k1hcd5:4) pahcd501;
       dow not %eof;

           if (d5sttc <> '3');

              fvto = (d5fvca * 10000) + (d5fvcm * 100) + d5fvcd;

               i = %lookup( fvto : cuotas(*).fvto );
               if i = 0;
                  i = %lookup( 0 : cuotas(*).fvto );
               endif;

               if i > 0;
                  cuotas(i).fvto  = fvto;
                  cuotas(i).imcu += d5imcu;
               endif;

           endif;

        reade %kds(k1hcd5:4) pahcd501;
       enddo;

       sorta cuotas(*).fvto;

       z = 0;
       for x = 1 to 256;
           if cuotas(x).fvto <> 0;
              z += 1;
              REST_startArray('cuota');
              @fvto = SVPREST_editFecha(cuotas(x).fvto);
              REST_writeXmlLine('fechaVencimiento': @fvto );
              REST_writeXmlLine('numero': %trim(%char(z)));
              REST_writeXmlLine('importe'
                               : SVPREST_editImporte(cuotas(x).imcu) );
              REST_writeXmlLine('estado'   : 'IMP');
              REST_endArray('cuota');
           endif;
           if z = 3;
              leave;
           endif;
       endfor;

       REST_endArray( 'cuotas' );

       return;

      /end-free

