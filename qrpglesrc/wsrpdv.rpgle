     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)

      * ********************************************************************** *
      * WSRPDV: QUOM Versión 2                                                 *
      *         Pólizas con Deuda Vencida a Productores                        *
      * ---------------------------------------------------------------------- *
      * Gio Nicolini                                             * 21-May-2018 *
      * ---------------------------------------------------------------------- *
      *                                                                        *
      * ********************************************************************** *

     Fpawdvd03  if   e           k disk

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

     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)

     D k1wdvd          ds                  likerec(p1wdvd:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       REST_getUri( psds.this : uri );
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

       clear peBase;
       clear peMsgs;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRPDV':peBase);

       k1wdvd.vdempr = empr;
       k1wdvd.vdsucu = sucu;
       k1wdvd.vdnivt = %dec(nivt:1:0);
       k1wdvd.vdnivc = %dec(nivc:5:0);

       setll %kds(k1wdvd:4) pawdvd03;

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine( 'productorConDeuda' : '*BEG');

       REST_writeXmlLine( 'tieneDeudaVencida' : %equal(pawdvd03) );

       REST_writeXmlLine( 'productorConDeuda' : '*END');

       REST_end();

       close *all;

       return;

      /end-free
