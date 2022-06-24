
     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)

      * ********************************************************************* *
      * WSRAGE - Autogestión: Productores por Póliza Documento                *
      *          RM#01148 Generar servicio REST lista de pólizas              *
      * --------------------------------------------------------------------- *
      * Gio Nicolini                                            * 23-Ago-2018 *
      * --------------------------------------------------------------------- *
      * Modificaciones :                                                      *
      *                                                                       *
      * ********************************************************************* *

     Fpahaag01  if   e           k disk
     Fpahec1    if   e           k disk
     Fpahpol    if   e           k disk
     Fsehni201  if   e           k disk
     fgnhda6    if   e           k disk    prefix(hda6_)

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D wslog           pr                  ExtPgm('QUOMDATA/WSLOG')
     D                              512    const

     D par310x3        pr                  ExtPgm('PAR310X3')
     D                                1
     D                                4  0
     D                                2  0
     D                                2  0

     D wsragf          pr                  ExtPgm('WSRAGF')
     D   peempr                            like(agempr)
     D   pesucu                            like(agsucu)
     D   pearcd                            like(agarcd)
     D   pespol                            like(agspol)
     D   perama                            like(agrama)
     D   pepoli                            like(agpoli)
     D   petdoc                            like(agtdoc)
     D   pendoc                            like(agndoc)

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
     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1hpol          ds                  likerec(p1hpol:*key)
     D k1hni2          ds                  likerec(s1hni201:*key)

     D uri             s            512a
     D url             s           3000a   varying
     D @@Rc1           s               n
     D @@Rc2           s             10i 0
     D @@Idx           s             10i 0
     D @@Jdx           s             10i 0
     D @@Kdx           s             10i 0

     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a

     D @@Msgs          ds                  likeds(paramMsgs)
     D @@repl          s          65535a
     D @@Tdoc          s              2  0
     D @@Ndoc          s             11  0

     D @@FechaHoy      s              8  0
     D @@FecA          s              4  0
     D @@FecM          s              2  0
     D @@FecD          s              2  0

     D hay_base        s              1n
     D peBase          ds                  likeds( paramBase )
     D @@Madd          ds                  likeds(MailAddr_t) dim(100)

     d @@AuxProd       s              6

     d dsHaag        e ds                  extname(pahaag01)
     d dsHec1        e ds                  extname(pahec1)
     d dsHni2        e ds                  extname(sehni201)

     d                 ds
     d @@Data                              dim(3000) ascend
     d   @@Key                       30                 overlay(@@Data : 1)
     d   @@Prod                       6                 overlay(@@Data : *next)
     d   @@Haag                      70                 overlay(@@Data : *next)
     d   @@Hec1                     500                 overlay(@@Data : *next)
     d   @@Hni2                     310                 overlay(@@Data : *next)

     d @@TdocCUIT      s              2  0 inz(98)

      /free

        *inlr = *on;

        // Obtener los parámetros de la URL
        // --------------------------------
        @@Rc1 = REST_getUri( psds.this : uri );
        if not @@Rc1;
          return;
        endif;
        url = %trim(uri);

        empr = REST_getNextPart(url);
        sucu = REST_getNextPart(url);
        tdoc = REST_getNextPart(url);
        ndoc = REST_getNextPart(url);

        in lda;
        lda.empr = empr;
        lda.sucu = sucu;
        out lda;

        par310x3(lda.empr : @@FecA : @@FecM : @@FecD);

        @@FechaHoy = ( @@FecA * 10000 ) + ( @@FecM * 100 ) + @@FecD;

        // Validacion de datos recibidos
        // -----------------------------
        if %check( '0123456789' : %trim(tdoc) ) <> 0;
          clear @@repl;
          @@repl = tdoc;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AAG0001'
                       : @@Msgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          @@Rc1 = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'AAG0001'
                                  : @@Msgs.peMsev
                                  : @@Msgs.peMsg1
                                  : @@Msgs.peMsg2 );
          REST_end();
          close *all;
          return;
        endif;

        monitor;
          @@Tdoc = %dec(tdoc:2:0);
        on-error;
          @@Tdoc = 0;
        endmon;

        @@Rc1 = *Off;
        if @@Tdoc = @@TdocCUIT or SVPVAL_tipoDeDocumento(@@Tdoc);
          @@Rc1 = *On;
        endif;

        if not @@Rc1;
          clear @@repl;
          @@repl = tdoc;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AAG0001'
                       : @@Msgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          @@Rc1 = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'AAG0001'
                                  : @@Msgs.peMsev
                                  : @@Msgs.peMsg1
                                  : @@Msgs.peMsg2 );
          REST_end();
          close *all;
          return;
        endif;

        if %check( '0123456789' : %trim(ndoc) ) <> 0;
          clear @@repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AAG0002'
                       : @@Msgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          @@Rc1 = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'AAG0002'
                                  : @@Msgs.peMsev
                                  : @@Msgs.peMsg1
                                  : @@Msgs.peMsg2 );
          REST_end();
          close *all;
          return;
        endif;

        monitor;
          @@Ndoc = %dec(ndoc:11:0);
        on-error;
          @@Ndoc = 0;
        endmon;

        @@Rc1 = *Off;
        if ( @@Tdoc = @@TdocCUIT and @@Ndoc > 10000000000 ) or
           ( @@Tdoc <> @@TdocCUIT and @@Ndoc < 100000000 ) ;
          @@Rc1 = *On;
        endif;

        if not @@Rc1;
          clear @@repl;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'AAG0002'
                       : @@Msgs
                       : %trim(@@repl)
                       : %len(%trim(@@repl)) );
          @@Rc1 = REST_writeHeader( 400
                                  : *omit
                                  : *omit
                                  : 'AAG0002'
                                  : @@Msgs.peMsev
                                  : @@Msgs.peMsg1
                                  : @@Msgs.peMsg2 );
          REST_end();
          close *all;
          return;
        endif;

        if SVPREST_chkCliente( empr
                             : sucu
                             : tdoc
                             : ndoc
                             : @@Msgs ) = *Off;
           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : @@Msgs.peMsid
                           : @@Msgs.peMsev
                           : @@Msgs.peMsg1
                           : @@Msgs.peMsg2 );
           REST_end();
           SVPREST_end();
           close *all;
           return;
        endif;

        @@Rc1 = COWLOG_logConAutoGestion( empr
                                        : sucu
                                        : @@Tdoc
                                        : @@Ndoc
                                        : psds.this);

        REST_writeHeader();
        REST_writeEncoding();
        REST_writeXmlLine( 'productores' : '*BEG');

        clear @@Jdx;
        @@Key = *all'9';
        clear @@Prod;
        clear @@Haag;
        clear @@Hec1;
        clear @@Hni2;

        k1haag.agempr = empr;
        k1haag.agsucu = sucu;
        k1haag.agtdoc = @@Tdoc;
        k1haag.agndoc = @@Ndoc;
        setll %kds(k1haag:4) pahaag01;
        dou %eof(pahaag01);
          reade %kds(k1haag:4) pahaag01;
          if not %eof(pahaag01);
            if agmar1 = '1';
            exsr $getBase;
            if SPVSPO_chkSpolRenovada( agempr
                                     : agsucu
                                     : agarcd
                                     : agspol ) = 0 and hay_base;

              k1hni2.n2empr = c1empr;
              k1hni2.n2sucu = c1sucu;
              k1hni2.n2nivt = c1nivt;
              k1hni2.n2nivc = c1nivc;
              chain %kds(k1hni2) sehni201;
              if %found(sehni201);

                @@Jdx += 1;
                @@Key(@@Jdx)  = %editc( c1nivt : 'X' )
                              + %editc( c1nivc : 'X' )
                              + %editc( agarcd : 'X' )
                              + %editc( agspol : 'X' )
                              + %editc( agrama : 'X' )
                              + %editc( agpoli : 'X' );
                @@Prod(@@Jdx) = %editc( c1nivt : 'X' )
                              + %editc( c1nivc : 'X' );
                @@Haag(@@Jdx) = dsHaag;
                @@Hec1(@@Jdx) = dsHec1;
                @@Hni2(@@Jdx) = dsHni2;

              endif;

            endif;

          endif;
         endif;
        enddo;

        if @@Jdx > *zeros;
          @@Kdx = @@Jdx;
          sorta @@Key;
          @@AuxProd = *zeros;
          for @@Jdx = 1 to @@Kdx;
            if @@Prod(@@Jdx) <> @@AuxProd;
              if @@AuxProd <> *zeros;

                REST_writeXmlLine( 'polizas' : '*END');
                REST_writeXmlLine( 'productor' : '*END');

              endif;
              dsHec1 = @@Hec1(@@Jdx);
              dsHni2 = @@Hni2(@@Jdx);
              peBase.peEmpr = c1empr;
              peBase.peSucu = c1sucu;
              peBase.peNivt = c1nivt;
              peBase.peNivc = c1nivc;
              peBase.peNit1 = c1nivt;
              peBase.peNiv1 = c1nivc;

              REST_writeXmlLine( 'productor' : '*BEG');
              exsr TagsProductor;
              REST_writeXmlLine( 'polizas' : '*BEG');

              @@AuxProd = @@Prod(@@Jdx);
            endif;
            dsHaag = @@Haag(@@Jdx);
            wsragf( agempr
                  : agsucu
                  : agarcd
                  : agspol
                  : agrama
                  : agpoli
                  : agtdoc
                  : agndoc );
          endfor;
          REST_writeXmlLine( 'polizas' : '*END');
          REST_writeXmlLine( 'productor' : '*END');
        endif;

        REST_writeXmlLine( 'productores' : '*END');
        REST_end();

        close *all;
        return;

        ////////////////////
        begsr TagsProductor;
        ////////////////////

            REST_writeXmlLine( 'nombre'   : %trim(dfnomb) );

            REST_writeXmlLine( 'domicilio' : %trim(dfdomi) );

            REST_writeXmlLine( 'localidad' : %trim(loloca) );

            REST_writeXmlLine( 'postal' : '*BEG' );
              REST_writeXmlLine( 'codigo':%trim(%editw(locopo:'     ')));
              REST_writeXmlLine( 'sufijo':%editc(locops:'X') );
            REST_writeXmlLine( 'postal' : '*END' );

            if SVPINT_isMostrarTelefonos( peBase.peEmpr
                                        : peBase.peSucu
                                        : peBase.peNivt
                                        : peBase.peNivc
                                        : @@FechaHoy);
              chain dfnrdf gnhda6;
              if not %found(gnhda6);
                clear hda6_dftel2;
                clear hda6_dftel6;
              endif;

              if %trim(hda6_dftel2) <> '' or %trim(hda6_dftel6) <> '';
                REST_startArray( 'telefonos' );
                if %trim(hda6_dftel2) <> '';
                  REST_startArray( 'telefono' );
                    REST_writeXmlLine( 'tipo'   : 'P' );
                    REST_writeXmlLine( 'numero' : %trim(hda6_dftel2) );
                   REST_endArray  ( 'telefono' );
                endif;
                if %trim(hda6_dftel6) <> '';
                  REST_startArray( 'telefono' );
                    REST_writeXmlLine( 'tipo'   : 'C' );
                    REST_writeXmlLine( 'numero' : %trim(hda6_dftel6) );
                  REST_endArray  ( 'telefono' );
                endif;
                REST_endArray  ( 'telefonos' );
              else;
                REST_writeXmlLine( 'telefonos' : '');
              endif;

            endif;

            @@Rc1 = SVPINT_isMostrarMails( peBase.peEmpr
                                         : peBase.peSucu
                                         : peBase.peNivt
                                         : peBase.peNivc
                                         : @@FechaHoy);
            if @@Rc1;
              @@Rc1 = *Off;
              clear @@Madd;
              @@Rc2 = SVPMAIL_xNivc( peBase.peEmpr
                                   : peBase.peSucu
                                   : peBase.peNivt
                                   : peBase.peNivc
                                   : @@Madd
                                   : *omit );
              if @@Rc2 > *zeros;
                REST_writeXmlLine( 'mails' : '*BEG');
                for @@Idx = 1 to @@Rc2;
                  @@Rc1 = *On;
                  REST_writeXmlLine( 'mail' : '*BEG');
                    REST_writeXmlLine( 'tipo': %editc(@@Madd(@@Idx).tipo:'X') );
                    REST_writeXmlLine( 'direccion': %trim(@@Madd(@@Idx).mail) );
                  REST_writeXmlLine( 'mail' : '*END');
                endfor;
                REST_writeXmlLine( 'mails' : '*END');
              endif;
            endif;
            if not @@Rc1;
              REST_writeXmlLine( 'mails' : '');
            endif;

        endsr;

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

      /end-free

