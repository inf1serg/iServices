     H option(*srcstmt:*noshowcpy:*nodebugio)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRAGH: Portal de Autogestión de Asegurados.                 *
      *         Tipos de Pólizas por Documento.                      *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Gio Nicolini                                   * 08-Ene-2019 *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *

     Fpahaag01  if   e           k disk
     Fset001    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  job                          26a   overlay(PsDs:244)

     D k1haag          ds                  likerec(p1haag:*key)

     D uri             s            512a
     D url             s           3000a   varying

     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a

     D peTdoc          s              2  0
     D peNdoc          s             11  0
     D rc              s              1n
     D x               s              3i 0
     D @@repl          s          65535a
     D gram            s              1a

     D peMsgs          ds                  likeds(paramMsgs)

     d                 ds
     d wadata                              dim(99)
     d   @@rama                       1    overlay(wadata)
     d   @@ramd                            like(t@ramd) overlay(wadata : *next)
     d   @@ramb                            like(t@ramb) overlay(wadata : *next)

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

      /free

       *inlr = *on;

       clear @@rama;
       clear @@ramd;
       clear @@ramb;

       if not REST_getUri( psds.this : uri );
          return;
       endif;
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tdoc = REST_getNextPart(url);
       ndoc = REST_getNextPart(url);

       in lda;
       lda.empr = empr;
       lda.sucu = sucu;
       out lda;

       if SVPREST_chkCliente( empr
                            : sucu
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

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'tiposDePoliza' );

       k1haag.agempr = empr;
       k1haag.agsucu = sucu;
       k1haag.agtdoc = peTdoc;
       k1haag.agndoc = peNdoc;

       setll %kds(k1haag:4) pahaag01;
       reade %kds(k1haag:4) pahaag01;
       dow not %eof;

           gram = SVPWS_getGrupoRama( agrama );
           if gram = 'V';
              select;
               when agrama = 23;
                    gram = 'P';
               when agrama = 80;
                    gram = 'L';
               when agrama = 89;
                    gram = 'G';
              endsl;
           endif;

           if %lookup( gram : @@rama ) = 0;

             x = %lookup( ' ' : @@rama );

             if x > 0;
               @@rama(x) = gram;
               chain agrama set001;
               if %found(set001);
                 @@ramd(x) = %trim(t@ramd);
                 @@ramb(x) = %trim(t@ramb);
               endif;
             endif;

           endif;

        reade %kds(k1haag:4) pahaag01;
       enddo;

       for x = 1 to 99;
           if @@rama(x) <> ' ';
              REST_startArray( 'grupo' );
               REST_writeXmlLine( 'tipo' : @@rama(x) );
               REST_writeXmlLine( 'descripcion' : %trim(@@ramd(x)) );
               REST_writeXmlLine( 'descripcionCorta' : %trim(@@ramb(x)) );
              REST_endArray  ( 'grupo' );
           endif;
       endfor;

       REST_endArray( 'tiposDePoliza' );
       REST_end();
       SVPREST_end();

       return;

      /end-free
