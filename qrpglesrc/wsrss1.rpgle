     H option(*srcstmt:*noshowcpy:*nodebugio: *nounref)
     H actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRSS1: RM#03689 Requerimiento SSN                           *
      *         AUTOS - Póliza Dígital SSN Actualiza datos           *
      * ------------------------------------------------------------ *
      * Luis R. Gómez                                  * 30-Ago-2018 *
      * ------------------------------------------------------------ *
      * Modificiones:                                                *
      * SGF 09/12/2019: Reemplazo "_" por blancos en expediente.     *
      *                 Si viene "_" o "NULL" en obse, va blanco.    *
      *                 Si expendiente es blanco, proc = '0'.        *
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
     D uri             s            512a
     D url             s           3000a   varying
     D wrepl           s          65535a

      * Estructuras --------------------------------------------- *
     D peMsgs          ds                  likeds( paramMsgs )
     D peBase          ds                  likeds( paramBase )

      * Informacion de Sistema ---------------------------------- *
     D psds           sds                  qualified
     D  this                         10a   overlay( psds : 1 )

     D Local           ds                  dtaara(*lda) qualified
     D  empr                          1a   overlay(Local:401)
     D  sucu                          2a   overlay(Local:*next)

      * Procedimientos ------------------------------------------ *

      // Log de llamadas...
     D WSLOG           pr                  extpgm('WSLOG')
     D   MS                         512

      // Procedimiento para debug...
     D sleep           pr            10u 0 extproc('sleep')
     D  secs                         10u 0 value

      * Copy's -------------------------------------------------- *
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'

      /free

        *inlr = *on;

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
        codi = REST_getNextPart(url);
        obse = REST_getNextPart(url);
        envi = REST_getNextPart(url);
        expe = REST_getNextPart(url);

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

        p0expe = expe;
        %subst(p0expe:18:3) = '   ';
        p0code = codi;
        p0obse = obse;
        if %trim(p0obse) = 'NULL' or
           %trim(p0obse) = '_';
           p0obse = *blanks;
        endif;
        if envi ='S';
          p0proc = '1';
        else;
          p0proc = '0';
        endif;
        if p0expe = *blanks;
           p0proc = '0';
        endif;
        if p0expe <> *blanks;
           p0obse = *blanks;
           p0code = ' ';
           p0proc = '1';
        endif;

        update s1np01;

        REST_writeHeader();
        REST_writeEncoding();
        REST_writeXmlLine('result':'OK');
        REST_end();
        SVPREST_end();
        return;

      /end-free
