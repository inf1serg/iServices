     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSREA1: QUOM Versión 2                                       *
      *         Emitir endoso de aumento de suma WEB.                *
      * ------------------------------------------------------------ *
      * Luis Roberto Gomez                   *15-Abr-2020            *
      * ------------------------------------------------------------ *
      * SGF 29/09/2020: En VHVU se suman GNC y accesorios.           *
      * SPV 08/01/2022: Cambia  @@DsG3.g3Mar1 = asmar1               *
      *                 Por     @@DsG3.g3Mar1 = '0'                  *
      * SGF 27/01/2022: COPO y COPS al CTWET0 van desde PAHEAS       *
      * ************************************************************ *
     Fpaheas01  uf   e           k disk

      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/spvveh_h.rpgle'
      /copy './qcpybooks/cowveh_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/spvtcr_h.rpgle'
      /copy './qcpybooks/getsysv_h.rpgle'

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
     D @1Dst3          ds                  likeds( dsctwet3_t )
     D @@Dst3          ds                  likeds( dsPahet3_t ) dim( 999 )
     D @@Dst3C         s             10i 0
     D @@Dst1          ds                  likeds( dsPahet1_t ) dim( 999 )
     D @@Dst1C         s             10i 0
     D @@DsC0          ds                  likeds( dsPahec0_t )
     D @@DsC1          ds                  likeds( dsPaheC1_t ) dim( 999 )
     D @@DsC1C         s             10i 0
     D @1Dst4          ds                  likeds( dsctwet4_t )
     D @@Dst4          ds                  likeds( dsPahet4_t ) dim( 999 )
     D @@Dst4C         s             10i 0
     D @@Dst5          ds                  likeds( dsPahet5_t ) dim( 999 )
     D @@Dst5C         s             10i 0
     D @@DsC3          ds                  likeds( dsPahec3V2_t )
     D @@DsAs          ds                  likeds( DsAsegurado_t )
     D @@DsW0          ds                  likeds( dsctw000_t )
     D dsAcce          ds                  likeds( AccVeh_t ) dim(100)
     D @@DsG3          ds                  likeds( dsctweg3_t )
     D @@DsT0          ds                  likeds( dsPahet0_t )
     D @@DsT9          ds                  likeds( dsPahet9_t )
     D @@DsCtwet0      ds                  likeds( dsCtwet0_t )
     D @@DsCtwetC      ds                  likeds( dsCtwetC_t )
     D @@DsCtwet5      ds                  likeds( dsCtwet5_t )
     D @1Ds01          ds                  likeds( dsCtw001_t )
     D @1Ds1C          ds                  likeds( dsCtw001c_t )
     D @@Cuit          s             11  0
     D @@Cuii          s             11
     D @@CbuTxt        s             22
     D @@Tipe          s              1
     D @@Fvtc          s              6  0
     D @@Fdes          s              8  0
     D @@Fhas          s              8  0
     D @@Femi          s              8  0
     D @@Ffta          s              4  0
     D @@Fftm          s              2  0
     D x               s             10i 0
     D i               s             10i 0
     D p@Fema          s              4  0
     D p@Femm          s              2  0
     D p@Femd          s              2  0
     D peCest          s              1  0 inz(1)
     D peCses          s              2  0 inz(9)
     D @@ccbp          s              3  0

     D k1heas          ds                  likerec(p1heas:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

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
            + '&nbsp<b>WSREA1 </b>'
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
          exsr WSREA1setError;
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
           + '&nbsp<b>WSREA1 </b>'
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

       k1heas.asempr = peEmpr;
       k1heas.assucu = peSucu;
       k1heas.asnivt = peNivt;
       k1heas.asnivc = peNivc;
       k1heas.asarcd = peArcd;
       k1heas.asspol = peSpol;
       k1heas.asrama = peRama;
       k1heas.asarse = peArse;
       k1heas.asoper = peOper;
       k1heas.aspoco = pePoco;
       chain %kds( k1heas : 10 ) paheas01;
       if not %found( paheas01 );

         %subst(wrepl:1:7) = %trim(%char(pePoli));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'EAS0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         REST_writeHeader( 204
                         : *omit
                         : *omit
                         : peMsgs.peMsid
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );
         REST_end();
         SVPREST_end();

         Data = CRLF
              + '<b>&nbspbuscaPaheas01 (Request)</b>'  + CRLF;
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
              + '<b>&nbspbuscaPaheas01 (Reponse)</b> :Error' + CRLF;
         COWLOG_spolog( peArcd : peSpol : Data );
         exsr WSREA1setError;
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

         REST_writeHeader( 204
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
         exsr WSREA1setError;

         return;

       endif;

       if not SPVVEH_getUltimoSuplemento( peEmpr
                                        : peSucu
                                        : peArcd
                                        : peSpol
                                        : peRama
                                        : peArse
                                        : pePoco
                                        : peSspo
                                        : peSuop
                                        : peOper );

         %subst(wrepl:1:7) = %trim(%char(pePoli));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'EAS0002'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         REST_writeHeader( 204
                         : *omit
                         : *omit
                         : peMsgs.peMsid
                         : peMsgs.peMsev
                         : peMsgs.peMsg1
                         : peMsgs.peMsg2 );
         REST_end();
         SVPREST_end();

         Data = CRLF
              + '<b>&nbspSPVVEH_getUltimoSuplemento (Request)</b>'  + CRLF;
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
              + '<b>&nbspSPVVEH_getUltimoSuplemento (Reponse)</b> :Error'
              + CRLF;
         COWLOG_spolog( peArcd : peSpol : Data );
         exsr WSREA1setError;

         return;

       endif;

       if assspo <> peSspo;

         %subst(wrepl:1:7) = %trim(%char(pePoli));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'EAS0002'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         REST_writeHeader( 204
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
           + '&nbspSuplemento a endosar      : ' +  %editc(assspo:'X')
           + CRLF;
         COWLOG_spolog( peArcd : peSpol : Data );
         exsr WSREA1setError;

         return;
       endif;

       if assuop <> peSuop;

         %subst(wrepl:1:7) = %trim(%char(pePoli));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'EAS0002'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         REST_writeHeader( 204
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
          +  %editc(assuop:'X') + CRLF;

         COWLOG_spolog( peArcd : peSpol : Data );
         exsr WSREA1setError;

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

         if SPVSPO_getCabecera( peEmpr
                              : peSucu
                              : peArcd
                              : peSpol
                              : @@DsC0 );

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
                 if DsDocu.Tiso = 98;
                   @@Tipe = 'F';
                 else;
                   @@Tipe = 'J';
                 endif;

                 if SVPASE_getAsegurado( @@DsC1(@@DsC1C).c1Asen
                                       : @@DsAs                 );
                 endif;
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
         clear DsAcce;
         clear @@DsC0;
         clear @@DsC1;
         clear @@DsC1C;
         clear @@DsC3;
         clear @@DsAs;
         clear @@DsG3;
         clear @@Dst3;
         clear @@Dst3C;
         clear @@DsW0;
         clear @@Dst1;
         clear @@Dst1C;
         clear @@Dst4;
         clear @@Dst4C;
         clear @1Dst3;
         clear @1Dst4;
         clear @1Ds01;
         clear @1Ds1c;
         clear @@DsCtwetC;

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
           REST_writeHeader( 204
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
           exsr WSREA1setError;
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
         exsr GrabCtwet0;
         exsr GrabCtwetC;
         exsr GrabCtw001;
         exsr GrabCtweg3;
         exsr GrabCtwet1;
         exsr GrabCtwet5;
         exsr GrabCtwet3;
         exsr GrabCtwet4;

        // Confirma Operacion
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

          REST_writeHeader( 204
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
          exsr WSREA1setError;

          return;

        endif;

         Data = CRLF + CRLF
              + '&nbsp<b>PRWSND4 (Response)</b> : OK '       + CRLF
              + '&nbspFecha/Hora: '
              + %trim(%char(%date():*iso)) + ' '
              + %trim(%char(%time():*iso))                   + CRLF
              + '&nbspPESOLN: '       + %editc(peSoln:'X')   + CRLF;
         COWLOG_spolog( peArcd : peSpol : Data );

        // Marca como enviado...
         asmar1 = 'E';
         update p1heas;

         // Retorna respuesta ok
         REST_writeHeader();
         REST_writeEncoding();
         REST_startArray( 'endosoAumentoSuma' );
         REST_startArray( 'datosEndoso' );
          REST_writeXmlLine( 'numeroCotizacion' : %trim(%char(peNctw)) );
          REST_writeXmlLine( 'numeroSolicitud'  : %trim(%char(peSoln)) );
         REST_endArray( 'datosEndoso');
         REST_endArray( 'endosoAumentoSuma' );

       endsr;

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

              REST_writeHeader( 204
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
              exsr WSREA1setError;
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

           REST_writeHeader( 204
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
           exsr WSREA1setError;
           return;

         endif;

         Data = CRLF + CRLF
              + '&nbsp<b>PRWASE8 (Reponse)</b> :OK';
         COWLOG_spolog( peArcd : peSpol : Data );

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWET0                                *
       //* ---------------------------------------------------------- *
       begsr GrabCtwet0;

        clear @@DsCtwet0;
        clear @@DsT9;

        if not SPVVEH_getPahet9( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : peRama
                               : peArse
                               : pePoco
                               : @@DsT9 );

         %subst(wrepl:1:10) = 'PAHET9';
         %subst(wrepl:11:7) = %trim(%char(peNctw));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0204'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();

           Data = CRLF + CRLF
            + '&nbsp<b>SPVVEH_getPahet9 </b>'
            + '<b>Obtener Datos de PAHET9 (Request)</b>' + CRLF
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
            + '&nbsp&nbspPEPOCO: '       + %editc(pePoco:'X') + CRLF;
           COWLOG_spolog( peArcd : peSpol : Data );
           Data = CRLF + CRLF
                + '&nbsp<b>SPVVEH_getPahet9 (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA1setError;
           return;
        endif;

        if not SPVVEH_chkVigencia( peEmpr
                                 : peSucu
                                 : peArcd
                                 : peSpol
                                 : peRama
                                 : peArse
                                 : peOper
                                 : pePoco
                                 : *off    );

         %subst(wrepl: 1:40) = %trim( @@DsT9.t9vhde );
         %subst(wrepl:41:25) = %trim(@@DsT9.t9nmat );
         %subst(wrepl:66:7 ) = %trim( %editc(pePoli:'X') );
         %subst(wrepl:73:4 ) = %trim( %editc(pePoco:'X') );
         %subst(wrepl:77:1 ) = %trim( %editc(peTiou:'X') );
         %subst(wrepl:78:2 ) = %trim( %editc(peStou:'X') );
         %subst(wrepl:80:2 ) = %trim( %editc(peStos:'X') );
         %subst(wrepl:82:30) = %trim( SVPDES_tipoDeOperacion( peTiou
                                                            : peStou
                                                            : peStos ));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0203'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();

           Data = CRLF + CRLF
                + '&nbsp<b>SPVVEH_chkVigencia (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA1setError;
           return;
        endif;

        clear @@DsT0;

        if not SPVVEH_getPahet0( peEmpr
                               : peSucu
                               : peArcd
                               : peSpol
                               : peRama
                               : peArse
                               : pePoco
                               : peSspo
                               : @@DsT0 );

         %subst(wrepl:1:10) = 'PAHET0';
         %subst(wrepl:11:7) = %trim(%char(peNctw));
         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0204'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();

           Data = CRLF + CRLF
            + '&nbsp<b>SPVVEH_getPahet0 </b>'
            + '<b>Obtener Datos de PAHET0 (Request)</b>' + CRLF
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
                + '&nbsp<b>SPVVEH_getPahet0 (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA1setError;
           return;

        endif;

        eval-corr @@DsCtwet0 = @@DsT0;
        @@DsCtwet0.t0nivt = peNivt;
        @@DsCtwet0.t0nivc = peNivc;
        @@DsCtwet0.t0nctw = peNctw;
        @@DsCtwet0.t0aver = @@DsT0.t0mar1;
        @@DsCtwet0.t0nmer = @@DsT9.t9nmer;

        if SVPREN_getClienteIntegral( peEmpr
                                    : peSucu
                                    : peArcd
                                    : peSpol
                                    : peRama
                                    : peArse
                                    : pePoco );
          @@DsCtwet0.t0clin = 'S';
        else;
          @@DsCtwet0.t0clin = 'N';
        endif;
        clear @@DsT4;
        clear @@DsT4C;
        @@DsCtwet0.t0dweb = '0';
        @@DsCtwet0.t0pweb = *zeros;

        clear @@ccbp;
        if SPVVEH_getCodDesRecxCodEqui( peEmpr
                                      : peSucu
                                      : peRama
                                      : pePoli
                                      : pePoco
                                      : peSuop
                                      : 'WEB'
                                      : @@ccbp  );

          clear @@DsT4;
          clear @@DsT4C;

          if SPVVEH_getPahet4( peEmpr
                             : peSucu
                             : peArcd
                             : peSpol
                             : peSspo
                             : peRama
                             : peArse
                             : peOper
                             : peSuop
                             : pePoco
                             : @@ccbp
                             : @@DsT4
                             : @@DsT4C );

            @@DsCtwet0.t0dweb = '1';
            @@DsCtwet0.t0pweb = @@DsT4(@@DsT4C).t4pcbp;
          endif;
        endif;

        if not SPVVEH_getLimitesRC( astarc
                                  : asmone
                                  : @@DsCtwet0.t0rcle
                                  : @@DsCtwet0.t0rcco
                                  : @@DsCtwet0.t0rcac
                                  : @@DsCtwet0.t0lrce
                                  : asctre
                                  : asvhca
                                  : asvhv1
                                  : asmtdf
                                  : asscta );

           %subst(wrepl:1:10) = 'LIMITE RC';
           %subst(wrepl:11:7) = %trim(%char(peNctw));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0204'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );


           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();

           Data = CRLF + CRLF
            + '&nbsp<b>SPVVEH_getLimitesRC </b>'
            + '<b>Obtener Datos de Limites RC (Request)</b>' + CRLF
            + '&nbspFecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + '&nbsp&nbspPETARC: '  + %editc(asTarc:'X')              + CRLF
            + '&nbsp&nbspPEMONE: '  + %trim(asMone)                   + CRLF
            + '&nbsp&nbspPERCLE: '  +
                 %editw(@@DsCtwet0.t0rcle:' .   .   .   . 0 ,  ') + CRLF
            + '&nbsp&nbspPERCCO: '  +
                 %editw(@@DsCtwet0.t0rcco:' .   .   .   . 0 ,  ') + CRLF
            + '&nbsp&nbspPERCAC: '  +
                 %editw(@@DsCtwet0.t0rcac:' .   .   .   . 0 ,  ') + CRLF
            + '&nbsp&nbspPELRCE: '  +
                 %editw(@@DsCtwet0.t0lrce:' .   .   .   . 0 ,  ') + CRLF
            + '&nbsp&nbspPECTRE: '  + %editc(asCtre:'X')              + CRLF
            + '&nbsp&nbspPEVHCA: '  + %editc(asVhca:'X')              + CRLF
            + '&nbsp&nbspPEVHV1: '  + %editc(asVhv1:'X')              + CRLF
            + '&nbsp&nbspPEMTDF: '  + %trim(asMtdf)                   + CRLF
            + '&nbsp&nbspPESCTA: '  + %editc(asScta:'X')       + CRLF;
           COWLOG_spolog( peArcd : peSpol : Data );
           Data = CRLF + CRLF
                + '&nbsp<b>SPVVEH_getLimitesRC (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA1setError;
           return;
        endif;

        @@DsCtwet0.t0mgnc = 'N';
        if @@Dst0.t0rgnc > *zeros;
           @@DsCtwet0.t0mgnc = 'S';
           @@DsCtwet0.t0rgnc = asrgnc;
        endif;

        @@DsCtwet0.t0sast = asvhva - (asvhvu + asrgnc + asvhvc);

        @@DsCtwet0.t0vhde = SPVVEH_GetDescripcion ( asvhmc
                                                  : asvhmo
                                                  : asvhcs );

        @@DsCtwet0.t0rama = asrama;
        @@DsCtwet0.t0arse = asarse;
        @@DsCtwet0.t0poco = aspoco;
        @@DsCtwet0.t0vhmc = asvhmc;
        @@DsCtwet0.t0vhmo = asvhmo;
        @@DsCtwet0.t0vhcs = asvhcs;
        @@DsCtwet0.t0vhcr = asvhcr;
        @@DsCtwet0.t0vhan = asvhaÑ;
        @@DsCtwet0.t0vhni = asvhni;
        @@DsCtwet0.t0moto = asmoto;
        @@DsCtwet0.t0chas = aschas;
        @@DsCtwet0.t0vhca = asvhca;
        @@DsCtwet0.t0vhca = asvhca;
        @@DsCtwet0.t0vhv1 = asvhv1;
        @@DsCtwet0.t0vhv2 = asvhv2;
        @@DsCtwet0.t0mtdf = asmtdf;
        @@DsCtwet0.t0vhct = asvhct;
        @@DsCtwet0.t0vhuv = asvhuv;
        @@DsCtwet0.t0vhvu = asvhva + asrgnc + asvhvc;
        @@DsCtwet0.t0m0km = asm0km;
        @@DsCtwet0.t0rcle = asrcle;
        @@DsCtwet0.t0rcco = asrcco;
        @@DsCtwet0.t0rcac = asrcac;
        @@DsCtwet0.t0claj = asclaj;
        @@DsCtwet0.t0copo = ascopo;
        @@DsCtwet0.t0cops = ascops;
        @@DsCtwet0.t0scta = asscta;
        @@DsCtwet0.t0tmat = astmat;
        @@DsCtwet0.t0nmat = asnmat;
        @@DsCtwet0.t0ctre = asctre;
        @@DsCtwet0.t0rebr = asrebr;
        @@DsCtwet0.t0aver = @@DsT0.t0mar1;
        @@DsCtwet0.t0mar4 = asmar4;
        @@DsCtwet0.t0iris = 'N';
        @@DsCtwet0.t0cesv = 'N';
        @@DsCtwet0.t0ma01 = ' ';
        @@DsCtwet0.t0ma02 = ' ';
        @@DsCtwet0.t0ma03 = ' ';
        @@DsCtwet0.t0ma04 = ' ';
        @@DsCtwet0.t0ma05 = '0';
        @@DsCtwet0.t0acrc = @@DsT0.t0acrc;

        if not COWVEH_setCtwet0( @@DsCtwet0 );

           %subst(wrepl:1:10) = 'CTWET0';
           %subst(wrepl:11:7) = %trim(%char(peNctw));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0204'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();

           Data = CRLF + CRLF
             + '&nbsp<b>COWVEH_setCtwet0 </b>'
             + '<b>Graba Datos en CTWET0 (Request)</b>' + CRLF
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
             + '&nbsp&nbspPERAMA: '      + %editc(peRama:'X')        + CRLF
             + '&nbsp&nbspPEPOCO: '      + %editc(pePoco:'X')        + CRLF
             + '&nbsp&nbspPEARSE: '      + %editc(peArse:'X')        + CRLF;
           COWLOG_spolog( peArcd : peSpol : Data );
           Data = CRLF + CRLF
                + '&nbsp<b>COWVEH_setCtwet0 (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA1setError;
           return;
        endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWETC                                *
       //* ---------------------------------------------------------- *
       begsr GrabCtwetC;

        exsr MoveDatosTc;

        if not COWVEH_setCtwetc( @@DsCtwetC );

           %subst(wrepl:1:10) = 'CTWETC';
           %subst(wrepl:11:7) = %trim(%char(peNctw));
           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'COW0204'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           REST_writeHeader( 204
                           : *omit
                           : *omit
                           : peMsgs.peMsid
                           : peMsgs.peMsev
                           : peMsgs.peMsg1
                           : peMsgs.peMsg2 );
           REST_end();
           SVPREST_end();

           Data = CRLF + CRLF
             + '&nbsp<b>COWVEH_setCtwetc </b>'
             + '<b>Graba Datos en CTWETC (Request)</b>' + CRLF
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
             + '&nbsp&nbspPERAMA: '      + %editc(peRama:'X')        + CRLF
             + '&nbsp&nbspPEARSE: '      + %editc(peArse:'X')        + CRLF
             + '&nbsp&nbspPEPOCO: '      + %editc(pePoco:'X')        + CRLF
             + '&nbsp&nbspPECOBL: ' + %trim(@@DsCtwetC.t0Cobl:'X')   + CRLF;
           COWLOG_spolog( peArcd : peSpol : Data );
           Data = CRLF + CRLF
                + '&nbsp<b>COWVEH_setCtwetc (Reponse)</b> :Error';
           COWLOG_spolog( peArcd : peSpol : Data );
           exsr WSREA1setError;
           return;
        endif;

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
           @1Ds1c.w1Xrea = asXrea;
           @1Ds1c.w1Read = asRead;
           @1Ds1c.w1Xopr = asXopr;
           @1Ds1c.w1Copr = asCopr;

           if not COWGRAI_setCtw001C( @1Ds1c );

              %subst(wrepl:1:10) = 'CTW001C';
              %subst(wrepl:11:7) = %trim(%char(peNctw));
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0204'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );

              REST_writeHeader( 204
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
              exsr WSREA1setError;
              return;
           endif;
         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWET1                                *
       //* ---------------------------------------------------------- *
       begsr GrabCtwet1;

         if SPVVEH_getPahet1( peEmpr
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
                            : @@Dst1
                            : @@Dst1C );

           i = 0;
           for x = 1 to @@Dst1C;

             i += 1;
             dsAcce(i).Secu = @@Dst1(x).t1Secu;
             dsAcce(i).Accd = @@Dst1(x).t1Accd;
             dsAcce(i).Accv = @@Dst1(x).t1Accv;
             dsAcce(i).Mar1 = @@Dst1(x).t1Mar1;

           endfor;

           if not COWVEH_saveAccesorios( peBase
                                       : peNctw
                                       : peRama
                                       : peArse
                                       : pePoco
                                       : dsAcce );

              %subst(wrepl:1:10) = 'CTWET1';
              %subst(wrepl:11:7) = %trim(%char(peNctw));
              SVPWS_getMsgs( '*LIBL'
                           : 'WSVMSG'
                           : 'COW0204'
                           : peMsgs
                           : %trim(wrepl)
                           : %len(%trim(wrepl))  );

             REST_writeHeader( 204
                             : *omit
                             : *omit
                             : peMsgs.peMsid
                             : peMsgs.peMsev
                             : peMsgs.peMsg1
                             : peMsgs.peMsg2 );
             REST_end();
             SVPREST_end();

             Data = CRLF + CRLF
              + '&nbsp<b>COWVEH_saveAccesorios </b>'
              + '<b>Guarda Accesorios (Request)</b>' + CRLF
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
              + '&nbsp&nbspPEPOCO: '       + %editc(pePoco:'X')  + CRLF;
             COWLOG_spolog( peArcd : peSpol : Data );
             Data = CRLF + CRLF
                  + '&nbsp<b>COWVEH_saveAccesorios (Reponse)</b> :Error';
             COWLOG_spolog( peArcd : peSpol : Data );
             exsr WSREA1setError;
             return;
           endif;

         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWET5 - Carta de Daños               *
       //* ---------------------------------------------------------- *
       begsr GrabCtwet5;

         if SPVVEH_getPahet5( peEmpr
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
                            : @@Dst5
                            : @@Dst5C );

           for i = 1 to @@DsT5C;
               clear @@DsCtwet5;
               eval-corr @@DSCtwEt5 = @@DsT5( i );
               @@DsCtwEt5.t5nivt = peNivt;
               @@DsCtwEt5.t5nivc = peNivc;
               @@DsCtwEt5.t5nctw = peNctw;
               if not COWVEH_setCtwet5( @@DsCtwEt5 );
                  %subst(wrepl:1:10) = 'CTWET5';
                  %subst(wrepl:11:7) = %trim(%char(peNctw));
                  SVPWS_getMsgs( '*LIBL'
                               : 'WSVMSG'
                               : 'COW0204'
                               : peMsgs
                               : %trim(wrepl)
                               : %len(%trim(wrepl))  );

                 REST_writeHeader( 204
                                 : *omit
                                 : *omit
                                 : peMsgs.peMsid
                                 : peMsgs.peMsev
                                 : peMsgs.peMsg1
                                 : peMsgs.peMsg2 );
                 REST_end();
                 SVPREST_end();

              Data = CRLF + CRLF
              + '&nbsp<b>COWVEH_setCtwet5</b>'
              + '<b>Guarda Carta de daños  (Request)</b>' + CRLF
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
                   + '&nbsp<b>COWGRAI_setCtw001C (Reponse)</b> :Error';
              COWLOG_spolog( peArcd : peSpol : Data );
              exsr WSREA1setError;
              return;
               endif;
           endfor;
         endif;

       endsr;
       //* ---------------------------------------------------------- *
       //* Graba información de CTWET4                                *
       //* ---------------------------------------------------------- *
       begsr GrabCtwet4;

         if SPVVEH_getPahet4( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peSspo
                            : peRama
                            : peArse
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : @@DsT4
                            : @@DsT4C );

           for x = 1 to @@DsT4C;

             eval-corr @1DsT4 = @@DsT4(x);
             @1Dst4.t4nivt = peNivt;
             @1Dst4.t4nivc = peNivc;
             @1Dst4.t4nctw = peNctw;
             @1Dst4.t4cobl = asCobl;

             if not COWVEH_setCtwet4( @1DsT4 );

                %subst(wrepl:1:10) = 'CTWET4';
                %subst(wrepl:11:7) = %trim(%char(peNctw));
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0204'
                             : peMsgs
                             : %trim(wrepl)
                             : %len(%trim(wrepl))  );

                REST_writeHeader( 204
                                : *omit
                                : *omit
                                : peMsgs.peMsid
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
                REST_end();
                SVPREST_end();

                Data = CRLF + CRLF
                  + '&nbsp<b>COWVEH_setCtwet4 </b>'
                  + '<b>Graba Datos en CTWET4 (Request)</b>' + CRLF
                  + '&nbspFecha/Hora: '
                  + %trim(%char(%date():*iso)) + ' '
                  + %trim(%char(%time():*iso))                    + CRLF
                  + '&nbsp&nbspPEBASE'                                  + CRLF
                  + '&nbsp&nbsp&nbsp;PEEMPR:' + peBase.peEmpr            + CRLF
                  + '&nbsp&nbsp&nbsp;PESUCU:' + peBase.peSucu            + CRLF
                  + '&nbsp&nbsp&nbsp;PENIVT:' + %editc(peBase.peNivt:'X')+ CRLF
                  + '&nbsp&nbsp&nbsp;PENIVC:' + %editc(peBase.peNivc:'X')+ CRLF
                  + '&nbsp&nbsp&nbsp;PENIT1:' + %editc(peBase.peNit1:'X')+ CRLF
                  + '&nbsp&nbsp&nbsp;PENIV1:' + %editc(peBase.peNiv1:'X')+ CRLF
                  + '&nbsp&nbspPEBASE'                                   + CRLF
                  + '&nbsp&nbspPENCTW: '      + %editc(peNctw:'X')       + CRLF
                  + '&nbsp&nbspPERAMA: '      + %editc(peRama:'X')       + CRLF
                  + '&nbsp&nbspPEARSE: '      + %editc(peArse:'X')       + CRLF
                  + '&nbsp&nbspPEPOCO: '      + %editc(pePoco:'X')       + CRLF
                  + '&nbsp&nbspPECOBL: '      + %trim(asCobl)            + CRLF
                  + '&nbsp&nbspPECCBP: ' + %editc(@1Dst4.t4Ccbp:'X') + CRLF;
                COWLOG_spolog( peArcd : peSpol : Data );
                Data = CRLF + CRLF
                     + '&nbsp<b>COWVEH_setCtwet4 (Reponse)</b> :Error';
                COWLOG_spolog( peArcd : peSpol : Data );
                exsr WSREA1setError;
                return;
             endif;

           endfor;
         endif;

       endsr;

       //* ---------------------------------------------------------- *
       //* Graba información de CTWET3                                *
       //* ---------------------------------------------------------- *
       begsr GrabCtwet3;

         if SPVVEH_getpahet3( peEmpr
                            : peSucu
                            : peArcd
                            : peSpol
                            : peRama
                            : peArse
                            : pePoco
                            : peSspo
                            : *omit
                            : *omit
                            : *omit
                            : *omit
                            : @@Dst3
                            : @@Dst3C
                            : *omit   );

           for x = 1 to @@Dst3C;

             eval-corr @1Dst3 = @@Dst3(x);
             @1Dst3.t3Nivt = peNivt;
             @1Dst3.t3Nivc = peNivc;
             @1Dst3.t3Nctw = peNctw;

             if not COWVEH_setCtwet3( @1Dst3 );

                %subst(wrepl:1:10) = 'CTWET3';
                %subst(wrepl:11:7) = %trim(%char(peNctw));
                SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'COW0204'
                             : peMsgs
                             : %trim(wrepl)
                             : %len(%trim(wrepl))  );

                REST_writeHeader( 204
                                : *omit
                                : *omit
                                : peMsgs.peMsid
                                : peMsgs.peMsev
                                : peMsgs.peMsg1
                                : peMsgs.peMsg2 );
                REST_end();
                SVPREST_end();

                Data = CRLF + CRLF
                  + '&nbsp<b>COWVEH_setCtwet3 </b>'
                  + '<b>Graba Datos en CTWET3 (Request)</b>' + CRLF
                  + '&nbspFecha/Hora: '
                  + %trim(%char(%date():*iso)) + ' '
                  + %trim(%char(%time():*iso))                    + CRLF
                  + '&nbsp&nbspPEBASE'                                  + CRLF
                  + '&nbsp&nbsp&nbsp;PEEMPR:' + peBase.peEmpr            + CRLF
                  + '&nbsp&nbsp&nbsp;PESUCU:' + peBase.peSucu            + CRLF
                  + '&nbsp&nbsp&nbsp;PENIVT:' + %editc(peBase.peNivt:'X')+ CRLF
                  + '&nbsp&nbsp&nbsp;PENIVC:' + %editc(peBase.peNivc:'X')+ CRLF
                  + '&nbsp&nbsp&nbsp;PENIT1:' + %editc(peBase.peNit1:'X')+ CRLF
                  + '&nbsp&nbsp&nbsp;PENIV1:' + %editc(peBase.peNiv1:'X')+ CRLF
                  + '&nbsp&nbspPEBASE'                                   + CRLF
                  + '&nbsp&nbspPENCTW: '      + %editc(peNctw:'X')       + CRLF
                  + '&nbsp&nbspPERAMA: '      + %editc(peRama:'X')       + CRLF
                  + '&nbsp&nbspPEARSE: '      + %editc(peArse:'X')       + CRLF
                  + '&nbsp&nbspPEPOCO: '      + %editc(pePoco:'X')       + CRLF
                  + '&nbsp&nbspPETAAJ: ' + %editc(@1Dst3.t3Taaj:'X')    + CRLF
                  + '&nbsp&nbspPECOSG: ' + %trim(@1Dst3.t3Cosg) + CRLF;
                COWLOG_spolog( peArcd : peSpol : Data );
                Data = CRLF + CRLF
                     + '&nbsp<b>COWVEH_setCtwet3 (Reponse)</b> :Error';
                COWLOG_spolog( peArcd : peSpol : Data );
                exsr WSREA1setError;
                return;
             endif;
           endfor;
         endif;

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

            REST_writeHeader( 204
                            : *omit
                            : *omit
                            : peMsgs.peMsid
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();

            Data = CRLF + CRLF
              + '&nbsp<b>COWVEH_setCtweg3 </b>'
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
                 + '&nbsp<b>COWVEH_setCtweg3 (Reponse)</b> :Error';
            COWLOG_spolog( peArcd : peSpol : Data );
            exsr WSREA1setError;
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
         @@DsG3.g3Rpro = asRpro;
         @@DsG3.g3Mone = peMone;
         @@DsG3.g3Come = asCome;
         @@DsG3.g3Suas = asVhva;
         @@DsG3.g3Saca = *zeros;
         @@DsG3.g3Sacr = *zeros;

         @@DsG3.g3Sast = asvhva - (asvhvu + asrgnc + asvhvc);
         @@DsG3.g3Prim = asPrim;
         @@DsG3.g3Bpri = asBpri;
         @@DsG3.g3Refi = asRefi;
         @@DsG3.g3Read = asRead;
         @@DsG3.g3Dere = asDere;
         @@DsG3.g3Seri = asSeri;
         @@DsG3.g3Seem = asSeem;
         @@DsG3.g3Ipr6 = asIpr6;
         @@DsG3.g3Ipr7 = asIpr7;
         @@DsG3.g3Ipr8 = asIpr8;
         @@DsG3.g3Prem = asPrem;
         @@DsG3.g3Mar1 = '0';
         @@DsG3.g3Mar2 = '0';
         @@DsG3.g3Mar3 = '0';
         @@DsG3.g3Mar4 = asMar4;
         @@DsG3.g3Mar5 = '0';
         @@DsG3.g3Ipr1 = asIpr1;
         @@DsG3.g3Ipr3 = asIpr3;
         @@DsG3.g3Ipr4 = asIpr4;
         @@DsG3.g3Sefr = asSefr;
         @@DsG3.g3Sefe = asSefe;

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
         @1Ds01.w1Dere = asDere;
         @1Ds01.w1Xref = asXref;
         @1Ds01.w1Refi = asRefi;
         @1Ds01.w1Seri = asSeri;
         @1Ds01.w1Seem = asSeem;
         @1Ds01.w1Pimi = asPimi;
         @1Ds01.w1Impi = asImpi;
         @1Ds01.w1Psso = asPsso;
         @1Ds01.w1Sers = asSers;
         @1Ds01.w1Pssn = asPssn;
         @1Ds01.w1Tssn = asTssn;
         @1Ds01.w1Pivi = asPivi;
         @1Ds01.w1Ipr1 = asIpr1;
         @1Ds01.w1Pivn = asPivn;
         @1Ds01.w1Ipr4 = asIpr4;
         @1Ds01.w1Pivr = asPivr;
         @1Ds01.w1Ipr3 = asIpr3;
         @1Ds01.w1Ipr6 = asIpr6;
         @1Ds01.w1Ipr7 = asIpr7;
         @1Ds01.w1Ipr8 = asIpr8;
         @1Ds01.w1Ipr9 = *zeros;
         @1Ds01.w1Ipr2 = asIpr2;
         @1Ds01.w1Ipr5 = asIpr5;
         @1Ds01.w1Prem = asPrem;
         @1Ds01.w1Vacc = asVacc;

       endsr;

       //* ---------------------------------------------------------- *
       //* Mueve datos a los campos del archivo CTWETC                *
       //* ---------------------------------------------------------- *
       begsr MoveDatosTc;

         @@DsCtwetC.t0cras = SPVVEH_getCodDeRastreador( peEmpr
                                                      : peSucu
                                                      : peRama
                                                      : peArse
                                                      : pePoco
                                                      : peArcd
                                                      : peSpol );
         @@DsCtwetC.t0rras = 'N';
         if SPVVEH_getRastreadorXSpol( peEmpr
                                     : peSucu
                                     : peArcd
                                     : peSpol
                                     : peRama ) <> *zeros;
           @@DsCtwetC.t0rras = 'S';
         endif;

         @@DsCtwetC.t0empr = @@DsCtwet0.t0empr;
         @@DsCtwetC.t0sucu = @@DsCtwet0.t0sucu;
         @@DsCtwetC.t0nivt = @@DsCtwet0.t0nivt;
         @@DsCtwetC.t0nivc = @@DsCtwet0.t0nivc;
         @@DsCtwetC.t0nctw = @@DsCtwet0.t0nctw;
         @@DsCtwetC.t0rama = @@DsCtwet0.t0rama;
         @@DsCtwetC.t0arse = @@DsCtwet0.t0arse;
         @@DsCtwetC.t0poco = @@DsCtwet0.t0poco;
         @@DsCtwetC.t0cobl = ascobl;
         @@DsCtwetC.t0prrc = asprrc;
         @@DsCtwetC.t0prac = asprac;
         @@DsCtwetC.t0prin = asprin;
         @@DsCtwetC.t0prro = asprro;
         @@DsCtwetC.t0pacc = aspacc;
         @@DsCtwetC.t0praa = aspraa;
         @@DsCtwetC.t0prsf = asprsf;
         @@DsCtwetC.t0prce = asprce;
         @@DsCtwetC.t0prap = asprap;
         @@DsCtwetC.t0rins = 'N';
         @@DsCtwetC.t0cobs = '1';
         @@DsCtwetC.t0mar1 = '0';
         @@DsCtwetC.t0mar2 = '0';
         @@DsCtwetC.t0mar3 = '0';
         @@DsCtwetC.t0mar4 = '0';
         @@DsCtwetC.t0mar5 = '0';
         @@DsCtwetC.t0ifra = asifra;
         @@DsCtwetC.t0prim = asprim;
         @@DsCtwetC.t0seri = asseri;
         @@DsCtwetC.t0seem = asseem;
         @@DsCtwetC.t0impi = asimpi;
         @@DsCtwetC.t0sers = assers;
         @@DsCtwetC.t0tssn = astssn;
         @@DsCtwetC.t0ipr1 = asipr1;
         @@DsCtwetC.t0ipr4 = asipr4;
         @@DsCtwetC.t0ipr3 = asipr3;
         @@DsCtwetC.t0ipr6 = asipr6;
         @@DsCtwetC.t0ipr7 = asipr7;
         @@DsCtwetC.t0ipr8 = asipr8;
         @@DsCtwetC.t0ipr9 = *zeros;
         @@DsCtwetC.t0prem = asprem;
         @@DsCtwetC.t0rcle = @@DsCtwet0.t0rcle;
         @@DsCtwetC.t0rcco = @@DsCtwet0.t0rcco;
         @@DsCtwetC.t0rcac = @@DsCtwet0.t0rcac;
         @@DsCtwetC.t0lrce = @@DsCtwet0.t0lrce;
         @@DsCtwetC.t0claj = @@DsCtwet0.t0claj;

       endsr;

       //* ---------------------------------------------------------- *
       //* Mueve datos de error                                       *
       //* ---------------------------------------------------------- *
       begsr WSREA1setError;
          exsr CambEstado;
          Data = '<br><br><b>WSREA1-Endoso Aumento de Suma Asegurada '
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

