     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSSSX1: QUOM Versión 2                                       *
      *         REST - Siniestralidad                                *
      * ------------------------------------------------------------ *
      * Astiz Facundo                        *13/10/2021*            *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      *--- Archivos ------------------------------------------------ *
     FPahsva    if   e           k disk    usropn
     FPahsb1    if   e           k disk    usropn
     FPahsbs    if   e           k disk    usropn
      *------------------------------------------------------------- *

      *--- Copy H -------------------------------------------------- *
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      *------------------------------------------------------------- *

      *--- Entry --------------------------------------------------- *
     D Main            pr                  ExtPgm('WSSSX1')
     D peEmpr                         1
     D peSucu                         2
     D peRama                         2  0
     D peSini                         7  0
     D peNops                         7  0
     D*------------------------------------------------------------- *
     D Main            pi
     D peEmpr                         1
     D peSucu                         2
     D peRama                         2  0
     D peSini                         7  0
     D peNops                         7  0
     D*------------------------------------------------------------- *

      *--- Variables REST ------------------------------------------ *
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D @@repl          s          65535a
     D peMsgs          ds                  likeds(paramMsgs)
      *------------------------------------------------------------- *

      *--- Variables de Trabajo ------------------------------------ *
     D p@DsCd          ds                  likeds ( DsPahscd_t )
     D @@Ds01          ds                  likeds ( DSSet001_t )
     D @1FecOcurr      s              8  0
     D @@FecOcurr      s             10
     D p@Nivt          s              1  0
     D p@Nivc          s              5  0
     D @@Nomb          s             40
     D @@Cesi          s              2  0
     D p@DsBe          ds                  likeds ( DsPahsbe_t ) dim(999)
     D p@DsBeC         s             10i 0
     D @x              s             10i 0
     D @@Nmat          s             25
     D @@Pago          s             25  2
     D @@Hecg          s              1
     D @@Riec          s              3
     D @@Ramd          s             20
      *------------------------------------------------------------- *

      *--- Keys ---------------------------------------------------- *
     D k1ysva          ds                  likeRec(p1hsva:*Key)
     D k1ysb1          ds                  likerec(p1hsb1:*key)
     D k1ysbs          ds                  likerec(p1hsbs:*key)
      *------------------------------------------------------------- *

      *--- Estructura Interna -------------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)
      *------------------------------------------------------------- *

       //------------------------------------------------------//
      /free

       *inlr = *on;

       //Busco Info
       exsr srBuscaData;

       if SVPSIN_getBeneficiarios ( peEmpr
                                  : peSucu
                                  : peRama
                                  : peSini
                                  : peNops
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : *omit
                                  : p@DsBe
                                  : p@DsBeC) = *on;
        for @x = 1 to p@DsBeC;
         if p@DsBe(@x).beMar2 = '1';
          exsr srBuscaData2;
01070      REST_startArray( 'siniestro');
01080       REST_writeXmlLine( 'numero'          : %char (peSini) );
01090       REST_writeXmlLine( 'nroOperStro'     : %char (peNops) );
01100       REST_writeXmlLine( 'rama'            : %char (peRama) );
01100       REST_writeXmlLine( 'descripcionRama' : %char (@@Ramd) );
01110       REST_writeXmlLine( 'patente'         : @@Nmat );
01120       REST_writeXmlLine( 'reclamo'         : '0' );
01130       REST_writeXmlLine( 'estadoReclamo'   : %char (@@cesi) );
01140       REST_writeXmlLine( 'poliza'         : %char (p@DsCd.cdPoli)     );
01150       REST_writeXmlLine( 'productor'       : @@Nomb );
01160       REST_writeXmlLine( 'fechaOcurrencia' : @@FecOcurr );
01170       REST_writeXmlLine( 'causa'          : %char (p@DsCd.cdCauc)     );
01180       REST_writeXmlLine( 'hechoGenerador'  : @@Hecg );
01190       REST_writeXmlLine( 'importePagos'    :
01200                          SVPREST_editImporte( @@Pago ));
01210       REST_writeXmlLine( 'cobertura'       : @@Riec );
01220       REST_writeXmlLine( 'estadoSiniestro' : %char (@@Cesi) );
01230       REST_writeXmlLine( 'nroJuicio'      : %char (p@DsCd.cdJuin)     );
01230       REST_writeXmlLine( 'asegurado'      : %char (p@DsCd.cdasen)     );
            REST_writeXmlLine( 'nombreAsegurado'
                             : SVPDAF_getNombre( p@DsCd.cdAsen));
01240      REST_endArray( 'siniestro');
          endif;
         endfor;
       endif;

      *------------------------------------------------------------- *
       begsr srBuscaData;
          if not SVPTAB_getSet001( peRama : @@Ds01 );
            @@Ramd = @@Ds01.t@Ramd;
          endif;
          if SVPSIN_getCaratula2( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : p@DsCd ) = *on;
             @1FecOcurr  = ( p@DsCd.cdFsia * 10000 )
                           + ( p@DsCd.cdFsim * 100 )
                           + p@DsCd.cdFsid;
             @@FecOcurr = SVPREST_editFecha (@1FecOcurr);
             @@Nomb = SPVSPO_getProductor ( peEmpr
                                          : peSucu
                                          : p@DsCd.cdArcd
                                          : p@DsCd.cdSpol
                                         //  : p@DsCd.cdSspo
                                          : *omit
                                          : p@Nivt
                                          : p@Nivc);
             @@cesi = SVPSIN_getEstSin( peEmpr
                                      : peSucu
                                      : peRama
                                      : peSini
                                      : peNops );
          endif;
       endsr;
     d*------------------------------------------------------------- *
       begsr srBuscaData2;
          if not %open (Pahsva);
             open Pahsva;
          endif;
          k1ysva.vaEmpr = peEmpr;
          k1ysva.vaSucu = peSucu;
          k1ysva.vaRama = peRama;
          k1ysva.vaSini = peSini;
          k1ysva.vaNops = peNops;
          k1ysva.vaPoco = p@DsBe(@x).bePoco;
          k1ysva.vaPaco = p@DsBe(@x).bePaco;
          chain %kds( k1ysva : 7 ) Pahsva;
          if %found;
             @@Nmat = vaNmat;
          endif;
          if %open (Pahsva);
             close Pahsva;
          endif;

          @@cesi = SVPSIN_getEstRec( peEmpr
                                   : peSucu
                                   : peRama
                                   : peSini
                                   : peNops
                                   : p@DsBe(@x).beNrdf
                                   : p@DsBe(@x).bePoco
                                   : p@DsBe(@x).bePaco
                                   : p@DsBe(@x).beRiec
                                   : p@DsBe(@x).beXcob
                                   : p@DsBe(@x).beSebe );
          @@Pago = SVPSIN_getPag( peEmpr
                                : peSucu
                                : peRama
                                : peSini
                                : peNops
                                : p@DsBe(@x).beNrdf );

          if not %open (Pahsb1);
             open Pahsb1;
          endif;
          k1ysb1.b1Empr = peEmpr;
          k1ysb1.b1Sucu = peSucu;
          k1ysb1.b1Rama = peRama;
          k1ysb1.b1Sini = peSini;
          k1ysb1.b1Nops = peNops;
          k1ysb1.b1Poco = p@DsBe(@x).bePoco;
          k1ysb1.b1Paco = p@DsBe(@x).bePaco;
          k1ysb1.b1Riec = p@DsBe(@x).beRiec;
          k1ysb1.b1Xcob = p@DsBe(@x).beXcob;
          k1ysb1.b1Nrdf = p@DsBe(@x).beNrdf;
          k1ysb1.b1Sebe = p@DsBe(@x).beSebe;

          chain(n) %kds( k1ysb1 : 11 ) pahsb1;
          if %found;
             @@Hecg = b1Hecg;
          endif;
          if %open (Pahsb1);
             close Pahsb1;
          endif;

          if not %open (Pahsbs);
             open Pahsbs;
          endif;
          k1ysbs.bsEmpr = peEmpr;
          k1ysbs.bsSucu = peSucu;
          k1ysbs.bsRama = peRama;
          k1ysbs.bsSini = peSini;
          k1ysbs.bsNops = peNops;
          k1ysbs.bsPoco = p@DsBe(@x).bePoco;
          k1ysbs.bsPaco = p@DsBe(@x).bePaco;
          k1ysbs.bsRiec = p@DsBe(@x).beRiec;
          k1ysbs.bsXcob = p@DsBe(@x).beXcob;
          chain(n) %kds( k1ysbs ) pahsbs;
          if %found;
             @@Riec = bsRiec;
          endif;
          if %open (Pahsbs);
             close Pahsbs;
          endif;
       endsr;
      *------------------------------------------------------------- *
