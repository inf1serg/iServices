     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRAGA: Portal de Autogestión de Asegurados.                 *
      *         Datos del asegurado.                                 *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *27-Jul-2018            *
      * ------------------------------------------------------------ *
      * Modificaciones :                                             *
      * SGF 13/06/2019: Mail sólo PARTICULAR.                        *
      * SGF 19/06/2019: Acomodo marca de fumador.                    *
      * JSN 22/06/2021: Se agregan los Tags:                         *
      *                  <medioDePago>                               *
      *                  <empresaTc>                                 *
      *                  <numero>                                    *
      * ************************************************************ *
     Fgnhdaf    if   e           k disk
     Fgnhda1    if   e           k disk
     Fgnhda6    if   e           k disk
     Fgnhda7    if   e           k disk
     Fgnhdad    if   e           k disk
     Fpahaag01  if   e           k disk
     Fsahint    if   e           k disk
     Fgnhdaf05  if   e           k disk
     Fgnhdaf07  if   e           k disk

      /copy './qcpybooks/svpdes_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'

     D SPEDAD          pr                  extpgm('SPEDAD')
     D  peFnac                        8  0 const
     D  peEdad                        2  0

      * ------------------------------------------------------------ *
      * URL y URI
      * ------------------------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')

      * ------------------------------------------------------------ *
      * Parámetros de URL
      * ------------------------------------------------------------ *
     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a

     D rc              s              1n
     D @@fnac          s              8  0
     D fech            s             10d
     D @@repl          s          65535a
     D errFnac         s              1n
     D fnac            s             10a
     D peNrdf          s              7  0
     D @apTran         s              1a
     D @vsys           s            512a
     D edad            s              2  0
     D elec            s              1n
     D cfpg            s              1  0
     D peCade          s              5  0 dim(9)
     D $$ndoc          s              8  0
     D cant            s              3i 0
     D i               s             10i 0

     D peMsgs          ds                  likeds(paramMsgs)
     D k1haag          ds                  likerec(p1haag:*key)
     D k1hint          ds                  likerec(s2hint:*key)
     D peBase          ds                  likeds(paramBase)
     D peDomi          ds                  likeds(prwaseDomi_t)
     D peDocu          ds                  likeds(prwaseDocu_t)
     D peNtel          ds                  likeds(prwaseTele_t)
     D peNaci          ds                  likeds(prwaseNaco_t)
     D peMail          ds                  likeds(prwaseEmail_t)
     D peInsc          ds                  likeds(prwaseInsc_t)

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

     D x               s             10i 0
     D @@Tdoc          s              2  0
     D @@Ndoc          s             11  0
     D @@mail          s             50a
     D @@Cara          s              1a
     D @@Cant          s             20  0
     D cbu_ed          s             25
     D nro_ed          s             20a
     D @@DsTc          ds                  likeds ( dsGnhdtc_t ) dim( 99 )
     D @@DsTcC         s             10i 0
     D peIvbc          s              3  0
     D peIvsu          s              3  0
     D peTcta          s              2  0
     D peNcta          s             25
     D @@Ncbu          s             25a
     D @@Ntdc          s             20  0
     D @@Etdc          s             10a
     D peErro          s             10i 0
     D @@nivt          s              1  0
     D @@nivc          s              5  0

      * Para SVPDAF
     D  pdNomb         ds                  likeDs(dsNomb_t)
     D  pdDomi         ds                  likeDs(dsDomi_t)
     D  pdDocu         ds                  likeDs(dsDocu_t)
     D  pdCont         ds                  likeDs(dsCont_t)
     D  pdNaci         ds                  likeDs(dsNaci_t)
     D  pdMarc         ds                  likeDs(dsMarc_t)
     D  pdCbuS         ds                  likeDs(dsCbuS_t)
     D  pdDape         ds                  likeDs(dsDape_t)
     D  pdClav         ds                  likeDs(dsClav_t)
     D  pdProv         ds                  likeDs(dsProI_t) dim(999)
     D  pdMail         ds                  likeds(Mailaddr_t) dim(100)
     D  pdText         s             79    dim(999)
     D  pdTextC        s             10i 0
     D  pdProvC        s             10i 0
     D  pdMailC        s             10i 0

     d lda             ds                  qualified dtaara(*lda)
     d   empr                         1a   overlay(lda:401)
     d   sucu                         2a   overlay(lda:402)

     D min             c                   const('abcdefghijklmnñopqrstuvwxyz-
     D                                     áéíóúàèìòùäëïöü')
     D may             c                   const('ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-
     D                                     ÁÉÍÓÚÀÈÌÒÙÄËÏÖÜ')

      /free

       *inlr = *on;

       REST_getUri( psds.this : uri );
       url = %trim(uri);

       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       tdoc = REST_getNextPart(url);
       ndoc = REST_getNextPart(url);

       in lda;
       lda.empr = empr;
       lda.sucu = sucu;
       out lda;

       if SVPREST_chkCliente( empr
                            : sucu
                            : tdoc
                            : ndoc
                            : peMsgs
                            : peNrdf ) = *off;
          rc = REST_writeHeader( 204
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2   );
          REST_end();
          close *all;
          return;
       endif;

       monitor;
         @@Tdoc = %dec(tdoc:2:0);
       on-error;
         @@Tdoc = 0;
       endmon;

       monitor;
         @@Ndoc = %dec(ndoc:11:0);
       on-error;
         @@Ndoc = 0;
       endmon;

       rc = COWLOG_logConAutoGestion( empr
                                    : sucu
                                    : @@Tdoc
                                    : @@Ndoc
                                    : psds.this);

       chain peNrdf gnhdaf;
       if not %found;
          dfnjub = 0;
       endif;

       chain peNrdf gnhda1;
       if not %found;
          dfcnac = 0;
          dfsexo = 0;
          dfesci = 0;
          dffnaa = 0;
          dffnam = 0;
          dffnad = 0;
          dfraae = 0;
          dfcprf = 0;
          dfmfum = 'N';
       endif;

       if dfmfum <> 'N' and dfmfum <> 'S';
          dfmfum = 'N';
       endif;

       chain peNrdf gnhda6;
       if not %found;
          clear dftel2;
          clear dftel6;
       endif;

       errFnac = *off;
       @@fnac = (dffnaa * 10000) + (dffnam * 100) + dffnad;
       monitor;
          fech = %date(@@fnac:*iso);
        on-error;
          errFnac = *on;
          @@fnac = 19010101;
       endmon;

       if errFnac;
          fnac = *blanks;
        else;
          fnac = %editc(dffnaa:'X')
               + '-'
               + %editc(dffnam:'X')
               + '-'
               + %editc(dffnad:'X');
       endif;

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'asegurado' );

        REST_writeXmlLine( 'nroAsegurado'    : %char(peNrdf) );
        REST_writeXmlLine( 'nombre'          : %trim(dfnomb) );
        REST_writeXmlLine( 'nacionalidad'    : %char(dfcnac) );
        REST_writeXmlLine( 'sexo'            : %char(dfsexo) );
        REST_writeXmlLine( 'cuil'            : %char(dfnjub) );
        REST_writeXmlLine( 'estadoCivil'     : %char(dfesci) );
        REST_writeXmlLine( 'fechaNacimiento' : fnac          );
        REST_writeXmlLine( 'cantidadDeHijos' : %char(dfchij) );
        REST_writeXmlLine( 'nivelDeEstudios' : %char(dfcnes) );
        REST_writeXmlLine( 'fumador'         : dfmfum        );
        REST_writeXmlLine( 'ramaActividadEc' : %char(dfraae) );
        REST_writeXmlLine( 'profesion'       : %char(dfcprf) );
        REST_writeXmlLine( 'hobbies'         : 'Varios'      );

        REST_startArray( 'deportes' );
         setll peNrdf gnhdad;
         reade peNrdf gnhdad;
         dow not %eof;
             REST_startArray( 'deporte' );
              REST_writeXmlLine( 'codigo' : %trim(%char(adcdep)) );
             REST_endArray  ( 'deporte' );
          reade peNrdf gnhdad;
         enddo;
        REST_endArray  ( 'deportes' );

        if %trim(dftel2) <> '' or %trim(dftel6) <> '';
          REST_startArray( 'telefonos' );
          if %trim(dftel2) <> '';
            REST_startArray( 'telefono' );
              REST_writeXmlLine( 'tipo'   : 'P' );
              REST_writeXmlLine( 'numero' : %trim(dftel2) );
             REST_endArray  ( 'telefono' );
          endif;
          if %trim(dftel6) <> '';
            REST_startArray( 'telefono' );
              REST_writeXmlLine( 'tipo'   : 'C' );
              REST_writeXmlLine( 'numero' : %trim(dftel6) );
            REST_endArray  ( 'telefono' );
          endif;
          REST_endArray  ( 'telefonos' );
        else;
          REST_writeXmlLine( 'telefonos' : '');
        endif;

        REST_startArray( 'emails' );
         setll peNrdf gnhda7;
         reade peNrdf gnhda7;
         dow not %eof;
           if dfctce = 1;
             REST_startArray( 'email' );
              @@mail = %xlate(may:min:%trim(dfmail));
              REST_writeXmlLine( 'tipo' : %char(dfctce) );
              REST_writeXmlLine( 'mail' : %trim(@@mail) );
             REST_endArray  ( 'email' );
           endif;
          reade peNrdf gnhda7;
         enddo;
        REST_endArray  ( 'emails' );

        exsr $apTran;
        REST_writeXmlLine( 'permiteApTransito' : @apTran );

        exsr $TcCbu;

        select;
          when @@Ntdc > *zeros;
            REST_writeXmlLine( 'medioDePago' : 'TC' );
            REST_writeXmlLine( 'empresaTc' : %trim(@@Etdc) );
            REST_writeXmlLine( 'numero': %trim( nro_ed ) );
          when @@Ncbu <> *blanks;
            REST_writeXmlLine( 'medioDePago' : 'CBU' );
            REST_writeXmlLine( 'empresaTc' : ' ' );
            REST_writeXmlLine( 'numero': %trim( cbu_ed ) );
          other;
            REST_writeXmlLine( 'medioDePago' : ' ' );
            REST_writeXmlLine( 'empresaTc' : ' ' );
            REST_writeXmlLine( 'numero': ' ' );
        endsl;

       REST_endArray( 'asegurado' );

       return;

       begsr $apTran;

        @apTran = 'S';

        // ValSys que desconecta todo
       if SVPVLS_getValSys( 'HAUGVENTAP' : *omit : @vsys );
          if @vsys = 'N';
             @apTran = 'N';
             Data = CRLF + CRLF
                  + 'Fecha/Hora: '
                  + %trim(%char(%date():*iso)) + ' '
                  + %trim(%char(%time():*iso))         + CRLF
                  + '&nbsp&nbspURL   : '      + uri    + CRLF
                  + 'Valor de sistema HAUGVENTAP en N.' + CRLF;
             COWLOG_pgmlog( psds.this : Data );
             leavesr;
          endif;
        else;
          Data = CRLF + CRLF
               + 'Fecha/Hora: '
               + %trim(%char(%date():*iso)) + ' '
               + %trim(%char(%time():*iso))         + CRLF
               + '&nbsp&nbspURL   : '      + uri    + CRLF
               + 'Valor de sistema HAUGVENTAP no encontrado.' + CRLF;
          COWLOG_pgmlog( psds.this : Data );
          @apTran = 'N';
          leavesr;
       endif;

        // Que no tenga otra de AP Vigente
        k1haag.agempr = empr;
        k1haag.agsucu = sucu;
        k1haag.agtdoc = @@tdoc;
        k1haag.agndoc = @@ndoc;
        setll %kds(k1haag:4) pahaag01;
        reade %kds(k1haag:4) pahaag01;
        dow not %eof;
            if agrama = 23 and agmar1 = '1';
               Data = CRLF + CRLF
                    + 'Fecha/Hora: '
                    + %trim(%char(%date():*iso)) + ' '
                    + %trim(%char(%time():*iso))         + CRLF
                    + '&nbsp&nbspURL   : '      + uri    + CRLF
                    + 'Asegurado ya tiene Accidentes Personales.' + CRLF;
               COWLOG_pgmlog( psds.this : Data );
               @apTran = 'N';
               leavesr;
            endif;
         reade %kds(k1haag:4) pahaag01;
        enddo;

        // Que no tenga mas de 65 años
        // Uso SPEDAD que tiene la edad acturial
        SPEDAD( @@fnac : edad );
        if edad >= 65;
           Data = CRLF + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso)) + ' '
                + %trim(%char(%time():*iso))         + CRLF
                + '&nbsp&nbspURL   : '      + uri    + CRLF
                + 'Edad del asegurado supera la máxima.' + CRLF;
           COWLOG_pgmlog( psds.this : Data );
           @apTran = 'N';
           leavesr;
        endif;

        // Que tenga al menos una de las otras polizas
        // con pago electronico
        elec = *off;
        setll %kds(k1haag:4) pahaag01;
        reade %kds(k1haag:4) pahaag01;
        dow not %eof;
            if agmar1 = '1';
               cfpg = SPVSPO_getFormaDePago( agempr
                                           : agsucu
                                           : agarcd
                                           : agspol
                                           : *omit  );
               if cfpg <= 3;
                  elec = *on;
                  leave;
               endif;
            endif;
         reade %kds(k1haag:4) pahaag01;
        enddo;

        if elec = *off;
           Data = CRLF + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso)) + ' '
                + %trim(%char(%time():*iso))         + CRLF
                + '&nbsp&nbspURL   : '      + uri    + CRLF
                + 'Asegurado sin pago electronico.' + CRLF;
           COWLOG_pgmlog( psds.this : Data );
           @apTran = 'N';
           leavesr;
        endif;

        // Que sea persona fisica
        if dftiso <> 98;
           Data = CRLF + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso)) + ' '
                + %trim(%char(%time():*iso))         + CRLF
                + '&nbsp&nbspURL   : '      + uri    + CRLF
                + 'Asegurado no es persona fisica.' + CRLF;
           COWLOG_pgmlog( psds.this : Data );
           @apTran = 'N';
           leavesr;
        endif;

        // Nacionalidad
        if dfcnac <= 0;
           Data = CRLF + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso)) + ' '
                + %trim(%char(%time():*iso))         + CRLF
                + '&nbsp&nbspURL   : '      + uri    + CRLF
                + 'Fecha de nacimiento invalida.' + CRLF;
           COWLOG_pgmlog( psds.this : Data );
           @apTran = 'N';
           leavesr;
        endif;

        // Bancos, Directo Empleados, etc no van
        setll %kds(k1haag:4) pahaag01;
        reade %kds(k1haag:4) pahaag01;
        dow not %eof;
            if SPVSPO_getCadenaComercial( agempr
                                        : agsucu
                                        : agarcd
                                        : agspol
                                        : peCade
                                        : *omit  );
                if peCade(1) <= 0;
                   Data = CRLF + CRLF
                        + 'Fecha/Hora: '
                        + %trim(%char(%date():*iso)) + ' '
                        + %trim(%char(%time():*iso))         + CRLF
                        + '&nbsp&nbspURL   : '      + uri    + CRLF
                        + 'No se pudo recuperar productor' + CRLF;
                   COWLOG_pgmlog( psds.this : Data );
                   @apTran = 'N';
                   leavesr;
                endif;
                k1hint.inEmpr = agempr;
                k1hint.inSucu = agsucu;
                k1hint.inNivt = 1;
                k1hint.inNivc = peCade(1);
                chain %kds( k1hint : 4 ) sahint;
                if %found;
                  if inRel1 <> 99400;
                    if inMabc = 'S';
                      Data = CRLF + CRLF
                           + 'Fecha/Hora: '
                           + %trim(%char(%date():*iso)) + ' '
                           + %trim(%char(%time():*iso))         + CRLF
                           + '&nbsp&nbspURL   : '      + uri    + CRLF
                           + 'Productor Banco o Directo.' + CRLF;
                      COWLOG_pgmlog( psds.this : Data );
                      @apTran = 'N';
                      leavesr;
                    endif;
                  endif;
                endif;
             else;
                @apTran = 'N';
                leavesr;
            endif;
         reade %kds(k1haag:4) pahaag01;
        enddo;

        // Documento con mas de un daf
        cant = 0;
        if @@tdoc <> 98;
           monitor;
              $$ndoc = %dec(@@ndoc:8:0);
            on-error;
              @apTran = 'N';
              leavesr;
           endmon;
           setll (@@tdoc:$$ndoc) gnhdaf05;
           reade (@@tdoc:$$ndoc) gnhdaf05;
           dow not %eof;
               cant += 1;
               if cant > 1;
                  Data = CRLF + CRLF
                       + 'Fecha/Hora: '
                       + %trim(%char(%date():*iso)) + ' '
                       + %trim(%char(%time():*iso))         + CRLF
                       + '&nbsp&nbspURL   : '      + uri    + CRLF
                       + 'Documento con mas de un daf' + CRLF;
                  COWLOG_pgmlog( psds.this : Data );
                  @apTran = 'N';
                  leavesr;
               endif;
            reade (@@tdoc:$$ndoc) gnhdaf05;
           enddo;
         else;
           setll ndoc gnhdaf07;
           reade ndoc gnhdaf07;
           dow not %eof;
               cant += 1;
               if cant > 1;
                  Data = CRLF + CRLF
                       + 'Fecha/Hora: '
                       + %trim(%char(%date():*iso)) + ' '
                       + %trim(%char(%time():*iso))         + CRLF
                       + '&nbsp&nbspURL   : '      + uri    + CRLF
                       + 'Documento con mas de un daf' + CRLF;
                  COWLOG_pgmlog( psds.this : Data );
                  @apTran = 'N';
                  leavesr;
               endif;
            reade ndoc gnhdaf07;
           enddo;
        endif;

        //
        // Veo si es valida para web
        //
        exsr $valiPrwAse;

       endsr;

       begsr $TcCbu;

        // Obtener Caracter para sustituir en la mascara...
        if SVPVLS_getValSys( 'HEDITCARTC' : *omit : @vsys );
          @@Cara = %trim(@vsys);
        endif;

        // Obtener Cantidad de digitos visible en la mascara...
        if SVPVLS_getValSys( 'HEDITCANTI' : *omit : @vsys );
          @@Cant = %dec(%trim(@vsys):20:0);
        endif;

        // Obtener CBU...
        if SPVCBU_getCuenta( peNrdf : peIvbc : peIvsu : peTcta : peNcta );
          @@Ncbu = SPVCBU_GetCBUEntero( peIvbc : peIvsu : peTcta : peNcta );
          cbu_ed = SPVCBU_enmascararNumero( @@Ncbu : @@Cara : @@Cant );
        endif;

        // Obtener TDC...
        clear @@DsTc;
        @@DsTcC = 0;
        if SPVTCR_getGnhdtc( peNrdf : *omit : *omit : @@DsTc : @@DsTcC );
          for x = 1 to @@DsTcC;
            if @@DsTc(x).dfBloq = 'N';
              @@Ntdc = @@DsTc(x).dfNrtc;
              @@Etdc = SVPDES_nombCortoEmpTdc( @@DsTc(x).dfCtcu );
              nro_ed = SPVTCR_enmascararNumero( @@DsTc(x).dfCtcu
                                              : @@DsTc(x).dfNrtc
                                              : @@Cara
                                              : @@Cant           );
              leave;
            endif;
          endfor;
        endif;

       endsr;

       begsr $valiPrwAse;

        clear peBase;
        clear peDomi;
        clear peDocu;
        clear peNtel;
        clear peNaci;
        clear peMail;
        clear peInsc;
        clear pdNomb;
        clear pdDomi;
        clear pdDocu;
        clear pdNaci;
        clear pdMarc;
        clear pdProv;
        clear pdMail;

        if SVPASE_getProductorAsegurado( peNrdf
                                       : @@nivt
                                       : @@nivc ) = *off;
           Data = CRLF + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso)) + ' '
                + %trim(%char(%time():*iso))         + CRLF
                + '&nbsp&nbspURL   : '      + uri    + CRLF
                + 'No se puede recuperar el Productor.' + CRLF;
           COWLOG_pgmlog( psds.this : Data );
           @apTran = 'N';
           leavesr;
        endif;
        peBase.peEmpr = empr;
        peBase.peSucu = sucu;
        peBase.peNivt = @@nivt;
        peBase.peNivc = @@nivc;
        peBase.peNit1 = peBase.peNivt;
        peBase.peNiv1 = peBase.peNivc;

        if SVPDAF_getDatoFiliatorio( peNrdf
                                   : pdNomb
                                   : pdDomi
                                   : pdDocu
                                   : pdCont
                                   : pdNaci
                                   : pdMarc
                                   : pdCbuS
                                   : pdDape
                                   : pdClav
                                   : pdText
                                   : pdTextC
                                   : pdProv
                                   : pdProvC
                                   : pdMail
                                   : pdMailC  ) = *off;
           Data = CRLF + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso)) + ' '
                + %trim(%char(%time():*iso))         + CRLF
                + '&nbsp&nbspURL   : '      + uri    + CRLF
                + 'No se puede recuperar DAF.' + CRLF;
           COWLOG_pgmlog( psds.this : Data );
           @apTran = 'N';
           leavesr;
        endif;

        eval-corr peDomi = pdDomi;
        eval-corr peDocu = pdDocu;

        peNtel.nte1 = %trim(%char(pdCont.teln));
        peNtel.nte2 = %trim(%char(pdCont.faxn));
        peNtel.nte3 = %trim(%char(pdCont.tel1));
        peNtel.nte4 = pdCont.tpa1;
        peNtel.pweb = pdCont.pweb;

        eval-corr peNaci = pdNaci;

        for i = 1 to pdMailC;
            if pdMail(i).tipo = 1;
               peMail.ctce = pdMail(i).tipo;
               peMail.mail = pdMail(i).mail;
               leave;
            endif;
        endfor;

        PRWASE_isValid2( peBase
                       : peNrdf
                       : peDomi
                       : peDocu
                       : peNtel
                       : pdDocu.tiso
                       : peNaci
                       : pdDape.cprf
                       : pdDape.sexo
                       : pdDape.esci
                       : pdDape.raae
                       : peMail
                       : 0
                       : 0
                       : 5
                       : peInsc
                       : peErro
                       : peMsgs
                       : *omit  );
        if peErro = -1;
           Data = CRLF + CRLF
                + 'Fecha/Hora: '
                + %trim(%char(%date():*iso)) + ' '
                + %trim(%char(%time():*iso))         + CRLF
                + '&nbsp&nbspURL   : '      + uri    + CRLF
                + 'PRWASE_isValid2(): '
                + peMsgs.peMsid
                + '->'
                + peMsgs.peMsg1 + CRLF;
           COWLOG_pgmlog( psds.this : Data );
           @apTran = 'N';
           leavesr;
        endif;

       endsr;

      /end-free

