     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * WSLSMA:  WebService                                          *
      *          Retorna Parámetros                                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *07-Oct-2015        *
      * ------------------------------------------------------------ *
      * SGF 12/08/2016: Rescatar todo de DTAARA.                     *
      *                                                              *
      * ************************************************************ *

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

     D WSLSMA          pi
     D  peServ                       50a
     D  peUser                       50a
     D  pePass                       50a
     D  peFrom                             likeds(wslsma_from)
     D  peSubj                       70a
     D  peRece                             likeds(wslsma_rece) dim(100)
     D  peReceC                      10i 0

     D wslsma_from     ds                  qualified based(template)
     D  nomb                         40a
     D  mail                         50a

     D wslsma_rece     ds                  qualified based(template)
     D  nomb                         40a
     D  mail                         50a
     D  tipo                         10i 0

     D rc              s             10i 0
     D x               s             10i 0
     D peCprc          s             20a   inz('ALTABAJANOMINA')
     D peCspr          s             20a   inz('ALTABAJANOMINA')
     D p2Subj          s             70a   varying
     D AS400Sys        s             10a
     D peRemi          ds                  likeds(Remitente_t)
     D peRprp          ds                  likeds(recprp_t) dim(100)

     D conexion        ds                  dtaara('DTASMA01') qualified
     D  user                         50a   overlay(conexion:1)
     D  pass                         50a   overlay(conexion:*next)
     D  serv                         50a   overlay(conexion:*next)

      /free

       *inlr = *on;

       clear peFrom;
       clear peSubj;
       clear peRece;
       clear peServ;
       clear peUser;
       clear pePass;
       peReceC = 0;

       in conexion;
       unlock conexion;

       peUser = conexion.user;
       pePass = conexion.pass;
       peServ = conexion.serv;

       // ---------------------------------------------
       // Busco From
       // ---------------------------------------------
       rc = MAIL_getFrom( peCprc : peCspr : peRemi );
       peFrom.nomb = peRemi.from;
       peFrom.mail = peRemi.fadr;

       // ---------------------------------------------
       // Busco asunto
       // ---------------------------------------------
       rc = MAIL_getSubject( peCprc : peCspr : p2Subj );
       peSubj = %trim(p2Subj);

       // ---------------------------------------------
       // Busco destinatarios
       // ---------------------------------------------
       rc = MAIL_getReceipt( peCprc : peCspr : peRprp : *ON );
       peReceC = rc;
       for x = 1 to rc;
           peRece(x).nomb = peRprp(x).rpnomb;
           peRece(x).mail = peRprp(x).rpmail;
           peRece(x).tipo = %int(peRprp(x).rpma01);
       endfor;

       return;

      /end-free
