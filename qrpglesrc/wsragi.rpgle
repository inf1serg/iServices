     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAGI: Portal de Autogestión de Asegurados.                 *
      *         Lista cuotas y totales.                              *
      *                                                              *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                        *02-Sep-2020            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *  JSN 10/03/2021 - Se aumenta el DIM de los array de cuotas y *
      *                   cuotasPagas                                *
      * ************************************************************ *
     Fpahcd501  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'

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
     D @@DsCd6         ds                  likeds( dsPahcd6_t ) dim(999)
     D @@DsCd6C        s             10i 0
     D @@total         s             10i 0
     D @@pagas         s             10i 0
     D @@impagas       s             10i 0
     D @@parciales     s             10i 0
     D @@avencer       s             10i 0
     D @@premioTotal   s             15s 2
     D @@premioCobrado...
     D                 s             15s 2
     D @@premioImpago  s             15s 2
     D @@premioAVencer...
     D                 s             15s 2
     D @@DsD0          ds                  likeds ( dsPahed0_t ) dim( 999 )
     D @@DsD0C         s             10i 0

     D peMsgs          ds                  likeds(paramMsgs)

     D k1hcd5          ds                  likerec(p1hcd501:*key)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

     D cuotas          ds                  qualified dim(512)
     D  fvto                          8  0
     D  imcu                         15  2
     D  estado                        1
     D  saldo                        15  2

     D cuotasPagas     ds                  qualified dim(512)
     D  fvto                          8  0
     D  imcu                         15  2

     D x               s             10i 0
     D i               s             10i 0
     D z               s             10i 0

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')

      /free

       *inlr = *on;


       rc = REST_getUri( psds.this : uri );
       if rc = *off;
         peMsgs.pemsev = 40;
         peMsgs.peMsid = 'RPG0001';
         peMsgs.pemsg1 = 'Error al parsear URL';
         peMsgs.pemsg2 = 'Error al parsear URL';
         exsr setError;
       endif;

       Data = CRLF + CRLF
            + '<b>' +  psds.this  + '</b>'
            + '<b>Detalles de Cuotas (Request)</b>'    + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri               + CRLF ;
       COWLOG_pgmlog( psds.this : Data );

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
         exsr setError;
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
         exsr setError;
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

       clear @@total;
       clear @@pagas;
       clear @@impagas;
       clear cuotas;
       clear cuotasPagas;
       clear @@premioTotal;
       clear @@premioCobrado;
       clear @@premioImpago;
       clear @@premioAVencer;

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
                  cuotas(i).fvto    = fvto;
                  cuotas(i).imcu   += d5imcu;
                  cuotas(i).saldo  += d5imcu;
                  if fvto < %int(%char(%date():*iso0));
                     cuotas(i).estado  = '3';
                     @@premioImpago+= d5imcu;
                  else;
                     cuotas(i).estado  = '0';
                     @@premioAVencer  += d5imcu;
                  endif;
               endif;

           else;
            if SPVSPO_getPahcd6( d5empr
                               : d5sucu
                               : d5arcd
                               : d5spol
                               : d5sspo
                               : d5rama
                               : d5arse
                               : d5oper
                               : d5suop
                               : d5nrcu
                               : d5nrsc
                               : *omit
                               : @@DsCd6
                               : @@DsCd6C );

               for x = 1 to @@DsCd6C;
                   fvto = (d5fvca * 10000) + (d5fvcm * 100) + d5fvcd;

                    i = %lookup( fvto : cuotasPagas(*).fvto );
                    if i = 0;
                       i = %lookup( 0 : cuotasPagas(*).fvto );
                    endif;

                    if i > 0;
                       cuotasPagas(i).fvto  = fvto;
                       cuotasPagas(i).imcu += @@DsCd6(x).d6prem;
                       @@premioCobrado     += @@DsCd6(x).d6prem;
                    endif;
               endfor;
             endif;
           endif;

        reade %kds(k1hcd5:4) pahcd501;
       enddo;

       if cuotasPagas(1).fvto <> 0;
          x = 1;
           dow cuotasPagas(x).fvto  <> 0;
               fvto = cuotasPagas( x ).fvto;

                i = %lookup( fvto : cuotas(*).fvto );
                if i = 0;
                   i = %lookup( 0 : cuotas(*).fvto );
                   cuotas(i).fvto = cuotasPagas(x).fvto;
                   cuotas(i).estado = '1';
                   cuotas(i).imcu   = cuotasPagas(x).imcu;
                   cuotas(i).saldo  = 0;
                else;
                   cuotas(i).fvto = cuotasPagas(x).fvto;
                   cuotas(i).estado = '1';
                   cuotas(i).imcu   = cuotasPagas(x).imcu;
                   cuotas(i).saldo  = cuotas(i).imcu
                                    - cuotasPagas(x).imcu;
                   if cuotas(i).imcu <> 0;
                      if cuotas(i).saldo <> cuotas(i).imcu ;
                         cuotas(i).estado = '2';
                      endif;
                   endif;
                endif;

             x += 1;
           enddo;

       endif;

       clear @@premioTotal;
       clear @@DsD0;
       clear @@DsD0C;

       if SVPPOL_getPoliza( empr
                          : sucu
                          : peRama
                          : pePoli
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : @@DsD0
                          : @@DsD0C  );

         for x = 1 to @@DsD0C;
             @@premioTotal += @@DsD0( x ).d0prem;
         endfor;

       endif;

       Data = CRLF + CRLF
            + '&nbsp<b>' +  psds.this  + '</b>'
            + '<b>Detalle de Cuotas</b>'
            + '(Response)</b> :'                  + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))          + CRLF;
       COWLOG_pgmlog( psds.this : Data );

       sorta cuotas(*).fvto;
       sorta cuotasPagas(*).fvto;
       z = 0;
       for x = 1 to 256;
           if cuotas(x).fvto <> 0;
              z += 1;
              @@total += 1;
              REST_startArray('cuota');
              @fvto = SVPREST_editFecha(cuotas(x).fvto);
              REST_writeXmlLine('fechaVencimiento': @fvto );
              REST_writeXmlLine('numero': %trim(%char(z)));
              REST_writeXmlLine('importe'
                               : SVPREST_editImporte(cuotas(x).imcu) );
              REST_writeXmlLine('saldo'
                               : SVPREST_editImporte(cuotas(x).saldo) );
              Select;
                when cuotas(x).estado = '0';
                 REST_writeXmlLine('estado'   : 'A vencer');
                 @@avencer += 1;
                when cuotas(x).estado = '1';
                 REST_writeXmlLine('estado'   : 'Pagada');
                 @@pagas += 1;
                when cuotas(x).estado = '2';
                 REST_writeXmlLine('estado'   : 'Pago Parcial');
                 @@parciales += 1;
                when cuotas(x).estado = '3';
                 REST_writeXmlLine('estado'   : 'Impaga');
                 @@impagas += 1;
                other;
                 REST_writeXmlLine('estado'   : 'Desconocido');
              endsl;
              exsr setCuotaLog;
              REST_endArray('cuota');
           endif;
       endfor;

       REST_writeXmlLine('total'          : %char( @@total            ) );
       REST_writeXmlLine('pagadas'        : %char( @@pagas            ) );
       REST_writeXmlLine('impagas'        : %char( @@impagas          ) );
       REST_writeXmlLine('aVencer'        : %char( @@avencer          ) );
       REST_writeXmlLine('pagosParciales' : %char( @@parciales        ) );
       REST_writeXmlLine('premioCobrado'  :
                                 SVPREST_editImporte( @@premioCobrado ) );
       REST_writeXmlLine('premioTotal'    :
                                 SVPREST_editImporte( @@premioTotal   ) );
       REST_writeXmlLine('premioImpago'   :
                                 SVPREST_editImporte( @@premioImpago  ) );
       REST_writeXmlLine('premioAVencer'  :
                                 SVPREST_editImporte( @@premioAVencer ) );
       exsr setTotalesLog;

       REST_endArray( 'cuotas' );

       Data = CRLF + 'PEERRO: ' +  '0'            + CRLF
            + 'PEMSGS'                            + CRLF
            + '&nbsp;PEMSEV: ' + '00'             + CRLF
            + '&nbsp;PEMSID: ' + ' '              + CRLF
            + '&nbsp;PEMSG1: ' + ' '              + CRLF
            + '&nbsp;PEMSG2: ' + ' '              + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_pgmlog( psds.this : Data );

       data = '<hr color="green" size=3 />' + CRLF;
       COWLOG_pgmlog( psds.this : Data );
       return;

      /end-free

       //* ---------------------------------------------------------- *
       begsr setCuotaLog;
         data = CRLF + '<b>CUOTA :</b>'
              + '&nbsp;NUMERO  :'+ %trim(%char(z))                      + CRLF
              + '&nbsp;FECHAVENCIMIENTO: ' + @fvto                      + CRLF
              + '&nbsp;IMPORTE :'+ SVPREST_editImporte(cuotas(x).imcu)  + CRLF
              + '&nbsp;SALDO   :'+ SVPREST_editImporte(cuotas(x).saldo) + CRLF
              + '&nbsp;ESTADO  :'+ cuotas(x).estado                     + CRLF;
         COWLOG_pgmlog( psds.this : Data );
       endsr;

       //* ---------------------------------------------------------- *
       begsr setTotalesLog;
         data = CRLF + '<b>TOTALES :</b>'                               + CRLF
              + '&nbsp;TOTAL CUOTAS   :'+ %char( @@total     )          + CRLF
              + '&nbsp;PAGADAS        :'+ %char( @@pagas     )          + CRLF
              + '&nbsp;IMPAGAS        :'+ %char( @@impagas   )          + CRLF
              + '&nbsp;A VENCER       :'+ %char( @@avencer   )          + CRLF
              + '&nbsp;PAGOSPARCIALES :'+ %char( @@parciales )          + CRLF
              + '&nbsp;PREMIOCOBRADO  :'
              + SVPREST_editImporte( @@premioCobrado         )          + CRLF
              + '&nbsp;PREMIOTOTAL    :'
              + SVPREST_editImporte( @@premioTotal           )          + CRLF
              + '&nbsp;PREMIOIMPAGO   :'
              + SVPREST_editImporte( @@premioImpago          )          + CRLF
              + '&nbsp;PREMIAVENCER   :'
              + SVPREST_editImporte( @@premioAVencer         )          + CRLF;
         COWLOG_pgmlog( psds.this : Data );
       endsr;
       //* ---------------------------------------------------------- *
       begsr setError;

         REST_writeHeader( 400
                         : *omit
                         : *omit
                         : peMsgs.peMsid
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );

          Data = '<br><br><b> psds.this-Detalle de Cuotas'
               + '(Response)</b> : Error' + CRLF
               + 'Fecha/Hora: '
               + %trim(%char(%date():*iso)) + ' '
               + %trim(%char(%time():*iso))                  + CRLF
               + 'PEERRO: ' +  '-1'                          + CRLF
               + 'PEMSGS'                                    + CRLF
               + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
               + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
               + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
               + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
               + 'PEMSGS' + CRLF;
          COWLOG_pgmlog( psds.this : Data );

          data = '<hr color="green" size=3 />' + CRLF;
          COWLOG_pgmlog( psds.this : Data );
          REST_end();
          return;
       endsr;
