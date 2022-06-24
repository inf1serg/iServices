     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRIND: QUOM Versión 2                                       *
      *         Indicadores                                          *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *31-May-2017            *
      * ************************************************************ *
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehni201  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D WSLIND          pr                  ExtPgm('WSLIND')
     D   peBase                            likeds(paramBase) const
     D   pePvig                            likeds(indPrdvig_t) dim(99)
     D   pePvigC                     10i 0
     D   peCart                            likeds(indCart_t)
     D   peCzas                            likeds(indCzas_t)
     D   peStro                            likeds(indStros_t)
     D   peCotw                            likeds(indCotiw_t)
     D   peFpro                            likeds(indFech_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLIND1         pr                  ExtPgm('WSLIND1')
     D   peBase                            likeds(paramBase) const
     D   peLind                            likeds(indicadores_t) dim(999)
     D   peLindC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D x               s             10i 0
     D prim            s             30a
     D prem            s             30a
     D qty             s             10a
     D auvi            s             10a
     D hovi            s             10a
     D vivi            s             10a
     D revi            s             10a
     D aucs            s             10a
     D hocs            s             10a
     D vics            s             10a
     D recs            s             10a
     D auxx            s             10a
     D hoxx            s             10a
     D vixx            s             10a
     D rexx            s             10a
     D xacw            s             10a
     D xhcw            s             10a
     D xvcw            s             10a
     D xrcw            s             10a
     D xx45            s             10a
     D xm45            s             10a
     D xaxf            s             10a
     D fech            s             10d
     D hora            s              6a
     D hor1            s              8a
     D orde            s              5i 0

     D CRLF            c                   x'0d25'

     D k1hni2          ds                  likerec(s1hni201:*key)

     D pePvig          ds                  likeds(indPrdvig_t) dim(99)
     D peCart          ds                  likeds(indCart_t)
     D peCzas          ds                  likeds(indCzas_t)
     D peStro          ds                  likeds(indStros_t)
     D peCotw          ds                  likeds(indCotiw_t)
     D peFpro          ds                  likeds(indFech_t)
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peLind          ds                  likeds(indicadores_t) dim(999)
     D peLindC         s             10i 0
     D pePvigC         s             10i 0
     D peErro          s             10i 0

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
       clear pePvig;
       clear peCart;
       clear peCzas;
       clear peStro;
       clear peCotw;
       clear peFpro;
       clear peMsgs;

       pePvigC = 0;
       peErro  = 0;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       COWLOG_logcon('WSRIND':peBase);

       WSLIND( peBase
             : pePvig
             : pePvigC
             : peCart
             : peCzas
             : peStro
             : peCotw
             : peFpro
             : peErro
             : peMsgs );

       clear peLind;
       peLindC = 0;

       WSLIND1( peBase
              : peLind
              : peLindC
              : peErro
              : peMsgs );

       REST_writeHeader();
       REST_write( '<?xml version="1.0" encoding="ISO-8859-1"?>');
       REST_writeXmlLine( 'indicadores' : '*BEG' );

       fech = %date(peFpro.fech:*iso);
       hora = %editc(peFpro.hora:'X');
       hor1 = %subst(hora:1:2)
            + ':'
            + %subst(hora:3:2)
            + ':'
            + %subst(hora:5:2);
       REST_writeXmlLine('fechaProceso':%char(fech:*iso));
       REST_writeXmlLine( 'horaProceso' : hor1);

       if pePvigC > 0;
         REST_writeXmlLine( 'polizasVigentes' : '*BEG' );
         orde = %lookup( 'pePvig' : peLind(*).indi );
         if orde > 0;
            orde = peLind(orde).orde;
         endif;
         REST_writeXmlLine( 'ordinal' : %trim(%char(orde)) );
         for x = 1 to pePvigC;
            qty = %char(pePvig(x).qty);
            prim = %editw( pePvig(x).prim : '                 .  -' );
            prem = %editw( pePvig(x).prem : '                 .  -' );
            REST_writeXmlLine( 'indicador' : '*BEG' );
            REST_writeXmlLine( 'rama' : %char(pePvig(x).rama) );
            REST_writeXmlLine( 'ramd' : pePvig(x).ramd );
            REST_writeXmlLine( 'cantidad': qty );
            REST_writeXmlLine( 'prima'   : prim);
            REST_writeXmlLine( 'premio'  : prem);
            REST_writeXmlLine( 'indicador' : '*END' );
         endfor;
         REST_writeXmlLine( 'polizasVigentes' : '*END' );
       endif;

       auvi = %editw( peCart.auvi : '   .  ');
       hovi = %editw( peCart.hovi : '   .  ');
       vivi = %editw( peCart.vivi : '   .  ');
       revi = %editw( peCart.revi : '   .  ');
       orde = %lookup( 'peCart' : peLind(*).indi );
       if orde > 0;
          orde = peLind(orde).orde;
       endif;
       if peCart.auvi <> 0 or
          peCart.hovi <> 0 or
          peCart.vivi <> 0 or
          peCart.revi <> 0;
          REST_writeXmlLine( 'carteraVigente' : '*BEG' );
          REST_writeXmlLine( 'ordinal'        : %trim(%char(orde)) );
          REST_writeXmlLine( 'autosSobreTotal' : auvi );
          REST_writeXmlLine( 'hogarSobreTotal' : hovi );
          REST_writeXmlLine( 'vidaSobreTotal' : vivi );
          REST_writeXmlLine( 'restoSobreTotal' : revi );
          REST_writeXmlLine( 'carteraVigente' : '*END' );
       ENDIF;

       orde = %lookup( 'peStro' : peLind(*).indi );
       if orde > 0;
          orde = peLind(orde).orde;
       endif;
       REST_writeXmlLine( 'siniestros' : '*BEG' );
       REST_writeXmlLine( 'ordinal'        : %trim(%char(orde)) );
       aucs = %trim(%char(peStro.aucs));
       auvi = %trim(%char(peStro.auvi));
       hocs = %trim(%char(peStro.hocs));
       hovi = %trim(%char(peStro.hovi));
       vics = %trim(%char(peStro.vics));
       vivi = %trim(%char(peStro.vivi));
       recs = %trim(%char(peStro.recs));
       revi = %trim(%char(peStro.revi));
       auxx = %trim(%editw(peStro.auxx:'   .  '));
       hoxx = %trim(%editw(peStro.hoxx:'   .  '));
       rexx = %trim(%editw(peStro.rexx:'   .  '));
       vixx = %trim(%editw(peStro.vixx:'   .  '));
       rexx = %trim(%editw(peStro.rexx:'   .  '));
       REST_writeXmlLine( 'cantStrAutos' : aucs );
       REST_writeXmlLine( 'cantVigAutos' : auvi );
       REST_writeXmlLine( 'cantStrHogar' : hocs );
       REST_writeXmlLine( 'cantVigHogar' : hovi );
       REST_writeXmlLine( 'cantStrVida'  : vics );
       REST_writeXmlLine( 'cantVigVida'  : vivi );
       REST_writeXmlLine( 'cantStrResto' : recs );
       REST_writeXmlLine( 'cantVigResto' : revi );
       REST_writeXmlLine( 'strAutoSoVig' : auxx );
       REST_writeXmlLine( 'strHogaSoVig' : hoxx );
       REST_writeXmlLine( 'strVidaSoVig' : vixx );
       REST_writeXmlLine( 'strRestSoVig' : rexx );
       REST_writeXmlLine( 'siniestros' : '*END' );

       xacw = %trim(%editw(peCotw.xacw:'   .  '));
       xhcw = %trim(%editw(peCotw.xhcw:'   .  '));
       xvcw = %trim(%editw(peCotw.xvcw:'   .  '));
       xrcw = %trim(%editw(peCotw.xrcw:'   .  '));

       orde = %lookup( 'peCotw' : peLind(*).indi );
       if orde > 0;
          orde = peLind(orde).orde;
       endif;

       if peCotw.xacw <> 0 or
          peCotw.xhcw <> 0 or
          peCotw.xvcw <> 0 or
          peCotw.xrcw <> 0;
          REST_writeXmlLine( 'cotizacionesWeb' : '*BEG' );
          REST_writeXmlLine( 'ordinal'        : %trim(%char(orde)) );
          REST_writeXmlLine( 'autosSobreTotal' : xacw );
          REST_writeXmlLine( 'hogarSobreTotal' : xhcw );
          REST_writeXmlLine( 'vidaSobreTotal' : xvcw );
          REST_writeXmlLine( 'restoSobreTotal' : xrcw );
          REST_writeXmlLine( 'cotizacionesWeb' : '*END' );
       ENDIF;

       xx45 = %trim(%editw(peCzas.xx45:'   .  '));
       xm45 = %trim(%editw(peCzas.xm45:'   .  '));
       xaxf = %trim(%editw(peCzas.xaxf:'   .  '));
       orde = %lookup( 'peCzas' : peLind(*).indi );
       if orde > 0;
          orde = peLind(orde).orde;
       endif;

       if peCzas.xx45 <> 0 or
          peCzas.xm45 <> 0 or
          peCzas.xaxf <> 0;
          REST_writeXmlLine( 'cobranzas' : '*BEG' );
          REST_writeXmlLine( 'ordinal'        : %trim(%char(orde)) );
          REST_writeXmlLine( 'deudaMayVig' : xx45 );
          REST_writeXmlLine( 'deudaMenVig' : xm45 );
          REST_writeXmlLine( 'anulFaPagVi' : xaxf );
          REST_writeXmlLine( 'cobranzas' : '*END' );
       ENDIF;

       REST_writeXmlLine( 'indicadores' : '*END' );
       REST_end();
       close *all;

       return;

