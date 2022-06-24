     H option(*srcstmt:*noshowcpy:*nodebugio: *nounref)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRSS2: Requerimiento SSN                                    *
      *         AUTOS - Póliza Dígital SSN Actualiza datos (POST)    *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *29-Nov-2019  *
      * ------------------------------------------------------------ *
      * SGF 09/12/2019: Reemplazo "_" por blancos en expediente.     *
      *                 Si viene "_" o "NULL" en obse, va blanco.    *
      *                 Si expendiente es blanco, proc = '0'.        *
      * SGF 11/12/2019: Eliminar encoding.                           *
      * SGF 27/10/2021: Nueva versión SOFT de SSN.                   *
      *                                                              *
      * ************************************************************ *
     Fssnp01    uf   e           k disk

      * Parametros de entrada ---------------------------------- *
     D empr            s              1a
     D sucu            s              2a
     D arcd            s              6a
     D spol            s              9a
     D supl            s              3a
     D rama            s              2a
     D arse            s              2a
     D oper            s              7a
     D suop            s              3a
     D expe            s             40a
     D codi            s              2a
     D obse            s            300a
     D envi            s              1a

      * Claves -------------------------------------------------- *
     D k1yf11          ds                  likerec( s1np01 : *key )

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
     D  expe                         26a
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

      * Procedimientos ------------------------------------------ *

      * Copy's -------------------------------------------------- *
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

      /free

        *inlr = *on;

        prt_enc = *on;
        if SVPVLS_getValSys( 'HWSRSS2' : *omit : peVsys );
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
        arcd = REST_getNextPart(url);
        spol = REST_getNextPart(url);
        supl = REST_getNextPart(url);
        rama = REST_getNextPart(url);
        arse = REST_getNextPart(url);
        oper = REST_getNextPart(url);
        suop = REST_getNextPart(url);

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

        k1yf11.p0empr = empr;
        k1yf11.p0sucu = sucu;
        monitor;
          k1yf11.p0arcd = %int( arcd );
          k1yf11.p0spol = %int( spol );
          k1yf11.p0sspo = %int( supl );
          k1yf11.p0rama = %int( rama );
          k1yf11.p0arse = %int( arse );
          k1yf11.p0oper = %int( oper );
          k1yf11.p0suop = %int( suop );
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
        chain %kds( k1yf11 : 9 ) ssnp01;
        if not %found( ssnp01 );
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

        p0expe = req.expe;
        //%subst(p0expe:18:3) = '   ';
        p0code = req.codi;
        p0obse = req.obse;
        if %trim(p0obse) = 'NULL' or
           %trim(p0obse) = '_';
           p0obse = *blanks;
        endif;
        if req.envi ='S';
           p0proc = '1';
        else;
           p0proc = '0';
        endif;
        if p0expe = *blanks;
           p0proc = '0';
        endif;

        update s1np01;

        REST_writeHeader();
        if prt_enc;
           REST_writeEncoding();
        endif;
        REST_writeXmlLine('result':'OK');
        REST_end();
        SVPREST_end();
        return;

      /end-free
