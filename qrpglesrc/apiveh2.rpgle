     H option(*nodebugio:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * APIVEH2: WebService                                          *
      *          Cotización API Autos - wrapper para _cotizarWeb()   *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                              *13-Sep-2019   *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/apiveh_h.rpgle'
      /copy './qcpybooks/apigrai_h.rpgle'

     D APIVEH2         pr                  ExtPgm('APIVEH2')
     D   peNsys                      20    const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peArcd                       6  0 const
     D   peinfo                       7  0 const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peLoca                       6  0 const
     D   peCfpg                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peTdoc                       3  0 const
     D   peNdoc                      11  0 const
     D   peAcce                            likeds(AccVehaAPI_t)dim(10) const
     D   pePcom                       5  2 const
     D   pePbon                       5  2 const
     D   pePreb                       5  2 const
     D   pePrec                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t)  dim(200) const
     D   pePaxc                            likeds(CobVehAPI_t) dim(20)
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D APIVEH2         pi
     D   peNsys                      20    const
     D   peNivc                       5  0 const
     D   peCuii                      11    const
     D   peArcd                       6  0 const
     D   peinfo                       7  0 const
     D   peVhan                       4    const
     D   peVhvu                      15  2 const
     D   peMgnc                       1    const
     D   peRgnc                       7  2 const
     D   peLoca                       6  0 const
     D   peCfpg                       3  0 const
     D   peTipe                       1    const
     D   peCiva                       2  0 const
     D   peTdoc                       3  0 const
     D   peNdoc                      11  0 const
     D   peAcce                            likeds(AccVehaAPI_t)dim(10) const
     D   pePcom                       5  2 const
     D   pePbon                       5  2 const
     D   pePreb                       5  2 const
     D   pePrec                       5  2 const
     D   peTaaj                       2  0 const
     D   peScor                            likeds(preguntas_t)  dim(200) const
     D   pePaxc                            likeds(CobVehAPI_t) dim(20)
     D   peNctw                       7  0
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     D pePaxcC         s             10i 0
     D i               s             10i 0
     D Data            s          65535a   varying
     D CRLF            s              4a   inz('<br>')
     D separa          s            100a   inz(*all'-')
     D @@Ncta          s              7  0
     D @@empr          s              1
     D @@sucu          s              2
     D @@vsys          s            512
     D W152            C                   ' .   .   .   . 0 ,  '
     D W72             C                   '   0 ,  '
     D W52             C                   ' 0 ,  '
     D @@base          ds                  likeds(paramBase)
     D rc              s             10i 0

     D sleep           pr            10u 0 extproc('sleep')
     D  secs                         10u 0 value

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D   JobName                     10a   overlay(PsDs:244)
     D   JobUser                     10a   overlay(PsDs:254)
     D   JobNbr                       6  0 overlay(PsDs:264)

      /free

       *inlr = *on;

       // Limpiar variables de output...

       clear pePaxc;
       clear pePaxcC;
       clear peNctw;
       clear peErro;
       clear peMsgs;
       clear @@base;
       if not APIGRAI_getParamBase( peNivc
                                  : @@base
                                  : peErro
                                  : peMsgs );
         return;
       endif;

       //Obtener Nro de Cotización WEB...
       @@Ncta = APIGRAI_getNroCotizacion(@@base.peEmpr :@@base.peSucu);

       // Log de entrada...
       Data = CRLF                                               + CRLF
            + '<b>APIVEH2-Cotizar Vehiculo API(Request)</b>'     + CRLF
            + 'Fecha/Hora: '
            + %trim( %char( %date() : *iso ) ) + ' '
            + %trim( %char( %time() : *iso ) )                   + CRLF
            + 'PENSYS: ' + peNsys                                + CRLF
            + 'PENIVC: ' + %editc( peNivc : 'X'  )               + CRLF
            + 'PECUII: ' + %trim ( peCuii        )               + CRLF
            + 'PEARCD: ' + %editc( peArcd : 'X'  )               + CRLF
            + 'PEINFO: ' + %editc( peinfo : 'X'  )               + CRLF
            + 'PEVHAN: ' + %trim ( peVhan        )               + CRLF
            + 'PEVHVU: ' + %trim(%editw( peVhvu : W152 ))        + CRLF
            + 'PEMGNC: ' + %trim ( peMgnc        )               + CRLF
            + 'PERGNC: ' + %trim (%editw( peRgnc : W72 ))        + CRLF
            + 'PELOCA: ' + %editc( peLoca : 'X'  )               + CRLF
            + 'PECFPG: ' + %editc( peCfpg : 'X'  )               + CRLF
            + 'PETIPE: ' + %trim ( peTipe        )               + CRLF
            + 'PECIVA: ' + %editc( peCiva : 'X'  )               + CRLF
            + 'PETDOC: ' + %editc( peTdoc : 'X'  )               + CRLF
            + 'PENDOC: ' + %editc( peNdoc : 'X'  )               + CRLF
            + 'PEPCOM: ' + %trim ( %editw( pePcom : w52 ))+ '%'  + CRLF
            + 'PEPBON: ' + %trim ( %editw( pePbon : w52 ))+ '%'  + CRLF
            + 'PEPREB: ' + %trim ( %editw( pePreb : w52 ))+ '%'  + CRLF
            + 'PEPREC: ' + %trim ( %editw( pePrec : w52 ))+ '%'  + CRLF;
         COWLOG_apilog( @@Ncta :peNivc : Data );

       for i = 1 to 10;
         if peAcce(i).desc = *Blanks;
          leave;
         endif;
         Data =                                                            CRLF
              + 'PEACCE(' + %trim(%char(i)) + ')'                        + CRLF
              + '&nbsp;PEDESC: '+ peAcce(i).desc                         + CRLF
              + '&nbsp;PEVALOR: '+ %trim( %editw( peAcce(i).valor: w152))+ CRLF
              + 'PEACCE'                                                 + CRLF;
         COWLOG_apilog( @@Ncta :peNivc : Data );
       endfor;

       Data =                                        CRLF
            + 'PETAAJ: '  + %editc(peTaaj:'X')     + CRLF;
       COWLOG_apilog( @@Ncta :peNivc : Data );

       for i = 1 to 200;
           if peScor(i).cosg = *blanks;
              leave;
           endif;
           Data =                                               CRLF
                + 'PESCOR(' + %trim(%char(i)) + ')'           + CRLF
                + '&nbsp;PECOSG: '+%trim(peScor(i).cosg)      + CRLF
                + '&nbsp;PEVEFA: '+%trim(peScor(i).vefa)      + CRLF
                + '&nbsp;PECANT: '+%editc(peScor(i).cant:'X') + CRLF
                + 'PESCOR'                                    + CRLF;
       COWLOG_apilog( @@Ncta :peNivc : Data );
       endfor;

       APIVEH_cotizar2( @@ncta
                      : peNsys
                      : peNivc
                      : peCuii
                      : peArcd
                      : peinfo
                      : peVhan
                      : peVhvu
                      : peMgnc
                      : peRgnc
                      : peLoca
                      : peCfpg
                      : peTipe
                      : peCiva
                      : peTdoc
                      : peNdoc
                      : peAcce
                      : pePcom
                      : pePbon
                      : PePreb
                      : PePrec
                      : peTaaj
                      : peScor
                      : pePaxc
                      : pePaxcC
                      : peNctw
                      : peErro
                      : peMsgs );

       // Parseamos el mensaje.
       rc = %scan('ç':peMsgs.peMsg2);
       if rc <> 0;
         peMsgs.peMsg2 = %trim( %subst( peMsgs.peMsg2 : rc + 1 ) );
       endif;

       Data = '<br><br><b>APIVEH2-Cotizar Vehiculo API (Response)</b>' + CRLF
            + 'Fecha/Hora: '
            + %trim( %char( %date() : *iso ) ) + ' '
            + %trim( %char( %time() : *iso ) )         + CRLF;
       COWLOG_apilog( @@Ncta :peNivc : Data );

       for i = 1 to pePaxcC;
         if pePaxc(i).cobl = *blanks;
           leave;
         endif;
         Data =                                                             CRLF
              + 'PEPAXC(' + %trim( %char(i) ) + ')'                       + CRLF
              + '&nbsp;COBL: ' + pePaxc(i).cobl                           + CRLF
              + '&nbsp;COBD: ' + pePaxc(i).cobd                           + CRLF
              + '&nbsp;RAST: ' + pePaxc(i).rast                           + CRLF
              + '&nbsp;INSP: ' + pePaxc(i).insp                           + CRLF
              + '&nbsp;PRIM: ' + %trim(%editw( pePaxc(i).prim : W152))    + CRLF
              + '&nbsp;PREM: ' + %trim(%editw( pePaxc(i).prem : W152))    + CRLF
              + '&nbsp;IFRA: ' + %trim(%editw( pePaxc(i).ifra : W152))    + CRLF
              + '&nbsp;RCLE: ' + %trim(%editw( pePaxc(i).rcle : W152))    + CRLF
              + '&nbsp;RCCO: ' + %trim(%editw( pePaxc(i).rcco : W152))    + CRLF
              + '&nbsp;RCAC: ' + %trim(%editw( pePaxc(i).rcac : W152))    + CRLF
              + '&nbsp;LRCE: ' + %trim(%editw( pePaxc(i).lrce : W152))    + CRLF
              + '&nbsp;CLAJ: ' + %trim(%editw( pePaxc(i).claj : w52))+'%' + CRLF
              + '&nbsp;VASE: ' + %trim(%editw( pePaxc(i).vase : W152))    + CRLF
              + '&nbsp;DERE: ' + %trim(%editw( pePaxc(i).dere : W152))    + CRLF
              + '&nbsp;EPVA: ' + %trim(%editw( pePaxc(i).epva : W152))    + CRLF
              + '&nbsp;READ: ' + %trim(%editw( pePaxc(i).read : W152))    + CRLF
              + '&nbsp;IMPU: ' + %trim(%editw( pePaxc(i).impu : W152))    + CRLF
              + 'PEPAXC';
         COWLOG_apilog( @@Ncta :peNivc : Data );
       endfor;

       Data =                                               CRLF
            + 'PEERRO: ' +  %trim(%char(peErro))          + CRLF
            + 'PEMSGS'                                    + CRLF
            + '&nbsp;PEMSEV: ' + %char(peMsgs.peMsev)     + CRLF
            + '&nbsp;PEMSID: ' + peMsgs.peMsid            + CRLF
            + '&nbsp;PEMSG1: ' + %trim(peMsgs.peMsg1)     + CRLF
            + '&nbsp;PEMSG2: ' + %trim(peMsgs.peMsg2)     + CRLF
            + 'PEMSGS' + CRLF;
       COWLOG_apilog( @@Ncta :peNivc : Data );
       Data = separa;
       COWLOG_apilog( @@Ncta :peNivc : Data );

       return;

      /end-free
