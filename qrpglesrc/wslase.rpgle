     H option(*nodebugio: *srcstmt: *noshowcpy)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSPASE  : WebService - Retorna Datos de un Asegurado         *
      * ------------------------------------------------------------ *
      * CSz 16-Abr-2015                                              *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 21/04/2015 - Agrego validacion de parametros base        *
      * SFA 04/05/2015 - Cambio parametro peMase.                    *
      * SGF 05/05/2015 - Recupero todo desde archivos GAUS.          *
      * SFA 01/06/2016 - Retorno nuevos campos de GNHDA1             *
      * SGF 28/07/2016 - PAHASE es PAHAS1.                           *
      * SGF 19/08/2016 - Si el asegurado no pertenece al productor   *
      *                  retorna todo en blanco.                     *
      * JSN 29/01/2019 - Retorno campo asbloq de SEHASE              *
      *                                                              *
      * ************************************************************ *
     Fpahas1    if   e           k disk

     Fsehase    if   e           k disk
     Fgntloc02  if   e           k disk
     Fgnttdo    if   e           k disk
     Fgntesc    if   e           k disk
     Fgnhdaf    if   e           k disk
     Fgnhda1    if   e           k disk
     Fgnhda2    if   e           k disk
     Fgnhda6    if   e           k disk
     Fgntsex    if   e           k disk
     Fgntiv1    if   e           k disk
     Fgnttce    if   e           k disk
     Fgnttis    if   e           k disk
     Fgntpai    if   e           k disk
     Fgntrae    if   e           k disk
     Fgntprf    if   e           k disk
     Fgnhda8    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpMail_H.rpgle'
      /copy './qcpybooks/mail_h.rpgle'

     D WSLASE          pr                  ExtPgm('WSLASE')
     D   peBase                            likeds(paramBase) const
     D   peAsen                            like(asasen)const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(100)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLASE          pi
     D   peBase                            likeds(paramBase) const
     D   peAsen                            like(asasen) const
     D   peDase                            likeds(pahase_t)
     D   peMase                            likeds(dsMail_t) dim(100)
     D   peMaseC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Leng          s             10i 0
     D @Mase           ds                  likeds(MailAddr_t) dim(100)
     D x               s             10i 0
     D rc              s             10i 0
     D tmp_nib1        s             13
     D tmp_nib2        s             13
     D tmp_nib3        s             13
     D tmp_nib4        s             13
     D xpain           s              5  0 inz(6)
     D @paid           s             30a

     D k1yase          ds                  likerec(p1has1:*key)

     D k1tloc          ds                  likerec(g1tloc02 : *key)

       *inLr = *On;

       clear peDase;
       clear peMase;
       clear peMaseC;
       clear peErro;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       k1yase.asempr = peBase.peEmpr;
       k1yase.assucu = peBase.peSucu;
       k1yase.asnivt = peBase.peNivt;
       k1yase.asnivc = peBase.peNivc;
       k1yase.asasen = peAsen;
       setll %kds ( k1yase ) pahas1;
       if not %equal ( pahas1 );
          return;
       endif;

       chain peAsen sehase;
       if not %found;
          @@Repl = %editC ( peAsen : '4' : *ASTFILL )  +
                   %char( peBase.peNivt ) + %char( peBase.peNivc );
          @@Leng = %len ( %trim ( @@repl ) );
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'ASE0001' :
                           peMsgs : @@Repl  : @@Leng );
          eval peErro = -1;
          clear peDase;
          return;
       endif;

       // ---------------------------
       // Datos directos desde SEHASE
       // ---------------------------
       peDase.asempr = peBase.peEmpr;
       peDase.assucu = peBase.peSucu;
       peDase.asnivt = peBase.peNivt;
       peDase.asnivc = peBase.peNivc;
       peDase.asasen = peAsen;
       peDase.asciva = asciva;
       peDase.asruta = asruta;
       peDase.asfein = asfein;
       peDase.asnrin = asnrin;
       peDase.asfeco = asfeco;
       peDase.asbloq = asBloq;

       // ---------------------------
       // Datos desde GNHDAF
       // ---------------------------
       chain asasen gnhdaf;
       if %found;
          peDase.asnomb = dfnomb;
          peDase.asdomi = dfdomi;
          peDase.astido = dftido;
          peDase.asnrdo = dfnrdo;
          peDase.ascuit = dfcuit;
          peDase.ascopo = dfcopo;
          peDase.ascops = dfcops;
          peDase.astiso = dftiso;
          peDase.ascuil = dfnjub;
        else;
          peDase.asnomb = *blanks;
          peDase.asdomi = *blanks;
          peDase.astido = 0;
          peDase.asnrdo = 0;
          peDase.ascuit = *blanks;
          peDase.ascopo = 0;
          peDase.ascops = 0;
          peDase.astiso = 0;
          peDase.ascuil = 0;
       endif;

       k1tloc.locopo = peDase.ascopo;
       k1tloc.locops = peDase.ascops;
       chain %kds(k1tloc:2) gntloc02;
       if %found;
          peDase.asloca = loloca;
          peDase.asprod = prprod;
          peDase.asproc = loproc;
        else;
          peDase.asloca = *blanks;
          peDase.asprod = *blanks;
          peDase.asproc = *blanks;
       endif;

       chain peDase.astido gnttdo;
       if %found;
          peDase.asdatd = gndatd;
        else;
          peDase.asdatd = *blanks;
       endif;

       // ---------------------------
       // Datos desde GNHDA1
       // ---------------------------
       peDase.asfnac = 0;
       peDase.ascesc = 0;
       peDase.asmar5 = 'N';
       peDase.asdsex = *blanks;
       peDase.asdesc = *blanks;
       peDase.astel2 = *blanks;
       peDase.ascnac = *Zeros;
       peDase.aslnac = *blanks;
       peDase.ascprf = 0;
       peDase.asdprf = *blanks;
       peDase.asraae = 0;
       peDase.asdeae = *blanks;
       peDase.aspaid = *blanks;
       peDase.aspain = 6;
       chain asasen gnhda1;
       if %found;
          peDase.asfnac = (dffnaa * 10000) + (dffnam * 100) + dffnad;
          peDase.ascesc = dfesci;
          peDase.asmar5 = dfmar5;
          peDase.assexo = dfsexo;
          peDase.ascnac = dfcnac;
          peDase.aslnac = dflnac;
          peDase.ascprf = dfcprf;
          peDase.asraae = dfraae;
          peDase.aspaid = dfnaci;
          chain dfsexo gntsex;
          if %found;
             peDase.asdsex = sedsex;
          endif;
          chain dfesci gntesc;
          if %found;
             peDase.asdesc = esdesc;
          endif;
          chain dfcprf gntprf;
          if %found;
             peDase.asdprf = prdprf;
          endif;
          chain dfraae gntrae;
          if %found;
             peDase.asdeae = aedeae;
          endif;
          @paid = dfnaci;
          chain xpain gntpai;
          if %found;
             peDase.aspaid = papaid;
          endif;
       endif;

       // ---------------------------------
       // IVA
       // ---------------------------------
       chain peDase.asciva gntiv1;
       if %found;
          peDase.asncil = i1ncil;
        else;
          peDase.asncil = *blanks;
       endif;

       // ---------------------------------
       // Tipo de Sociedad
       // ---------------------------------
       chain peDase.astiso gnttis;
       if %found;
          peDase.asdtis = gndtis;
        else;
          peDase.asdtis = *blanks;
       endif;

       // ---------------------------------
       // Los teléfonos desde DA6...
       // ---------------------------------
       chain asasen gnhda6;
       if %found;
          peDase.astel2 = %trim(dftel2);
          peDase.astel3 = %trim(dftel3);
          peDase.astel4 = %trim(dftel4);
          peDase.astel5 = %trim(dftel5);
          peDase.astel6 = %trim(dftel6);
          peDase.astel7 = %trim(dftel7);
          peDase.astel8 = %trim(dftel8);
          peDase.astel9 = %trim(dftel9);
          peDase.aspweb = %trim(dfpweb);
       endif;

       // ---------------------------
       // Datos desde GNHDA2
       // ---------------------------
       peDase.asnnib = *blanks;
       chain asasen gnhda2;
       if %found;
          tmp_nib1 = %editc(dfnri1:'X');
          tmp_nib2 = %editc(dfnri2:'X');
          tmp_nib3 = %editc(dfnri3:'X');
          tmp_nib4 = %editc(dfnri4:'X');
          select;
           when %subst(dfnnib:1:4) = '0009';
                peDase.asnnib = dfnnib;
           when %subst(tmp_nib4:1:4) = '0009';
                peDase.asnnib = tmp_nib4;
           when %subst(tmp_nib3:1:4) = '0009';
                peDase.asnnib = tmp_nib3;
           when %subst(tmp_nib2:1:4) = '0009';
                peDase.asnnib = tmp_nib2;
           when %subst(tmp_nib1:1:4) = '0009';
                peDase.asnnib = tmp_nib1;
           when dfnnib <> ' ' and %len(dfnnib) > 4;
                peDase.asnnib = dfnnib;
           when dfnri4 <> 0;
                peDase.asnnib = tmp_nib4;
           when dfnri3 <> 0;
                peDase.asnnib = tmp_nib3;
           when dfnri2 <> 0;
                peDase.asnnib = tmp_nib2;
           when dfnri1 <> 0;
                peDase.asnnib = tmp_nib1;
          endsl;
          for x = 1 to 14;
              if %subst(peDase.asnnib:x:1) = '0';
                 %subst(peDase.asnnib:x:1) = ' ';
               else;
                 leave;
              endif;
          endfor;
          peDase.asnnib = %trim(peDase.asnnib);
       endif;

       // ---------------------------
       // Los mails...
       // ---------------------------
       rc = SVPMAIL_xNrDaf ( peAsen
                           : @Mase
                           : *omit  );
       for x = 1 to rc;
           if MAIL_isValid(@Mase(x).mail);
              peMaseC += 1;
              peMase(x).mail = @Mase(x).mail;
              peMase(x).nomb = @Mase(x).nomb;
              peMase(x).tipo = @Mase(x).tipo;
              chain @Mase(x).tipo gnttce;
              if %found;
                 peMase(x).dtce = cedtce;
                 peMase(x).mar1 = cemar1;
               else;
                 peMase(x).dtce = *blanks;
                 peMase(x).mar1 = *blank;
              endif;
           endif;
       endfor;

       // ---------------------------
       // CBU de Siniestros
       // ---------------------------
       peDase.ascbus = 0;
       setgt  peAsen gnhda8;
       readpe peAsen gnhda8;
       dow not %eof;
           if dfmar1 = '1';
              peDase.ascbus = %dec(dfncbu:22:0);
              leave;
           endif;
        readpe peAsen gnhda8;
       enddo;

       return;
