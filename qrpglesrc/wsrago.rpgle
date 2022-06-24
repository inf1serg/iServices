     H option(*srcstmt:*noshowcpy:*nodebugio)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAGO: Portal de Autogestión de Asegurados.                 *
      *         Actualiza datos del asegurado (otros).               *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *31-Jul-2018            *
      * ------------------------------------------------------------ *
      *                                                              *
      * Se espera una estructura como la siguiente:                  *
      *                                                              *
      *  <mensaje>                                                   *
      *   <texto></texto>                                            *
      *  </mensaje>                                                  *
      *                                                              *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SGF 13/06/2019: Si sucursal llega en blanco, cargar.         *
      *                                                              *
      * ************************************************************ *
     Fpahag3    if a e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D SPT902          pr                  ExtPgm('SPT902')
     D  peTnum                        1a   const
     D  peNres                        7  0

     D mensaje_t       ds                  qualified template
     D  texto                       500a

     D mensaje         ds                  likeds(mensaje_t)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  job                          26a   overlay(PsDs:244)
     D  CurUsr                       10a   overlay(PsDs:358)

     D k1hag3          ds                  likerec(p1hag3:*key)

     D uri             s            512a
     D url             s           3000a   varying

     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a

     D buffer          s          65535a
     D buflen          s             10i 0
     D peTdoc          s              2  0
     D peNdoc          s             11  0
     D peCuit          s             11a
     D @@repl          s          65535a
     D peNres          s              7  0
     D peNrdf          s              7  0
     D options         s            100a
     D rc              s             10i 0
     D peMsgs          ds                  likeds(paramMsgs)
     D rc2             s              1n

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

      /free

       *inlr = *on;

       if not REST_getUri( psds.this : uri );
          return;
       endif;
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tdoc = REST_getNextPart(url);
       ndoc = REST_getNextPart(url);

       if sucu = *blanks;
          sucu = 'CA';
       endif;

       in lda;
       lda.empr = empr;
       lda.sucu = sucu;
       out lda;

       if SVPREST_chkCliente( empr
                            : sucu
                            : tdoc
                            : ndoc
                            : peMsgs
                            : peNrdf ) = *off;
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2   );
          REST_end();
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

       rc2 = COWLOG_logConAutoGestion( empr
                                     : sucu
                                     : peTdoc
                                     : peNdoc
                                     : psds.this);

       peCuit = %editc(peNdoc:'X');

       options = 'doc=string +
               path=mensaje  +
               case=any +
               allowextra=yes +
               allowmissing=yes';

       rc = REST_readStdInput( %addr(buffer): %len(buffer) );

       monitor;
           xml-into mensaje %xml( buffer : options);
        on-error;
           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : 'RPG0000'
                           : 40
                           : 'Error al parsear XML'
                           : 'Error al parsear XML' );
           REST_end();
           return;
       endmon;

       SPT902( ';' : peNres );
       k1hag3.g3empr = empr;
       k1hag3.g3sucu = sucu;
       k1hag3.g3nres = peNres;
       setll %kds(k1hag3) pahag3;
       if not %equal;
          g3empr = empr;
          g3sucu = sucu;
          g3nres = peNres;
          g3tdoc = peTdoc;
          g3ndoc = peNdoc;
          g3text = %trim(mensaje.texto);
          g3mar1 = '0';
          g3user = PsDs.CurUsr;
          g3date = %dec(%date():*iso);
          g3time = %dec(%time():*iso);
          write p1hag3;
       endif;

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine('result':'OK');
       REST_end();
       SVPREST_end();

       return;

      /end-free

