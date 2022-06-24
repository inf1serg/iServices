
     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ********************************************************************* *
      * WSREAT - AP Tránsito RPG                                              *
      *          RM#10063 Generar servicio REST para emitir AP Tránsito       *
      * --------------------------------------------------------------------- *
      * Jennifer Segovia                                        * 11-Jul-2021 *
      * --------------------------------------------------------------------- *
      * Modificaciones :                                                      *
      *                                                                       *
      * ********************************************************************* *
     Fset001    if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/spvspo_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'
      /copy './qcpybooks/spvcbu_h.rpgle'
      /copy './qcpybooks/cowape_h.rpgle'

     D COWAPE7         pr                  extpgm('COWAPE7')
     D  peArcd                        6  0 const
     D  peTdoc                        2  0 const
     D  peNdoc                       11  0 const
     D  peXpro                        3  0 const
     D  peNctw                        7  0
     D  peSoln                        7  0
     D  pePoli                        7  0
     D  peErro                       10i 0
     D  peMsgs                             likeds(paramMsgs)

     D psds           sds                  qualified
     D  this                         10a   overlay(PsDs:1)
     D  JobName                      10a   overlay(PsDs:244)
     D  UsrName                      10a   overlay(PsDs:*next)
     D  JobNbr                        6  0 overlay(PsDs:*next)
     D  CurUsr                       10a   overlay(PsDs:358)

     D lda             ds                  qualified dtaara(*lda)
     D   empr                         1a   overlay(lda:401)
     D   sucu                         2a   overlay(lda:402)

     D uri             s            512a
     D url             s           3000a   varying
     D @@Rc1           s              1n
     D @@Rc2           s             10i 0

     D empr            s              1a
     D sucu            s              2a
     D tdoc            s              2a
     D ndoc            s             11a
     D xpro            s              3a

     D var             s            512a

     D @@a             s              4  0
     D @@m             s              2  0
     D peMsgs          ds                  likeds(paramMsgs)
     D peErro          s             10i 0
     D @@repl          s          65535a
     D peArcd          s              6  0
     D peCfpg          s              1  0
     D peXpro          s              3  0
     D peNctw          s              7  0
     D peSoln          s              7  0
     D pePoli          s              7  0
     D peTdoc          s              2  0
     D peNdoc          s             11  0
     D @@Vsys          s            512
     D @@FecA          s              4  0
     D @@FecM          s              2  0
     D @@FecD          s              2  0

      /free

        *inlr = *on;

          @@Rc1  = REST_getUri( psds.this : uri );
          if @@Rc1 = *off;
            return;
          endif;
          url = %trim(uri);

          // Obtener los parámetros de la URL
          empr = REST_getNextPart(url);
          sucu = REST_getNextPart(url);
          tdoc = REST_getNextPart(url);
          ndoc = REST_getNextPart(url);
          xpro = REST_getNextPart(url);

          in lda;
            lda.empr = empr;
            lda.sucu = sucu;
          out lda;

          // Número de plan de pago...
          monitor;
            peXpro = %dec(xpro:3:0);
          on-error;
            peXpro = 0;
          endmon;

          // Tipo de documento...
          monitor;
            peTdoc = %dec(tdoc:2:0);
          on-error;
            peTdoc = 0;
          endmon;

          // Número de documento...
          monitor;
            peNdoc = %dec(Ndoc:11:0);
          on-error;
            peNdoc = 0;
          endmon;

          if SVPREST_chkCliente( empr
                               : sucu
                               : tdoc
                               : ndoc
                               : peMsgs ) = *Off;
            REST_writeHeader( 204
                            : *omit
                            : *omit
                            : peMsgs.peMsid
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
            REST_end();
            SVPREST_end();
            close *all;
            return;
          endif;

          @@Rc1 = COWLOG_logConAutoGestion( empr
                                          : sucu
                                          : peTdoc
                                          : peNdoc
                                          : psds.this);

          if SVPVLS_getValSys( 'HARCDATR'  :*omit :@@Vsys );
            peArcd =  %int(%trim( @@VSys ));
          endif;

          clear peMsgs;

          peNctw = *zeros;
          peSoln = *zeros;
          pePoli = *zeros;
          peErro = *zeros;

          COWAPE7( peArcd
                 : peTdoc
                 : peNdoc
                 : peXpro
                 : peNctw
                 : peSoln
                 : pePoli
                 : peErro
                 : peMsgs );

          if peErro = *zeros;
            REST_writeHeader();
            REST_writeEncoding();

            REST_writeXmlLine( 'emisionApTransito' : '*BEG');
              REST_writeXmlLine( 'numeroCotizacion' : %char(peNctw) );
              REST_writeXmlLine( 'numeroPropuesta'  : %char(peSoln) );
              REST_writeXmlLine( 'numeroPoliza' : %char(pePoli) );
            REST_writeXmlLine( 'emisionApTransito' : '*END');
          else;
            REST_writeHeader();
            REST_writeEncoding();

            REST_writeXmlLine( 'emisionApTransito' : '*BEG');
              REST_writeXmlLine( 'numeroCotizacion' : '0' );
              REST_writeXmlLine( 'numeroPropuesta'  : '0' );
              REST_writeXmlLine( 'numeroPoliza' : '0' );
            REST_writeXmlLine( 'emisionApTransito' : '*END');

            REST_writeHeader( 200
                            : *omit
                            : *omit
                            : peMsgs.peMsid
                            : peMsgs.peMsev
                            : peMsgs.peMsg1
                            : peMsgs.peMsg2 );
          endif;

          REST_end();

          close *all;
          return;

      /end-free
