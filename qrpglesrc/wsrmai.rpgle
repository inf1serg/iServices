     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRMAI: QUOM Versión 2                                       *
      *         Retorna configuración de correo.                     *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *02-Ene-2018            *
      * ************************************************************ *
     Fmailconf  if   e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'

     D uri             s            512a
     D empr            s              1a
     D sucu            s              2a
     D nivt            s              1a
     D nivc            s              5a
     D nit1            s              1a
     D niv1            s              5a
     D cspr            s             20a
     D @@repl          s          65535a
     D url             s           3000a   varying
     D rc              s              1n
     D r2              s             10i 0
     D c               s             10i 0
     D x               s             10i 0
     D rc2             s             10i 0
     D peSubj          s             70a   varying
     D @@mint          ds                  likeds(MailAddr_t) dim(100)
     D peRemi          ds                  likeds(Remitente_t)
     D peRprp          ds                  likeds(recprp_t) dim(100)

     D peCprc          s             20a   inz('QUOM_MAILS')

     D peBase          ds                  likeds(paramBase)
     D peMsgs          ds                  likeds(paramMsgs)
     D peSini          ds                  likeds(pahstro_t)
     D peErro          s             10i 0

     D k1mail          ds                  likerec(mailconfr:*key)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

      /free

       *inlr = *on;

       rc  = REST_getUri( psds.this : uri );
       if rc = *off;
          return;
       endif;
       url = %trim(uri);

       // ------------------------------------------
       // Obtener los parámetros de la URL
       // ------------------------------------------
       empr = REST_getNextPart(url);
       sucu = REST_getNextPart(url);
       nivt = REST_getNextPart(url);
       nivc = REST_getNextPart(url);
       nit1 = REST_getNextPart(url);
       niv1 = REST_getNextPart(url);
       cspr = REST_getNextPart(url);

       if SVPREST_chkBase(empr:sucu:nivt:nivc:nit1:niv1:peMsgs) = *off;
          rc = REST_writeHeader( 400
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

       peBase.peEmpr = empr;
       peBase.peSucu = sucu;
       peBase.peNivt = %dec(nivt:1:0);
       peBase.peNivc = %dec(nivc:5:0);
       peBase.peNit1 = %dec(nit1:1:0);
       peBase.peNiv1 = %dec(niv1:5:0);
       COWLOG_logcon('WSRMAI':peBase);

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'configuracionMail' : '*BEG');

       r2 = MAIL_getFrom(peCprc: cspr: peRemi );
       if r2 = -1;
          peMsgs.peMsid = 'MAI0001';
          peMsgs.peMsev = 40;
          peMsgs.peMsg1 = 'No se ha encontrado la lista de distribución';
          peMsgs.peMsg2 = 'No se ha encontrado la lista de distribución';
          rc = REST_writeHeader( 400
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
       if peRemi.From = '*CURRENT';
          peRemi.From = '*SYSTEM';
          peRemi.Fadr = *blanks;
       endif;
       if peRemi.From = '*SYSTEM';
          k1mail.nfsecu = 1;
          chain %kds(k1mail) mailconf;
          if %found;
             peRemi.From = nfsysn;
             peRemi.Fadr = %trim(nfsysm) + '@' + %trim(nfdomi);
          endif;
       endif;

       r2 = MAIL_getSubject(peCprc: cspr: peSubj );
       if r2 = -1;
          peSubj = 'HDI Seguros S.A.';
       endif;

       c = MAIL_getReceipt(peCprc: cspr: peRprp: *on);

       // --------------------------------------------
       // Si el proceso es PROPUESTA_* envio copia al
       // productor
       // --------------------------------------------
       if %subst(cspr:1:10) = 'PROPUESTA_';
          if c <= 99;
             r2 = SVPMAIL_xNivc( empr
                               : sucu
                               : %dec(nivt:1:0)
                               : %dec(nivc:5:0)
                               : @@mint
                               : 5              );
             for x = 1 to r2;
                 c += 1;
                 if c > 100;
                    c = 100;
                    leave;
                 endif;
                 peRprp(c).rpmail = @@mint(x).mail;
                 peRprp(c).rpnomb = @@mint(x).nomb;
                 peRprp(c).rpma01 = '1';
             endfor;
          endif;
       endif;

       REST_writeXmlLine( 'from' : %trim(peRemi.from) );
       REST_writeXmlLine( 'fromAddress' : %trim(peRemi.fadr) );
       REST_writeXmlLine( 'subject'     : %trim(peSubj) );

       REST_writeXmlLine( 'destinatarios' : '*BEG');

       for x = 1 to c;
           REST_writeXmlLine( 'destinatario' : '*BEG');
            REST_writeXmlLine( 'to' : %trim(peRprp(x).rpnomb) );
            REST_writeXmlLine( 'toAddress' : %trim(peRprp(x).rpmail) );
            select;
             when peRprp(x).rpma01 = '1';
               REST_writeXmlLine( 'toType' : 'NORMAL' );
             when peRprp(x).rpma01 = '2';
               REST_writeXmlLine( 'toType' : 'CC' );
             when peRprp(x).rpma01 = '3';
               REST_writeXmlLine( 'toType' : 'CCO' );
            endsl;
           REST_writeXmlLine( 'destinatario' : '*END');
       endfor;

       REST_writeXmlLine( 'destinatarios' : '*END');

       REST_writeXmlLine( 'configuracionMail' : '*END');

       close *all;

       return;

