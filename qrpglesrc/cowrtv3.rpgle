     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV3: Recupera los Bienes asegurados(Hogar)            *
      * --------------------------------------------------------- *
      * Alvarez Fernando                     22-Sep-2015          *
      * --------------------------------------------------------- *
      * SGF 16/08/2016: Agrego PROC.                              *
      * SGF 17/08/2016: Agrego Familia de Coberturas.             *
      * SFA 18/08/2016: Agrego Suma e Inspeccion en Estructura.   *
      * SGF 27/03/2017: Retorno ma03.                             *
      *                                                           *
      * ********************************************************* *

     D COWRTV3         pr                  ExtPgm('COWRTV3')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfU                            likeds(InfUbic) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWRTV3         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfU                            likeds(InfUbic) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D o               s             10i 0
     D u               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      /copy './qcpybooks/cowrtv_h.rpgle'

       *inlr  = *on;

       clear peInfu;
       clear peMsgs;
       peErro = 0;

       Data = CRLF                                          + CRLF
            + '<b>COWRTV3 (Request)</b>'                    + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso))                    + CRLF
            + 'PEBASE'                                      + CRLF
            + '&nbsp;PEEMPR: ' + peBase.peEmpr              + CRLF
            + '&nbsp;PESUCU: ' + peBase.peSucu              + CRLF
            + '&nbsp;PENIVT: ' + %editc(peBase.peNivt:'X')  + CRLF
            + '&nbsp;PENIVC: ' + %editc(peBase.peNivc:'X')  + CRLF
            + '&nbsp;PENIT1: ' + %editc(peBase.peNit1:'X')  + CRLF
            + '&nbsp;PENIV1: ' + %editc(peBase.peNiv1:'X')  + CRLF
            + 'PEBASE'                                      + CRLF
            + 'PENCTW: '  + %editc(peNctw:'X');
            COWLOG_log( peBase : peNctw : Data );

       COWRTV_getUbicaciones ( peBase
                             : peNctw
                             : peInfU
                             : peErro
                             : peMsgs );
       Data =
              '<br><br><b>COWRTV3 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso));
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 10;
         if peInfU(i).rama = *zeros;
           leave;
         endif;
         Data =                                               CRLF
              + 'PEINFU(' + %trim(%char(i)) + ')'           + CRLF
              + '&nbsp;RAMA: ' + %editc(peInfu(i).rama:'X') + CRLF
              + '&nbsp;POCO: ' + %editc(peInfu(i).poco:'X') + CRLF
              + '&nbsp;ARSE: ' + %editc(peInfu(i).arse:'X') + CRLF
              + '&nbsp;XPRO: ' + %editc(peInfu(i).xpro:'X') + CRLF
              + '&nbsp;RPRO: ' + %editc(peInfu(i).rpro:'X') + CRLF
              + '&nbsp;PROC: ' + %trim(peInfu(i).proc)      + CRLF
              + '&nbsp;RDES: ' + %trim(peInfu(i).rdes)      + CRLF
              + '&nbsp;COPO: ' + %editc(peInfu(i).copo:'X') + CRLF
              + '&nbsp;COPS: ' + %editc(peInfu(i).cops:'X') + CRLF
              + '&nbsp;SUMA: ' + %editc(peInfu(i).suma:'X') + CRLF
              + '&nbsp;INSP: ' + %trim(peInfu(i).insp)      + CRLF
              + '&nbsp;TVIV: ' + %editc(peInfu(i).tviv:'X');
         COWLOG_log( peBase : peNctw : Data );

         for o = 1 to 10;
           if peInfU(i).cobe(o).riec = *blanks;
             leave;
           endif;
           Data =                                               CRLF
             + '&nbsp;COBE(' + %trim(%char(o)) + ')'
             + CRLF
             + '&nbsp;&nbsp;RIEC: ' + %trim(peInfu(i).cobe(o).riec)
             + CRLF
             + '&nbsp;&nbsp;XCOB: ' + %editc(peInfu(i).cobe(o).xcob:'X')
             + CRLF
             + '&nbsp;&nbsp;RIED: ' + %trim(peInfu(i).cobe(o).ried)
             + CRLF
             + '&nbsp;&nbsp;COBD: ' + %trim(peInfu(i).cobe(o).cobd)
             + CRLF
             + '&nbsp;&nbsp;COBL: ' + %trim(peInfu(i).cobe(o).cobl)
             + CRLF
             + '&nbsp;&nbsp;BAOP: ' + %trim(peInfu(i).cobe(o).baop)
             + CRLF
             + '&nbsp;&nbsp;SACO: ' + %editc(peInfu(i).cobe(o).saco:'K')
             + CRLF
             + '&nbsp;&nbsp;SMAX: ' + %editc(peInfu(i).cobe(o).smax:'K')
             + CRLF
             + '&nbsp;&nbsp;SMIN: ' + %editc(peInfu(i).cobe(o).smin:'K')
             + CRLF
             + '&nbsp;&nbsp;PRSA: ' + %editc(peInfu(i).cobe(o).prsa:'K')
             + CRLF
             + '&nbsp;&nbsp;ORIE: ' + %trim(peInfu(i).cobe(o).orie)
             + CRLF
             + '&nbsp;&nbsp;OCOB: ' + %editc(peInfu(i).cobe(o).ocob:'X')
             + CRLF
             + '&nbsp;&nbsp;SAC1: ' + %editc(peInfu(i).cobe(o).sac1:'K')
             + CRLF
             + '&nbsp;&nbsp;XPRI: ' + %editc(peInfu(i).cobe(o).xpri:'K')
             + CRLF
             + '&nbsp;&nbsp;PRIM: ' + %editc(peInfu(i).cobe(o).prim:'K')
             + CRLF
             + '&nbsp;&nbsp;CFAC: ' + %editc(peInfu(i).cobe(o).cfac:'K')
             + CRLF
             + '&nbsp;&nbsp;DFAC: ' + %trim(peInfu(i).cobe(o).dfac);
           COWLOG_log( peBase : peNctw : Data );
           for u = 1 to 10;
             if peInfU(i).cobe(o).bonu(u).nive= *zeros;
               leave;
             endif;
           Data =                                               CRLF
                + '&nbsp;&nbsp;BONU(' + %trim(%char(o)) + ')' + CRLF
                + '&nbsp;&nbsp;&nbsp;NIVE: '
                +  %editc(peInfu(i).cobe(o).bonu(u).nive:'X') + CRLF
                + '&nbsp;&nbsp;&nbsp;CCBP: '
                +  %editc(peInfu(i).cobe(o).bonu(u).ccbp:'X') + CRLF
                + '&nbsp;&nbsp;&nbsp;RECA: '
                +  %editc(peInfu(i).cobe(o).bonu(u).reca:'K') + CRLF
                + '&nbsp;&nbsp;&nbsp;BONI: '
                +  %editc(peInfu(i).cobe(o).bonu(u).boni:'K') + CRLF
                + '&nbsp;&nbsp;BONU';
           COWLOG_log( peBase : peNctw : Data );
           endfor;

           Data =                                               CRLF
                + 'COBE';
             COWLOG_log( peBase : peNctw : Data );
         endfor;

         for o = 1 to 10;
           if peInfU(i).cara(o).ccba = *zeros;
             leave;
           endif;
           Data =                                               CRLF
                + '&nbsp;CARA(' + %trim(%char(o)) + ')'               + CRLF
                + '&nbsp;&nbsp;CCBA: ' + %editc(peInfU(i).cara(o).ccba:'X')
                + CRLF
                + '&nbsp;&nbsp;DCBA: ' + %trim(peInfU(i).cara(o).dcba)
                + CRLF
                + '&nbsp;&nbsp;MA01: ' + %trim(peInfU(i).cara(o).ma01)
                + CRLF
                + '&nbsp;&nbsp;MA02: ' + %trim(peInfU(i).cara(o).ma02)
                + CRLF
                + '&nbsp;&nbsp;MA01M:' + %trim(peInfU(i).cara(o).ma01m)
                + CRLF
                + '&nbsp;&nbsp;MA02M:' + %trim(peInfU(i).cara(o).ma02m)
                + CRLF
                + '&nbsp;&nbsp;MA03: ' + %trim(peInfU(i).cara(o).ma03)
                + CRLF
                + 'CARA';
             COWLOG_log( peBase : peNctw : Data );
         endfor;
         Data =                                               CRLF
              + 'PEINFU';
         COWLOG_log( peBase : peNctw : Data );
       endfor;

       Data =                                               CRLF
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

       COWRTV_end();

       return;
