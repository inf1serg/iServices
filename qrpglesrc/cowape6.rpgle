     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWAPE6: WebService                                          *
      *          Cotización AP  - wrapper para _cotizarWeb()         *
      *          Relación Bici + RC + AP                             *
      * ------------------------------------------------------------ *
      * JSN                                      *18-May-2021        *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/spvfdp_h.rpgle'
      /copy './qcpybooks/prwsnd_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D COWAPE6         pr                  ExtPgm('COWAPE6')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peCfpg                       1  0 const
     D   peNcbu                      22  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   pefvtc                       6  0 const
     D   peNctr                       7  0 const
     D   peFnac                       8  0 const
     D   peActi                            likeds(Activ_t)  dim(99)
     D   peActiC                     10i 0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWAPE6         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   peNrpp                       3  0 const
     D   peVdes                       8  0 const
     D   peVhas                       8  0 const
     D   peXpro                       3  0 const
     D   peClie                            likeds(ClienteCot_t) const
     D   peCfpg                       1  0 const
     D   peNcbu                      22  0 const
     D   peCtcu                       3  0 const
     D   peNrtc                      20  0 const
     D   pefvtc                       6  0 const
     D   peNctr                       7  0 const
     D   peFnac                       8  0 const
     D   peActi                            likeds(Activ_t)  dim(99)
     D   peActiC                     10i 0
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

     D COWRTV4         pr                  ExtPgm('COWRTV4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peRama                       2  0   const
     D   peCond                            likeds(condCome2_t) dim(99)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWGRA9         pr                  extpgm('COWGRA9')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peEpvm                        3  0
     D  peEpvx                        3  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

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

     D i               s             10i 0
     D o               s             10i 0
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
     D @@Ncbu          s             22  0
     D peCbus          s             22  0
     D peRuta          s             16  0
     D peCiva          s              2  0
     D peInsc          ds                  likeds(prwaseInsc_t)
     D peAct1          s              5  0
     D peSecu          s              2  0
     D peLcom          ds                  likeds(compActi_t) dim(999999)
     D peLcomC         s             10i 0
     D peSolx          s              7  0
     D peFema          s              4  0
     D peFemm          s              2  0
     D peXrea          s              5  2
     D peXopr          s              5  2
     D @@Naci          s             30

      /free

       *inlr = *on;

       clear peImpu;
       clear pePrim;
       clear pePrem;
       clear peErro;
       clear peMsgs;

       separa = *all'-';

       Data = CRLF                                     + CRLF
            + '<b>COWAPE6 (Request)</b>'               + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))               + CRLF
            + 'PEBASE'                                 + CRLF
            + '&nbsp;PEEMPR: ' + peBase.peEmpr         + CRLF
            + '&nbsp;PESUCU: ' + peBase.peSucu         + CRLF
            + '&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + 'PEBASE'                                 + CRLF
            + 'PERAMA: '  + %editc(peRama:'X')         + CRLF
            + 'PEARSE: '  + %editc(peArse:'X')         + CRLF
            + 'PENRPP: '  + %editc(peNrpp:'X')         + CRLF
            + 'PEVDES: '  + %editc(peVdes:'X')         + CRLF
            + 'PEVHAS: '  + %editc(peVhas:'X')         + CRLF
            + 'PEXPRO: '  + %editc(peXpro:'X')         + CRLF
            + 'PECFPG: '  + %editc(peCfpg:'X')         + CRLF
            + 'PENCBU: '  + %editc(peNcbu:'X')         + CRLF
            + 'PECTCU: '  + %editc(peCtcu:'X')         + CRLF
            + 'PENRTC: '  + %editc(peNrtc:'X')         + CRLF
            + 'PEFVTC: '  + %editc(pefvtc:'X')         + CRLF
            + 'PENCTR: '  + %editc(peNctr:'X')         + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       Data = 'PECLIE' + CRLF
          + '&nbsp;ASEN: ' + %editc(peClie.Asen:'X') + CRLF
          + '&nbsp;TIDO: ' + %editc(peClie.Tido:'X') + CRLF
          + '&nbsp;NRDO: ' + %editc(peClie.Nrdo:'X') + CRLF
          + '&nbsp;NOMB: ' + peClie.Nomb + CRLF
          + '&nbsp;CUIT: ' + peClie.Cuit + CRLF
          + '&nbsp;TIPE: ' + peClie.Tipe + CRLF
          + '&nbsp;PROC: ' + peClie.Proc + CRLF
          + '&nbsp;RPRO: ' + %editc(peClie.Rpro:'X') + CRLF
          + '&nbsp;COPO: ' + %editc(peClie.Copo:'X') + CRLF
          + '&nbsp;COPS: ' + %editc(peClie.Cops:'X') + CRLF
          + '&nbsp;CIVA: ' + %editc(peClie.Civa:'X') + CRLF
          + 'PECLIE' + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to peActiC;
         Data = 'PEACTI(' + %trim(%char(i)) + ')' + CRLF
            + '&nbsp;ACTI: ' + %editc(peActi(i).Acti:'X') + CRLF
            + '&nbsp;CANT: ' + %editc(peActi(i).Cant:'X') + CRLF
            + '&nbsp;PACO: ' + %editc(peActi(i).Paco:'X') + CRLF
            + '&nbsp;SECU: ' + %editc(peActi(i).Secu:'X') + CRLF
            + '&nbsp;RAED: ' + %editc(peActi(i).Raed:'X') + CRLF
            + '&nbsp;PRIM: ' +
                 %editw(peActi(i).Prim:' .   .   .   . 0 ,  ') + CRLF
            + '&nbsp;PREM: ' +
                 %editw(peActi(i).Prem:' .   .   .   . 0 ,  ') + CRLF;
         COWLOG_log( peBase : peNctw : Data );

         for o = 1 to peActi(i).CobeC;
           Data = 'COBE(' + %trim(%char(o)) + ')' + CRLF
                + '&nbsp;RIEC: ' + %trim(peActi(i).cobe(o).riec) + CRLF
                + '&nbsp;XCOB: ' + %editc(peActi(i).Cobe(o).xcob:'X') + CRLF
                + '&nbsp;SAC1: ' +
                     %editw(peActi(i).Cobe(o).sac1:'  .   .   . 0 ,  ')+CRLF
                + 'COBE' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
         endfor;

       endfor;

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

             clear peNomb;
             clear peDomi;
             clear peDocu;
             clear peNtel;
             clear peNaci;
             clear peMail;
             clear peTarc;
             clear peInsc;

             if not PRWASE_getAseguradoTomador( peBase
                                              : peNctr
                                              : peClie.Asen
                                              : peNomb
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
                                              : @@Ncbu
                                              : peCbus
                                              : peRuta
                                              : peCiva
                                              : peInsc );
             endif;

             PRWASE8( peBase
                    : peNctw
                    : peClie.Asen
                    : peNomb
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
                    : @@Ncbu
                    : peCbus
                    : peRuta
                    : peCiva
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
                          : peNomb
                          : peDocu.tido
                          : peDocu.nrdo
                          : peFnac
                          : @@Naci
                          : peActi(peActiC).acti
                          : peActi(peActiC).cate
                          : peErro
                          : peMsgs               );

                 if peErro = *zeros;

                   peFema = %int(%subst(%editc(peFvtc:'X'):1:4));
                   peFemm = %int(%subst(%editc(peFvtc:'X'):5  ));

                   PRWFPG1( peBase
                          : peNctw
                          : peCfpg
                          : peNcbu
                          : peCtcu
                          : peNrtc
                          : peFema
                          : peFemm
                          : peErro
                          : peMsgs );

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
            + '<b>COWAPE6 (Response)</b>'              + CRLF
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

       return;

      /end-free
