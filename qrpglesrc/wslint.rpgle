     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLINT  : Tareas generales.                                  *
      *           WebService - Retorna Datos de un Intermediario     *
      *                                                              *
      * ------------------------------------------------------------ *
      * Jorge Julio Gronda                             *17-Abr-2015  *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 22/04/2015 - Agrego validacion de parametros base        *
      * SGF 05/05/2015 - Recupero todo de tablas GAUS.               *
      *                                                              *
      * ************************************************************ *
     Fsehni201  if   e           k disk
     Fgnhda6    if   e           k disk
     Fgnhda1    if   e           k disk
     Fcntrim    if   e           k disk
     Fgntiv2    if   e           k disk
     Fcntri101  if   e           k disk
     Fcntriv    if   e           k disk
     Fgnttce    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/mail_h.rpgle'
      /copy './qcpybooks/svpmail_h.rpgle'

     D WSLINT          pr                  ExtPgm('WSLINT')
     D   peBase                            likeds(paramBase) const
     D   peDint                            likeds(pahint_t)
     D   peMint                            likeds(dsMail_t) dim(100)
     D   peMintc                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLINT          pi
     D   peBase                            likeds(paramBase) const
     D   peDint                            likeds(pahint_t)
     D   peMint                            likeds(dsMail_t) dim(100)
     D   peMintc                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1hni2          ds                  likerec(s1hni201 : *key)
     D k1trim          ds                  likerec(c1trim   : *key)
     D k1tiv2          ds                  likerec(g1tiv2   : *key)
     D k1tri101        ds                  likerec(c1tri101 : *key)
     D k1triv          ds                  likerec(c1triv   : *key)

     D x               s             10i 0
     D rc              s             10i 0
     D @@repl          s          65535a
     D @@leng          s             10i 0
     D @@mint          ds                  likeds(MailAddr_t) dim(100)
     D r1echa          s              8  0
     D r2echa          s              8  0
     D hoy             s              8  0

       *inLr = *On;

       peErro  = *Zeros;
       peMintc = *Zeros;

       hoy = (*year * 10000)
           + (*month *  100)
           +  *day;

       clear peMint;
       clear peMsgs;
       clear @@mint;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       k1hni2.n2empr = peBase.peEmpr;
       k1hni2.n2sucu = peBase.peSucu;
       k1hni2.n2nivt = peBase.peNivt;
       k1hni2.n2nivc = peBase.peNivc;

       chain %kds(k1hni2) sehni201;
       if not %found(sehni201);
          @@Repl = %char(peBase.peNivt)
                 + %char(peBase.peNivc);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'PRD0001'
                       : peMsgs
                       : %trim(@@Repl)
                       : %len(%trim(@@Repl)) );
          peErro = -1;
          return;
       endif;

       // -----------------------------------
       // Campos directos desde SEHNI201
       // -----------------------------------
       peDint.inempr = n2empr;
       peDint.insucu = n2sucu;
       peDint.innivt = n2nivt;
       peDint.innivc = n2nivc;
       peDint.innomb = dfnomb;
       peDint.indomi = dfdomi;
       peDint.inndom = dfndom;
       peDint.inpiso = dfpiso;
       peDint.indeto = dfdeto;
       peDint.incopo = dfcopo;
       peDint.incops = dfcops;
       peDint.inloca = loloca;
       peDint.inproc = prproc;
       peDint.inprod = prprod;
       peDint.incoma = n2coma;
       peDint.innrma = n2nrma;
       peDint.incuit = dfcuit;
       peDint.intido = dftido;
       if peDint.intido <= 0 or peDint.intido = 99;
          peDint.intido = 4;
       endif;
       peDint.innrdo = dfnrdo;
       peDint.ininta = n2inta;
       peDint.infiaa = n2fiaa;
       peDint.infiam = n2fiam;
       peDint.infiad = n2fiad;
       peDint.inbloq = %dec(n2bloq:1:0);
       peDint.ints20 = *zeros;
       peDint.inmatr = n2matr;

       // -----------------------------------
       // Busco todos los mails del pibe
       // -----------------------------------
       rc = SVPMAIL_xNivc( n2empr
                         : n2sucu
                         : n2nivt
                         : n2nivc
                         : @@mint
                         : *omit   );
       // ----------------------------------------
       // Clean dejando solo los validos
       // El primero de tipo 5 lo mando como
       // si fuese el único para dar compatibili-
       // dad con el viejo PAHINT...
       // ----------------------------------------
       peMintC = 0;
       for x = 1 to rc;
           if MAIL_isValid( @@mint(x).mail );
              peMintC += 1;
              peMint(peMintC).mail = @@mint(x).mail;
              peMint(peMintC).nomb = @@mint(x).nomb;
              peMint(peMintC).tipo = @@mint(x).tipo;
              chain @@mint(x).tipo gnttce;
              if %found;
                 peMint(peMintC).dtce = cedtce;
                 peMint(peMintC).mar1 = cemar1;
               else;
                 peMint(peMintC).dtce = *blanks;
                 peMint(peMintC).mar1 = *blank;
              endif;
              if (peDint.inmail = *blanks);
                 if ( @@mint(x).tipo = 5 );
                    peDint.inmail = @@mint(x).mail;
                 endif;
              endif;
           endif;
       endfor;

       // ----------------------------------------
       // Teléfonos desde DA6...
       // ----------------------------------------
       chain n2nrdf gnhda6;
       if %found;
          peDint.intel2 = dftel2;
          peDint.intel3 = dftel3;
          peDint.intel4 = dftel4;
          peDint.intel5 = dftel5;
          peDint.intel6 = dftel6;
          peDint.intel7 = dftel7;
          peDint.intel8 = dftel8;
          peDint.intel9 = dftel9;
        else;
          peDint.intel2 = *blanks;
          peDint.intel3 = *blanks;
          peDint.intel4 = *blanks;
          peDint.intel5 = *blanks;
          peDint.intel6 = *blanks;
          peDint.intel7 = *blanks;
          peDint.intel8 = *blanks;
          peDint.intel9 = *blanks;
       endif;

       // ----------------------------------------
       // Fecha de nacimiento desde DA1...
       // ----------------------------------------
       chain n2nrdf gnhda1;
       if %found;
          peDint.infnaa = dffnaa;
          peDint.infnam = dffnam;
          peDint.infnad = dffnad;
          peDint.inpaid = dfnaci;
        else;
          peDint.infnaa = 1;
          peDint.infnam = 1;
          peDint.infnad = 1;
          peDint.inpaid = *blanks;
       endif;

       // ----------------------------------------
       // Nro de ingresos brutos desde RIM...
       // ----------------------------------------
       k1trim.riempr = n2empr;
       k1trim.risucu = n2sucu;
       k1trim.ricoma = n2coma;
       k1trim.rinrma = n2nrma;
       k1trim.ritiic = 'IBR';
       setgt %kds(k1trim:5) cntrim;
       readpe %kds(k1trim:5) cntrim;
       if %eof;
          peDint.innuib = 0;
        else;
          peDint.innuib = 0;
       endif;

       // ----------------------------------------
       // Condición de IVA también desde RIM...
       // ----------------------------------------
       peDint.incaliva = 'N';
       peDint.inporiva =   0;
       peDint.inporret =   0;
       peDint.inretmin =   0;

       k1trim.ritiic = 'IVA';
       setgt %kds(k1trim:5) cntrim;
       readpe %kds(k1trim:5) cntrim;
       if not %eof and ricoi1 = 1;
          peDint.incaliva = 'S';
          // -----------------------
          // % retención de iva
          // -----------------------
          k1tiv2.i2civa = ricoi1;
          setll %kds(k1tiv2:1) gntiv2;
          reade %kds(k1tiv2:1) gntiv2;
          dow not %eof;
              peDint.inporiva = i2pivi;
           reade %kds(k1tiv2:1) gntiv2;
          enddo;
       endif;

       // -----------------------------
       // % Retención de IVA
       // -----------------------------
       if ( peDint.incaliva = 'S' );
          k1trim.ritiic = 'RIV';
          setgt  %kds(k1trim:5) cntrim;
          readpe %kds(k1trim:5) cntrim;
          if not %eof;
             k1tri101.r1empr = peDint.inempr;
             k1tri101.r1sucu = peDint.insucu;
             k1tri101.r1coma = peDint.incoma;
             k1tri101.r1nrma = peDint.innrma;
             k1tri101.r1tiic = 'RIV';
             k1tri101.r1ftia = *year;
             k1tri101.r1ftim = *month;
             k1tri101.r1ftid = *day;
             chain %kds(k1tri101) cntri101;
             if %found;
                peDint.inporret = r1poim;
              else;
                setll %kds(k1tri101) cntri101;
                readp cntri101;
                   r1echa = (r1ftia * 10000)
                          + (r1ftim *   100)
                          +  r1ftid;
                   r2echa = (r1ftha * 10000)
                          + (r1fthm *   100)
                          +  r1fthd;
                if not %eof and
                   r1empr = n2empr and
                   r1sucu = n2sucu and
                   r1coma = n2coma and
                   r1nrma = n2nrma and
                   r1tiic = 'RIV'  and
                   hoy    >= r1echa and
                   hoy    <= r2echa;
                   peDint.inporret = r1poim;
                endif;
             endif;
           if peDint.inporret = 0;
              k1triv.ivtiic = 'RIV';
              k1triv.ivcoi2 = ricoi2;
              setll %kds(k1triv:2) cntriv;
              reade %kds(k1triv:2) cntriv;
              dow not %eof;
                  peDint.inporret = ivpoim;
                  peDint.inretmin = ivretm;
               reade %kds(k1triv:2) cntriv;
              enddo;
           endif;
          endif;
       endif;

       return;
