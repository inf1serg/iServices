     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRRCT: QUOM Versión 2                                       *
      *         Lista rechazos débito automático - Cabecera          *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Feb-2020            *
      * ------------------------------------------------------------ *
      * 07/02/20 EXT1 - Se agrega logica                             *
      * ************************************************************ *
     Fpahrwc01  if   e           k disk    rename(p1hrwc:p1hrwc01)
     Fpahrwc02  if   e           k disk    rename(p1hrwc:p1hrwc02)

      /copy './qcpybooks/spvtcr_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D fema            s              4a
     D femm            s              2a
     D tipo            s              1a
     D ctcu            s              3a
     D url             s           3000a   varying
     D rc              s              1n

     D ErrCode         s             10i 0
     D ErrText         s             80A

     D peFemm          s              2  0
     D peCtcu          s              3  0
     D peFema          s              4  0

     D peMsgs          ds                  likeds(paramMsgs)
     D k1hrwc          ds                  likerec(p1hrwc01:*key)
     D k2hrwc          ds                  likerec(p1hrwc02:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       ctcu = *Blanks;
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       fema = REST_getNextPart(url);
       femm = REST_getNextPart(url);
       tipo = REST_getNextPart(url);
       if url <> *blanks;
          ctcu = REST_getNextPart(url);
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

       monitor;
         peFema = %dec(fema:4:0);
        on-error;
         peFema = %subdt(%timestamp():*y);
       endmon;

       monitor;
         peFemm = %dec(femm:2:0);
        on-error;
         peFema = %subdt(%timestamp():*m);
       endmon;

       if tipo <> 'T' and tipo <> 'D';
         tipo = 'D';
       endif;

       monitor;
         peCtcu = %dec(ctcu:3:0);
       on-error;
         peCtcu = 0;
       endmon;

       if tipo = 'T';
         if not SPVTCR_chkEmpresa( peCtcu );
           ErrText = SPVTCR_Error(ErrCode);
           if ( ErrCode = SPVTCR_EMINE );
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'TCR0001'
                          : peMsgs );
           else;
             SVPWS_getMsgs( '*LIBL'
                          : 'WSVMSG'
                          : 'TCR0002'
                          : peMsgs );
           endif;
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           return;
         endif;
       endif;


       REST_writeHeader();
       REST_writeEncoding();

       if tipo = 'D';
         k1hrwc.wcempr = empr;
         k1hrwc.wcsucu = sucu;
         k1hrwc.wcnivt = %dec(nivt:1:0);
         k1hrwc.wcnivc = %dec(nivc:5:0);
         k1hrwc.wcfvpa = peFema;
         k1hrwc.wcfvpm = peFemm;
       else;
         k2hrwc.wcempr = empr;
         k2hrwc.wcsucu = sucu;
         k2hrwc.wcnivt = %dec(nivt:1:0);
         k2hrwc.wcnivc = %dec(nivc:5:0);
         k2hrwc.wcctcu = peCtcu;
         k2hrwc.wcfvpa = peFema;
         k2hrwc.wcfvpm = peFemm;
       endif;

       if tipo = 'D';
          setll %kds(k1hrwc:6) pahrwc01;
          reade %kds(k1hrwc:6) pahrwc01;
        else;
          setll %kds(k2hrwc:7) pahrwc02;
          reade %kds(k2hrwc:7) pahrwc02;
       endif;

       REST_startArray( 'lotes' );

       dow not %eof;

         REST_startArray( 'lote' );

         REST_writeXmlLine( 'fecha'
                          : %editc(wcfvpa:'X')
                          + '-'
                          + %editc(wcfvpm:'X')
                          + '-'
                          + %editc(wcfvpd:'X') );
         REST_writeXmlLine( 'numeroPreliquidacion' : %trim(%char(wcnrpl)));

         REST_endArray  ( 'lote' );

         if tipo = 'D';
           reade %kds(k1hrwc:6) pahrwc01;
         else;
           reade %kds(k2hrwc:7) pahrwc02;
         endif;
       enddo;

       REST_endArray  ( 'lotes' );

       return;

      /end-free
