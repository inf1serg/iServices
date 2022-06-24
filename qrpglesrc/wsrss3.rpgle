     H option(*srcstmt:*noshowcpy:*nodebugio: *nounref)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRSS3: Requerimiento SSN                                    *
      *         AUTOS - Siniestro Dígital SSN Actualiza datos (POST) *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                               *13-Ene-2020  *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fssns01    uf   e           k disk

      * Parametros de entrada ---------------------------------- *
     D empr            s              1a
     D sucu            s              2a
     D rama            s              2a
     D sini            s              7a
     D nops            s              7a
     D expe            s             40a
     D codi            s              2a
     D obse            s            300a
     D envi            s              1a

      * Claves -------------------------------------------------- *
     D k1ys01          ds                  likerec( s1ns01 : *key )

      * Variable    --------------------------------------------- *
     D rc              s               n
     D r1              s             10i 0
     D uri             s            512a
     D url             s           3000a   varying
     D wrepl           s          65535a
     d buffer          s          65535a
     d options         s            100a
     d peValu          s           1024a
     d peVsys          s            512a
     d prt_enc         s              1n

      * Estructuras --------------------------------------------- *
     D peMsgs          ds                  likeds( paramMsgs )
     D peBase          ds                  likeds( paramBase )

     D req             ds                  qualified
     D  expe                         40a
     D  codi                          2a
     D  obse                        300a
     D  envi                          1a

      * Informacion de Sistema ---------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay( psds : 1 )
     D  job                          26a   overlay( psds : 244 )

     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)
     D  sucu                          2a   overlay(Local:*next)

     D wslog           pr                  extpgm('QUOMDATA/WSLOG')
     D msg                          512a   const

     D sleep           pr            10u 0 extproc('sleep')
     D  secs                         10u 0 value

      * Procedimientos ------------------------------------------ *

      * Copy's -------------------------------------------------- *
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

      /free

        *inlr = *on;

        prt_enc = *on;
        if SVPVLS_getValSys( 'HWSRSS3' : *omit : peVsys );
           if (peVsys <> 'S');
              prt_enc = *off;
           endif;
        endif;

        options = 'doc=string path=req +
                   case=any allowextra=yes allowmissing=yes';

        REST_getEnvVar('REQUEST_METHOD':peValu);

        if %trim(peValu) <> 'POST';
           REST_writeHeader( 405
                           : *omit
                           : *omit
                           : *omit
                           : *omit
                           : *omit  );
           REST_end();
           close *all;
           return;
        endif;

        rc  = REST_getUri( psds.this : uri );
        if rc = *off;
           return;
        endif;
        url = %trim( uri );

        // ------------------------------------------ //
        // Obtener los parámetros de la URL           //
        // ------------------------------------------ //
        empr = REST_getNextPart(url);
        sucu = REST_getNextPart(url);
        rama = REST_getNextPart(url);
        sini = REST_getNextPart(url);
        nops = REST_getNextPart(url);

        r1 = REST_readStdInput( %addr(buffer): %len(buffer) );

        monitor;
            xml-into req %xml( buffer : options);
         on-error;
            REST_writeHeader( 204
                            : *omit
                            : *omit
                            : 'RPG0000'
                            : 40
                            : 'Error al parsear XML'
                            : 'Error al parsear XML' );
            REST_end();
            close *all;
            return;
        endmon;

        k1ys01.s1Empr = empr;
        k1ys01.s1Sucu = sucu;
        monitor;
          k1ys01.s1Rama = %int( rama );
          k1ys01.s1Sini = %int( sini );
          k1ys01.s1Nops = %int( nops );
        on-error;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'SSN0001'
                       : peMsgs
                       : %trim(wrepl)
                       : %len(%trim(wrepl))  );
          REST_writeHeader( 400
                          : *omit
                          : *omit
                          : peMsgs.peMsid
                          : peMsgs.peMsev
                          : peMsgs.peMsg1
                          : peMsgs.peMsg2 );
          REST_end();
          SVPREST_end();
          return;
        endmon;
        chain %kds( k1ys01 : 5 ) ssns01;
        if not %found( ssns01 );
          //error...
          REST_writeHeader( 204
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit
                          : *omit );
          REST_end();
          SVPREST_end();
          return;
        endif;

        s1expe = req.expe;
        %subst(s1expe:18:3) = '   ';
        s1code = req.codi;
        s1obse = req.obse;
        if %trim(s1obse) = 'NULL' or
           %trim(s1obse) = '_';
           s1obse = *blanks;
        endif;
        if req.envi ='S';
           s1proc = '1';
        else;
           s1proc = '0';
        endif;
        if s1expe = *blanks;
           s1proc = '0';
        endif;
        s1data = %dec(%date():*iso);
        s1tima = %dec(%time():*iso);

        update s1ns01;

        REST_writeHeader();
        if prt_enc;
           REST_writeEncoding();
        endif;
        REST_writeXmlLine('result':'OK');
        REST_end();
        SVPREST_end();
        return;

      /end-free
