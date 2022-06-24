     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWAPE7: WebService Cotización AP                            *
      *          Transito - wrapper para _cotizarWeb()               *
      *                                                              *
      * ------------------------------------------------------------ *
      * JSN                                      *11-Jun-2021        *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svpase_h.rpgle'
      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/cowape_h.rpgle'
      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/spvfdp_h.rpgle'
      /copy './qcpybooks/prwsnd_h.rpgle'

     D COWAPE7         pr                  ExtPgm('COWAPE7')
     D  peArcd                        6  0 const
     D  peTdoc                        2  0 const
     D  peNdoc                       11  0 const
     D  peXpro                        3  0 const
     D  peNctw                        7  0
     D  peSoln                        7  0
     D  pePoli                        7  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWAPE7         pi
     D  peArcd                        6  0 const
     D  peTdoc                        2  0 const
     D  peNdoc                       11  0 const
     D  peXpro                        3  0 const
     D  peNctw                        7  0
     D  peSoln                        7  0
     D  pePoli                        7  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D PAR310X3        pr                  ExtPgm('PAR310X3')
     D  peEmpr                        1
     D  peFeca                        4  0
     D  peFecm                        2  0
     D  peFecd                        2  0

     D  COWGRA1        pr                  ExtPgm('COWGRA1')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peMone                       2      const
     D   peTiou                       1  0   const
     D   peStou                       2  0   const
     D   peStos                       2  0   const
     D   peSpo1                       7  0   const
     D   peNctx                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWAPE4         pr                  ExtPgm('COWAPE4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peActi                            likeds(Activ_t)  dim(99)
     D   peActiC                     10i 0
     D   peImpu                            likeds(Impuesto)
     D   pePrim                      15  2
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWGRA8         pr                  extpgm('COWGRA8')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peNrpp                       3  0 const
     D   peCon1                            likeds(Condcome) dim(99) const
     D   peCon1C                     10i 0 const
     D   peImp1                            likeds(primPrem) dim(99)
     D   peImp1C                     10i 0
     D   pePrem                      15  2
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND2         pr                  ExtPgm('PRWSND2')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peFhfa                       8  0
     D   peModi                       1a
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

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

     D COWAPE3         pr                  ExtPgm('COWAPE3')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peActi                        5  0 const
     D  peSecu                        2  0 const
     D  peLcom                             likeds(compActi_t) dim(999999)
     D  peLcomC                      10i 0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D PRWBIEN13       pr                  ExtPgm('PRWBIEN13')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       6  0 const
     D   pePaco                       3  0 const
     D   peNomb                      40a   const
     D   peTido                       2  0 const
     D   peNrdo                       8  0 const
     D   peFnac                       8  0 const
     D   peNaci                      25    const
     D   peActi                       5  0 const
     D   peCate                       2  0 const
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWFPG1         pr                  ExtPgm('PRWFPG1')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peCfpg                        1  0 const
     D  peNcbu                       22  0 const
     D  peCtcu                        3  0 const
     D  peNrtc                       20  0 const
     D  peFema                        4  0 const
     D  peFemm                        2  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D PRWSND3         pr                  ExtPgm('PRWSND3')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWMAIL         pr                  ExtPgm('COWMAIL')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const

     D sleep           pr            10u 0 extproc('sleep')
     D   secs                        10u 0 value

     D i               s             10i 0
     D o               s             10i 0
     D @@a             s              4  0
     D @@m             s              2  0
     D @@d             s              2  0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D @@DsTim         ds                  likeds( Dsctwtim_t )
     D peImpu          ds                  likeds(Impuesto)
     D pePrim          s             15  2
     D pePrem          s             15  2
     D peCond          ds                  likeds(condCome2_t) dim(99)
     D peEpvm          s              3  0
     D peEpvx          s              3  0
     D peCon1          ds                  likeds(Condcome) dim(99)
     D peCon1C         s             10i 0
     D peImp1          ds                  likeds(primPrem) dim(99)
     D peImp1C         s             10i 0
     D peFha1          s              8  0
     D peFhfa          s              8  0
     D peModi          s              1a
     D peNomb          s             40a
     D peDomi          ds                  likeds(prwaseDomi_t)
     D peDocu          ds                  likeds(prwaseDocu_t)
     D peNtel          ds                  likeds(prwaseTele_t)
     D peTiso          s              2  0
     D peNaci          ds                  likeds(prwaseNaco_t)
     D peCprf          s              3  0
     D peSexo          s              1  0
     D peEsci          s              1  0
     D peRaae          s              3  0
     D peMail          ds                  likeds(prwaseEmail_t)
     D peAgpe          s              1a
     D peTarc          ds                  likeds(prwaseTarc_t)
     D peNcbu          s             22  0
     D peCbus          s             22  0
     D peRuta          s             16  0
     D peCiva          s              2  0
     D peInsc          ds                  likeds(prwaseInsc_t)
     D peAct1          s              5  0
     D peSecu          s              2  0
     D peLcom          ds                  likeds(compActi_t) dim(999999)
     D peLcomC         s             10i 0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peXrea          s              5  2
     D peXopr          s              5  2
     D @@Naci          s             30
     D peTiou          s              1  0 inz(1)
     D peStou          s              2  0 inz(0)
     D peStos          s              2  0 inz(0)
     D peSpo1          s              7  0 inz(0)
     D peRama          s              2  0 inz(23)
     D peMone          s              2    inz('01')
     D @@Date          s               d
     D peBase          ds                  likeds(paramBase)
     D peNrdf          s              7  0
     D peNivt          s              1  0
     D peNivc          s              5  0
     D peClie          ds                  likeds(ClienteCot_t)
     D peActi          ds                  likeds(Activ_t)  dim(99)
     D peActiC         s             10i 0
     D peVdes          s              8  0
     D peVhas          s              8  0
     D peNrpp          s              3  0
     D peArse          s              2  0 inz(1)
     D peCfpg          s              1  0
     D DsPoli          ds                  likeds(spolizas) Dim(100)
     D DsPoliC         s             10i 0

     D                uds
     D  ldalma                57     58
     D  usempr               401    401
     D  ussucu               402    403

      /free

       *inlr = *on;

       clear peImpu;
       clear pePrim;
       clear pePrem;
       clear peErro;
       clear peMsgs;

       separa = *all'-';

       clear peBase;
       clear peNrdf;
       clear peNivt;
       clear peNivc;

       if SVPASE_isAseguradoHdi( peTdoc
                               : peNdoc
                               : peNrdf
                               : peNivt
                               : peNivc );

         peBase.peEmpr = usempr;
         peBase.peSucu = ussucu;
         peBase.peNivt = peNivt;
         peBase.peNivc = peNivc;
         peBase.peNit1 = peNivt;
         peBase.peNiv1 = peNivc;

         // Obtenemos fecha de vigencia...

         PAR310X3 ( usempr : @@a : @@m : @@d );
         peVdes = (@@a * 10000) + (@@m * 100) + @@d;
         monitor;
         @@date = %date(peVdes:*iso);
          on-error;
             @@date = %date((*year*10000)+(*month*100)+*day:*iso);
         endmon;
         @@date += %years(1);
         peVhas = %int( %char( @@date : *iso0) );

         // Retorna Actividad...

         clear peActi;
         if not COWAPE_cargaActividad( peRama : peXpro : peMone
                                     : peActi : peActiC );
         endif;

         clear peClie;
         clear peDomi;
         clear peDocu;
         clear peNtel;
         clear peNaci;
         clear peMail;
         clear peTarc;
         clear peInsc;

         if SVPASE_infoAsegurado( peNrdf
                                : peTiso
                                : peCprf
                                : peSexo
                                : peEsci
                                : peRaae
                                : peAgpe
                                : peNcbu
                                : peCbus
                                : peRuta
                                : peClie
                                : peDomi
                                : peDocu
                                : peNtel
                                : peNaci
                                : peMail
                                : peTarc
                                : peInsc );

           select;
             when peTarc.Nrtc > *zeros;
               peCfpg = 1;
               peFema = peTarc.ffta;
               peFemm = peTarc.fftm;
               clear peNcbu;
               clear peCbus;
             when peNcbu > *zeros;
               peCfpg = 2;
               clear peTarc;
               peFema = *zeros;
               peFemm = *zeros;
           endsl;

           clear peNrpp;
           peNrpp = SPVFDP_getPlanDePago( peArcd : peCfpg );
         endif;

       endif;

       // Cotización AP transito...

       callp COWGRA1( peBase
                    : peArcd
                    : peMone
                    : peTiou
                    : peStou
                    : peStos
                    : peSpo1
                    : peNctw
                    : peErro
                    : peMsgs );

       Data = CRLF                                     + CRLF
            + '<b>COWAPE7 (Request)</b>'               + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEARCD: '  + %editc(peArcd:'X')         + CRLF
            + 'PETDOC: '  + %editc(peTdoc:'X')         + CRLF
            + 'PENDOC: '  + %editc(peNdoc:'X')         + CRLF
            + 'PEXPRO: '  + %editc(peXpro:'X')         + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       if peErro = *zeros;

         COWAPE4( peBase
                : peNctw
                : peRama
                : peArse
                : peNrpp
                : peVdes
                : peVhas
                : peXpro
                : peClie
                : peActi
                : peActiC
                : peImpu
                : pePrim
                : pePrem
                : peErro
                : peMsgs  );

         if peErro = *zeros;
           clear peCon1;
           peCon1C = 0 ;
           peCon1(1).Rama = peRama;

           peImp1C = *zeros;
           clear peImp1;
           COWGRA8( peBase
                  : peNctw
                  : peNrpp
                  : peCon1
                  : peCon1C
                  : peImp1
                  : peImp1C
                  : pePrem
                  : peErro
                  : peMsgs  );

           if peErro = *zeros;

             PRWSND2( peBase
                    : peNctw
                    : peVdes
                    : peFha1
                    : peFhfa
                    : peModi
                    : peErro
                    : peMsgs );

             if peErro = *zeros;

               PRWASE8( peBase
                      : peNctw
                      : peNrdf
                      : %trim(peClie.nomb)
                      : peDomi
                      : peDocu
                      : peNtel
                      : peTiso
                      : peNaci
                      : peCprf
                      : peSexo
                      : peEsci
                      : peRaae
                      : peMail
                      : peAgpe
                      : peTarc
                      : peNcbu
                      : peCbus
                      : peRuta
                      : peClie.civa
                      : peInsc
                      : peErro
                      : peMsgs );

               if peErro = *zeros;

                 peSecu = 1;
                 clear peLcom;
                 clear peLcomC;
                 COWAPE3( peBase
                        : peNctw
                        : peRama
                        : peArse
                        : peActi(peActiC).Acti
                        : peSecu
                        : peLcom
                        : peLcomC
                        : peErro
                        : peMsgs               );

                 if peErro = *zeros;

                   @@Naci = SVPDES_nacionalidad( peNaci.Cnac );
                   PRWBIEN13( peBase
                            : peNctw
                            : peRama
                            : peArse
                            : 1
                            : 1
                            : %trim(peClie.nomb)
                            : peTdoc
                            : peNdoc
                            : peNaci.fnac
                            : @@Naci
                            : peActi(peActiC).acti
                            : peActi(peActiC).cate
                            : peErro
                            : peMsgs               );

                   if peErro = *zeros;

                     PRWFPG1( peBase
                            : peNctw
                            : peCfpg
                            : peNcbu
                            : peTarc.ctcu
                            : peTarc.nrtc
                            : peFema
                            : peFemm
                            : peErro
                            : peMsgs );

                     if peErro = *zeros;
                       PRWSND3( peBase
                              : peNctw
                              : peVdes
                              : peVhas
                              : peSoln
                              : peErro
                              : peMsgs );

                     endif;
                   endif;
                 endif;
               endif;
             endif;
           endif;
         endif;
       endif;

       clear @@DsTim;
       if COWGRAI_getAuditoria( peBase
                              : peNctw
                              : @@DsTim );
         @@DsTim.w0fcot = %dec(%date : *iso);
         @@DsTim.w0hcot = %dec(%time);
         COWGRAI_setAuditoria( @@DsTim );
       endif;

       Data = CRLF                                     + CRLF
            + '<b>COWAPE7 (Response)</b>'              + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PEERRO: ' +  %trim(%char(peErro))          + CRLF
            + 'PEMSGS'                                    + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_log( peBase : peNctw : Data );
       Data = separa;
       COWLOG_log( peBase : peNctw : Data );

       if peErro = *zeros and peSoln > *zeros;

         sleep(5);

         clear DsPoli;
         DsPoliC = 0;
         if COWGRAI_getPolizasxPropuesta( peBase
                                        : peSoln
                                        : DsPoli
                                        : DsPoliC
                                        : peErro
                                        : peMsgs  );

           for i = 1 to DsPolic;
             if DsPoli(i).Rama = peRama;
               pePoli = DsPoli(i).poliza;
               leave;
             endif;
           endfor;

           COWMAIL( peBase
                  : peNctw );

         endif;
       endif;

       return;

      /end-free
