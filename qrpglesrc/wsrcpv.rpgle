
     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)

      * ************************************************************ *
      * WSRCPV - Certificado sin deuda Unificado                     *
      * ------------------------------------------------------------ *
      * Gio Nicolini                                   * 10-Ene-2018 *
      * ------------------------------------------------------------ *
      * Modificaciones :                                             *
      * JSN 13/08/2020 : Escapa &.                                   *
      *                                                              *
      * ************************************************************ *

     Fset001    if   e           k disk
     Fpahed004  if   e           k disk    rename(p1hed004:p1hed0)

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'

     D WSLCON4         pr                  ExtPgm('WSLCON4')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSuop                       3  0 const
     D   peText                            likeds(SdvTxt_t) dim(10)
     D   peTextC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D rama            s              2a
     D poli            s              7a
     D suop            s              3a
     D arcd            s              6a
     D spol            s              9a
     D sspo            s              3a

     D uri             s            512a
     D url             s           3000a   varying
     D femi            s             10a
     D fdes            s             10a
     D fhas            s             10a
     D fpag            s             10a
     D fvto            s             10a
     D prim            s             30a
     D prem            s             30a
     D ipag            s             30a
     D imcu            s             30a
     D epv             s             30a
     D refi            s             30a
     D seri            s             30a
     D ipr1            s             30a
     D ipr6            s             30a
     D impu            s             30a
     D xref            s             10a
     D xrea            s             10a
     D pimp            s             10a
     D dpdf            s             55a
     D nrtc            s             20a
     D dere            s             30a
     D rc              s              1n
     D peMore          s              1n
     D rc2             s             10i 0
     D @@nit1          s              1  0
     D @@niv1          s              5  0
     D @imp            s             15  2
     D ximp            s              5  2
     D @@repl          s          65535a
     D peErro          s             10i 0
     D peErr1          s             10i 0
     D x               s             10i 0
     D h               s             10i 0
     D q               s             10i 0
     D z               s             10i 0
     D peLsu1C         s             10i 0
     D peLsupC         s             10i 0
     D peCuotC         s             10i 0
     D @@dura          s             40a
     D copr            s             30a
     D @@kaus          s              1a
     D peRama          s              2  0
     D pePoli          s              7  0
     D peSuop          s              3  0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D peSspo          s              3  0
     D peText          ds                  likeds(SdvTxt_t) dim(10)
     D peTextC         s             10i 0
     D @@Response      s            256a

     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)
     D pePosi          ds                  likeds(keysup_t)
     D pePos1          ds                  likeds(keysup_t)
     D pePreg          ds                  likeds(keysup_t)
     D peUreg          ds                  likeds(keysup_t)
     D peLsu1          ds                  likeds(pahsu1_t) dim(1000)
     D peLsup          ds                  likeds(pahsup_t) dim(99)
     D peCuot          ds                  likeds(pahcuo_t) dim(100)
     D k1hed0          ds                  likerec(p1hed0:*key)

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
        rama = REST_getNextPart(url);
        poli = REST_getNextPart(url);
        suop = REST_getNextPart(url);
        arcd = REST_getNextPart(url);
        spol = REST_getNextPart(url);
        sspo = REST_getNextPart(url);

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

        if %check( '0123456789' : %trim(rama) ) <> 0;
           @@repl = rama;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'RAM0001'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'RAM0001'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
        endif;

        peRama = %dec( rama : 2 : 0 );
        setll peRama set001;
        if not %equal;
           @@repl = rama;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'RAM0001'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'RAM0001'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
        endif;

        if %check( '0123456789' : %trim(poli) ) <> 0;
           %subst(@@repl:1:2) = rama;
           %subst(@@repl:3:7) = poli;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'POL0001'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'RAM0001'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
        endif;

        pePoli = %dec( poli : 7 : 0 );
        k1hed0.d0empr = empr;
        k1hed0.d0sucu = sucu;
        k1hed0.d0rama = peRama;
        k1hed0.d0poli = pePoli;
        setgt  %kds(k1hed0:4) pahed004;
        readpe %kds(k1hed0:4) pahed004;
        if %eof;
           %subst(@@repl:1:2) = rama;
           %subst(@@repl:3:7) = poli;
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'POL0001'
                        : peMsgs
                        : %trim(@@repl)
                        : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'RAM0001'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
        endif;

        monitor;
          peSuop = %dec(suop:3:0);
         on-error;
          peSuop = 0;
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
          peSspo = %dec(sspo:3:0);
         on-error;
          peSspo = 0;
        endmon;

        if not SPVSPO_chkSpol( empr :sucu : peArcd: peSpol);
           %subst(@@repl:1:6) = arcd;
           %subst(@@repl:7:9) = spol;
           rc2 = SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'SPO0001'
                              : peMsgs
                              : %trim(@@repl)
                              : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'SPO0001'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
        endif;

        if not SPVSPO_chkSspo( empr :sucu : peArcd: peSpol: peSspo);
           %subst(@@repl:1:3)  = sspo;
           %subst(@@repl:4:6)  = arcd;
           %subst(@@repl:10:9) = spol;
           rc2 = SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'SPO0002'
                              : peMsgs
                              : %trim(@@repl)
                              : %len(%trim(@@repl)) );
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : 'SPO0002'
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
        endif;

        // ---------------------------------------------
        // Obtengo Certificado sin deuda
        // ---------------------------------------------

        clear peBase;
        clear peText;
        clear peTextC;
        clear peErro;
        clear peMsgs;

        peBase.peEmpr = empr;
        peBase.peSucu = sucu;
        peBase.peNivt = %dec(nivt:1:0);
        peBase.peNivc = %dec(nivc:5:0);
        peBase.peNit1 = %dec(nit1:1:0);
        peBase.peNiv1 = %dec(niv1:5:0);

        COWLOG_logcon('WSRCPV':peBase);

        WSLCON4( peBase
               : peRama
               : pePoli
               : peSuop
               : peText
               : peTextC
               : peErro
               : peMsgs  );

        if peErro = -1;
           rc = REST_writeHeader( 400
                                : *omit
                                : *omit
                                : peMsgs.peMsid
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
           REST_end();
           close *all;
           return;
        endif;

        REST_writeHeader();
        REST_writeEncoding();
        REST_writeXmlLine( 'CertificadoSinDeuda' : '*BEG');

          REST_write( '<Texto>' );

          if peTextC > 0;
             for x = 1 to peTextC;
               if peText(x).text <> *blanks;
                  @@Response = %trim(peText(x).text) + '|';
                  @@Response = REST_xmlEscape( @@Response );
                  REST_write( %trim(@@Response) );
               endif;
             endfor;
          endif;

          REST_write( '</Texto>' );

        REST_writeXmlLine( 'CertificadoSinDeuda' : '*END');
        REST_end();

        close *all;

        return;

      /end-free
