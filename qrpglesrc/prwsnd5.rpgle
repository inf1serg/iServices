     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRWSND5: WebService                                          *
      *          Propuesta Web                                       *
      *          Wrapper para _sendPropuesta2()                      *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                         *04-Abr-2021        *
      * ************************************************************ *

      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/spvfdp_h.rpgle'
      /copy './qcpybooks/prwsnd_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D PRWSND5         pr                  ExtPgm('PRWSND5')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peNuse                      50    const
     D   peAxpr                       3  0 const
     D   peFnac                       8  0 const
     D   peRxpr                       3  0 const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peNctx                       7  0
     D   peNcty                       7  0
     D   peSolx                       7  0
     D   peSoly                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND5         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peNuse                      50    const
     D   peAxpr                       3  0 const
     D   peFnac                       8  0 const
     D   peRxpr                       3  0 const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peNctx                       7  0
     D   peNcty                       7  0
     D   peSolx                       7  0
     D   peSoly                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D PRWSND3         pr                  ExtPgm('PRWSND3')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peSoln                       7  0
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
     D   peNctx                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

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

     D PRWSND6         pr                  ExtPgm('PRWSND6')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peFdes                       8  0 const
     D   peFhas                       8  0
     D   peSoln                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D sleep           pr            10u 0 extproc('sleep')
     D   secs                        10u 0 value

     D x               s             10i 0
     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D @@nuse          s             50
     D peMone          s              2
     D peTiou          s              1  0 inz(1)
     D peStou          s              2  0 inz(0)
     D peStos          s              2  0 inz(0)
     D peSpo1          s              7  0 inz(0)
     D peNrpp          s              3  0
     D peClie          ds                  likeds(ClienteCot_t)
     D peActi          ds                  likeds(Activ_t)  dim(99)
     D peActiC         s             10i 0
     D DsCtw           ds                  likeds(dsctw000_t)
     D peRamx          s              2  0 inz(23)
     D peRamy          s              2  0 inz(8)
     D peRama          s              2  0 inz(9)
     D peFha1          s              8  0
     D peFhfa          s              8  0
     D peModi          s              1a
     D peNcbu          s             22  0
     D peCbus          s             22  0
     D peSecu          s              2  0
     D peXrea          s              5  2
     D peXopr          s              5  2
     D @@Xcob          ds                  likeds(cobert_t) dim(999)
     D @@XcobC         s             10i 0
     D pePoco          ds                  likeds(UbicPoc_t) dim(10)
     D pePocoC         s             10i 0
     D @@Poco          ds                  likeds(UbicPoc_t) dim(10)
     D @@PocoC         s             10i 0
     D peRdes          s             30
     D @@Xpro          s              3  0
     D peArcx          s              6  0
     D peArcy          s              6  0
     D @@ValSys        s            512a

      /free

       *inlr = *on;

       separa = *all'-';

       peNctx = 0;
       peNcty = 0;
       peSoln = 0;
       peSolx = 0;
       peSoly = 0;

       Data = '<br><br>'
            + '<b>PRWSND5 (Request)</b>'               + CRLF
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
            + 'PENUSE: '  + peNuse                     + CRLF
            + 'PEFDES: '  + %editc(peFdes:'X')         + CRLF
            + 'PEAXPR: '  + %editc(peAxpr:'X')         + CRLF
            + 'PEFNAC: '  + %editc(peFnac:'X')         + CRLF
            + 'PERXPR: '  + %editc(peRxpr:'X')         + CRLF
            + 'PEFHAS: '  + %editc(peFhas:'X');
       COWLOG_log( peBase : peNctw : Data );

       clear DsCtw;
       if COWGRAI_getCtw000( peBase
                           : peNctw
                           : DsCtw  );

         if peAxpr > *zeros or peRxpr > *zeros;

           clear peClie;
           if not COWGRAI_getCliente( peBase : peNctw : peClie );

           endif;

           @@PocoC = 0;
           clear @@Poco;
           if COWRGV_getComponentes( peBase
                                   : peNctw
                                   : peRama
                                   : @@Poco
                                   : @@PocoC      );

             clear pePoco;
             pePocoC = 1;
             eval-corr pePoco(pePocoC) = @@Poco(1);
           endif;

           clear peRdes;
           peRdes = COWRGV_ubicacionDelRiesgo( peBase
                                             : peNctw
                                             : peRama
                                             : pePoco(pePocoC).poco
                                             : 1                    );

         endif;
       endif;

       if peAxpr > *zeros;
         if not SVPVLS_getValSys( 'HARCDRAP':*omit :@@ValSys );
           peErro = -1;
           return;
         else;
           peArcx = %dec( @@ValSys : 6 : 0 );
         endif;

         clear peNrpp;
         peNrpp = SPVFDP_getPlanDePago( peArcx : DsCtw.w0Cfpg );

         clear peSpo1;
         clear peNctx;
         callp COWGRA1( peBase
                      : peArcx
                      : DsCtw.w0Mone
                      : peTiou
                      : peStou
                      : peStos
                      : peSpo1
                      : peNctx
                      : peErro
                      : peMsgs       );

         if peErro = *zeros;
           clear peActi;

           if not COWAPE_cargaActividad( peRamx : peAxpr : DsCtw.w0Mone
                                       : peActi : peActiC );
           endif;

           callp COWAPE6( peBase
                        : peNctx
                        : peRamx
                        : 1
                        : peNrpp
                        : peFdes
                        : peFhas
                        : peAxpr
                        : peClie
                        : DsCtw.w0Cfpg
                        : DsCtw.w0Ncbu
                        : DsCtw.w0Ctcu
                        : DsCtw.w0Nrtc
                        : DsCtw.w0Fvtc
                        : peNctw
                        : peFnac
                        : peActi
                        : peActiC
                        : peErro
                        : peMsgs  );
         endif;
       endif;

       if peErro = *zeros;
         if peRxpr > *zeros;
           if not SVPVLS_getValSys( 'HARCDRRC':*omit :@@ValSys );
             peErro = -1;
             return;
           else;
             peArcy = %dec( @@ValSys : 6 : 0 );
           endif;

           clear peNrpp;
           peNrpp = SPVFDP_getPlanDePago( peArcy : DsCtw.w0Cfpg );

           clear peSpo1;
           clear peNcty;
           callp COWGRA1( peBase
                        : peArcy
                        : DsCtw.w0Mone
                        : peTiou
                        : peStou
                        : peStos
                        : peSpo1
                        : peNcty
                        : peErro
                        : peMsgs );

           clear @@Xcob;
           @@Xpro = peRxpr;
           WSLTAB_coberturasPorPlan( peRamy
                                   : @@Xpro
                                   : DsCtw.w0Mone
                                   : @@Xcob
                                   : @@XcobC          );

           i = 0;
           clear pePoco(pePocoC).cobe;
           for x = 1 to @@XcobC;
             i += 1;
             pePoco(pePocoC).cobe(i).riec = @@Xcob(x).riec;
             pePoco(pePocoC).cobe(i).xcob = @@Xcob(x).xcob;
             pePoco(pePocoC).cobe(i).sac1 = @@Xcob(x).saco;
           endfor;

           pePoco(pePocoC).Xpro = @@Xpro;

           COWGRAI_getCondComerciales( peBase
                                     : peNcty
                                     : peRamy
                                     : peXrea
                                     : peXopr );

           if peErro = *zeros;
             COWRCE3( peBase
                    : peNcty
                    : peRamy
                    : 1
                    : peNrpp
                    : peClie
                    : pePoco
                    : pePocoC
                    : peXrea
                    : peFdes
                    : peNctw
                    : peRdes
                    : DsCtw.w0Ncbu
                    : DsCtw.w0Ctcu
                    : DsCtw.w0Nrtc
                    : DsCtw.w0Fvtc
                    : DsCtw.w0Cfpg
                    : peErro
                    : peMsgs       );
           endif;
         endif;
       endif;

       if peErro = *zeros and ( peAxpr > *zeros or peRxpr > *zeros );
         if COWGRAI_setRelacion( peBase
                               : DsCtw.w0Arcd
                               : peNctw
                               : peNctx
                               : peNcty       );
         endif;
       endif;

       if peErro = *zeros;

         if peAxpr > *zeros;

           PRWSND6( peBase
                  : peNctx
                  : peFdes
                  : peFhas
                  : peSolx
                  : peErro
                  : peMsgs );

           if peErro = 0;
              @@nuse = peNuse;
              COWGRAI_updCabecera( peBase
                                 : peNctx
                                 : peErro
                                 : peMsgs
                                 : *omit
                                 : *omit
                                 : *omit
                                 : @@nuse );
           endif;
         endif;

         if peRxpr > *zeros;

           PRWSND6( peBase
                  : peNcty
                  : peFdes
                  : peFhas
                  : peSoly
                  : peErro
                  : peMsgs );

           if peErro = 0;
              @@nuse = peNuse;
              COWGRAI_updCabecera( peBase
                                 : peNcty
                                 : peErro
                                 : peMsgs
                                 : *omit
                                 : *omit
                                 : *omit
                                 : @@nuse );
           endif;
         endif;

         PRWSND3( peBase
                : peNctw
                : peFdes
                : peFhas
                : peSoln
                : peErro
                : peMsgs );

         if peErro = 0;
            @@nuse = peNuse;
            COWGRAI_updCabecera( peBase
                               : peNctw
                               : peErro
                               : peMsgs
                               : *omit
                               : *omit
                               : *omit
                               : @@nuse );

         endif;
       endif;


       Data = '<br><br>'
            + '<b>PRWSND5 (Response)</b>'                 + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                  + CRLF
            + 'PENCTX: ' + %trim(%char(peNctx))           + CRLF
            + 'PENCTY: ' + %trim(%char(peNcty))           + CRLF
            + 'PESOLN: ' + %trim(%char(peSoln))           + CRLF
            + 'PESOLX: ' + %trim(%char(peSolx))           + CRLF
            + 'PESOLY: ' + %trim(%char(peSoly))           + CRLF
            + 'PEERRO: ' +  %trim(%char(peErro))          + CRLF
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
