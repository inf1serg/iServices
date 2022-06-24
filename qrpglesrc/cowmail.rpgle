     H dftactgrp(*NO)
     H option(*srcstmt: *nodebugio: *noshowcpy: *nounref)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COWMAIL: Envía mail a productor para avisar que se emitio    *
      *          una cotización AP transito                          *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                     *28-Jun-2021            *
      * ************************************************************ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/ifsio_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/cowgrai_h.rpgle'

     D COWMAIL         pr
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const

     D COWMAIL         pi
     D  peBase                             likeds(paramBase) const
     D  peNctw                        7  0 const

     D SNDMAIL         pr                  ExtPgm('SNDMAIL')
     D  peCprc                       20a   const
     D  peCspr                       20a   const
     D  peMens                      512a   varying options(*nopass:*omit)
     D  peLmen                     5000a   options(*nopass:*omit)

     D peCprc          s             20a   inz('QUOM_MAILS')
     D peCspr          s             20a   inz('AUTOGEST_EMIAP')
     D peRprp          ds                  likeds(RecPrp_t) dim(100)
     D peRemi          ds                  likeds(Remitente_t)
     D err             ds                  likeds(MAIL_ERDS_T)
     D peMadd          ds                  likeds(MailAddr_t) dim(100)
     D peSubj          s             70a   varying
     D peMens          s            512a   varying
     D peLmen          s           5000a
     D TIPO_MAIL       s              2  0 inz(5)
     D @@DsCtw         ds                  likeds(dsctw000_t)
     D @@Asen          s              7  0
     D @@Nase          s             40a

     D peTo            s             50a   dim(100)
     D peToad          s            256a   dim(100)
     D peToty          s             10i 0 dim(100)
     D peAttf          s            255a   dim(10)
     D peAttn          s            256a   dim(10)
     D peSspo          s              3  0 inz(0)
     D rc              s             10i 0
     D x               s             10i 0
     D z               s             10i 0

     D @PsDs          sds                  qualified
     D  JobName                      10a   overlay(@PsDs:244)

      /free

       *inlr = *on;

       rc = MAIL_getFrom( peCprc: peCspr: peRemi );
       rc = MAIL_getSubject( peCprc: peCspr: peSubj );

       if ( MAIL_isLongBody( peCprc : peCspr ) = *ON );
          rc = MAIL_getLBody( peCprc : peCspr : peLmen );
        else;
          rc = MAIL_getBody( peCprc : peCspr : peMens );
          peLmen = %trim(peMens);
       endif;

       clear @@DsCtw;

       if COWGRAI_getCtw000( peBase : peNctw : @@DsCtw );
         @@Asen = SPVSPO_getAsen( peBase.peEmpr
                                : peBase.peSucu
                                : @@DsCtw.w0Arcd
                                : @@DsCtw.w0Spol
                                : peSspo         );

         @@Nase = SVPDAF_getNombre( @@Asen );
         peLmen = %scanrpl( '%NASE%' : %trim(@@Nase) : peLmen );
       endif;

       z = SVPMAIL_xNivc( peBase.peEmpr
                        : peBase.peSucu
                        : peBase.peNivt
                        : peBase.peNivc
                        : peMadd
                        : TIPO_MAIL );
       for x = 1 to z;
           peTo(x)   = peMadd(x).nomb;
           peToad(x) = peMadd(x).mail;
           peToty(x) = 0;
       endfor;

       rc = MAIL_sndLmail( peRemi.From
                         : peRemi.Fadr
                         : peSubj
                         : peLmen
                         : 'H'
                         : peTo
                         : peToad
                         : peToty );

      /end-free
