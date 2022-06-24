     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRPQ5: QUOM Versión 2                                       *
      *         Preliquidación - Listar Columnas                     *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *17-Jul-2017            *
      * ------------------------------------------------------------ *
      * SGF 09/05/18: Edición de decimales.                          *
      *                                                              *
      * ************************************************************ *
      * NWN - 17-06-21 : Agregado de Quincena Posterior              *
      * ************************************************************ *
     Fgntemp    if   e           k disk
     Fgntsuc    if   e           k disk
     Fsehni201  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/plqweb_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D nrpl            s              7a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D x               s             10i 0
     D dant            s             30a
     D qant            s             30a
     D qact            s             30a
     D qsig            s             30a
     D qpos            s             30a
     D sald            s             30a
     D @@cfpg          s              1  0

     D k1hni2          ds                  likerec(s1hni201:*key)

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D pePosi          ds                  likeds(keypliq_t)
     D pePreg          ds                  likeds(keypliq_t)
     D peUreg          ds                  likeds(keypliq_t)
     D peLdet          ds                  likeds(listpliq_t) dim(99)
     D peMore          s              1n
     D peLdetC         s             10i 0
     D peRoll          s              1a
     D peErro          s             10i 0
     D peNrpl          s              7  0

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

       nrpl = REST_getNextPart(url);

       monitor;
          peNrpl = %dec(nrpl:7:0);
        on-error;
          peNrpl = 0;
       endmon;

       clear peBase;
       clear peMsgs;
       clear pePosi;
       peErro = 0;

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);

       pePosi.nrpl = peNrpl;
       peRoll = 'I';

       REST_writeHeader();
       REST_writeEncoding();

       REST_startArray( 'preliquidacion' );

       dou peMore = *off;

           PLQWEB_listarPreliquidacion( peBase
                                      : 99
                                      : peRoll
                                      : 'OPERACUOTA'
                                      : pePosi
                                      : pePreg
                                      : peUreg
                                      : peLdet
                                      : peLdetC
                                      : peMore
                                      : peErro
                                      : peMsgs       );

           peRoll = 'F';
           pePosi = peUreg;

           for x = 1 to peLdetC;
               REST_startArray( 'linea' );
               dant = SVPREST_editImporte( peLdet(x).dant );
               qant = SVPREST_editImporte( peLdet(x).qant );
               qact = SVPREST_editImporte( peLdet(x).qact );
               qsig = SVPREST_editImporte( peLdet(x).qsig );
               qpos = SVPREST_editImporte( peLdet(x).qpos );
               sald = SVPREST_editImporte( peLdet(x).sald );
               REST_writeXmlLine( 'articulo' : %char(peLdet(x).arcd) );
               REST_writeXmlLine( 'superpoliza' : %char(peLdet(x).spol) );
               REST_writeXmlLine( 'suplementoSpol' : %char(peLdet(x).sspo) );
               REST_writeXmlLine( 'rama' : %char(peLdet(x).rama) );
               REST_writeXmlLine( 'arse' : %char(peLdet(x).arse) );
               REST_writeXmlLine( 'operacion' : %char(peLdet(x).oper) );
               REST_writeXmlLine( 'suplemento' : %char(peLdet(x).suop) );
               REST_writeXmlLine( 'poliza' : %char(peLdet(x).poli) );
               REST_writeXmlLine( 'deudaAnterior': dant);
               REST_writeXmlLine( 'quincenaAnterior': qant);
               REST_writeXmlLine( 'quincenaActual': qact);
               REST_writeXmlLine( 'quincenaSiguiente': qsig);
               REST_writeXmlLine( 'quincenaPosterior': qpos);
               REST_writeXmlLine( 'saldo': sald);
               REST_writeXmlLine( 'asegurado': peLdet(x).nomb);

               exsr $fdp;

               REST_endArray( 'linea' );
           endfor;

           if peMore = *off;
              leave;
           endif;

       enddo;

       REST_endArray( 'preliquidacion' );
       REST_end();
       close *all;

       return;

       begsr $fdp;

        @@cfpg = SPVSPO_getFormaDePago( peBase.peEmpr
                                      : peBase.peSucu
                                      : peLdet(x).arcd
                                      : peLdet(x).spol
                                      : *omit          );

        if @@cfpg <= 3 and @@cfpg > 0;
           REST_writeXmlLine( 'debitoAutomatico': 'S' );
         else;
           REST_writeXmlLine( 'debitoAutomatico': 'N' );
        endif;

       endsr;

