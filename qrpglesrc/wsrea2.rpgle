     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSREA2: QUOM Versión 2                                       *
      *         Emitir endoso de aumento de suma WEB.                *
      * ------------------------------------------------------------ *
      * Valeria Marquez                      *14-Mar-2022            *
      * ------------------------------------------------------------ *
      * ************************************************************ *
     Fpaheac01  uf   e           k disk

      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpriv_h.rpgle'
      /copy './qcpybooks/svppol_h.rpgle'
      /copy './qcpybooks/cowrgv_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'
      /copy './qcpybooks/getsysv_h.rpgle'
      /copy './qcpybooks/prwbien_h.rpgle'

     D PRWASE8         pr                  ExtPgm('PRWASE8')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peAsen                       7  0   const
     D   peNomb                      40a     const
     D   peDomi                            likeds(prwaseDomi_t) const
     D   peDocu                            likeds(prwaseDocu_t) const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peTiso                       2  0   const
     D   peNaci                            likeds(prwaseNaco_t) const
     D   peCprf                       3  0   const
     D   peSexo                       1  0   const
     D   peEsci                       1  0   const
     D   peRaae                       3  0   const
     D   peMail                            likeds(prwaseEmail_t) const
     D   peAgpe                       1a   const
     D   peTarc                            likeds(prwaseTarc_t) const
     D   peNcbu                      22  0   const
     D   peCbus                      22  0   const
     D   peRuta                      16  0   const
     D   peCiva                       2  0   const
     D   peInsc                            likeds(prwaseInsc_t) const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D  COWGRA1        pr                  ExtPgm('COWGRA1')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peMone                       2      const
     D   peTiou                       1  0   const
     D   peStou                       2  0   const
     D   peStos                       2  0   const
     D   peSpo1                       7  0   const
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND4         pr                  ExtPgm('PRWSND4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peNuse                      50    const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     DPAR310X3         pr                  extpgm('PAR310X3')
     D                                1a   const
     D                                4  0
     D                                2  0
     D                                2  0

     D PRWBIEN16       pr                  ExtPgm('PRWBIEN16')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peNrdm                       5  0 const
     D   peInsp                            const likeds(prwbienInsp_t)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D uri             s            512a
     D url             s           3000a   varying
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D arcd            s              6a
     D spol            s              9a
     D rama            s              2a
     D arse            s              3a
     D oper            s              7a
     D poco            s              4a

     D rc              s              1n
     D endoso          s               n
     D peEndo          s              7  0
     D @@Sspo          s              3  0
     D @@Suop          s              3  0

     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D wrepl           s          65535a
     D AS400Sys        s             10a

     D peEmpr          s              1
     D peSucu          s              2
     D peNivt          s              1  0
     D peNivc          s              5  0
     D peNit1          s              1  0
     D peNiv1          s              5  0
     D peArcd          s              6  0
     D peSpol          s              9  0
     D peSpo1          s              9  0
     D peNctw          s              7  0
     D peRama          s              2  0
     D peArse          s              3  0
     D peOper          s              7  0
     D pePoco          s              4  0
     D pePoli          s              7  0
     D peMone          s              2
     D peTiou          s              1  0 inz(3)
     D peStou          s              2  0 inz(1)
     D peStos          s              2  0 inz(5)
     D @@user          s             50
     D peSspo          s              3  0
     D peSuop          s              3  0
     D peSoln          s              7  0
     D @@msgID         s              7
     D pesaco          s             15  2
     D totsac          s             15  2
     D peRdes          s             30a
     D peNrdm          s              5  0
     D peInsp          ds                  likeds(prwbienInsp_t)


     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D peVsys          s            512a
     D DsNomb          ds                  likeDs(dsNomb_t)
     D DsDomi          ds                  likeDs(dsDomi_t)
     D DsDocu          ds                  likeDs(dsDocu_t)
     D DsCont          ds                  likeDs(dsCont_t)
     D DsNaci          ds                  likeDs(dsNaci_t)
     D DsMarc          ds                  likeDs(dsMarc_t)
     D DsCbuS          ds                  likeDs(dsCbuS_t)
     D DsDape          ds                  likeDs(dsDape_t)
     D DsClav          ds                  likeDs(dsClav_t)
     D DsText          s             79    dim(999)
     D DsTextC         s             10i 0
     D DsProv          ds                  likeDs(dsProI_t) dim(999)
     D DsProvC         s             10i 0
     D DsMail          ds                  likeds(Mailaddr_t) dim(100)
     D DsMailC         s             10i 0

      * Parametros PRWASE
     D DsDomiPRW       ds                  likeds(prwaseDomi_t)
     D DsDocuPRW       ds                  likeds(prwaseDocu_t)
     D DsNtel          ds                  likeds(prwaseTele_t)
     D DsNaciPRW       ds                  likeds(prwaseNaco_t)
     D DsMailPRW       ds                  likeds(prwaseEmail_t)
     D DsTarc          ds                  likeds(prwaseTarc_t)
     D @@Ncbu          s             22  0
     D @@Cbus          s             22  0
     D DsInsc          ds                  likeds(prwaseInsc_t)
     D
     D @@DsR0          ds                  likeds( dsPaher0_t )
     D
     D @@DsR2          ds                  likeds( dsPaher2_t ) dim( 999 )
     D @@DsR2C         s             10i 0
     D
     D @@DsR6          ds                  likeds( dsPaher6_t ) dim( 999 )
     D @@DsR6C         s             10i 0
     D
     D @@DsC1          ds                  likeds( dsPaheC1_t ) dim( 999 )
     D @@DsC1C         s             10i 0
     D
     D @@DsD0          ds                  likeds( dsPahed0_t ) dim(999)
     D @@DsD0C         s             10i 0
     D
     D @@DsC3          ds                  likeds( dsPahec3V2_t )
     D @@DsAs          ds                  likeds( DsAsegurado_t )
     D @@DsW0          ds                  likeds( dsctw000_t )
     D @@DsG3          ds                  likeds( dsctweg3_t )
     D @1Ds01          ds                  likeds( dsCtw001_t )
     D @1Ds1C          ds                  likeds( dsCtw001c_t )

     D @@DsWr2         ds                  likeds( dsCtwer2_t )

     D @@Cuit          s             11  0
     D @@Cuii          s             11
     D @@CbuTxt        s             22
     D @@Tipe          s              1
     D @@Fvtc          s              6  0
     D @@Fhas          s              8  0
     D @@Femi          s              8  0
     D @@Ffta          s              4  0
     D @@Fftm          s              2  0
     D @x              s             10i 0
     D @y              s             10i 0
     D p@Fema          s              4  0
     D p@Femm          s              2  0
     D p@Femd          s              2  0
     D peCest          s              1  0 inz(1)
     D peCses          s              2  0 inz(9)

     D k1heac          ds                  likerec(p1heac:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

     D sleep           pr            10u 0 ExtProc('sleep')
     D  secs                         10u 0 value


      /free

       *inlr = *on;

       separa = *all'-';

       AS400Sys = rtvSysName();

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
       arcd = REST_getNextPart(url);
       spol = REST_getNextPart(url);
       rama = REST_getNextPart(url);
       arse = REST_getNextPart(url);
       oper = REST_getNextPart(url);
       poco = REST_getNextPart(url);

      // Inicialemnte se loguea inicio de endoso con el
      // nro de arcd y spol en 0 para obtener todos
      // datos de entrada en caso de que esten erroneos
      // COPIO URL para revisar>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      // http://softdesa:8050/wsrest/dsplgspol/?X1ARCD=0&X1SPOL=0

        Data = CRLF + CRLF
            + '&nbsp<b>WSREA2 </b>'
            + '<b>Endoso de Aumento de Suma (Request)</b>' + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspURL   : '      + uri                         + CRLF
            + '&nbsp&nbspPEEMPR: '      + empr                        + CRLF
            + '&nbsp&nbspPESUCU: '      + sucu                        + CRLF
            + '&nbsp&nbspPENIVT: '      + nivt                        + CRLF
            + '&nbsp&nbspPENIVC: '      + nivc                        + CRLF
            + '&nbsp&nbspPENIT1: '      + nit1                        + CRLF
            + '&nbsp&nbspPENIV1: '      + niv1                        + CRLF
            + '&nbsp&nbspPEARCD: '      + arcd                        + CRLF
            + '&nbsp&nbspPESPOL: '      + spol                        + CRLF
            + '&nbsp&nbspPERAMA: '      + rama                        + CRLF
            + '&nbsp&nbspPEARSE: '      + arse                        + CRLF
            + '&nbsp&nbspPEOPER: '      + oper                        + CRLF
            + '&nbsp&nbspPEPOCO: '      + poco                        + CRLF;
        COWLOG_spolog( peArcd : peSpol : Data );

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
          exsr WSREA2setError;
          REST_end();
          SVPREST_end();
          close *all;
          return;
       endif;

       peEmpr = empr;
       peSucu = sucu;

       monitor;
         peNivt = %int(nivt);
       on-error;
         clear peNivt;
       endmon;

       monitor;
         peNivc = %int(nivc);
       on-error;
         clear peNivc;
       endmon;

       monitor;
         peNiv1 = %int(niv1);
       on-error;
         clear peNiv1;
       endmon;

       monitor;
         peNit1 = %int(nit1);
       on-error;
         clear peNit1;
       endmon;

       monitor;
         peArcd = %int(arcd);
       on-error;
         clear peArcd;
       endmon;

       monitor;
         peSpol = %int(spol);
       on-error;
         clear peSpol;
       endmon;

       monitor;
         peRama = %int(rama);
       on-error;
         clear peRama;
       endmon;

       monitor;
         peArse = %int(arse);
       on-error;
         clear peArse;
       endmon;

       monitor;
         peOper = %int(oper);
       on-error;
         clear peOper;
       endmon;

       monitor;
         pePoco = %int(poco);
       on-error;
         clear pePoco;
       endmon;

      // Segunda etapa del logueo, ya con informacion completa

       Data = CRLF
           + '&nbsp<b>WSREA2 </b>'
           + '<b>Endoso de Aumento de Suma (Request)</b>' + CRLF
           + '&nbspFecha/Hora: '
           + %trim(%char(%date():*iso)) + ' '
           + %trim(%char(%time():*iso))                    + CRLF
           + '&nbsp&nbspPEEMPR: '      + empr                        + CRLF
           + '&nbsp&nbspPESUCU: '      + sucu                        + CRLF
           + '&nbsp&nbspPENIVT: '      + nivt                        + CRLF
           + '&nbsp&nbspPENIVC: '      + nivc                        + CRLF
           + '&nbsp&nbspPENIT1: '      + nit1                        + CRLF
           + '&nbsp&nbspPENIV1: '      + niv1                        + CRLF
           + '&nbsp&nbspPEARCD: '      + arcd                        + CRLF
           + '&nbsp&nbspPESPOL: '      + spol                        + CRLF
           + '&nbsp&nbspPERAMA: '      + rama                        + CRLF
           + '&nbsp&nbspPEARSE: '      + arse                        + CRLF
           + '&nbsp&nbspPEOPER: '      + oper                        + CRLF
           + '&nbsp&nbspPEPOCO: '      + poco + CRLF;
       COWLOG_spolog( peArcd : peSpol : Data );

       pePoli   = SPVSPO_getPoliza( peEmpr
                                  : peSucu
                                  : peArcd
                                  : peSpol );

       peBase.peEmpr = peEmpr;
       peBase.peSucu = peSucu;
       peBase.peNivt = peNivt;
       peBase.peNivc = peNivc;
       peBase.peNit1 = peNit1;
       peBase.peNiv1 = peNiv1;

       k1heac.acempr = peEmpr;
       k1heac.acsucu = peSucu;
       k1heac.acnivt = peNivt;
       k1heac.acnivc = peNivc;
       k1heac.acarcd = peArcd;
       k1heac.acspol = peSpol;
       k1heac.acrama = peRama;
       k1heac.acarse = peArse;
       k1heac.acoper = peOper;
       k1heac.acpoco = pePoco;
       chain %kds( k1heac : 10 ) paheac01;
       if not %found( paheac01 );

          %subst(wrepl:1:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'EAS0001'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();

          Data = CRLF
               + '<b>&nbspbuscaPaheac01 (Request)</b>'  + CRLF;
          COWLOG_spolog( peArcd : peSpol : Data );

          Data = CRLF
             + '&nbsp&nbspFecha/Hora: '
             + %trim(%char(%date():*iso)) + ' '
             + %trim(%char(%time():*iso))               + CRLF
             + '&nbsp&nbspPEBASE'                                 + CRLF
             + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr         + CRLF
             + '&nbsp&nbsp&nbsp;PESUCU: ' + peBase.peSucu         + CRLF
             + '&nbsp&nbsp&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
             + '&nbsp&nbspPEBASE'                                 + CRLF
             + '&nbsp&nbspPEARCD: '  + %editc(peArcd:'X')         + CRLF
             + '&nbsp&nbspPESPOL: '  + %editc(peSpol:'X')         + CRLF
             + '&nbsp&nbspPERAMA: '  + %editc(peRama:'X')         + CRLF
             + '&nbsp&nbspPEARSE: '  + %editc(peArse:'X')         + CRLF
             + '&nbsp&nbspPEOPER: '  + %editc(peOper:'X')         + CRLF
             + '&nbsp&nbspPEPOCO: '  + %editc(pePoco:'X')         + CRLF;

          COWLOG_spolog( peArcd : peSpol : Data );
          Data = CRLF
               + '<b>&nbspbuscaPaheac01 (Reponse)</b> :Error' + CRLF;
          COWLOG_spolog( peArcd : peSpol : Data );
          exsr WSREA2setError;
          return;
       endif;

       clear peMsgs;
       clear peErro;

       if not COWVEH_chkEndoso( peBase
                              : peArcd
                              : peSpol
                              : peRama
                              : peArse
                              : peOper
                              : pePoli
                              : @@user
                              : peTiou
                              : peStou
                              : peStos
                              : peErro
                              : peMsgs );

         REST_writeHeader( 400
                         : *omit
                         : *omit
                         : peMsgs.peMsid
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );
         REST_end();
         SVPREST_end();

         Data = CRLF
              + '<b>&nbspCOWVEH_chkEndoso (Request)</b>'  + CRLF;
         COWLOG_spolog( peArcd : peSpol : Data );

         Data = CRLF
            + '&nbsp&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + '&nbsp&nbspPEBASE'                                 + CRLF
            + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr         + CRLF
            + '&nbsp&nbsp&nbsp;PESUCU: ' + peBase.peSucu         + CRLF
            + '&nbsp&nbsp&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + '&nbsp&nbspPEBASE'                                 + CRLF
            + '&nbsp&nbspPEARCD: '  + %editc(peArcd:'X')         + CRLF
            + '&nbsp&nbspPESPOL: '  + %editc(peSpol:'X')         + CRLF
            + '&nbsp&nbspPERAMA: '  + %editc(peRama:'X')         + CRLF
            + '&nbsp&nbspPEARSE: '  + %editc(peArse:'X')         + CRLF
            + '&nbsp&nbspPEOPER: '  + %editc(peOper:'X')         + CRLF
            + '&nbsp&nbspPEPOLI: '  + %editc(pePoli:'X')         + CRLF
            + '&nbsp&nbspPEUSER: '  + @@user                     + CRLF
            + '&nbsp&nbspPETIOU: '  + %editc(peTiou:'X')         + CRLF
            + '&nbsp&nbspPESTOU: '  + %editc(peStou:'X')         + CRLF
            + '&nbsp&nbspPESTOS: '  + %editc(peStos:'X')         + CRLF;

         COWLOG_spolog( peArcd : peSpol : Data );

         Data = CRLF
              + '<b>&nbspCOWVEH_chkEndoso (Reponse)</b> :Error' + CRLF;
         COWLOG_spolog( peArcd : peSpol : Data );
         exsr WSREA2setError;

         return;

       endif;


       if not SVPRIV_getUltimoEstadoComponente( peEmpr
                                              : peSucu
                                              : peArcd
                                              : peSpol
                                              : peRama
                                              : peArse
                                              : peOper
                                              : pePoco
                                              : @@DsR0 );

          %subst(wrepl:1:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'EAS0002'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();

          Data = CRLF
               + '<b>&nbspSVPRIV_getUltimoEstadoComponente (Request) +
                  </b>'  + CRLF;
          COWLOG_spolog( peArcd : peSpol : Data );

          Data = CRLF
             + '&nbsp&nbspFecha/Hora: '
             + %trim(%char(%date():*iso)) + ' '
             + %trim(%char(%time():*iso))               + CRLF
             + '&nbsp&nbspPEBASE'                                 + CRLF
             + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr         + CRLF
             + '&nbsp&nbsp&nbsp;PESUCU: ' + peBase.peSucu         + CRLF
             + '&nbsp&nbsp&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
             + '&nbsp&nbspPEBASE'                                 + CRLF
             + '&nbsp&nbspPEARCD: '  + %editc(peArcd:'X')         + CRLF
             + '&nbsp&nbspPESPOL: '  + %editc(peSpol:'X')         + CRLF
             + '&nbsp&nbspPERAMA: '  + %editc(peRama:'X')         + CRLF
             + '&nbsp&nbspPEARSE: '  + %editc(peArse:'X')         + CRLF
             + '&nbsp&nbspPEPOCO: '  + %editc(pePoco:'X')         + CRLF
             + '&nbsp&nbspPESSPO: '  + %editc(peSspo:'X')         + CRLF
             + '&nbsp&nbspPESUOP: '  + %editc(peSuop:'X')         + CRLF
             + '&nbsp&nbspPEOPER: '  + %editc(peOper:'X')         + CRLF;

          COWLOG_spolog( peArcd : peSpol : Data );

          Data = CRLF
               + '<b>&nbspSVPRIV_getUltimoEstadoComponente (Reponse) +
                  </b> :Error' + CRLF;
          COWLOG_spolog( peArcd : peSpol : Data );
          exsr WSREA2setError;

          return;

        else;
          peSspo = @@DsR0.r0sspo;
          peSuop = @@DsR0.r0suop;
       endif;

       if acsspo <> peSspo;

          %subst(wrepl:1:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'EAS0002'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();

          Data =  CRLF
            + '<b>&nbspdiferenteSuplemento (Reponse)</b> :Error' + CRLF
            + '&nbspUltimo suplemento de póliza ' +  %editc(peSspo:'X')
            + CRLF
            + '&nbspSuplemento a endosar      : ' +  %editc(acsspo:'X')
            + CRLF;
          COWLOG_spolog( peArcd : peSpol : Data );
          exsr WSREA2setError;

          return;

       endif;

       if acsuop <> peSuop;

          %subst(wrepl:1:7) = %trim(%char(pePoli));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'EAS0002'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );

          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();

          Data = CRLF
           + '<b>&nbspdiferenteSuplementoOper (Reponse)</b> :Error'
           + CRLF
           + '&nbspUltimo suplementoOper de póliza :'
           +  %editc(peSuop:'X') + CRLF
           + '&nbspSuplementoOper a endosar        : '
           +  %editc(acsuop:'X') + CRLF;

          COWLOG_spolog( peArcd : peSpol : Data );
          exsr WSREA2setError;

          return;

       endif;

       exsr ObtenerDatos;
       exsr GnrCotizacion;

       data = separa;
       COWLOG_spolog( peArcd : peSpol : Data );

       return;

      /end-free

       //* ---------------------------------------------------------- *
       //* Obtener datos                                              *
       //* ---------------------------------------------------------- *
       begsr ObtenerDatos;

         exsr BorraDS;

         PAR310X3( peBase.peEmpr : p@Fema : p@Femm : p@Femd);
         @@Femi = (p@Fema * 10000) + (p@Femm * 100) + p@Femd;

         if SPVSPO_getCabeceraSuplemento( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peSspo
                                        : @@DsC1
                                        : @@DsC1C );

            peMone = @@DsC1(@@DsC1C).c1Mone;

            select;
              when @@DsC1(@@DsC1C).c1Cfpg = 1;
                clear @@Ffta;
                clear @@Fftm;
                clear @@Fvtc;

                if SPVTCR_fechaVencimientoTcr( @@DsC1(@@DsC1C).c1Asen
                                             : @@DsC1(@@DsC1C).c1Ctcu
                                             : @@DsC1(@@DsC1C).c1Nrtc
                                             : @@Ffta
                                             : @@Fftm                 );
                  @@Fvtc = ( @@Ffta * 100 ) + @@Fftm;
                endif;

              when @@DsC1(@@DsC1C).c1Cfpg = 2 or @@DsC1(@@DsC1C).c1Cfpg = 3;
                clear @@Cbus;
                clear @@Ncbu;
                @@CbuTxt = *zeros;
                evalr @@CbuTxt = %trim(@@CbuTxt)
                      + %trim(SPVCBU_getCbuEntero( @@DsC1(@@DsC1C).c1Ivbc
                                                 : @@DsC1(@@DsC1C).c1Ivsu
                                                 : @@DsC1(@@DsC1C).c1Tcta
                                                 : @@DsC1(@@DsC1C).c1Ncta ));

                @@Ncbu = %dec(@@CbuTxt:22:0);
            endsl;

            @@Fhas = ( @@DsC1(@@DsC1C).c1Fvoa * 10000)
                   + ( @@DsC1(@@DsC1C).c1Fvom * 100)
                   +   @@DsC1(@@DsC1C).c1Fvod;

            if SPVSPO_getPlanDePagoV2( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : *omit
                                     : @@DsC3 );

              if SVPDAF_getDatoFiliatorio( @@DsC1(@@DsC1C).c1Asen
                                         : DsNomb
                                         : DsDomi
                                         : DsDocu
                                         : DsCont
                                         : DsNaci
                                         : DsMarc
                                         : DsCbuS
                                         : DsDape
                                         : DsClav
                                         : DsText
                                         : DsTextC
                                         : DsProv
                                         : DsProvC
                                         : DsMail
                                         : DsMailC                );

                clear @@Cuit;
                if %trim(DsDocu.Cuit) <> *blanks;
                  monitor;
                    @@Cuit = %dec(%trim(DsDocu.Cuit):11:0);
                  on-error;
                    clear @@Cuit;
                  endmon;
                endif;

                clear @@Cuii;
                select;
                when DsDocu.Cuil > *zeros;
                  @@Cuii = %editc(DsDocu.Cuil:'X');
                when @@Cuit > *zeros;
                  @@Cuii = %editc(@@Cuit:'X');
                endsl;

                clear @@Tipe;
                select;
                 when DsDocu.Tiso = 98;
                      @@Tipe = 'F';
                 when DsDocu.Tiso = 80 or DsDocu.Tiso = 81;
                      @@Tipe = 'C';
                 other;
                      @@Tipe = 'J';
                endsl;

                if SVPASE_getAsegurado( @@DsC1(@@DsC1C).c1Asen
                                      : @@DsAs                 );
                endif;
              endif;
            endif;
         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* BorraDS: Limpia todas las DS para obtener datos            *
       //* ---------------------------------------------------------- *
       begsr BorraDs;

         clear DsNomb;
         clear DsDomi;
         clear DsDocu;
         clear DsCont;
         clear DsNaci;
         clear DsMarc;
         clear DsCbuS;
         clear DsDape;
         clear DsClav;
         clear DsText;
         clear DsTextC;
         clear DsProv;
         clear DsProvC;
         clear DsMail;
         clear DsMailC;
         clear DsDomiPrw;
         clear DsDocuPrw;
         clear DsNtel;
         clear DsNaciPrw;
         clear DsMailPrw;
         clear DsMailPrw;
         clear DsTarc;
         clear DsCbus;
         clear DsInsc;
         clear @@DsC1;
         clear @@DsC1C;
         clear @@DsC3;
         clear @@DsAs;
         clear @@DsG3;
         clear @@DsW0;
         clear @1Ds01;
         clear @1Ds1c;
         clear peInsp;

       endsr;

       //* ---------------------------------------------------------- *
       //* GnrCotizacion : Obtener Nro. de Cotización y Graba         *
       //* ---------------------------------------------------------- *
       begsr GnrCotizacion;

         clear peNctw;

         peTiou = 3;
         peStou = 1;
         peStos = 5;
         peSpo1 = peSpol;

         Data = CRLF + CRLF
            + '&nbsp<b>COWGRA1 </b>'
            + '<b>Obtener Nro. de Cotización (Request)</b>' + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspPEBASE'                                      + CRLF
            + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr              + CRLF
            + '&nbsp&nbsp&nbsp;PESUCU: ' + peBase.peSucu              + CRLF
            + '&nbsp&nbsp&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + '&nbsp&nbspPEBASE'                                      + CRLF
            + '&nbsp&nbspPEARCD: '       + %editc(peArcd:'X')         + CRLF
            + '&nbsp&nbspPEMONE: '       + peMone                     + CRLF
            + '&nbsp&nbspPETIOU: '       + %editc(peTiou:'X')         + CRLF
            + '&nbsp&nbspPESTOU: '       + %editc(peStou:'X')         + CRLF
            + '&nbsp&nbspPESTOS: '       + %editc(peStos:'X')         + CRLF
            + '&nbsp&nbspPESPO1: '       + %editc(peSpo1:'X');
         COWLOG_spolog( peArcd : peSpol : Data );

         COWGRA1( peBase
                : peArcd
                : peMone
                : peTiou
                : peStou
                : peStos
                : peSpo1
                : peNctw
                : peErro
                : peMsgs );

         if peErro <> *zeros;
           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           Data = CRLF + CRLF
                + '&nbsp<b>COWGRA1 (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA2setError;
           return;
         endif;

         Data = CRLF + CRLF
              + '&nbsp<b>COWGRA1 (Response)</b> : OK '       + CRLF
              + '&nbspFecha/Hora: '
              + %trim(%char(%date():*iso)) + ' '
              + %trim(%char(%time():*iso))                   + CRLF
              + '&nbspPENCTW: '       + %editc(peNctw:'X')   + CRLF
              + '&nbsp<a href='
              + '"http://'
              + %trim(AS400SyS)
              + ':8050/wsrest/dsplogwf/?X1NCTW='
              + %editc(peNctw:'X') +'/">'+ 'Ver Log de la Cotización</a>'
              + CRLF;
         COWLOG_spolog( peArcd : peSpol : Data );


         exsr GrabCtw000;
         exsr GrabCtw3y4;
         exsr GrabCtwer0;
         exsr GrabCtw001;
         exsr GrabCtwer2;
         exsr UpdCtwer0;
         exsr GrabCtwer6;
         exsr GrabCtwer4;
         exsr GrabCtweg3;

         peRdes = acRdes;
         peNrdm = acNrdm;

         PRWBIEN16( peBase
                  : peNctw
                  : peRama
                  : peArse
                  : pePoco
                  : peRdes
                  : peNrdm
                  : peInsp
                  : peErro
                  : peMsgs );

         ///Confirma Operacion
         clear peSoln;

         Data = CRLF + CRLF
             + '&nbsp<b>PRWSND4 </b>'
             + '<b>Obtener Nro. de Propuesta (Request)</b>' + CRLF
             + '&nbspFecha/Hora: '
             + %trim(%char(%date():*iso)) + ' '
             + %trim(%char(%time():*iso))                    + CRLF
             + '&nbsp&nbspPEBASE'                                      + CRLF
             + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr              + CRLF
             + '&nbsp&nbsp&nbsp;PESUCU: ' + peBase.peSucu              + CRLF
             + '&nbsp&nbsp&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
             + '&nbsp&nbsp&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
             + '&nbsp&nbspPEBASE'                                      + CRLF
             + '&nbsp&nbspPENCTW: '       + %editc(peNctw:'X')         + CRLF
             + '&nbsp&nbspPEFDES: '       + %editc(@@Femi:'X')         + CRLF
             + '&nbsp&nbspPEUSER: '       + @@User                     + CRLF
             + '&nbsp&nbspPEFHAS: '       + %editc(@@Fhas:'X')         + CRLF
             + '&nbsp&nbspPESOLN: '       + %editc(peSoln:'X');
         COWLOG_spolog( peArcd : peSpol : Data );

         PRWSND4( peBase
                : peNctw
                : @@Femi
                : @@User
                : @@Fhas
                : peSoln
                : peErro
                : peMsgs );

         if peErro <> *zeros;

           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           Data = CRLF + CRLF
                + '&nbsp<b>PRWSND4 (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA2setError;

           return;

         endif;

         //sleep(5);
         // Obtengo nro de Endoso
         //exsr obtEndoso;

         Data = CRLF + CRLF
              + '&nbsp<b>PRWSND4 (Response)</b> : OK '       + CRLF
              + '&nbspFecha/Hora: '
              + %trim(%char(%date():*iso)) + ' '
              + %trim(%char(%time():*iso))                   + CRLF
              + '&nbspPESOLN: '       + %editc(peSoln:'X')   + CRLF;
         COWLOG_spolog( peArcd : peSpol : Data );

        // Marca como enviado...
         acmar1 = 'E';
         update p1heac;

         // Retorna respuesta ok
         REST_writeHeader();
         REST_writeEncoding();
         REST_startArray( 'endosoAumentoSuma' );
         REST_startArray( 'datosEndoso' );
          REST_writeXmlLine( 'numeroCotizacion' : %trim(%char(peNctw)) );
          REST_writeXmlLine( 'numeroSolicitud'  : %trim(%char(peSoln)) );
       // REST_writeXmlLine( 'numeroEndoso'     : %trim(%char(peEndo)) );
         REST_endArray( 'datosEndoso');
         REST_endArray( 'endosoAumentoSuma' );

       endsr;

       //* ---------------------------------------------------------- *
       //* Obtengo nro de Endoso                                      *
       //* ---------------------------------------------------------- *
       //begsr obtEndoso;

         // Llamo con nuevo suplemento
       //@@Suop = peSuop + 1;
       //@@Sspo = peSspo + 1;
       //SVPPOL_getPoliza( peEmpr
       //                : peSucu
       //                : peRama
       //                : pePoli
       //                : @@Suop
       //                : peArcd
       //                : peSpol
       //                : @@Sspo
       //                : peArse
       //                : peOper
       //                : @@DsD0
       //                : @@DsD0C );
       //if @@DsD0C <> 0;
       //   peEndo = @@DsD0(1).d0endo;
       //else;
       //   peEndo = 0;
       //endif;
       //
       //endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTW000                                *
       //* ---------------------------------------------------------- *
       begsr GrabCtw000;

         if COWGRAI_getCtw000( peBase
                             : peNctw
                             : @@DsW0 );

           @@DsW0.w0Nomb = DsNomb.Nomb;
           @@DsW0.w0Fpro = @@Femi;
           @@DsW0.w0Ncbu = @@Ncbu;
           @@DsW0.w0Ctcu = @@DsC1(@@DsC1C).c1Ctcu;
           @@DsW0.w0Nrtc = @@DsC1(@@DsC1C).c1Nrtc;
           @@DsW0.w0Fvtc = @@Fvtc;
           @@DsW0.w0Asen = @@DsC1(@@DsC1C).c1Asen;
           @@DsW0.w0Civa = @@DsC1(@@DsC1C).c1Civa;
           @@DsW0.w0Copo = DsDomi.Copo;
           @@DsW0.w0Cops = DsDomi.Cops;
           @@DsW0.w0Cfpg = @@DsC1(@@DsC1C).c1Cfpg;
           @@DsW0.w0Nrpp = @@DsC3.c3Nrpp;
           @@DsW0.w0Vdes = @@Femi;
           @@DsW0.w0Vhas = @@Fhas;
           @@DsW0.w0Tipe = @@Tipe;
           if @@DsW0.w0Cuii = *blanks;
             @@DsW0.w0Cuii = @@Cuii;
           endif;

           if not COWGRAI_updCtw000( @@DsW0 );

              %subst(wrepl:1:10) = 'CTW000';
              %subst(wrepl:11:7) = %trim(%char(peNctw));
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0204'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );

              REST_writeHeader( 400
                              : *omit
                              : *omit
                              : peMsgs.peMsid
                              : peMsgs.peMsev
                              : peMsgs.peMsg1
                              : peMsgs.peMsg2 );
              REST_end();
              SVPREST_end();

              Data = CRLF + CRLF
              + '&nbsp<b>COWGRAI_updCtw000 </b>'
              + '<b>Actualiza CTW000 (Request)</b>' + CRLF
              + '&nbspFecha/Hora: '
              + %trim(%char(%date():*iso)) + ' '
              + %trim(%char(%time():*iso))                    + CRLF
              + '&nbsp&nbspPEBASE'                                      + CRLF
              + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr              + CRLF
              + '&nbsp&nbsp&nbsp;PESUCU: ' + peBase.peSucu              + CRLF
              + '&nbsp&nbsp&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
              + '&nbsp&nbsp&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
              + '&nbsp&nbsp&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
              + '&nbsp&nbsp&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
              + '&nbsp&nbspPEBASE'                                      + CRLF
              + '&nbsp&nbspPENCTW: '       + %editc(peNctw:'X')         + CRLF
              + '&nbsp&nbspPENOMB: '       + %trim(@@DsW0.w0Nomb)       + CRLF
              + '&nbsp&nbspPEFPRO: '       + %editc(@@DsW0.w0Fpro:'X' ) + CRLF
              + '&nbsp&nbspPENCBU: '       + %editc(@@DsW0.w0Ncbu:'X' ) + CRLF
              + '&nbsp&nbspPECTCU: '       + %editc(@@DsW0.w0Ctcu:'X' ) + CRLF
              + '&nbsp&nbspPENRTC: '       + %editc(@@DsW0.w0Nrtc:'X' ) + CRLF
              + '&nbsp&nbspPEFVTC: '       + %editc(@@DsW0.w0Fvtc:'X' ) + CRLF
              + '&nbsp&nbspPEASEN: '       + %editc(@@DsW0.w0Asen:'X' ) + CRLF
              + '&nbsp&nbspPECIVA: '       + %editc(@@DsW0.w0Civa:'X' ) + CRLF
              + '&nbsp&nbspPECOPO: '       + %editc(@@DsW0.w0Copo:'X' ) + CRLF
              + '&nbsp&nbspPECOPS: '       + %editc(@@DsW0.w0Cops:'X' ) + CRLF
              + '&nbsp&nbspPECFPG: '       + %editc(@@DsW0.w0Cfpg:'X' ) + CRLF
              + '&nbsp&nbspPENRPP: '       + %editc(@@DsW0.w0Nrpp:'X' ) + CRLF
              + '&nbsp&nbspPEVDES: '       + %editc(@@DsW0.w0Vdes:'X' ) + CRLF
              + '&nbsp&nbspPEVHAS: '       + %editc(@@DsW0.w0Vhas:'X' ) + CRLF
              + '&nbsp&nbspPETIPE: '       + %trim(@@DsW0.w0Tipe) + CRLF
              + '&nbsp&nbspPECUII: '       + %trim(@@DsW0.w0Cuii)      + CRLF;
              COWLOG_spolog( peArcd : peSpol : Data );

              Data = CRLF + CRLF
                   + '&nbsp<b>COWGRAI_updCtw000 (Reponse)</b> :Error';
              COWLOG_spolog( peArcd : peSpol : Data );
              exsr WSREA2setError;
              return;
           endif;

         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTW003 y CTW004                       *
       //* ---------------------------------------------------------- *
       begsr GrabCtw3y4;

         DsDomiPrw.Domi = DsDomi.Domi;
         DsDomiPrw.Copo = DsDomi.Copo;
         DsDomiPrw.Cops = DsDomi.Cops;

         DsDocuPrw.Tido = DsDocu.Tido;
         DsDocuPrw.Nrdo = DsDocu.Nrdo;
         DsDocuPrw.Cuil = DsDocu.Cuil;
         DsDocuPrw.Cuit = @@Cuit;

         DsNtel.Nte1 = DsCont.Tpa1;
         DsNtel.Nte2 = DsCont.Ttr1;
         DsNtel.Nte3 = DsCont.Tcel;
         DsNtel.Pweb = DsCont.Pweb;

         eval-corr DsNaciPrw = DsNaci;

         DsMailPrw.Ctce = DsMail(1).Tipo;
         DsMailPrw.Mail = DsMail(1).Mail;

         DsTarc.Ctcu = @@DsC1(@@DsC1C).c1Ctcu;
         DsTarc.Nrtc = @@DsC1(@@DsC1C).c1Nrtc;
         DsTarc.Ffta = @@Ffta;
         DsTarc.Fftm = @@Fftm;

         DsInsc.Fein = @@DsAs.asFein;
         DsInsc.Nrin = @@DsAs.asNrin;
         DsInsc.Feco = @@DsAs.asFeco;

         Data = CRLF + CRLF
              + '&nbsp<b>PRWASE8 </b>'
              + '<b>Inserta Asegurado Tomador (Request)</b>';
         COWLOG_spolog( peArcd : peSpol : Data );

         PRWASE8( peBase
                : peNctw
                : @@DsC1(@@DsC1C).c1Asen
                : DsNomb.Nomb
                : DsDomiPrw
                : DsDocuPrw
                : DsNtel
                : DsDocu.Tiso
                : DsNaciPrw
                : DsDape.Cprf
                : DsDape.Sexo
                : DsDape.Esci
                : DsDape.Raae
                : DsMailPrw
                : 'N'
                : DsTarc
                : @@Ncbu
                : @@Cbus
                : @@DsAs.asRuta
                : @@DsC1(@@DsC1C).c1Civa
                : DsInsc
                : peErro
                : peMsgs                 );

         if peErro <> *zeros;

           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();
           Data = CRLF + CRLF
                + '&nbsp<b>PRWASE8 (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA2setError;
           return;

         endif;

         Data = CRLF + CRLF
              + '&nbsp<b>PRWASE8 (Reponse)</b> :OK';
         COWLOG_spolog( peArcd : peSpol : Data );

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWER0 - Cabecera                     *
       //* ---------------------------------------------------------- *
       begsr GrabCtwer0;

        clear @@DsR0;

        if not SVPRIV_getUltimoEstadoComponente( peEmpr
                                               : peSucu
                                               : peArcd
                                               : peSpol
                                               : peRama
                                               : peArse
                                               : peOper
                                               : pePoco
                                               : @@DsR0 );

         %subst(wrepl:1:10) = 'PAHER0';
         %subst(wrepl:11:7) = %trim(%char(peNctw));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0204'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           REST_writeHeader( 400
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();

           Data = CRLF + CRLF

            + '&nbsp<b>SVPRIV_getUltimoEstadoComponente </b>'
            + '<b>Obtener Datos de PAHER0 (Request)</b>' + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspPEBASE'                                      + CRLF
            + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr              + CRLF
            + '&nbsp&nbsp&nbsp;PESUCU: ' + peBase.peSucu              + CRLF
            + '&nbsp&nbsp&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp&nbsp&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + '&nbsp&nbspPEBASE'                                      + CRLF
            + '&nbsp&nbspPEARCD: '       + %editc(peArcd:'X')         + CRLF
            + '&nbsp&nbspPESPOL: '       + %editc(peSpol:'X')         + CRLF
            + '&nbsp&nbspPERAMA: '       + %editc(peRama:'X')         + CRLF
            + '&nbsp&nbspPEARSE: '       + %editc(peArse:'X')         + CRLF
            + '&nbsp&nbspPEPOCO: '       + %editc(pePoco:'X')         + CRLF
            + '&nbsp&nbspPESSPO: '       + %editc(peSspo:'X')  + CRLF;
           COWLOG_spolog( peArcd : peSpol : Data );
           Data = CRLF + CRLF
                + '&nbsp<b>SVPRIV_getUltimoEstadoComponente (Reponse) +
                   </b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA2setError;
           return;

        endif;

        COWRGV_saveCabeceraRV( peBase
                             : peNctw
                             : peRama
                             : peArse
                             : pePoco
                             : acCopo
                             : acCops
                             : acxpro
                             : @@DsR0.r0cviv );


       endsr;
       //* ---------------------------------------------------------- *
       //* Graba información de CTW001 y CTW001C                      *
       //* ---------------------------------------------------------- *
       begsr GrabCtw001;

         exsr MoveDatos01;

         if COWGRAI_setCtw001( @1Ds01 );

            @1Ds1c.w1Empr = peEmpr;
            @1Ds1c.w1Sucu = peSucu;
            @1Ds1c.w1Nivt = peNivt;
            @1Ds1c.w1Nivc = peNivc;
            @1Ds1c.w1Nctw = peNctw;
            @1Ds1c.w1Rama = peRama;
            @1Ds1c.w1Xrea = acXrea;
            @1Ds1c.w1Read = acRead;
            @1Ds1c.w1Xopr = acXopr;
            @1Ds1c.w1Copr = acCopr;

            if not COWGRAI_setCtw001C( @1Ds1c );

               %subst(wrepl:1:10) = 'CTW001C';
               %subst(wrepl:11:7) = %trim(%char(peNctw));
               SVPWS_getMsgs( '*LIBL'
                            : 'WSVMSG'
                            : 'COW0204'
                            : peMsgs
                            : %trim(wrepl)
                            : %len(%trim(wrepl))  );

               REST_writeHeader( 400
                               : *omit
                               : *omit
                               : peMsgs.peMsid
                               : peMsgs.peMsev
                               : peMsgs.peMsg1
                               : peMsgs.peMsg2 );
               REST_end();
               SVPREST_end();

               Data = CRLF + CRLF
                 + '&nbsp<b>COWGRAI_setCtw001c </b>'
                 + '<b>Graba Datos en CTW001C (Request)</b>' + CRLF
                 + '&nbspFecha/Hora: '
                 + %trim(%char(%date():*iso)) + ' '
                 + %trim(%char(%time():*iso))                    + CRLF
                 + '&nbsp&nbspPEBASE'                                  + CRLF
                 + '&nbsp&nbsp&nbsp;PEEMPR:' + peBase.peEmpr             + CRLF
                 + '&nbsp&nbsp&nbsp;PESUCU:' + peBase.peSucu             + CRLF
                 + '&nbsp&nbsp&nbsp;PENIVT:' + %editc(peBase.peNivt:'X') + CRLF
                 + '&nbsp&nbsp&nbsp;PENIVC:' + %editc(peBase.peNivc:'X') + CRLF
                 + '&nbsp&nbsp&nbsp;PENIT1:' + %editc(peBase.peNit1:'X') + CRLF
                 + '&nbsp&nbsp&nbsp;PENIV1:' + %editc(peBase.peNiv1:'X') + CRLF
                 + '&nbsp&nbspPEBASE'                                    + CRLF
                 + '&nbsp&nbspPENCTW: '      + %editc(peNctw:'X')        + CRLF
                 + '&nbsp&nbspPERAMA: '      + %editc(peRama:'X')        + CRLF;
               COWLOG_spolog( peArcd : peSpol : Data );
               Data = CRLF + CRLF
                    + '&nbsp<b>COWGRAI_setCtw001C (Reponse)</b> :Error';
               COWLOG_spolog( peArcd : peSpol : Data );
               exsr WSREA2setError;
               return;
            endif;
         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWER2 - Coberturas                   *
       //* ---------------------------------------------------------- *
       begsr GrabCtwer2;

         if not SVPRIV_getCoberturas( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : peSspo
                                    : peRama
                                    : peArse
                                    : peOper
                                    : pePoco
                                    : peSuop
                                    : *omit
                                    : *omit
                                    : @@DsR2
                                    : @@DsR2C );

            %subst(wrepl:1:10) = 'PAHER2';
            %subst(wrepl:11:7) = %trim(%char(peNctw));
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0204'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : peMsgs.peMsid
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();

            Data = CRLF + CRLF
              + '&nbsp<b>SVPRIV_getCoberturas </b>'
              + '<b>Obtiene Datos de PAHER2 (Request)</b>' + CRLF
              + '&nbspFecha/Hora: '
              + %trim(%char(%date():*iso)) + ' '
              + %trim(%char(%time():*iso))                    + CRLF
              + '&nbsp&nbspPEBASE'                                  + CRLF
              + '&nbsp&nbsp&nbsp;PEEMPR:' + peBase.peEmpr             + CRLF
              + '&nbsp&nbsp&nbsp;PESUCU:' + peBase.peSucu             + CRLF
              + '&nbsp&nbsp&nbsp;PENIVT:' + %editc(peBase.peNivt:'X') + CRLF
              + '&nbsp&nbsp&nbsp;PENIVC:' + %editc(peBase.peNivc:'X') + CRLF
              + '&nbsp&nbsp&nbsp;PENIT1:' + %editc(peBase.peNit1:'X') + CRLF
              + '&nbsp&nbsp&nbsp;PENIV1:' + %editc(peBase.peNiv1:'X') + CRLF
              + '&nbsp&nbspPEBASE'                                    + CRLF
              + '&nbsp&nbspPENCTW: '      + %editc(peNctw:'X')        + CRLF
              + '&nbsp&nbspPERAMA: '      + %editc(peRama:'X')        + CRLF;
            COWLOG_spolog( peArcd : peSpol : Data );
            Data = CRLF + CRLF
                 + '&nbsp<b>SVPRIV_getCoberturas (Reponse)</b> :Error';
            COWLOG_spolog( peArcd : peSpol : Data );
            exsr WSREA2setError;
            return;

         endif;

         totsac = *zeros;

         for @x = 1 to @@DsR2C;

             endoso = *off;
             select;

                when @@DsR2(@x).r2riec = '002'
                 and @@DsR2(@x).r2xcob = 908;
                     pesaco = acsnca;        //Nueva Suma Ascensores
                     endoso = *on;

                when @@DsR2(@x).r2riec = '002'
                 and @@DsR2(@x).r2xcob = 909;
                     pesaco = acsncc;        //Nueva Suma Calderas
                     endoso = *on;

                other;
                     pesaco = @@DsR2(@x).r2saco;
             endsl;

             totsac = totsac + pesaco;

             COWRGV_saveCoberturasRv( peBase
                                    : peNctw
                                    : peRama
                                    : acxpro
                                    : peArse
                                    : pePoco
                                    : @@DsR2(@x).r2riec
                                    : @@DsR2(@x).r2xcob
                                    : pesaco );

             exsr ActualizaDatosWr2;
             SVPRIV_updCtwer2( @@DsWr2 );

         endfor;
       endsr;

       //* ---------------------------------------------------------- *
       //* Actualiza datos del archivo CTWER2                         *
       //* ---------------------------------------------------------- *
       begsr ActualizaDatosWr2;

         SVPRIV_getCtwer2( peEmpr
                         : peSucu
                         : peNivt
                         : peNivc
                         : peNctw
                         : peRama
                         : peArse
                         : pePoco
                         : @@DsR2(@x).r2riec
                         : @@DsR2(@x).r2xcob
                         : @@DsWR2 );

         if endoso;
            select;

               when @@DsR2(@x).r2riec = '002'
               and @@DsR2(@x).r2xcob = 908;

               @@DsWR2.r2ptco = acprra;        //Prima de Ascensores

               when @@DsR2(@x).r2riec = '002'
               and @@DsR2(@x).r2xcob = 909;

               @@DsWR2.r2ptco = acprrc;      //Prima de Calderas

            endsl;

         else;
            @@DsWR2.r2xpri = @@DsR2(@x).r2xpri;
            @@DsWR2.r2xpra = @@DsR2(@x).r2xpra;
            @@DsWR2.r2ptco = *zeros;
            @@DsWR2.r2ptca = *zeros;
         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Actualiza Importes de CTWER0                               *
       //* ---------------------------------------------------------- *
       begsr UpdCtwer0;

         COWRGV_UpdCabeceraRV( peBase
                             : peNctw
                             : peRama
                             : peArse
                             : pePoco );

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWER4 - Descuentos                   *
       //* ---------------------------------------------------------- *
       begsr GrabCtwer4;

         if not SVPDRC_setDesc( peBase
                              : peNctw
                              : peRama
                              : peArse
                              : pePoco
                              : acxpro );

            %subst(wrepl:1:10) = 'CTWER4';
            %subst(wrepl:11:7) = %trim(%char(peNctw));
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0204'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : peMsgs.peMsid
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();

            Data = CRLF + CRLF
            + '&nbsp<b>SVPDRC_setDesc</b>'
            + '<b>Guarda Descuentos  (Request)</b>' + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso)) + CRLF
            + '&nbsp&nbspPEBASE'         + CRLF
            + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr  +CRLF
            + '&nbsp&nbsp&nbsp;PESUCU:' + peBase.peSucu             + CRLF
            + '&nbsp&nbsp&nbsp;PENIVT:' + %editc(peBase.peNivt:'X') + CRLF
            + '&nbsp&nbsp&nbsp;PENIVC:' + %editc(peBase.peNivc:'X') + CRLF
            + '&nbsp&nbsp&nbsp;PENIT1:' + %editc(peBase.peNit1:'X') + CRLF
            + '&nbsp&nbsp&nbsp;PENIV1:' + %editc(peBase.peNiv1:'X') + CRLF
            + '&nbsp&nbspPEBASE'                                    + CRLF
            + '&nbsp&nbspPENCTW: '      + %editc(peNctw:'X')        + CRLF
            + '&nbsp&nbspPERAMA: '      + %editc(peRama:'X')        + CRLF;
            COWLOG_spolog( peArcd : peSpol : Data );
            Data = CRLF + CRLF
                 + '&nbsp<b>SVPDRC_setDesc (Reponse)</b> :Error';
            COWLOG_spolog( peArcd : peSpol : Data );
            exsr WSREA2setError;
            return;

         endif;

       endsr;
       //* ---------------------------------------------------------- *
       //* Graba información de CTWER6 - Caracteristicas              *
       //* ---------------------------------------------------------- *
       begsr GrabCtwer6;

         if not SVPRIV_getCaracteristicas( peEmpr
                                         : peSucu
                                         : peArcd
                                         : peSpol
                                         : peSspo
                                         : peRama
                                         : peArse
                                         : peOper
                                         : pePoco
                                         : peSuop
                                         : *omit
                                         : @@DsR6
                                         : @@DsR6C );

            %subst(wrepl:1:10) = 'PAHER6';
            %subst(wrepl:11:7) = %trim(%char(peNctw));
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0204'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : peMsgs.peMsid
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();

            Data = CRLF + CRLF
            + '&nbsp<b>SVPRIV_getCaracteristicas </b>'
            + '<b>Obtiene Caracteristicas (Request)</b>' + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso)) + CRLF
            + '&nbsp&nbspPEBASE'         + CRLF
            + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr  +CRLF
            + '&nbsp&nbsp&nbsp;PESUCU:' + peBase.peSucu             + CRLF
            + '&nbsp&nbsp&nbsp;PENIVT:' + %editc(peBase.peNivt:'X') + CRLF
            + '&nbsp&nbsp&nbsp;PENIVC:' + %editc(peBase.peNivc:'X') + CRLF
            + '&nbsp&nbsp&nbsp;PENIT1:' + %editc(peBase.peNit1:'X') + CRLF
            + '&nbsp&nbsp&nbsp;PENIV1:' + %editc(peBase.peNiv1:'X') + CRLF
            + '&nbsp&nbspPEBASE'                                    + CRLF
            + '&nbsp&nbspPENCTW: '      + %editc(peNctw:'X')        + CRLF
            + '&nbsp&nbspPERAMA: '      + %editc(peRama:'X')        + CRLF;
            COWLOG_spolog( peArcd : peSpol : Data );
            Data = CRLF + CRLF
                 + '&nbsp<b>SVPRIV_getCaracteristicas (Reponse)</b> :Error';
            COWLOG_spolog( peArcd : peSpol : Data );
            exsr WSREA2setError;
            return;

         endif;

         for @y = 1 to @@DsR6C;

             COWRGV_SaveCaracteristicas( peBase
                                       : peNctw
                                       : peRama
                                       : peArse
                                       : pePoco
                                       : @@DsR6(@y).r6ccba
                                       : @@DsR6(@y).r6ma01
                                       : @@DsR6(@y).r6ma02 );
         endfor;

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWEG3                                *
       //* ---------------------------------------------------------- *
       begsr GrabCtweg3;

         exsr MoveDatosG3;

         if not COWGRAI_setCtweg3( @@DsG3 );

            %subst(wrepl:1:10) = 'CTWEG3';
            %subst(wrepl:11:7) = %trim(%char(peNctw));
            SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'COW0204'
                         : peMsgs
                         : %trim(wrepl)
                         : %len(%trim(wrepl))  );

            REST_writeHeader( 400
                            : *omit
                            : *omit
                            : peMsgs.peMsid
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();

            Data = CRLF + CRLF
              + '&nbsp<b>COWGRAI_setCtweg3 </b>'
              + '<b>Graba Datos en CTWEG3 (Request)</b>' + CRLF
              + '&nbspFecha/Hora: '
              + %trim(%char(%date():*iso)) + ' '
              + %trim(%char(%time():*iso))                    + CRLF
              + '&nbsp&nbspPEBASE'                                      + CRLF
              + '&nbsp&nbsp&nbsp;PEEMPR: ' + peBase.peEmpr              + CRLF
              + '&nbsp&nbsp&nbsp;PESUCU: ' + peBase.peSucu              + CRLF
              + '&nbsp&nbsp&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
              + '&nbsp&nbsp&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
              + '&nbsp&nbsp&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
              + '&nbsp&nbsp&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
              + '&nbsp&nbspPEBASE'                                      + CRLF
              + '&nbsp&nbspPENCTW: '       + %editc(peNctw:'X')         + CRLF
              + '&nbsp&nbspPERAMA: '       + %editc(peRama:'X')         + CRLF
              + '&nbsp&nbspPEARSE: '       + %editc(peArse:'X')         + CRLF
              + '&nbsp&nbspPERPRO: ' + %editc(@@DsG3.g3Rpro:'X') + CRLF;
            COWLOG_spolog( peArcd : peSpol : Data );

            Data = CRLF + CRLF
                 + '&nbsp<b>COWGRAI_setCtweg3 (Reponse)</b> :Error';
            COWLOG_spolog( peArcd : peSpol : Data );
            exsr WSREA2setError;
            return;
         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Cambia estado de la cotización                             *
       //* ---------------------------------------------------------- *
       begsr CambEstado;

         if peNctw <> *zeros;
           if not COWGRAI_updEstado( peBase
                                   : peNctw
                                   : peCest
                                   : peCses );
              return;
           endif;
         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Mueve datos a los campos del archivo CTWEG3                *
       //* ---------------------------------------------------------- *
       begsr MoveDatosG3;

         @@DsG3.g3Empr = peEmpr;
         @@DsG3.g3Sucu = peSucu;
         @@DsG3.g3Nivt = peNivt;
         @@DsG3.g3Nivc = peNivc;
         @@DsG3.g3Nctw = peNctw;
         @@DsG3.g3Rama = peRama;
         @@DsG3.g3Arse = peArse;
         @@DsG3.g3Rpro = acRpro;
         @@DsG3.g3Mone = peMone;
         @@DsG3.g3Come = acCome;

         @@DsG3.g3Suas = *zeros;
         @@DsG3.g3Suas = totsac;

         @@DsG3.g3Saca = *zeros;
         @@DsG3.g3Sacr = *zeros;

         @@DsG3.g3Sast = *zeros;
         @@DsG3.g3Sast = totsac;

         @@DsG3.g3Prim = acPrim;
         @@DsG3.g3Bpri = acBpri;
         @@DsG3.g3Refi = acRefi;
         @@DsG3.g3Read = acRead;
         @@DsG3.g3Dere = acDere;
         @@DsG3.g3Seri = acSeri;
         @@DsG3.g3Seem = acSeem;
         @@DsG3.g3Ipr6 = acIpr6;
         @@DsG3.g3Ipr7 = acIpr7;
         @@DsG3.g3Ipr8 = acIpr8;
         @@DsG3.g3Prem = acPrem;
         @@DsG3.g3Mar1 = '0';
         @@DsG3.g3Mar2 = '0';
         @@DsG3.g3Mar3 = '0';

         @@DsG3.g3Mar4 = '0';

         @@DsG3.g3Mar5 = '0';
         @@DsG3.g3Ipr1 = acIpr1;
         @@DsG3.g3Ipr3 = acIpr3;
         @@DsG3.g3Ipr4 = acIpr4;
         @@DsG3.g3Sefr = acSefr;
         @@DsG3.g3Sefe = acSefe;

       endsr;

       //* ---------------------------------------------------------- *
       //* Mueve datos a los campos del archivo CTW001                *
       //* ---------------------------------------------------------- *
       begsr MoveDatos01;

         @1Ds01.w1Empr = peEmpr;
         @1Ds01.w1Sucu = peSucu;
         @1Ds01.w1Nivt = peNivt;
         @1Ds01.w1Nivc = peNivc;
         @1Ds01.w1Nctw = peNctw;
         @1Ds01.w1Rama = peRama;
         @1Ds01.w1Dere = acDere;
         @1Ds01.w1Xref = acXref;
         @1Ds01.w1Refi = acRefi;
         @1Ds01.w1Seri = acSeri;
         @1Ds01.w1Seem = acSeem;
         @1Ds01.w1Pimi = acPimi;
         @1Ds01.w1Impi = acImpi;
         @1Ds01.w1Psso = acPsso;
         @1Ds01.w1Sers = acSers;
         @1Ds01.w1Pssn = acPssn;
         @1Ds01.w1Tssn = acTssn;
         @1Ds01.w1Pivi = acPivi;
         @1Ds01.w1Ipr1 = acIpr1;
         @1Ds01.w1Pivn = acPivn;
         @1Ds01.w1Ipr4 = acIpr4;
         @1Ds01.w1Pivr = acPivr;
         @1Ds01.w1Ipr3 = acIpr3;
         @1Ds01.w1Ipr6 = acIpr6;
         @1Ds01.w1Ipr7 = acIpr7;
         @1Ds01.w1Ipr8 = acIpr8;
         @1Ds01.w1Ipr9 = *zeros;
         @1Ds01.w1Ipr2 = acIpr2;
         @1Ds01.w1Ipr5 = acIpr5;
         @1Ds01.w1Prem = acPrem;
         @1Ds01.w1Vacc = acVacc;

       endsr;

       //* ---------------------------------------------------------- *
       //* Mueve datos de error                                       *
       //* ---------------------------------------------------------- *
       begsr WSREA2setError;
          exsr CambEstado;
          Data = '<br><br><b>WSREA2-Endoso Aumento de Suma Asegurada '
               + '(Response)</b> : Error' + CRLF
               + 'Fecha/Hora: '
               + %trim(%char(%date():*iso)) + ' '
               + %trim(%char(%time():*iso))                  + CRLF
               + 'PEERRO: ' +  %trim(%char(peErro))          + CRLF
               + 'PEMSGS'                                    + CRLF
               + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
               + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
               + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
               + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
               + 'PEMSGS' + CRLF;
          COWLOG_spolog( peArcd : peSpol : Data );
       endsr;

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'

