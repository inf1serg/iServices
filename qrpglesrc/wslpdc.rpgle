     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLPDC : WebService: Listado de Proveedores de Confianza     *
      * ------------------------------------------------------------ *
      * Alvarez Fernando                              *29/02/2016    *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * ************************************************************ *
     Fcntnau05  if   e           k disk
     Fgnhdaf    if   e           k disk
     Fgntloc    if   e           k disk
     Fgntpro    if   e           k disk
     Fgnttce    if   e           k disk

      /copy './qcpybooks/wsstruc_h.rpgle'
      /copy './qcpybooks/svpval_h.rpgle'
      /copy './qcpybooks/svpcob_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D WSLPDC          pr                  ExtPgm('WSLMSA')
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(dsProv_t) const
     D   pePreg                            likeds(dsProv_t)
     D   peUreg                            likeds(dsProv_t)
     D   peProv                            likeds(dsProv_t) dim(99)
     D   peProvC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPDC          pi
     D   peEmpr                       1    const
     D   peSucu                       2    const
     D   peCant                      10i 0 const
     D   peRoll                       1    const
     D   pePosi                            likeds(dsProv_t) const
     D   pePreg                            likeds(dsProv_t)
     D   peUreg                            likeds(dsProv_t)
     D   peProv                            likeds(dsProv_t) dim(99)
     D   peProvC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@more          s               n
     D @@cant          s             10i 0
     D wrepl           s          65535a
     D rc              s             10i 0
     D x               s             10i 0

     D @@mase          ds                  likeds(MailAddr_t) dim(100)

     D k1ynau          ds                  likeRec(c1tnau:*key)
     D k1yloc          ds                  likeRec(g1tloc:*key)

       *inLr = *On;

       clear peProv;
       clear peProvC;
       clear peErro;
       clear peMsgs;

       @@more = *On;

      *- Validaciones
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

      *- Valido Parametro Forma de Paginado
       if not SVPWS_chkRoll ( peRoll : peMsgs );
         peErro = -1;
         return;
       endif;

      *- Valido Cantidad de Lineas a Retornar
       @@cant = peCant;
       if ( ( peCant <= *Zeros ) or ( peCant > 99 ) );
         @@cant = 99;
       endif;

      *- Posicionamiento en archivo
       exsr posArc;

      * Retrocedo si es paginado 'R'
       exsr retPag;

       read cntnau05;

       exsr priReg;

       dow ( ( not finArc ) and ( peProvC < @@cant ) );

         if nabloq = 'N';

           peProvC += 1;

           chain nanrdf gnhdaf;

           peProv(peProvC).coma = nacoma;
           peProv(peProvC).nrma = nanrma;
           peProv(peProvC).nomb = dfnomb;
           peProv(peProvC).domi = dfdomi;
           peProv(peProvC).copo = dfcopo;
           peProv(peProvC).cops = dfcops;

           k1yloc.locopo = dfcopo;
           k1yloc.locops = dfcops;
           chain %kds( k1yloc ) gntloc;

           peProv(peProvC).loca = loloca;
           peProv(peProvC).proc = loproc;

           chain loproc gntpro;

           peProv(peProvC).prod = prprod;

           rc = SVPMAIL_xNrDaf ( dfnrdf : @@mase : *Omit );

           if rc > 10;
             rc = 10;
           endif;

           for x = 1 to rc;

             if MAIL_isValid(@@mase(x).mail);

               peProv(peProvC).mail(x).mail = @@Mase(x).mail;
               peProv(peProvC).mail(x).nomb = @@Mase(x).nomb;
               peProv(peProvC).mail(x).tipo = @@Mase(x).tipo;
               chain @@Mase(x).tipo gnttce;

               if %found ( gnttce );
                 peProv(peProvC).mail(x).dtce = cedtce;
                 peProv(peProvC).mail(x).mar1 = cemar1;
               else;
                 peProv(peProvC).mail(x).dtce = *Blanks;
                 peProv(peProvC).mail(x).mar1 = *Blanks;
               endif;

             endif;

           endfor;

           exsr UltReg;

         endif;

         read cntnau05;

       enddo;

       select;
         when ( peRoll = 'R' );
           peMore = @@more;
         when %eof ( cntnau05 )
         or %eof( cntnau05 )
         or %eof( cntnau05 );
           peMore = *Off;
         other;
           peMore = *On;
       endsl;

       return;

      *- Rutina de Posicionamiento de Archivo. Segun pePosi, peRoll
       begsr posArc;

         k1ynau.naempr = peEmpr;
         k1ynau.nasucu = peSucu;
         k1ynau.nacoma = pePosi.coma;
         k1ynau.nanrma = pePosi.nrma;

         if ( peRoll = 'F' );
           setgt %kds ( k1ynau : 4 ) cntnau05;
         else;
           setll %kds ( k1ynau : 4 ) cntnau05;
         endif;

       endsr;

      *- Rutina de Posicionamiento en Comienzo de Archivo
       begsr retPag;

       if ( peRoll = 'R' );
         readp cntnau05;
         dow ( ( not finArc ) and ( @@cant > 0 ) );
           @@cant -= 1;
           readp cntnau05;
         enddo;
         if finArc;
           @@more = *Off;
           setll *Start cntnau05;
         endif;
         @@cant = peCant;
         if (@@cant <= 0 or @@cant > 99);
            @@cant = 99;
         endif;
       endif;

       endsr;

      *- Rutina que graba el Primer Registro
       begsr priReg;

         pePreg.coma = nacoma;
         pePreg.nrma = nanrma;

       endsr;

      *- Rutina que graba el Ultimo Registro
       begsr ultReg;

         peUreg.coma = nacoma;
         peUreg.nrma = nanrma;

       endsr;

      *- Rutina que determina si es Fin de Archivo
     P finArc          B
     D finArc          pi              n

         return %eof ( cntnau05 );

     P finArc          E
