     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRPIW: QUOM Versión 2                                       *
      *         Polizas con Saldo impago.                            *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        *14-Feb-2020            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fpahpiw01  if   e           k disk    rename(p1hpiw:p1hpiw01)
     Fpahpiw02  if   e           k disk    rename(p1hpiw:p1hpiw02)
     Fpahpiw03  if   e           k disk    rename(p1hpiw:p1hpiw03)

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'

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
     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D Nombre          s             50
     D xxDram          s             20

     D k1hpiw01        ds                  likerec(p1hpiw01:*key)

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

       if tipo <> 'F' and tipo <> 'R';
        tipo = *blank;
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

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon(%trim(psds.this):peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'polizasConSaldo' : '*BEG' );

       k1hpiw01.piempr = empr;
       k1hpiw01.pisucu = sucu;
       k1hpiw01.pinivt = peBase.peNivt;
       k1hpiw01.pinivc = peBase.peNivc;
       k1hpiw01.pinivc = peBase.peNivc;

       select;
        when (tipo = 'R');  // Renovaciones //
             setll %kds(k1hpiw01:4) pahpiw01;
             reade %kds(k1hpiw01:4) pahpiw01;
             dow not %eof;
                 exsr srdatos;
              reade %kds(k1hpiw01:4) pahpiw01;
             enddo;
        when (tipo = 'F');  // Refacturaciones //
             setll %kds(k1hpiw01:4) pahpiw02;
             reade %kds(k1hpiw01:4) pahpiw02;
             dow not %eof;
                 exsr srdatos;
              reade %kds(k1hpiw01:4) pahpiw02;
             enddo;
        other;              // Todas //
             setll %kds(k1hpiw01:4) pahpiw03;
             reade %kds(k1hpiw01:4) pahpiw03;
             dow not %eof;
                 exsr srdatos;
              reade %kds(k1hpiw01:4) pahpiw03;
             enddo;
       endsl;

       REST_writeXmlLine( 'polizasConSaldo' : '*END' );
       REST_end();

       close *all;

       return;

       begsr srdatos;

       // Nombre Asegurado -------------------------
         Nombre = SVPDAF_getNombre( pinrdf
                                  : *omit );
       // Descripcion de la Rama -------------------
            xxdram = SVPDES_rama( piRama );
       // Fecha Vencimiento Renovacion / Refacturación..

        REST_writeXmlLine( 'polizaConSaldo' : '*BEG' );
         REST_writeXmlLine('descripcionRama' : %trim(xxdram) );
         REST_writeXmlLine('nroPoliza' : %trim(%char(pipoli)) );
         REST_writeXmlLine('nombreAsegurado':%trim(Nombre) );
         REST_writeXmlLine('fechaVencimiento':SVPREST_editfecha(pifvto));
         REST_writeXmlLine('saldo':SVPREST_editImporte(piprem));
         select;
          when (pimar1 = 'R');
               REST_writeXmlLine('tipo': 'RENOVACION');
          when (pimar1 = 'F');
               REST_writeXmlLine('tipo': 'REFACTURACION');
          other;
               REST_writeXmlLine('tipo': 'DESCONOCIDO');
         endsl;
         REST_writeXmlLine('saldo':SVPREST_editImporte(piprem));
        REST_writeXmlLine( 'polizaConSaldo' : '*END' );

       endsr;



      /end-free
