     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLUPA : WebService: Modificar datos de un asegurado         *
      * ------------------------------------------------------------ *
      * Julio Barranco                                *01/03/2016    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     FGnhda6    uf a e           k disk
     FGnhda7    uf a e           k disk
     FGnttce    if   e           k disk
     Fsehase    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/prwase_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'

     D WSLUPA          pr                  ExtPgm('WSLUPA')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peMail                            likeds(prwaseEmail_t)const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLUPA          pi
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peAsen                       7  0 const
     D   peNtel                            likeds(prwaseTele_t) const
     D   peMail                            likeds(prwaseEmail_t)const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     Dspwliblc         pr                  extpgm('TAATOOL/SPWLIBLC')
     D ento                           1a   const

     D wrepl           s          65535a
     D actualiza       s               n

     D k1yda6          ds                  likerec(g1hda6:*key)
     D k1yda7          ds                  likerec(g1hda7:*key)
     D k1ytce          ds                  likerec(g1ttce:*key)
     D
     D                sds
     D vsuser                254    263
     D
     D

     D telef           s             20  0

       *inLr = *On;

       clear peErro;
       clear peMsgs;

       if not SVPVAL_empresa ( peEmpr );

         %subst(wrepl:1:1) = peEmpr;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0113'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;

       if not SVPVAL_sucursal ( peEmpr : peSucu );

         %subst(wrepl:1:1) = peEmpr;
         %subst(wrepl:2:2) = peSucu;

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'COW0114'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;

       endif;

      *- Valido Existencia de Asegurado
       setll peAsen sehase;
       if not %equal ( sehase );

         %subst(wrepl:1:7) = %editC(peAsen:'X');

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;

         return;
       endif;

      *- Valido telefonos ingresados
       select;

         when peNtel.nte1 <> *blanks;

           monitor;
             telef = %int(peNtel.nte1);
           on-error;
             peErro = -1;
           endmon;

         when peNtel.nte2 <> *blanks;

           monitor;
             telef = %int(peNtel.nte2);
           on-error;
             peErro = -1;
           endmon;

         when peNtel.nte3 <> *blanks;

           monitor;
             telef = %int(peNtel.nte3);
           on-error;
             peErro = -1;
           endmon;

         when peNtel.nte4 <> *blanks;

           monitor;
             telef = %int(peNtel.nte4);
           on-error;
             peErro = -1;
           endmon;

       endsl;

       if peErro <> *zeros; //falta error de teléfono

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0001'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );
         return;

       endif;

      *- Valido mail

       k1ytce.cectce = peMail.ctce;

       setll %kds( k1ytce ) Gnttce;
       if not %equal( Gnttce );

         SVPWS_getMsgs( '*LIBL'
                      : 'WSVMSG'
                      : 'PRW0025'
                      : peMsgs
                      : %trim(wrepl)
                      : %len(%trim(wrepl))  );

         peErro = -1;
         return;

       endif;

       if peMail.mail <> *blanks;

         if MAIL_isValid( peMail.mail ) = *off;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0025'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

       endif;

      *- Valido pagina Web
       if peNtel.pweb <> *blanks;

         if SVPVAL_urlIsValid ( %trim(peNtel.pweb) :
                                %len ( %trim(peNtel.pweb) ) ) = *off;

           SVPWS_getMsgs( '*LIBL'
                        : 'WSVMSG'
                        : 'PRW0032'
                        : peMsgs
                        : %trim(wrepl)
                        : %len(%trim(wrepl))  );

           peErro = -1;
           return;

         endif;

       endif;

       SPWLIBLC ('P');

       if peNtel.nte1 <> *blanks or
          peNtel.nte2 <> *blanks or
          peNtel.nte3 <> *blanks or
          peNtel.nte4 <> *blanks;

         k1yda6.dfnrdf = peAsen;

         chain %kds ( k1yda6 ) gnhda6;
         if %found( gnhda6 );

           if peNtel.nte1 <> *blanks;
             dftel2 =  peNtel.nte1;
           endif;

           if peNtel.nte1 <> *blanks;
             dftel4 =  peNtel.nte2;
           endif;

           if peNtel.nte1 <> *blanks;
             dftel6 =  peNtel.nte3;
           endif;

           if peNtel.nte1 <> *blanks;
             dftel8 =  peNtel.nte4;
           endif;

           if peNtel.pweb <> *blanks;
             dfpweb =  peNtel.pweb;
           endif;

           dfuser =  vsuser;
           dfdate =  udate;
           dftime =  %dec(%time);

           update g1hda6;

         endif;

       endif;

       if peMail.mail <> *blanks;

         k1yda7.dfnrdf = peAsen;
         k1yda7.dfctce = peMail.ctce;
         k1yda7.dfmail = peMail.mail;

         chain %kds ( k1yda7 : 3 ) gnhda7;
         if %found( gnhda7 );
           actualiza = *on;
           dfmail =  peMail.mail;
         else;
           actualiza = *off;
           clear g1hda7;
           dfnrdf =  peAsen;
           dfctce =  peMail.ctce;
           dfmail =  peMail.mail;
           dfmar1 =  '0';
           dfmar2 =  '0';
           dfmar3 =  '0';
           dfmar4 =  '0';
           dfmar5 =  '0';
           dfmar6 =  '0';
           dfmar7 =  '0';
           dfmar8 =  '0';
           dfmar9 =  '0';
           dfmar0 =  '0';
         endif;

           dfuser =  vsuser;
           dfdate =  udate;
           dftime =  %dec(%time);

           if actualiza = *off;
             write g1hda7;
           else;
             update g1hda7;
           endif;

       endif;

       return;

