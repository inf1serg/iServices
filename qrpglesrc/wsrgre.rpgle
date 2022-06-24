     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRGRE: QUOM Versión 2                                       *
      *         Recupera datos de cotización renovación.             *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *14-Sep-2018            *
      * ------------------------------------------------------------ *
      * SGF 14/11/2018: Cambio nombre de tags.                       *
      *                                                              *
      * ************************************************************ *
     Fpahed0    if   e           k disk
     Fpahec0    if   e           k disk
     Fpahec1    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fgnttdo    if   e           k disk
     Fpahet9    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'

     D WSPCSP          pr                  ExtPgm('WSPCSP')
     D  peBase                             likeds(paramBase) const
     D  peRama                        2  0 const
     D  pePoli                        7  0 const
     D  peFech                         d   const
     D  peCast                       10i 0
     D  peCasp                       10i 0
     D  peCass                       10i 0
     D  peCasi                       10i 0
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D nctw            s              7a

     D @@prim          s             15  2
     D @@prem          s             15  2
     D @@datd          s             20a
     D @@nrdo          s             11  0
     D @@repl          s          65535a
     D fdes            s              8  0
     D fhas            s              8  0
     D femi            s              8  0
     D priPat          s              1n

     D peCast          s             10i 0
     D peCasp          s             10i 0
     D peCass          s             10i 0
     D peCasi          s             10i 0
     D peErro          s             10i 0
     D peNctw          s              7  0
     D rc              s              1n
     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D peCtw0          ds                  likeds(dsctw000_t)

     D k1hed0          ds                  likerec(p1hed0:*key)

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
       nctw = REST_getNextPart(url);

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
          return;
       endif;

       monitor;
          peNctw = %dec(nctw:7:0);
        on-error;
          peNctw = 0;
       endmon;

       clear peBase;
       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       COWLOG_logcon( psds.this : peBase );

       if COWGRAI_getCtw000( peBase : peNctw : peCtw0 ) = *off;
          %subst(@@repl:1:7) = nctw;
          %subst(@@repl:8:1) = nivt;
          %subst(@@repl:9:5) = nivc;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : 'COW0008'
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          REST_end();
          close *all;
          return;
       endif;

       if peCtw0.w0tiou <> 2;
          rc = REST_writeHeader( 204 );
          REST_end();
          close *all;
          return;
       endif;

       REST_writeHeader();
       REST_writeEncoding();
       REST_startArray( 'poliza' );

       k1hed0.d0empr = empr;
       k1hed0.d0sucu = sucu;
       k1hed0.d0arcd = peCtw0.w0arcd;
       k1hed0.d0spol = peCtw0.w0spo1;
       setgt  %kds(k1hed0:4) pahed0;
       readpe %kds(k1hed0:4) pahed0;
       if not %eof;

          WSPCSP( peBase
                : d0rama
                : d0poli
                : %date()
                : peCast
                : peCasp
                : peCass
                : peCasi
                : peErro
                : peMsgs );

          REST_writeXmlLine( 'articulo'    : %char(d0arcd) );
          REST_writeXmlLine( 'superpoliza' : %char(d0spol) );
          REST_writeXmlLine( 'rama'        : %char(d0rama) );
          REST_writeXmlLine( 'nroPoliza'   : %char(d0poli) );
          REST_writeXmlLine( 'arse'        : %char(d0arse) );
          REST_writeXmlLine( 'operacion'   : %char(d0oper) );

          chain %kds(k1hed0:4) pahec0;
          if not %found;
             c0fema = 0;
             c0femm = 0;
             c0femd = 0;
          endif;

          femi = (c0fema * 10000) + (c0femm * 100) + c0femd;
          fdes = (c0fioa * 10000)
               + (c0fiom *   100)
               + (c0fiod);
          fhas = (c0fvoa * 10000)
               + (c0fvom *   100)
               + (c0fvod);

          setgt  %kds(k1hed0:4) pahec1;
          readpe %kds(k1hed0:4) pahec1;
          if not %eof;
             exsr $aseg;
             REST_writeXmlLine( 'codigoAsegurado' : %char(c1asen) );
             REST_writeXmlLine( 'nombreAsegurado'
                              : SVPDAF_getNombre( c1asen : *omit ));
             REST_writeXmlLine( 'tipoDocAsegurado' : @@datd );
             REST_writeXmlLine( 'numeroDocAsegurado' : %char(@@nrdo));
          endif;

          REST_writeXmlLine( 'fechaEmision' : SVPREST_editFecha(femi) );
          REST_writeXmlLine( 'fechaVigDesd' : SVPREST_editFecha(fdes) );
          REST_writeXmlLine( 'fechaVigHast' : SVPREST_editFecha(fhas) );

          exsr $patente;

          REST_writeXmlLine( 'moneda': d0mone );
          exsr $valor;
          REST_writeXmlLine( 'prima': SVPREST_editImporte(@@prim));
          REST_writeXmlLine( 'premio': SVPREST_editImporte(@@prem));
          REST_writeXmlLine( 'cantidadStros': %char(peCasi) );

       endif;

       REST_endArray( 'poliza' );
       REST_end();

       return;

       begsr $valor;
        @@prim = 0;
        @@prem = 0;
        setll %kds(k1hed0:4) pahed0;
        reade %kds(k1hed0:4) pahed0;
        dow not %eof;
            if d0come <= 0;
               d0come = 1;
            endif;
            @@prim += d0prim * d0come;
            @@prem += d0prem * d0come;
         reade %kds(k1hed0:4) pahed0;
        enddo;
       endsr;

       begsr $aseg;
        @@datd = *blanks;
        @@nrdo = 0;
        chain c1asen gnhdaf;
        if not %found;
           dftiso = 0;
        endif;
        select;
         when dftiso = 98;
              chain dftido gnttdo;
              if not %found;
                 gndatd = *blanks;
              endif;
              @@datd = gndatd;
              if dfnrdo > 0;
                 @@nrdo = dfnrdo;
               else;
                 if dfcuit <> *all'0' and dfcuit <> *blanks;
                    monitor;
                      @@nrdo = %dec(dfcuit:11:0);
                     on-error;
                      @@nrdo = 0;
                      @@datd = *blanks;
                    endmon;
                  else;
                     @@nrdo = dfnjub;
                 endif;
               endif;
               other;
                    if dfcuit <> *all'0' and dfcuit <> *blanks;
                       @@datd = 'CUIT';
                       monitor;
                         @@nrdo = %dec(dfcuit:11:0);
                        on-error;
                         @@datd = *blanks;
                         @@nrdo = *zeros;
                       endmon;
                    endif;
              endsl;
       endsr;

       begsr $patente;
        priPat = *off;
        REST_startArray( 'patente' );
        setll %kds(k1hed0:4) pahet9;
        reade %kds(k1hed0:4) pahet9;
        dow not %eof;
         if t9poli <> 0;
            if not priPat;
               REST_write(%trim(t9nmat));
               priPat = *on;
             else;
               REST_write(';' + %trim(t9nmat));
            endif;
         endif;
         reade %kds(k1hed0:4) pahet9;
        enddo;
        REST_endArray( 'patente' );
       endsr;

      /end-free
