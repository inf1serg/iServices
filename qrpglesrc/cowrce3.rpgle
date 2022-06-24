     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWRCE1: WebService                                          *
      *          Cotización Responsabilidad Civil wrapper para       *
      *          _cotizarWeb()                                       *
      *          Relación Bici + RC + AP                             *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                         *22-May-2019        *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/cowrce_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/prwbien_h.rpgle'

     D COWRCE3         pr                  ExtPgm('COWRCE3')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNrpp                        3  0 const
     D  peClie                             likeds(ClienteCot_t) const
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0 const
     D  peXrea                        5  2 const
     D  peFdes                        8  0 const
     D  peNctr                        7  0 const
     D  peRdes                       30    const
     D  peNcbu                       22  0 const
     D  peCtcu                        3  0 const
     D  peNrtc                       20  0 const
     D  pefvtc                        6  0 const
     D  peCfpg                        1  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWRCE3         pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peNrpp                        3  0 const
     D  peClie                             likeds(ClienteCot_t) const
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0 const
     D  peXrea                        5  2 const
     D  peFdes                        8  0 const
     D  peNctr                        7  0 const
     D  peRdes                       30    const
     D  peNcbu                       22  0 const
     D  peCtcu                        3  0 const
     D  peNrtc                       20  0 const
     D  pefvtc                        6  0 const
     D  peCfpg                        1  0 const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWRCE1         pr                  ExtPgm('COWRCE1')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0 const
     D  peClie                             likeds(ClienteCot_t) const
     D  pePoco                             likeds(UbicPoc_t) dim(10)
     D  pePocoC                      10i 0 const
     D  peXrea                        5  2 const
     D  peImpu                             likeds(PrimPrem) dim(99)
     D  peSuma                       13  2
     D  pePrim                       15  2
     D  pePrem                       15  2
     D  peCond                             likeds(condCome2_t)
     D  peCon1                             likeds(condCome)
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

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

     D PRWBIEN4        pr                  ExtPgm('PRWBIEN4')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peRdes                      30a   const
     D   peInsp                            const likeds(prwbienInsp_t)
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
     D x               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D @@DsTim         ds                  likeds( Dsctwtim_t )
     D peImpu          ds                  likeds(PrimPrem) dim(99)
     D peSuma          s             13  2
     D pePrim          s             15  2
     D pePrem          s             15  2
     D peCond          ds                  likeds(condCome2_t)
     D peCon1          ds                  likeds(condCome)
     D peFhas          s              8  0
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
     D peFema          s              4  0
     D peFemm          s              2  0
     D peInsp          ds                  likeds(prwbienInsp_t)

      /free

       *inlr = *on;

       separa = *all'-';

       Data = CRLF                                     + CRLF
            + '<b>COWRCE3'
            + ' Cotizador de Respnsabilidad Civil(Request)</b>'  + CRLF
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
            + 'PECFPG: '  + %editc(peCfpg:'X')         + CRLF
            + 'PENRPP: '  + %editc(peNrpp:'X')         + CRLF
            + 'PEXREA: '  + %editw(peXrea:' 0 ,  ')    + CRLF
            + 'PEPOCOC:'  + %editc(pePocoC:'X')        + CRLF;

       COWLOG_log( peBase : peNctw : Data );

       Data = 'PECLIE' + CRLF
          + '&nbsp;ASEN: ' + %editc(peClie.Asen:'X') + CRLF
          + '&nbsp;TIDO: ' + %editc(peClie.Tido:'X') + CRLF
          + '&nbsp;NRDO: ' + %editc(peClie.Nrdo:'X') + CRLF
          + '&nbsp;NOMB: ' + %trim(peClie.Nomb) + CRLF
          + '&nbsp;CUIT: ' + %trim(peClie.Cuit) + CRLF
          + '&nbsp;TIPE: ' + %trim(peClie.Tipe) + CRLF
          + '&nbsp;PROC: ' + %trim(peClie.Proc) + CRLF
          + '&nbsp;RPRO: ' + %editc(peClie.Rpro:'X') + CRLF
          + '&nbsp;COPO: ' + %editc(peClie.Copo:'X') + CRLF
          + '&nbsp;COPS: ' + %editc(peClie.Cops:'X') + CRLF
          + '&nbsp;CIVA: ' + %editc(peClie.Civa:'X') + CRLF
          + 'PECLIE' + CRLF;
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 10;
         if pePoco(i).Poco <= 0;
           leave;
         endif;
         Data = 'PEPOCO(' + %trim(%char(i)) + ')' + CRLF
              + '&nbsp;POCO: ' + %editc(pePoco(i).Poco:'X') + CRLF
              + '&nbsp;XPRO: ' + %editc(pePoco(i).Xpro:'X') + CRLF
              + '&nbsp;TVIV: ' + %editc(pePoco(i).Tviv:'X') + CRLF
              + '&nbsp;COPO: ' + %editc(pePoco(i).Copo:'X') + CRLF
              + '&nbsp;COPS: ' + %editc(pePoco(i).Cops:'X') + CRLF
              + '&nbsp;SCTA: ' + %editc(pePoco(i).Scta:'X') + CRLF
              + '&nbsp;BURE: ' + %editc(pePoco(i).Bure:'X') + CRLF
              + '&nbsp;CARAC:' + %editc(pePoco(i).CaraC:'X') + CRLF;
         COWLOG_log( peBase : peNctw : Data );

         for x = 1 to pePoco(i).CaraC;
           if pePoco(i).Cara(x).Ccba <= 0;
             leave;
           endif;
           Data = 'CARA(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;CCBA: ' + %editc(pePoco(i).Cara(x).Ccba:'X') + CRLF
                + '&nbsp;DCBA: ' + %trim(pePoco(i).Cara(x).Dcba) + CRLF
                + '&nbsp;MA01: ' + %trim(pePoco(i).Cara(x).Ma01) + CRLF
                + '&nbsp;MA02: ' + %trim(pePoco(i).Cara(x).Ma02) + CRLF
                + '&nbsp;MA03: ' + %trim(pePoco(i).Cara(x).Ma03) + CRLF
                + '&nbsp;CBAE: ' + %trim(pePoco(i).Cara(x).Cbae) + CRLF
                + 'CARA' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
         endfor;

         for x = 1 to 20;
           if pePoco(i).Cobe(x).Riec = *blanks;
             leave;
           endif;
           Data = 'COBE(' + %trim(%char(i)) + ')' + CRLF
                + '&nbsp;RIEC: ' + %trim(pePoco(i).Cobe(x).Riec) + CRLF
                + '&nbsp;XCOB: ' + %editc(pePoco(i).Cobe(x).Xcob:'X') + CRLF
                + '&nbsp;SAC1: ' +
                      %editw(pePoco(i).Cobe(X).Sac1:'  .   .   . 0 ,  ') + CRLF
                + '&nbsp;XPRI: ' +
                      %editw(pePoco(i).Cobe(X).Xpri:' 0 ,      ') + CRLF
                + '&nbsp;PRIM: ' +
                      %editw(pePoco(i).Cobe(X).Prim:'  .   .   . 0 ,  ') + CRLF
                + 'COBE' + CRLF;
           COWLOG_log( peBase : peNctw : Data );
         endfor;

       endfor;

       clear peErro;
       clear peMsgs;
       clear peCond;
       clear peCon1;
       clear peImpu;
       clear peSuma;
       clear pePrim;
       clear pePrem;

       COWRCE1( peBase
              : peNctw
              : peRama
              : peArse
              : peNrpp
              : peClie
              : pePoco
              : pePocoC
              : peXrea
              : peImpu
              : peSuma
              : pePrim
              : pePrem
              : peCond
              : peCon1
              : peErro
              : peMsgs  );

       if peErro = *zeros;

         PRWSND2( peBase
                : peNctw
                : peFdes
                : peFhas
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

             clear peInsp;
             PRWBIEN4( peBase
                     : peNctw
                     : peRama
                     : peArse
                     : pePoco(pePocoC).poco
                     : peRdes
                     : peInsp
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

       clear @@DsTim;
       if COWGRAI_getAuditoria( peBase
                              : peNctw
                              : @@DsTim );
         @@DsTim.w0fcot = %dec(%date : *iso);
         @@DsTim.w0hcot = %dec(%time);
         COWGRAI_setAuditoria( @@DsTim );
       endif;

       Data = CRLF                                     + CRLF
            + '<b>COWRCE3 (Response)</b>'              + CRLF
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

