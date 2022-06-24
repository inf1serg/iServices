     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * APIPOL: Apis                                                 *
      *         Lista de pólizas por intermediario                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *26-May-2017            *
      * ------------------------------------------------------------ *
      * SGF 07/12/2018: Loguear.                                     *
      * JSN 29/04/2019 - Se agrega inicialización en las estructuras *
      *                  del DAF.                                    *
      * JSN 16/09/2019 - Se agrega parametros para la llamada APIPO2.*
      * LRG 29/05/2020 - Se agrega parametro para validar cuit/nivc  *
      *                                                              *
      * ************************************************************ *
     Fpahspo02  if   e           k disk
     Fpahec1    if   e           k disk
     Fgntloc    if   e           k disk
     Fsehase    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpdaf_h.rpgle'
      /copy './qcpybooks/svpint_h.rpgle'

      * ------------------------------------------------------------ *
      * Cuotas                                                       *
      * ------------------------------------------------------------ *
     D APIPO1          pr                  ExtPgm('APIPO1')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

      * ------------------------------------------------------------ *
      * Pólizas                                                      *
      * ------------------------------------------------------------ *
     D APIPO2          pr                  ExtPgm('APIPO2')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peArcd                        6  0 const
     D  peSpol                        9  0 const
     D  peSspo                        3  0 const

     D sleep           pr            10u 0 extproc('sleep')
     D   secs                        10u 0 value

      // Log de llamadas...
     D WSLOG           pr                  extpgm('WSLOG')
     D   MS                         512
     D   MSG           s            512

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D fdes            s             10a
     D fhas            s             10a
     D url             s           3000a   varying
     D rc              s              1n
     D rc2             s             10i 0
     D @fdes           s             10d
     D @fhas           s             10d
     D vigd            s             10a
     D vigh            s             10a
     D prem            s             30a
     D cuit            s             11a
     D valcuit         s              1a
     D @@cuit          s             11a

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

     D k1hspo          ds                  likerec(p1hspo:*key)
     D k1hec1          ds                  likerec(p1hec1:*key)

     D peFdes          s              8  0
     D peFhas          s              8  0
     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D wrepl           s          65535a

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  JobUser                      10a   overlay(PsDs:254)
     D  JobNbr                        6  0 overlay(PsDs:264)

      /free

       *inlr = *on;
        //Msg = PsDs.this;
        //WSLOG( Msg );
        //Msg = PsDs.JobName;
        //WSLOG( Msg );
        //Msg = PsDs.JobUser;
        //WSLOG( Msg );
        //Msg = %editc(PsDs.JobNbr:'X');
        //WSLOG( Msg  );
        //sleep(60);

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
       fdes = REST_getNextPart(url);
       fhas = REST_getNextPart(url);
       cuit = REST_getNextPart(url);
       valcuit = REST_getNextPart(url);

       monitor;
         @fdes = %date(fdes:*iso);
         peFdes = %dec(@fdes:*iso);
        on-error;
         peFdes = %dec(%date():*iso);
       endmon;

       monitor;
         @fhas = %date(fhas:*iso);
         peFhas = %dec(@fhas:*iso);
        on-error;
         peFhas = %dec(%date():*iso);
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

       if valcuit = '1';
         //Valida cuit del intermediario...
         clear @@cuit;
         @@cuit = svpint_getCuit( empr
                                : sucu
                                : %dec(nivt:1:0)
                                : %dec(nivc:5:0));
         if cuit <> @@cuit;
           if cuit = *blanks;
              cuit = *all'0';
           endif;
           //error...
           %subst( wrepl : 1 : 13 ) = %subst( cuit : 1  : 2 ) + '-' +
                                      %subst( cuit : 3  : 8 ) + '-' +
                                      %subst( cuit : 11 : 1 );

           %subst( wrepl : 14 : 5 ) = nivc;
           %subst( wrepl : 19 : 40) = *blanks;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'API0001'
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
       endif;

       // --------------------------------------------------
       // Si hay mas de 7 días entre desde y hasta, ajusto
       // la diferencia a 7 días. Esto es por performance,
       // más de 7 días se va a poner ultra pesado
       // --------------------------------------------------
       d = %diff(@fhas:@fdes:*d);
       if d > 7;
          z = d - 7;
          @fhas -= %days(z);
          peFhas = %dec(@fhas:*iso);
       endif;


       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nivt:1:0);
       peBase.peNiv1 = %dec(nivc:5:0);
       COWLOG_logCon( psds.this : peBase );

       REST_writeHeader();
       REST_writeEncoding();

       REST_writeXmlLine('Operaciones' : '*BEG');

       k1hspo.poempr = empr;
       k1hspo.posucu = sucu;
       k1hspo.ponivt = %dec(nivt:1:0);
       k1hspo.ponivc = %dec(nivc:5:0);
       k1hspo.pofemi = peFdes;
       setll %kds(k1hspo:5) pahspo02;
       reade %kds(k1hspo:4) pahspo02;
       dow not %eof;
           if pofemi <= peFhas;
              k1hec1.c1empr = poempr;
              k1hec1.c1sucu = posucu;
              k1hec1.c1arcd = poarcd;
              k1hec1.c1spol = pospol;
              k1hec1.c1sspo = posspo;
              chain %kds(k1hec1) pahec1;
              if %found;
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
                REST_writeXmlLine('articulo'    : %char(poarcd) );
                REST_writeXmlLine('superPoliza' : %char(pospol) );
                REST_writeXmlLine('suplementoSuperPoliza' : %char(posspo) );
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

                APIPO1( poempr: posucu: poarcd: pospol: posspo);
                APIPO2( poempr: posucu: ponivt : ponivc :poarcd:
                        pospol: posspo);

                REST_writeXmlLine('Operacion' : '*END');
              endif;
           endif;
        reade %kds(k1hspo:4) pahspo02;
       enddo;

       REST_writeXmlLine('Operaciones' : '*END');

       REST_end();

       return;

      /end-free

