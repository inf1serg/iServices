     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * APIPOA: Apis                                                 *
      *         Retorna pólizas de una solicitud                     *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *26-May-2017            *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * LRG 29/08/2018 - Se agrega mensaje para error 204            *
      * JSN 29/04/2019 - Se agrega inicialización en las estructuras *
      *                  del DAF.                                    *
      * JSN 25/09/2019 - Se agrega parametros al APIPO2.             *
      *                                                              *
      * ************************************************************ *
     Fctw00015  if   e           k disk
     Fpahec1    if   e           k disk
     Fgntloc    if   e           k disk
     Fsehase    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'

     D APIPO1          pr                  ExtPgm('APIPO1')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

     D APIPO2          pr                  ExtPgm('APIPO2')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D soln            s              7a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @fdes           s             10d
     D @fhas           s             10d
     D vigd            s             10a
     D vigh            s             10a
     D prem            s             30a
     D wrepl           s          65535a

      * Para SVPDAF_getDatoFiliatorio...
     D peNomb          ds                  likeDs(dsNomb_t)
     D peDomi          ds                  likeDs(dsDomi_t)
     D peDocu          ds                  likeDs(dsDocu_t)
     D peCont          ds                  likeDs(dsCont_t)
     D peDape          ds                  likeDs(dsDape_t)
     D peNaci          ds                  likeDs(dsNaci_t)
     D peMarc          ds                  likeDs(dsMarc_t)
     D peCbuS          ds                  likeDs(dsCbuS_t)
     D peClav          ds                  likeDs(dsClav_t)
     D peText          s             79    dim(999)
     D peTextC         s             10i 0
     D peProv          ds                  likeDs(dsProI_t) dim(999)
     D peProvC         s             10i 0
     D peMail          ds                  likeds(Mailaddr_t) dim(100)
     D peMailC         s             10i 0

     D peNivt          s              1  0
     D peNivc          s              5  0
     D z               s             10i 0
     D d               s             10i 0
     D peSoln          s              7  0

     D k1hec1          ds                  likerec(p1hec1:*key)
     D k1w000          ds                  likerec(c1w000:*key)

     D peFdes          s              8  0
     D peFhas          s              8  0
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
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
       nit1 = nivt;
       niv1 = nivc;
       soln = REST_getNextPart(url);

       monitor;
         peSoln = %dec(soln:7:0);
        on-error;
         peSoln = 0;
       endmon;

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 204
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

       k1w000.w0empr = empr;
       k1w000.w0sucu = sucu;
       k1w000.w0sucu = sucu;
       k1w000.w0nivt = %dec(nivt:1:0);
       k1w000.w0nivc = %dec(nivc:5:0);
       k1w000.w0soln = peSoln;
       chain %kds(k1w000:5) ctw00015;
       if not %found;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'POA0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
          rc = REST_writeHeader( 204
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

       if w0cest <> 7 or w0cses <> 7;
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'POA0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
          rc = REST_writeHeader( 204
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

       REST_writeHeader();
       REST_writeEncoding();

       clear peNomb;
       clear peDomi;
       clear peDocu;
       clear peCont;
       clear peNaci;
       clear peMarc;
       clear peCbus;
       clear peDape;
       clear peClav;
       clear peText;
       clear peTextC;
       clear peProv;
       clear peProvC;
       clear peMail;
       clear peMailC;

       k1hec1.c1empr = w0empr;
       k1hec1.c1sucu = w0sucu;
       k1hec1.c1arcd = w0arcd;
       k1hec1.c1spol = w0spol;
       k1hec1.c1sspo = 0;
       chain %kds(k1hec1) pahec1;
       if %found;
          rc = SVPDAF_getDatoFiliatorio( c1asen
                                       : peNomb
                                       : peDomi
                                       : peDocu
                                       : peCont
                                       : peNaci
                                       : peMarc
                                       : peCbus
                                       : peDape
                                       : peClav
                                       : peText
                                       : peTextC
                                       : peProv
                                       : peProvC
                                       : peMail
                                       : peMailC  );
          chain (peDomi.copo:peDomi.cops) gntloc;
          if not %found;
             loloca = *blanks;
             loproc = *blanks;
          endif;
          vigd = %editc(c1fioa:'X')
               + '-'
               + %editc(c1fiom:'X')
               + '-'
               + %editc(c1fiod:'X');
          vigh = %editc(c1fvoa:'X')
               + '-'
               + %editc(c1fvom:'X')
               + '-'
               + %editc(c1fvod:'X');
          if c1prem = 0;
             prem = '.00';
           else;
             prem = %editw(c1prem:'           0 .  -');
          endif;
          chain c1asen sehase;
          if not %found;
             asciva = 0;
          endif;
          REST_writeXmlLine('Operacion' : '*BEG');
          REST_writeXmlLine('articulo'    : %char(c1arcd) );
          REST_writeXmlLine('superPoliza' : %char(c1spol) );
          REST_writeXmlLine('suplementoSuperPoliza' : %char(c1sspo) );
          REST_writeXmlLine('tomador': peNomb.nomb);
          REST_writeXmlLine('tomadorDni': %char(peDocu.nrdo) );
          REST_writeXmlLine('tomadorCuit': %trim(peDocu.cuit) );
          REST_writeXmlLine('tomadorIva': %char(asciva));
          REST_writeXmlLine('tomadorDomicilio': peDomi.domi );
          REST_writeXmlLine('tomadorCodigoPostal':%char(peDomi.copo));
          REST_writeXmlLine('tomadorLocalidad': %trim(loloca) );
          REST_writeXmlLine('tomadorProvincia': %trim(loproc) );
          REST_writeXmlLine('tomadorPais':%char(peNaci.cnac) );
          REST_writeXmlLine('moneda': c1mone);
          REST_writeXmlLine('formaDePago': %char(c1cfpg));
          REST_writeXmlLine('vigenciaDesde': %trim(vigd));
          REST_writeXmlLine('vigenciaHasta': %trim(vigh));
          REST_writeXmlLine('premio': %trim(prem));

          APIPO1( c1empr: c1sucu: c1arcd: c1spol: c1sspo);
          APIPO2( c1empr: c1sucu: w0nivt: w0nivc: c1arcd: c1spol: c1sspo);

          REST_writeXmlLine('Operacion' : '*END');

       endif;

       REST_end();

       return;

      /end-free

