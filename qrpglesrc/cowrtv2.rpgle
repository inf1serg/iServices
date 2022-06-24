     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV2: Recupera los bienes asegurados(Vehículos)        *
      * --------------------------------------------------------- *
      * Alvarez Fernando                     22-Sep-2015          *
      * --------------------------------------------------------- *
      * SGF 10/08/2016: Agrego accesorios y suma asegurada.       *
      * SGF 12/08/2016: Agrego importe de franquicia.             *
      * SGF 16/08/2016: Agrego Códigos de Provincia.              *
      * SGF 10/11/2016: Agrego Comisión.                          *
      *                                                           *
      * ********************************************************* *

     D COWRTV2         pr                  ExtPgm('COWRTV2')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfV                            likeds(Infvehi) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWRTV2         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0   const
     D   peInfV                            likeds(Infvehi) Dim(10)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D i               s             10i 0
     D o               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')

      /copy './qcpybooks/cowrtv_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

       *inlr  = *on;
       clear peInfv;
       Data = CRLF                                          + CRLF
            + '<b>COWRTV2 (Request)</b>'                    + CRLF
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

       COWRTV_getVehiculos( peBase
                          : peNctw
                          : peInfV
                          : peErro
                          : peMsgs );

       Data =
              '<br><br><b>COWRTV2 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso));
       COWLOG_log( peBase : peNctw : Data );

       for i = 1 to 10;
           if peInfV(i).rama = *zeros;
              leave;
           endif;
           Data =                                               CRLF
                + 'PEINFV(' + %trim(%char(i)) + ')'           + CRLF
                + '&nbsp;RAMA: ' + %editc(peInfv(i).rama:'X') + CRLF
                + '&nbsp;POCO: ' + %editc(peInfv(i).poco:'X') + CRLF
                + '&nbsp;ARSE: ' + %editc(peInfv(i).Arse:'X') + CRLF
                + '&nbsp;VHMC: ' + %trim(peInfv(i).Vhmc)      + CRLF
                + '&nbsp;VHMO: ' + %trim(peInfv(i).Vhmo)      + CRLF
                + '&nbsp;VHCS: ' + %trim(peInfv(i).Vhcs)      + CRLF
                + '&nbsp;VHCR: ' + %trim(peInfv(i).Vhcr)      + CRLF
                + '&nbsp;VHAN: ' + %editc(peInfv(i).Vhan:'X') + CRLF
                + '&nbsp;VHNI: ' + %trim(peInfv(i).Vhni)      + CRLF
                + '&nbsp;MOTO: ' + %trim(peInfv(i).Moto)      + CRLF
                + '&nbsp;CHAS: ' + %trim(peInfv(i).Chas)      + CRLF
                + '&nbsp;VHCT: ' + %editc(peInfv(i).Vhct:'X') + CRLF
                + '&nbsp;VHUV: ' + %editc(peInfv(i).Vhuv:'X') + CRLF
                + '&nbsp;M0KM: ' + %trim(peInfv(i).M0km)      + CRLF
                + '&nbsp;PROC: ' + %trim(peInfv(i).proc)      + CRLF
                + '&nbsp;RPRO: ' + %editc(peInfv(i).Rpro:'X') + CRLF
                + '&nbsp;COPO: ' + %editc(peInfv(i).Copo:'X') + CRLF
                + '&nbsp;COPS: ' + %editc(peInfv(i).Cops:'X') + CRLF
                + '&nbsp;SCTA: ' + %editc(peInfv(i).Scta:'X') + CRLF
                + '&nbsp;MGNC: ' + %trim(peInfv(i).Mgnc)      + CRLF
                + '&nbsp;RGNC: ' + %editc(peInfv(i).Rgnc:'K') + CRLF
                + '&nbsp;NMAT: ' + %trim(peInfv(i).Nmat)      + CRLF
                + '&nbsp;CTRE: ' + %editc(peInfv(i).Ctre:'X') + CRLF
                + '&nbsp;REBR: ' + %editc(peInfv(i).Rebr:'X') + CRLF
                + '&nbsp;NMER: ' + %trim(peInfv(i).Nmer)      + CRLF
                + '&nbsp;AVER: ' + %trim(peInfv(i).Aver)      + CRLF
                + '&nbsp;IRIS: ' + %trim(peInfv(i).Iris)      + CRLF
                + '&nbsp;CESV: ' + %trim(peInfv(i).Cesv)      + CRLF
                + '&nbsp;VHVU: ' + %editc(peInfv(i).vhvu:'X');
           COWLOG_log( peBase : peNctw : Data );

          for o = 1 to 20;
           if  peInfv(i).cobe(o).cobl = *blanks;
            leave;
           endif;
          Data =                                                        CRLF
           + '&nbsp;COBE(' + %trim(%char(o)) + ')'                    + CRLF
           + '&nbsp;&nbsp;COBL: ' + %trim(peInfv(i).Cobe(o).Cobl)     + CRLF
           + '&nbsp;&nbsp;COBD: ' + %trim(peInfv(i).Cobe(o).Cobd)     + CRLF
           + '&nbsp;&nbsp;RAST: ' + %trim(peInfv(i).Cobe(o).rast)     + CRLF
           + '&nbsp;&nbsp;CRAS: ' + %editc(peInfv(i).Cobe(o).cras:'X')+ CRLF
           + '&nbsp;&nbsp;SELE: ' + %trim(peInfv(i).Cobe(o).sele)     + CRLF
           + '&nbsp;&nbsp;PRIM: ' + %editc(peInfv(i).Cobe(o).prim:'K')+ CRLF
           + '&nbsp;&nbsp;PREM: ' + %editc(peInfv(i).Cobe(o).prem:'K')+ CRLF
           + '&nbsp;&nbsp;IFRA: ' + %editc(peInfv(i).Cobe(o).ifra:'K')+ CRLF
           + '&nbsp;&nbsp;XOPR: ' + %editc(peInfv(i).Cobe(o).xopr:'K')+ CRLF
           + '&nbsp;COBE';
            COWLOG_log( peBase : peNctw : Data );
          endfor;

          for o = 1 to 99;
            if  peInfv(i).Boni(o).Cobl = *blanks;
             leave;
            endif;
          Data =                                                      CRLF
           + '&nbsp;&nbsp;BONI(' + %trim(%char(o)) + ')'         + CRLF
           + '&nbsp;&nbsp;&nbsp;COBL: ' + %trim(peInfv(i).Boni(o).Cobl)
           + CRLF
           + '&nbsp;&nbsp;&nbsp;CCBP: '+ %editc(peInfv(i).Boni(o).Ccbp:'X')
           + CRLF
           + '&nbsp;&nbsp;&nbsp;DCBP: ' + %trim(peInfv(i).Boni(o).Dcbp)
           + CRLF
           + '&nbsp;&nbsp;&nbsp;PCBP: ' + %editc(peInfv(i).Boni(o).Pcbp:'K')
           + CRLF
           + '&nbsp;&nbsp;&nbsp;PCBM: ' + %editc(peInfv(i).Boni(o).Pcbm:'K')
           + CRLF
           + '&nbsp;&nbsp;&nbsp;PCBX: ' + %editc(peInfv(i).Boni(o).Pcbx:'K')
           + CRLF
           + '&nbsp;&nbsp;&nbsp;MODI: ' + %trim(peInfv(i).Boni(o).Modi)
           + CRLF
           + '&nbsp;&nbsp;BONI';
           COWLOG_log( peBase : peNctw : Data );
         endfor;
          for o = 1 to 100;
           if  peInfv(i).acce(o).secu = 0;
            leave;
           endif;
          Data =                                                        CRLF
           + '&nbsp;ACCE(' + %trim(%char(o)) + ')'                    + CRLF
           + '&nbsp;&nbsp;SECU: ' + %editc(peInfv(i).acce(o).secu:'X')+ CRLF
           + '&nbsp;&nbsp;ACCV: ' + %editc(peInfv(i).acce(o).accv:'X')+ CRLF
           + '&nbsp;&nbsp;ACCD: ' + peInfv(i).acce(o).accd            + CRLF
           + '&nbsp;&nbsp;MAR1: ' + peInfv(i).acce(o).mar1            + CRLF
           + '&nbsp;ACCE';
            COWLOG_log( peBase : peNctw : Data );
          endfor;

           Data =                                           CRLF
                + 'PEINFV';
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
