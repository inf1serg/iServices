     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRRWD: QUOm Versión 2 de WSRRCT                             *
      *         Lista rechazos débito automático - Cabecera          *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *04-Feb-2020            *
      * ------------------------------------------------------------ *
      * 07/02/20 EXT1 - Se agrega logica                             *
      * 09/06/21 SPV  - Se agrega:                                   *
      *                 - Lectura de archivo PAHPD510                *
      *                 - Servicios de Edicion                       *
      *                   Tarjeta   SPVTCR_getNroTcPant()            *
      *                   CBU       SPVCBU_GetCBUEntero()            *
      * ************************************************************ *
     Fpahrwc    if   e           k disk
     Fpahrwd01  if   e           k disk
spv  Fpahpd510  if   e           k disk
     Fgnttc7    if   e           k disk
     Fgnttc1    if   e           k disk
     Fgnttc5    if   e           k disk
     Fcntbcu    if   e           k disk
     Fcntbcrc   if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'
spv   /copy './qcpybooks/spvtcr_h.rpgle'
spv   /copy './qcpybooks/spvcbu_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D nrpl            s              7a
     D url             s           3000a   varying
     D rc              s              1n
     D t               s              1a
     D crch            s              3  0

spv  D @@Nrt           s             25a
spv  D @@Tar           s             25a
spv  D @@cbu           s             25a                                        |              PAR35
spv  D @@dta           s             25a

     D peNrpl          s              7  0

     D peMsgs          ds                  likeds(paramMsgs)
     D k1hrwd          ds                  likerec(p1hrwd:*key)
     D k1hrwc          ds                  likerec(p1hrwc:*key)
spv  D k1hpd5          ds                  likerec(p1hpd510:*key)

     D k1ttc1          ds                  likerec(g1ttc1:*key)
     D k1ttc5          ds                  likerec(g1ttc5:*key)
     D k1ttc7          ds                  likerec(g1ttc7:*key)
     D k1tbcu          ds                  likerec(c1tbcu:*key)
     D k1tbcr          ds                  likerec(c1tbcrc:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       t = 'D';
       rc  = REST_getUri( psds.this : uri );
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

       monitor;
         peNrpl = %dec(nrpl:7:0);
        on-error;
         peNrpl = 0;
       endmon;

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

       REST_writeHeader();
       REST_writeEncoding();

       k1hrwc.wcempr = empr;
       k1hrwc.wcsucu = sucu;
       k1hrwc.wcnivt = %dec(nivt:1:0);
       k1hrwc.wcnivc = %dec(nivc:5:0);
       k1hrwc.wcnrpl = peNrpl;
       chain %kds(k1hrwc:5) pahrwc;
       if %found;
          if wcctcu > 0;
             t = 'T';
          endif;
       endif;

       chain wcctcu gnttc1;
       if not %found;
          t1ctce = *blanks;
       endif;

       k1hrwd.wdempr = empr;
       k1hrwd.wdsucu = sucu;
       k1hrwd.wdnivt = %dec(nivt:1:0);
       k1hrwd.wdnivc = %dec(nivc:5:0);
       k1hrwd.wdnrpl = peNrpl;

       REST_startArray( 'rechazos' );

       setll %kds(k1hrwd:5) pahrwd01;
       reade %kds(k1hrwd:5) pahrwd01;

       dow not %eof;

        REST_startArray( 'rechazo' );

         REST_writeXmlLine( 'rama'   : %trim(%char(wdrama)) );
         REST_writeXmlLine( 'descripcioRama' : SVPDES_rama(wdrama) );
         REST_writeXmlLine( 'poliza' : %trim(%char(wdpoli)) );
         REST_writeXmlLine( 'endoso' : %trim(%char(wdsuop)) );

         REST_writeXmlLine( 'asegurado' :
         SVPASE_getNombre( SPVSPO_getAsen
                         ( wdempr : wdsucu : wdarcd : wdspol : wdsspo ) ) );

         REST_writeXmlLine( 'importe': SVPREST_editImporte(wdimpo) );

spv  *  // Recupera Numero de Tarjeta y CBU
spv      k1hpd5.p5empr = wdempr;
spv      k1hpd5.p5sucu = wdsucu;
spv      k1hpd5.p5nrpl = wdnrpl;
spv      k1hpd5.p5rama = wdrama;
spv      k1hpd5.p5poli = wdpoli;
spv      k1hpd5.p5sspo = wdsspo;
spv      k1hpd5.p5arcd = wdarcd;
spv      k1hpd5.p5spol = wdspol;
spv      setll %kds(k1hpd5:8) pahpd510;
spv      reade %kds(k1hpd5:8) pahpd510;
spv  *  // edita Tarjeta o CBU
spv      if t = 'T';
spv          @@Nrt = SPVTCR_getNroTcPant ( p5Ctcu
spv                                      : p5Nrtc );
spv          @@tar = %trim(@@Nrt);
spv          @@dta = '**** **** **' + %subst(@@tar:13:07);
spv          @@dta = '************' + %subst(@@tar:13:07);
spv          @@dta = '000000000000' + %subst(@@tar:13:07);
spv      else;
spv          @@cbu  = SPVCBU_getCbuEntero( p5ivbc
spv                                      : p5ivsu
spv                                      : p5tcta
spv                                      : p5ncta);
spv          @@tar = %trim(@@cbu);
spv          @@dta = '****************' + %subst(@@tar:17:06);
spv          @@dta = '0000000000000000' + %subst(@@tar:17:06);
spv      endif;

       //REST_writeXmlLine( 'numeroPago': %trim(%char(wdnrpl)) );
spv      REST_writeXmlLine( 'numeroPago': %trim(@@dta) );

         REST_writeXmlLine( 'numeroRechazo': %char(wdpsre) );

         monitor;
           crch = %dec(wdcrce:3:0);
         on-error;
           crch = *Zeros;
         endmon;
         if t = 'T';
           k1ttc7.t7empr = empr;
           k1ttc7.t7sucu = sucu;
           k1ttc7.t7ctcu = wcctcu;
           k1ttc7.t7ivbc = 0;
           k1ttc7.t7crch = wdcrch;
           k1ttc7.t7care = wdpsre;
           t7drch = 'DESCRIPCION NO ENCONTRADA';
           chain %kds(k1ttc7:6) gnttc7;
           // --------------------------------------
           // Diners y Cabal: especial
           // --------------------------------------
           if t1ctce = 'DC' or t1ctce = 'CA';
              k1ttc5.t5ctcu = wcctcu;
              k1ttc5.t5crch = wdcrce;
              chain %kds(k1ttc5) gnttc5;
              if %found;
                 t7drch = t5drch;
              endif;
           endif;
           REST_writeXmlLine( 'motivoRechazo': %trim( t7drch ) );
         else;
           k1tbcr.crcivcc = 1;
           k1tbcr.crcivbc = 15;
           k1tbcr.crccrch = wdcrch;
           k1tbcr.crccare = wdpsre;
           chain %kds(k1tbcr:4) cntbcrc;
           REST_writeXmlLine( 'motivoRechazo': %trim( crcdrch ) );
         endif;

        REST_endArray  ( 'rechazo' );

        reade %kds(k1hrwd:5) pahrwd01;
       enddo;

       REST_endArray  ( 'rechazos' );

       return;

      /end-free
