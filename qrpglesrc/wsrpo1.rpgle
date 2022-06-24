     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSRPOL: QUOM Versión 2                                       *
      *         Lista de pólizas por intermediario                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *26-May-2017            *
      * ************************************************************ *
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fset901    if   e           k disk
     Fpahed004  if   e           k disk
     Fsehase01  if   e           k disk
     Fgntmon    if   e           k disk
     Fsehni201  if   e           k disk    prefix(n2:2)
     Fgnhdaf    if   e           k disk
     Fgnttdo    if   e           k disk
     Fctw00003  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D GSWEB037        pr                  ExtPgm('GSWEB037')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peRama                        2  0 const
     D  peTiou                        1  0 const
     D  peStou                        2  0 const
     D  peDsop                       20a

     D WSPCSP          pr                  ExtPgm('WSPCSP')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peFech                        d   const
     D   peCast                      10i 0
     D   peCasp                      10i 0
     D   peCass                      10i 0
     D   peCasi                      10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPOL          pr                  ExtPgm('WSLPOL')
     D  peBase                             likeds(paramBase) const
     D  peCant                       10i 0 const
     D  peRoll                        1a   const
     D  peOrde                       10a   const
     D  pePosi                             likeds(keypol_t) const
     D  pePreg                             likeds(keypol_t)
     D  peUreg                             likeds(keypol_t)
     D  peLpol                             likeds(pahpol_t) dim(99)
     D  peLpolC                      10i 0
     D  peMore                         n
     D  peErro                             like(paramErro)
     D  peMsgs                             likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D prim            s             30a
     D prem            s             30a
     D rama            s              2a
     D poli            s              7a
     D arcd            s              6a
     D spol            s              9a
     D @@datd          s             20a
     D @@repl          s          65535a
     D @@dsop          s             20a
     D url             s           3000a   varying
     D rc              s              1n
     D @@nrdo          s             11  0
     D @@tiou          s              1  0
     D @@stou          s              2  0
     D peCast          s             10i 0
     D peCasp          s             10i 0
     D peCass          s             10i 0
     D peCasi          s             10i 0
     D rc2             s             10i 0
     D @@femi          s             10a
     D @@fdes          s             10a
     D @@fhas          s             10a
     D peMore          s              1n

     D CRLF            c                   x'0d25'
     D pePosi          ds                  likeds(keypol_t)
     D pePreg          ds                  likeds(keypol_t)
     D peUreg          ds                  likeds(keypol_t)
     D peLpol          ds                  likeds(pahpol_t) dim(99)
     D peLpolC         s             10i 0
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)
     D k1w000          ds                  likerec(c1w000:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

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
       rama = REST_getNextPart(url);
       poli = REST_getNextPart(url);
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);

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
       clear pePosi;
       clear pePreg;
       clear peUreg;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       pePosi.porama = %dec(rama:2:0);
       pePosi.popoli = %dec(poli:7:0);

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRPO1':peBase);

       WSLPOL( peBase
             : 1
             : 'I'
             : 'RAMAPOLIZA'
             : pePosi
             : pePreg
             : peUreg
             : peLpol
             : peLpolC
             : peMore
             : peErro
             : peMsgs    );

       if peErro = -1;
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

       k1hed0.d0empr = peLpol(1).poempr;
       k1hed0.d0sucu = peLpol(1).posucu;
       k1hed0.d0rama = peLpol(1).porama;
       k1hed0.d0poli = peLpol(1).popoli;
       setgt %kds(k1hed0:4) pahed004;
       readpe %kds(k1hed0:4) pahed004;
       if %eof;
          @@tiou = peLpol(1).potiou;
          @@stou = peLpol(1).postou;
        else;
          @@tiou = d0tiou;
          @@stou = d0stou;
       endif;
       GSWEB037( peLpol(1).poempr
               : peLpol(1).posucu
               : peLpol(1).porama
               : @@tiou
               : @@stou
               : @@dsop );

       chain peLpol(1).pomone gntmon;
       if not %found;
          monmoc = *blanks;
       endif;

       chain peLpol(1).poasen gnhdaf;
       if not %found;
          dfnomb = *blanks;
          dftido = 0;
          dfnrdo = 0;
          dfcuit = *all'0';
          dfnjub = 0;
          dftiso = 0;
       endif;

       @@datd = *blanks;
       @@nrdo = 0;
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

       k1hni2.n2empr = peLpol(1).poempr;
       k1hni2.n2sucu = peLpol(1).posucu;
       k1hni2.n2nivt = 1;
       k1hni2.n2nivc = peLpol(1).ponivc1;
       chain %kds(k1hni2:4) sehni201;
       if not %found;
          n2nomb = *blanks;
       endif;

       WSPCSP( peBase
             : peLpol(1).porama
             : peLpol(1).popoli
             : %date
             : peCast
             : peCasp
             : peCass
             : peCasi
             : peErro
             : peMsgs );

       prim = %editw( peLpol(1).poprim : '                 .  -' );
       prem = %editw( peLpol(1).poprem : '                 .  -' );

       if peLpol(1).poprim = 0;
          prim = '.00';
       endif;

       if peLpol(1).poprem = 0;
          prem = '.00';
       endif;

       k1w000.w0empr = empr;
       k1w000.w0sucu = sucu;
       k1w000.w0arcd = %dec(arcd:6:0);
       k1w000.w0spol = %dec(spol:9:0);
       k1w000.w0nivt = %dec(nivt:1:0);
       k1w000.w0nivc = %dec(nivc:5:0);
       chain %kds(k1w000:6) ctw00003;
       if not %found;
          w0nctw = 0;
          w0soln = 0;
       endif;

       @@femi = %char(peLpol(1).pofemi:*iso);
       @@fdes = %char(peLpol(1).pofdes:*iso);
       @@fhas = %char(peLpol(1).pofhas:*iso);

       REST_writeXmlLine('polizas':'*BEG');
       REST_writeXmlLine('poliza':'*BEG' );
       REST_writeXmlLine('articulo':%trim(%char(peLpol(1).poarcd)));
       REST_writeXmlLine('superpoliza':%trim(%char(peLpol(1).pospol)));
       REST_writeXmlLine('rama':%trim(%char(peLpol(1).porama)));
       REST_writeXmlLine('nroPoliza':%trim(%char(peLpol(1).popoli)));
       REST_writeXmlLine('arse':%trim(%char(peLpol(1).poarse)));
       REST_writeXmlLine('operacion':%trim(%char(peLpol(1).pooper)));
       REST_writeXmlLine('certificado':%trim(%char(peLpol(1).pocert)));
       REST_writeXmlLine('tipoOperacion':%trim(@@dsop));
       REST_writeXmlLine('codigoAsegurado':%char(peLpol(1).poasen));
       REST_writeXmlLine('nombreAsegurado':%trim(dfnomb));
       REST_writeXmlLine('tipoDocAsegurado':%trim(@@datd));
       REST_writeXmlLine('numeroDocAsegurado':%trim(%char(@@nrdo)));
       REST_writeXmlLine('codigoProductor':%trim(%char(peLpol(1).ponivc1)));
       REST_writeXmlLine('nombreProductor':%trim(n2nomb));
       REST_writeXmlLine('fechaEmision':@@femi);
       REST_writeXmlLine('fechaVigDesd':@@fdes);
       REST_writeXmlLine('fechaVigHast':@@fhas);
       REST_writeXmlLine('moneda':%trim(monmoc));
       REST_writeXmlLine('prima':%trim(prim));
       REST_writeXmlLine('premio':%trim(prem));
       REST_writeXmlLine('patente':%trim(peLpol(1).popatente));
       REST_writeXmlLine('cantidadSiniestros':%trim(%char(peCasi)));
       REST_writeXmlLine('embarcacion':%trim(peLpol(1).poemcn));
       REST_writeXmlLine('cotizacionWeb':%trim(%char(w0nctw)) );
       REST_writeXmlLine('solicitudWeb':%trim(%char(w0soln)));
       REST_writeXmlLine('poliza':'*END');

       REST_writeXmlLine('cantidad' : '1');
       REST_writeXmlLine('polizas' : '*END' );

       close *all;

       return;

