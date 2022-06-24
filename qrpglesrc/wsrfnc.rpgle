
     H option(*srcstmt:*noshowcpy:*nodebugio) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)

      * ************************************************************ *
      * WSRFNC: Recibe datos de contacto de un NO CLIENTE HDI para   *
      *         enviarlo por mail a quien corresponda                *
      *         RM#01148 Generar servicio REST lista de pólizas      *
      * ------------------------------------------------------------ *
      * Gio Nicolini                                   * 16-Jul-2018 *
      * ------------------------------------------------------------ *
      * Modificiones:                                                *
      *                                                              *
      * ************************************************************ *

     Fpahag2    o    e           k disk

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'
      /copy inf1giov/qcpybooks,spwliblc_h

     D lda             ds                  qualified dtaara(*lda)
     D   empr                         1a   overlay(lda:401)
     D   sucu                         2a   overlay(lda:402)

     D PsDs           sds                  qualified
     D  this                         10a   overlay(PsDs:1)

     D peMsgs          ds                  likeds(paramMsgs)
     D uri             s            512a
     D url             s           3000a   varying
     D rc              s              1n
     D tdoc            s              2a
     D ndoc            s             11a
     D @@Tdoc          s              2  0
     D @@Ndoc          s             11  0
     D UrlNombre       s             40a
     D UrlApellido     s             40a
     D UrlMail         s             50a
     D UrlDni          s             20a
     D UrlTelefono     s             20a
     D UrlCodPostal    s             10a
     D UrlComConHDI    s              1a
     D UrlTengoAuto    s              1a
     D UrlTengoCasa    s              1a
     D UrlTengoCome    s              1a
     D UrlTengoOtro    s              1a

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
        UrlNombre    = REST_getNextPart(url);
        UrlApellido  = REST_getNextPart(url);
        UrlMail      = REST_getNextPart(url);
        UrlDni       = REST_getNextPart(url);
        UrlTelefono  = REST_getNextPart(url);
        UrlCodPostal = REST_getNextPart(url);
        UrlComConHDI = REST_getNextPart(url);
        UrlTengoAuto = REST_getNextPart(url);
        UrlTengoCasa = REST_getNextPart(url);
        UrlTengoCome = REST_getNextPart(url);
        UrlTengoOtro = REST_getNextPart(url);

        in lda;
        if lda.empr = *blanks;
          out lda;
          if %trim(rtvSysName()) = 'SOFTTEST';
            spwliblc('I');
          else;
            spwliblc('P');
          endif;
          in lda;
        endif;
        out lda;

        tdoc = '4';
        ndoc = %trim(UrlDni);

        // Caso inverso, si es cliente hay error
        if SVPREST_chkCliente( lda.empr
                             : lda.sucu
                             : tdoc
                             : ndoc
                             : peMsgs );
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

        monitor;
          @@Tdoc = %dec(tdoc:2:0);
         on-error;
          @@Tdoc = 0;
        endmon;

        monitor;
          @@Ndoc = %dec(ndoc:11:0);
         on-error;
          @@Ndoc = 0;
        endmon;

        rc = COWLOG_logConAutoGestion( lda.empr
                                     : lda.sucu
                                     : @@Tdoc
                                     : @@Ndoc
                                     : psds.this);

        exsr GrabaDatos;

        REST_writeHeader(200);
        REST_writeEncoding();
        REST_writeXmlLine('result':'OK');
        REST_end();

        return;

        /////////////////
        begsr GrabaDatos;
        /////////////////

          clear p1hag2;

          g2unom = %trim(UrlNombre);
          g2uape = %trim(UrlApellido);
          g2umai = %trim(UrlMail);
          g2udni = %trim(UrlDni);
          g2utel = %trim(UrlTelefono);
          g2ucpo = %trim(UrlCodPostal);
          g2ucch = %trim(UrlComConHDI);
          g2uaut = %trim(UrlTengoAuto);
          g2ucas = %trim(UrlTengoCasa);
          g2ucom = %trim(UrlTengoCome);
          g2uotr = %trim(UrlTengoOtro);
          g2mar1 = *Off;
          g2frec = %dec(%date():*iso);
          g2hrec = %dec(%time():*iso);
          g2fenv = *zeros;
          g2henv = *zeros;

          write p1hag2;

        endsr;

      /end-free

      /define GETSYSV_LOAD_PROCEDURE
      /copy './qcpybooks/getsysv_h.rpgle'

