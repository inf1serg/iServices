     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRTPI: QUOM Versión 2                                       *
      *         Lista de totales de producción                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *31-May-2017            *
      * ************************************************************ *
     Fpahpr102  if   e           k disk
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fpahed004  if   e           k disk
     Fsehni201  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D prim            s             30a
     D prem            s             30a
     D comi            s             30a
     D pric            s             30a
     D prec            s             30a
     D comc            s             30a
     D mes             s             20a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D tope            s              6  0
     D fecha           s              6  0
     D c               s             10i 0
     D rc2             s             10i 0

     D meses           s             20a   dim(12) ctdata perrcd(1)

     D CRLF            c                   x'0d25'

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D k1hpr1          ds                  likerec(p1hpr1:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       tope = ( (*year - 1) * 100 ) + *month;

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

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       COWLOG_logcon('WSRTPI':peBase);


       k1hpr1.prempr = empr;
       k1hpr1.prsucu = sucu;
       k1hpr1.prnivt = %dec( nivt : 1 : 0 );
       k1hpr1.prnivc = %dec( nivc : 5 : 0 );

       REST_writeHeader();

       REST_writeEncoding();
       REST_writeXmlLine( 'totales' : '*BEG');

       c = 0;

       setll %kds(k1hpr1:4) pahpr102;
       reade %kds(k1hpr1:4) pahpr102;
       dow not %eof;

           fecha = (prfema * 100) + prfemm;
           if fecha < tope;
              leave;
           endif;

           prim = %editw( prprim : '                 .  -' );
           prem = %editw( prprem : '                 .  -' );
           select;
            when k1hpr1.prnivt = 1;
                 comi = %editw( prcomi01 : '                 .  -' );
                 pric = %editw( prprco01 : '                 .  -' );
                 prec = %editw( prpoco01 : '                 .  -' );
                 comc = %editw( prcoco01 : '                 .  -' );
            when k1hpr1.prnivt = 2;
                 comi = %editw( prcomi02 : '                 .  -' );
                 pric = %editw( prprco02 : '                 .  -' );
                 prec = %editw( prpoco02 : '                 .  -' );
                 comc = %editw( prcoco02 : '                 .  -' );
            when k1hpr1.prnivt = 3;
                 comi = %editw( prcomi03 : '                 .  -' );
                 pric = %editw( prprco03 : '                 .  -' );
                 prec = %editw( prpoco03 : '                 .  -' );
                 comc = %editw( prcoco03 : '                 .  -' );
            when k1hpr1.prnivt = 4;
                 comi = %editw( prcomi04 : '                 .  -' );
                 pric = %editw( prprco04 : '                 .  -' );
                 prec = %editw( prpoco04 : '                 .  -' );
                 comc = %editw( prcoco04 : '                 .  -' );
            when k1hpr1.prnivt = 5;
                 comi = %editw( prcomi05 : '                 .  -' );
                 pric = %editw( prprco05 : '                 .  -' );
                 prec = %editw( prpoco05 : '                 .  -' );
                 comc = %editw( prcoco05 : '                 .  -' );
            when k1hpr1.prnivt = 6;
                 comi = %editw( prcomi06 : '                 .  -' );
                 pric = %editw( prprco06 : '                 .  -' );
                 prec = %editw( prpoco06 : '                 .  -' );
                 comc = %editw( prcoco06 : '                 .  -' );
            when k1hpr1.prnivt = 7;
                 comi = %editw( prcomi07 : '                 .  -' );
                 pric = %editw( prprco07 : '                 .  -' );
                 prec = %editw( prpoco07 : '                 .  -' );
                 comc = %editw( prcoco07 : '                 .  -' );
            when k1hpr1.prnivt = 8;
                 comi = %editw( prcomi08 : '                 .  -' );
                 pric = %editw( prprco08 : '                 .  -' );
                 prec = %editw( prpoco08 : '                 .  -' );
                 comc = %editw( prcoco08 : '                 .  -' );
            when k1hpr1.prnivt = 9;
                 comi = %editw( prcomi09 : '                 .  -' );
                 pric = %editw( prprco09 : '                 .  -' );
                 prec = %editw( prpoco09 : '                 .  -' );
                 comc = %editw( prcoco09 : '                 .  -' );
           endsl;

           c += 1;

           if prim = *blanks;
              prim = '.00';
           endif;

           if prem = *blanks;
              prem = '.00';
           endif;

           if comi = *blanks;
              comi = '.00';
           endif;

           if pric = *blanks;
              pric = '.00';
           endif;

           if prec = *blanks;
              prec = '.00';
           endif;

           if comc = *blanks;
              comc = '.00';
           endif;

           mes = meses(prfemm);

           REST_writeXmlLine( 'total ' : '*BEG' );
            REST_writeXmlLine( 'rama'            : %trim(%char(prrama)) );
            REST_writeXmlLine( 'mes'             : mes );
            REST_writeXmlLine( 'anio'            : %trim(%char(prfema)) );
            REST_writeXmlLine( 'primaEmitida'    :  %trim(prim)    );
            REST_writeXmlLine( 'premioEmitido'   :  %trim(prem)    );
            REST_writeXmlLine( 'comisionEmitida' :  %trim(comi)    );
            REST_writeXmlLine( 'primaCobrada'    :  %trim(pric)    );
            REST_writeXmlLine( 'premioCobrado'   :  %trim(prec)    );
            REST_writeXmlLine( 'comisionCobrada' :  %trim(comc)    );
           REST_writeXmlLine( 'total ' : '*END' );

        reade %kds(k1hpr1:4) pahpr102;
       enddo;

       REST_writeXmlLine( 'cantidad' : %trim(%char(c)) );
       REST_writeXmlLine( 'totales' : '*END' );

       close *all;

       return;

**
Enero
Febrero
Marzo
Abril
Mayo
Junio
Julio
Agosto
Septiembre
Octubre
Noviembre
Diciembre
