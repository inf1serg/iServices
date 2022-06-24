     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * COWHOG6: WebService                                          *
      *          Renovación Combinado Familiar - wrapper para        *
      *          _cotizarWeb()                                       *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                         *02-may-2018        *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * JSN 19/02/2019 - Se agrega el llamado al procedimiento       *
      *                  COWGRAI_vencerCotizacion                    *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/cowhog_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     D COWGRA3         pr                  extpgm('COWGRA3')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0   const
     D  peAsen                        7  0   const
     D  peNomb                       40      const
     D  peCiva                        2  0   const
     D  peTipe                        1      const
     D  peCopo                        5  0   const
     D  peCops                        1  0   const
     D  peCuit                       11a     const
     D  peTido                        1  0   const
     D  peNrdo                        8  0   const
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D COWHOG6         pr                  ExtPgm('COWHOG6')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWHOG6         pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0   const
     D   peSpol                       9  0   const
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWGRA1         pr                  ExtPgm('COWGRA1')
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

     D COWHOG7         pr                  ExtPgm('COWHOG7')
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const
     D  peRama                        2  0 const
     D  peArse                        2  0 const
     D  peCfpg                        3  0 const
     D  peClie                             likeds(ClienteCot_t)
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

     D i               s             10i 0
     D peLnsp          s              1
     D peSuma          s             13  2
     D peBoni          ds                  likeds(Bonific) dim(200)
     D peImpu          ds                  likeds(PrimPrem) dim(99)
     D peClie          ds                  likeds(ClienteCot_t)
     D peCond          ds                  likeds(condCome2_t)
     D peCon1          ds                  likeds(condCome)
     D pePrem          s             15  2
     D pePrim          s             15  2
     D peXrea          s              5  2
     D peCfpg          s              3  0
     D peRama          s              2  0
     D peArse          s              2  0
     D peSpo1          s              7  0
     D peMone          s              2
     D peTiou          s              1  0
     D peStou          s              2  0
     D peStos          s              2  0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a
     D pePoco          ds                  likeds( UbicPoc_t ) dim(10)
     D pePocoC         s             10i 0

      /free

       *inlr = *on;

       clear peErro ;
       clear peMsgs ;
       clear peNctw ;

       separa = *all'-';

       callp COWHOG_chkRenovacion( peBase
                                 : peArcd
                                 : peSpol
                                 : peErro
                                 : peMsgs );

       if peErro <> *zeros;
         return;
       else;

         peTiou = 2;
         peMone = '01';
         peSpo1 = peSpol;
         clear pePoco;
         clear peClie;
         clear peStou;
         clear peStos;
         clear peSuma;

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

         if peErro = *zeros;

           COWHOG_getInfoHogar( peBase
                              : peArcd
                              : peSpol
                              : peNctw
                              : peRama
                              : peArse
                              : peCfpg
                              : peClie
                              : pePoco
                              : peXrea );
           for i = 1 to 10;
             if pePoco(i).Poco <= 0;
               leave;
             else;
               pePocoC += 1;
             endif;
           endfor;

             COWHOG7( peBase
                    : peNctw
                    : peRama
                    : peArse
                    : peCfpg
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

          if peErro = 0;
             COWGRA3( peBase
                    : peNctw
                    : peClie.asen
                    : peClie.nomb
                    : peClie.civa
                    : peClie.tipe
                    : peClie.copo
                    : peClie.cops
                    : peClie.cuit
                    : peClie.tido
                    : peClie.nrdo
                    : peErro
                    : peMsgs        );
          else;

             COWGRAI_vencerCotizacion( peBase
                                     : peNctw );

          endif;

         endif;
       endif;

       //Data = CRLF                                     + CRLF
         // + '<b>COWHOG6 (Response)</b>'              + CRLF
         // + 'Fecha/Hora: '
         // + %trim(%char(%date():*iso)) + ' '
         // + %trim(%char(%time():*iso))               + CRLF;
       //COWLOG_log( peBase : peNctw : Data );

       return;

      /end-free
