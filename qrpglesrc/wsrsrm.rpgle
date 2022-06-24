     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSRSRM: QUOM Versión 2                                       *
      *         Datos de Servidor de mail.                           *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                     *02-Ene-2018            *
      * ************************************************************ *

      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'

     D WSLSMA          pr                  ExtPgm('WSLSMA')
     D  peServ                       50a
     D  peUser                       50a
     D  pePass                       50a
     D  peFrom                             likeds(wslsma_from)
     D  peSubj                       70a
     D  peRece                             likeds(wslsma_rece) dim(100)
     D  peReceC                      10i 0

     D peServ          s             50a
     D peUser          s             50a
     D pePass          s             50a
     D peFrom          ds                  likeds(wslsma_from)
     D peSubj          s             70a
     D peRece          ds                  likeds(wslsma_rece) dim(100)
     D peReceC         s             10i 0

     D wslsma_from     ds                  qualified based(template)
     D  nomb                         40a
     D  mail                         50a

     D wslsma_rece     ds                  qualified based(template)
     D  nomb                         40a
     D  mail                         50a
     D  tipo                         10i 0

     D psds           sds                  qualified
     D  this                         10a   overlay(psds:1)

      /free

       *inlr = *on;

       WSLSMA( peServ
             : peUser
             : pePass
             : peFrom
             : peSubj
             : peRece
             : peReceC );

       REST_writeHeader();
       REST_writeEncoding();
       REST_writeXmlLine( 'servidorMail' : '*BEG');

       REST_writeXmlLine( 'servidor' : %trim(peServ) );
       REST_writeXmlLine( 'usuario'  : %trim(peUser) );
       REST_writeXmlLine( 'password' : %trim(pePass) );

       REST_writeXmlLine( 'servidorMail' : '*END');

       REST_end();

       return;

      /end-free
