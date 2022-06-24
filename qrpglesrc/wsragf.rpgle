
     H option(*srcstmt:*noshowcpy:*nodebugio)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)

      * ************************************************************ *
      * WSRAGF: Portal de Autogestión de Asegurados.                 *
      *         Lista Póliza segun requerimiento                     *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Gio Nicolini                                 *  23-Ago-2018  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * GIO  06-06-2019  Se utiliza el campo AGMAR1 para determinar  *
      *                  la vigencia de la poliza                    *
      * SGF  25-07-2019  Agrego tipo de asistencia.                  *
      * SGF  15-05-2021  Agrego permiteAnular, permiteArrepentir y   *
      *                  anulacionEnProceso.                         *
      *                                                              *
      * ************************************************************ *

     Fpahaag    if   e           k disk
     Fpahed001  if   e           k disk
     Fpahpol    if   e           k disk
     Fpahec1    if   e           k disk
     Fset001    if   e           k disk
     Fpahag4    if   e           k disk
     Fpawpc0    if   e           k disk
     Fgti982    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'

     D WSRAGF          pr                  ExtPgm('WSRAGF')
     D  peEmpr                             like(agempr) const
     D  peSucu                             like(agsucu) const
     D  peArcd                             like(agarcd) const
     D  peSpol                             like(agspol) const
     D  peRama                             like(agrama) const
     D  pePoli                             like(agpoli) const
     D  peTdoc                             like(agtdoc) const
     D  peNdoc                             like(agndoc) const

     D WSRAGF          pi
     D  peEmpr                             like(agempr) const
     D  peSucu                             like(agsucu) const
     D  peArcd                             like(agarcd) const
     D  peSpol                             like(agspol) const
     D  peRama                             like(agrama) const
     D  pePoli                             like(agpoli) const
     D  peTdoc                             like(agtdoc) const
     D  peNdoc                             like(agndoc) const

     D par310x3        pr                  ExtPgm('PAR310X3')
     D                                1
     D                                4  0
     D                                2  0
     D                                2  0

     D SPWLIBLC        pr                  ExtPgm('TAATOOL/SPWLIBLC')
     D  peEnto                        1a   const

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  UsrName                      10a   overlay(PsDs:*next)
     D  JobNbr                        6  0 overlay(PsDs:*next)
     D  CurUsr                       10a   overlay(PsDs:358)

     D lda             ds                  qualified dtaara(*lda)
     D   empr                         1a   overlay(lda:401)
     D   sucu                         2a   overlay(lda:402)

     D k1haag          ds                  likerec(p1haag:*key)
     D k1hed0          ds                  likerec(p1hed001:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1hpol          ds                  likerec(p1hpol:*key)
     D k1hag4          ds                  likerec(p1hag4:*key)

     D fdes            s              8  0
     D fhas            s              8  0
     D hay_base        s              1n
     D peMsgs          ds                  likeds(paramMsgs)
     D peBase          ds                  likeds(paramBase)

      * Fecha 1 AAAAMMDD
     D                 ds
     D  dsF1amd                1      8  0
     D  dsF1aa                 1      4  0
     D  dsF1mm                 5      6  0
     D  dsF1dd                 7      8  0

      * Fecha 2 AAAAMMDD
     D                 ds
     D  dsF2amd                1      8  0
     D  dsF2aa                 1      4  0
     D  dsF2mm                 5      6  0
     D  dsF2dd                 7      8  0

     D @@FechaHoy      s              8  0
     D @@FecA          s              4  0
     D @@FecM          s              2  0
     D @@FecD          s              2  0

     D @@FecDate       s               D

     D @@Tdoc          s              2
     D @@Ndoc          s             11
     D @@Rama          s              2a
     D @@Poli          s              7a
     D @@Arcd          s              6a
     D @@Spol          s              9a
     D rc              s               n
     D tasi            s              3a
     D cuad            s            256a
     D pArr            s              1n
     D pAnu            s              1n
     D aEnp            s              1n
     D @@fec1          s              8a

      /free

        *inlr = *on;

        in lda;
        if lda.empr = *blanks;
          out lda;
          if %trim(rtvSysName()) = 'SOFTTEST';
            spwliblc('I');
          else;
            spwliblc('P');
          endif;
          in lda;
        endif;
        out lda;

        par310x3(lda.empr : @@FecA : @@FecM : @@FecD);
        @@FechaHoy = ( @@FecA * 10000 ) + ( @@FecM * 100 ) + @@FecD;

        @@Tdoc = %trim(%editw(peTdoc:'  '));
        @@Ndoc = %trim(%editw(peNdoc:'           '));
        @@Rama = %trim(%editw(peRama:'  '));
        @@Poli = %trim(%editw(pePoli:'       '));
        @@Arcd = %trim(%editw(peArcd:'      '));
        @@Spol = %trim(%editw(peSpol:'         '));

        if SVPREST_chkCliente( peEmpr
                             : peSucu
                             : @@Tdoc
                             : @@Ndoc
                             : peMsgs ) = *Off;
           REST_writeHeader( 204
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

        if SVPREST_chkPolizaCliente( peEmpr
                                   : peSucu
                                   : @@Arcd
                                   : @@Spol
                                   : @@Rama
                                   : @@Poli
                                   : @@Tdoc
                                   : @@Ndoc
                                   : peMsgs ) = *off;
           REST_writeHeader( 204
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

        rc = COWLOG_logConAutoGestion( peEmpr
                                     : peSucu
                                     : peTdoc
                                     : peNdoc
                                     : psds.this);

        dsF1amd = @@FechaHoy;
        dsF1dd = 1;
        @@FecDate = %date(dsF1amd);
        @@FecDate = @@FecDate + %months(1);
        dsF1amd = %dec(@@FecDate);

        k1haag.agempr = peEmpr;
        k1haag.agsucu = peSucu;
        k1haag.agarcd = peArcd;
        k1haag.agspol = peSpol;
        k1haag.agrama = peRama;
        k1haag.agpoli = pePoli;
        k1haag.agtdoc = peTdoc;
        k1haag.agndoc = peNdoc;
        chain %kds(k1haag) pahaag;
        if %found(pahaag);

          exsr $getBase;
          if hay_base;

            chain agrama set001;
            if not %found;
              t@ramd = *blanks;
            endif;

            k1hed0.d0empr = agempr;
            k1hed0.d0sucu = agsucu;
            k1hed0.d0arcd = agarcd;
            k1hed0.d0spol = agspol;
            k1hed0.d0rama = agrama;
            chain %kds(k1hed0:5) pahed001;

            fdes = (d0fioa * 10000) + (d0fiom * 100) + d0fiod;
            fhas = (d0fvoa * 10000) + (d0fvom * 100) + d0fvod;
            if fhas = 99999999;
              fhas = (d0fvaa * 10000) + (d0fvam * 100) + d0fvad;
            endif;
            dsF2amd = fhas;

            REST_startArray( 'poliza' );

              REST_writeXmlLine( 'codigoRama' : %char(agrama) );
              REST_writeXmlLine( 'rama'       : %trim(t@ramd) );
              REST_writeXmlLine( 'nroPoliza'  : %char(agpoli) );
              REST_writeXmlLine( 'articulo'   : %char(agarcd) );
              REST_writeXmlLine( 'superpoliza': %char(agspol) );
              REST_writeXmlLine( 'arse'       : %char(d0arse) );
              REST_writeXmlLine( 'certificado': %char(d0cert) );
              REST_writeXmlLine( 'operacion'  : %char(d0oper) );

              REST_startArray( 'base' );
                REST_writeXmlLine( 'empr' : peBase.peEmpr );
                REST_writeXmlLine( 'sucu' : peBase.peSucu );
                REST_writeXmlLine( 'nivt' : %editc(peBase.peNivt:'X') );
                REST_writeXmlLine( 'nivc' : %editc(peBase.peNivc:'X') );
                REST_writeXmlLine( 'nit1' : %editc(peBase.peNit1:'X') );
                REST_writeXmlLine( 'niv1' : %editc(peBase.peNiv1:'X') );
              REST_endArray( 'base' );

              REST_writeXmlLine( 'tipoRama' : SVPWS_getGrupoRama(agrama) );
              REST_writeXmlLine( 'vigenDesde' : SVPREST_editFecha(fdes)  );
              REST_writeXmlLine( 'vigenHasta' : SVPREST_editFecha(fhas)  );

              if agmar1 = *On;
                REST_writeXmlLine( 'tipoPoliza' : 'VIG' );
              else;
                REST_writeXmlLine( 'tipoPoliza' : 'NVI' );
              endif;

              tasi = SVPPOL_tipoAsistencia( d0empr
                                          : d0sucu
                                          : d0arcd
                                          : d0spol
                                          : d0rama
                                          : d0arse
                                          : d0oper
                                          : d0poli
                                          : cuad    );
              REST_writeXmlLine( 'tipoAsistencia' : %trim(tasi) );
              REST_writeXmlLine( 'cuadernilloAsis': %trim(cuad) );

              pAnu = SVPPOL_permiteAnular( d0empr
                                         : d0sucu
                                         : d0arcd
                                         : d0spol
                                         : d0rama
                                         : d0arse
                                         : d0oper
                                         : d0poli  );

              pArr = SVPPOL_permiteArrepentir( d0empr
                                             : d0sucu
                                             : d0arcd
                                             : d0spol
                                             : d0rama
                                             : d0arse
                                             : d0oper
                                             : d0poli  );

              aEnp = SVPPOL_anulacionEnProceso( d0empr
                                              : d0sucu
                                              : d0arcd
                                              : d0spol
                                              : d0rama
                                              : d0arse
                                              : d0oper
                                              : d0poli  );

            if aEnp;
               REST_writeXmlLine( 'anulacionEnProceso' : 'S');
               REST_writeXmlLine( 'permiteAnular'      : 'N');
               REST_writeXmlLine( 'permiteArrepentir'  : 'N');
             else;
               REST_writeXmlLine( 'anulacionEnProceso' : 'N');
               if pArr;
                  REST_writeXmlLine( 'permiteArrepentir' : 'S');
                  REST_writeXmlLine( 'permiteAnular' : 'N');
                else;
                  if pAnu;
                     REST_writeXmlLine( 'permiteArrepentir' : 'N');
                     REST_writeXmlLine( 'permiteAnular' : 'S');
                   else;
                     REST_writeXmlLine( 'permiteArrepentir' : 'N');
                     REST_writeXmlLine( 'permiteAnular' : 'N');
                  endif;
               endif;
            endif;
            k1hag4.g4empr = d0empr;
            k1hag4.g4sucu = d0sucu;
            k1hag4.g4arcd = d0arcd;
            k1hag4.g4spol = d0spol;
            k1hag4.g4rama = d0rama;
            k1hag4.g4arse = d0arse;
            k1hag4.g4oper = d0oper;
            k1hag4.g4poli = d0poli;
            k1hag4.g4endo = 0;
            chain %kds(k1hag4) pahag4;
            if %found;
               REST_writeXmlLine( 'idTramite'    : g4nres );
               @@fec1 = %editc(g4fec1:'X');
               REST_writeXmlLine( 'fechaTramite'
                                : %subst(@@fec1:7:2)
                                + '/'
                                + %subst(@@fec1:5:2)
                                + '/'
                                + %subst(@@fec1:1:4) );
             else;
               REST_writeXmlLine( 'idTramite'    : ' ' );
               REST_writeXmlLine( 'fechaTramite' : *blanks );
            endif;

            exsr $veSini;
            exsr $veEndo;

            REST_endArray( 'poliza' );

          endif;

        endif;

        return;

        begsr $getBase;

          hay_base = *off;
          clear peBase;

          peBase.peEmpr = agempr;
          peBase.peSucu = agsucu;
          k1hec1.c1empr = agempr;
          k1hec1.c1sucu = agsucu;
          k1hec1.c1arcd = agarcd;
          k1hec1.c1spol = agspol;
          setgt  %kds(k1hec1:4) pahec1;
          readpe %kds(k1hec1:4) pahec1;
          dow not %eof;

            k1hpol.poempr = agempr;
            k1hpol.posucu = agsucu;
            k1hpol.ponivt = c1nivt;
            k1hpol.ponivc = c1nivc;
            k1hpol.porama = agrama;
            k1hpol.popoli = agpoli;
            setll %kds(k1hpol:6) pahpol;
            if %equal;
              hay_base = *on;
              peBase.peNivt = c1nivt;
              peBase.peNivc = c1nivc;
              peBase.peNit1 = c1nivt;
              peBase.peNiv1 = c1niv1;
              leavesr;
            endif;

            readpe %kds(k1hec1:4) pahec1;
          enddo;

        endsr;

        begsr $veSini;
         if SVPSIN_getSini( peEmpr
                          : peSucu
                          : peArcd
                          : peSpol );
            REST_writeXmlLine( 'tieneSiniestro' : 'S' );
          else;
            REST_writeXmlLine( 'tieneSiniestro' : 'N' );
         endif;
        endsr;

        begsr $veEndo;
         setll (peEmpr:peSucu:peArcd:peSpol) pawpc0;
         if %equal;
            REST_writeXmlLine( 'tieneEndoso' : 'S' );
            leavesr;
         endif;
         setll (peArcd:pePoli) gti982;
         if %equal;
            REST_writeXmlLine( 'tieneEndoso' : 'S' );
            leavesr;
         endif;
         REST_writeXmlLine( 'tieneEndoso' : 'N' );
        endsr;

      /end-free

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'

