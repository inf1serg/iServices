     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWRTV6: Retorna Datos de componente de vida              *
      * --------------------------------------------------------- *
      * Julio Barranco                       11-Feb-2016          *
      * ********************************************************* *

     D COWRTV6         pr                  ExtPgm('COWRTV6')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peComp                            likeds(CompVida)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D COWRTV6         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   peArse                       2  0 const
     D   pePoco                       4  0 const
     D   peComp                            likeds(CompVida)
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

       peErro = *Zeros;
       clear peMsgs;

      //Log de Entrada...
       Data = CRLF                                          + CRLF
            + '<b>COWRTV6 (Request)</b>'                    + CRLF
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
            + 'PEBASE';
       COWLOG_log( peBase : peNctw : Data );

       clear peComp;

       COWRTV_getComponenteVida ( peBase
                                : peNctw
                                : peRama
                                : peArse
                                : pePoco
                                : peComp
                                : peErro
                                : peMsgs );

          Data =
              '<br><br><b>COWRTV6 (Response)</b>'      + CRLF
            + 'Fecha/Hora: '
            + %trim(%char(%date():*iso)) + ' '
            + %trim(%char(%time():*iso));

           COWLOG_log( peBase : peNctw : Data );

           Data =                                               CRLF
                + 'PECOMP'                                    + CRLF
                + '&nbsp;RAMA: ' + %editc(peComp.rama:'X')    + CRLF
                + '&nbsp;POCO: ' + %editc(peComp.poco:'X')    + CRLF
                + '&nbsp;ARSE: ' + %editc(peComp.Arse:'X')    + CRLF
                + '&nbsp;ACTI: ' + %editc(peComp.Acti:'X')    + CRLF
                + '&nbsp;SECU: ' + %editc(peComp.Secu:'X')    + CRLF
                + '&nbsp;XPRO: ' + %editc(peComp.Xpro:'X')    + CRLF
                + '&nbsp;NOMB: ' + %trim (peComp.Nomb)        + CRLF
                + '&nbsp;TIDO: ' + %editc(peComp.tido:'X')    + CRLF
                + '&nbsp;NRDO: ' + %editc(peComp.nrdo:'X')    + CRLF
                + '&nbsp;FNAC: ' + %editc(peComp.fnac:'X')    + CRLF
                + '&nbsp;NACI: ' + %trim (peComp.naci)        + CRLF
                + '&nbsp;CATE: ' + %editc(peComp.cate:'X')    + CRLF
                + 'PECOMP';
           COWLOG_log( peBase : peNctw : Data );

          for o = 1 to 20;
           if  peComp.cobe(o).xcob = *zeros;
            leave;
           endif;
          Data =                                                     CRLF
             + 'COBE(' + %trim(%char(o)) + ')'                     + CRLF
             + '&nbsp;SECU: ' + %editc (peComp.Cobe(o).secu:'X')   + CRLF
             + '&nbsp;RIEC: ' + %trim  (peComp.Cobe(o).riec)       + CRLF
             + '&nbsp;XCOB: ' + %editc (peComp.Cobe(o).xcob:'X')   + CRLF
             + '&nbsp;SACO: ' + %editc (peComp.Cobe(o).saco:'K')   + CRLF
             + '&nbsp;PTCO: ' + %editc (peComp.Cobe(o).ptco:'K')   + CRLF
             + '&nbsp;XPRI: ' + %editc (peComp.Cobe(o).xpri:'K')   + CRLF
             + '&nbsp;PRSA: ' + %editc (peComp.Cobe(o).prsa:'X')   + CRLF
             + '&nbsp;ECOB: ' + %trim  (peComp.Cobe(o).ecob    )   + CRLF
             + 'COBE';
            COWLOG_log( peBase : peNctw : Data );
          endfor;

          Data =                                                     CRLF
               + '&nbsp;PREM: ' + %editc(peComp.prem:'X') + CRLF ;
          COWLOG_log( peBase : peNctw : Data );

          Data =                                           CRLF
               + 'PECOMP';
          COWLOG_log( peBase : peNctw : Data );

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
