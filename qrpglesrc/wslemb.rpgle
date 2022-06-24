     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLEMB  : WebService - Retorna Datos de una Embarcacion      *
      * ------------------------------------------------------------ *
      * CSz 24-Abr-2015                                              *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * SFA 05/05/15 - Agrego validacion de parametro Base           *
      * SFA 06/05/15 - Modifico para que tome datos desde GAUS       *
      * SFA 28/05/15 - Modifico LikeRec por LikeDs                   *
      * ************************************************************ *
     Fgntloc    if   e           k disk
     Fgntpai    if   e           k disk
     Fset061    if   e           k disk
     Fset0611   if   e           k disk
     Fset0612   if   e           k disk
     Fpaher9296 if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLEMB          pr                  ExtPgm('WSLEMB')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peDemb                            likeds(barcos_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLEMB          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peDemb                            likeds(barcos_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@Repl          s          65535a
     D @@Poco          s              6s 0
     D @@Leng          s             10i 0
     D fecha_char      s              8a
     D aÑo_char        s              4a
     D mes_char        s              2a
     D dia_char        s              2a

     D k1yer92         ds                  likerec(p1her92:*key)
     D k1t0611         ds                  likerec(s1t0611:*key)
     D k1t0612         ds                  likerec(s1t0612:*key)
     D k1tloc          ds                  likerec(g1tloc:*key)

       *inLr = *On;

       clear peErro;
       clear peMsgs;
       clear peDemb;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

 b1    if peRama <> 17;
         @@Repl = %editw( peRama : '0 ' )
                + %editw( pePoli : '     0 ' );
         @@Leng = %len ( %trimr ( @@Repl ) );
         SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0004'
                       : peMsgs  : @@Repl  : @@Leng );
         peErro = -1;
         return;
 x1    endif;

       k1yer92.r9empr2 = peBase.peEmpr;
       k1yer92.r9sucu2 = peBase.peSucu;
       k1yer92.r9rama2 = peRama;
       k1yer92.r9poli2 = pePoli;
       k1yer92.r9spol2 = peSpol;
       k1yer92.r9poco2 = pePoco;
       setll %kds ( k1yer92 : 6 ) paher9296;

 b4    if not %equal ( paher9296 );
         return;
 e4    endif;

       reade %kds ( k1yer92 : 6 ) paher9296;

       if not %eof;
          peDemb.rsemct = r9emct2;
          chain r9emct2 set061;
          if %found;
             peDemb.rsemcd = t@emcd;
          endif;
          peDemb.rsemcn = r9emcn2;
          peDemb.rsemcr = r9emcr2;
          if peDemb.rsemcr = *blanks;
             peDemb.rsemcr = '-';
          endif;
          peDemb.rsemcj = r9emcj2;
          if peDemb.rsemcj = *blanks;
             peDemb.rsemcj = '-';
          endif;
          peDemb.rsemcj = r9emcj2;
          peDemb.rspain = r9pain2;
          chain r9pain2 gntpai;
          if %found;
             peDemb.rspaid = papaid;
          endif;
          peDemb.rsemcf = r9emcf2;
          peDemb.rsemcm = r9emcm2;
          peDemb.rsemca = r9emca2;
          peDemb.rsemcc = r9emcc2;
          k1t0611.t@emct = r9emct2;
          k1t0611.t@emcc = r9emcc2;
          chain %kds(k1t0611:2) set0611;
          if %found;
             peDemb.rsemci = t@emci;
          endif;
          peDemb.rsemst = r9emst2;
          peDemb.rsemsc = r9emsc2;
          peDemb.rsemsm = r9emsm2;
          peDemb.rseslo = r9emc12;
          peDemb.rsmang = r9emc22;
          peDemb.rspunt = r9emc32;
          peDemb.rsamar = r9emc42;
          peDemb.rsobse = r9emc52;

          peDemb.rsemmm = r9emmm2;
          peDemb.rsemmo = r9emmo2;
          peDemb.rsemmn = r9emmn2;
          peDemb.rsemma = r9emma2;
          peDemb.rsemmp = r9emmp2;
          peDemb.rsemmt = r9emmt2;

          peDemb.rse2mm = r9e2mm2;
          peDemb.rse2mo = r9e2mo2;
          peDemb.rse2mn = r9e2mn2;
          peDemb.rse2ma = r9e2ma2;
          peDemb.rse2mp = r9e2mp2;
          peDemb.rse2mt = r9e2mt2;

          peDemb.rsemcb = r9emcb2;
          k1t0612.t@emct = r9emct2;
          k1t0612.t@emcb = r9emcb2;
          chain %kds(k1t0612:2) set0612;
          if %found;
             peDemb.rsemce = t@emce;
          endif;
          peDemb.rscopo = r9copo2;
          peDemb.rscops = r9cops2;
          k1tloc.locopo = r9copo2;
          k1tloc.locops = r9cops2;
          chain %kds(k1tloc) gntloc;
          if %found;
             peDemb.rslocj = loloca;
          endif;

          peDemb.rscopa = r9copa2;
          peDemb.rscoas = r9coas2;
          k1tloc.locopo = r9copa2;
          k1tloc.locops = r9coas2;
          chain %kds(k1tloc) gntloc;
          if %found;
             peDemb.rslocr = loloca;
          endif;
          peDemb.rscuit = r9cuit2;

          peDemb.rse0km = r9e0km2;
          if peDemb.rse0km <> 'S' and peDemb.rse0km <> 'N';
             peDemb.rse0km = 'N';
          endif;
          peDemb.rsemsd = r9emsd2;
          peDemb.rsinsp = r9inps2;

          test(de) *iso r9fadq2;
          if %error;
             peDemb.rsfadq = '0001-01-01T00:00:00-03:00';
           else;
             fecha_char = %editc(r9fadq2:'X');
             aÑo_char = %subst(fecha_char:1:4);
             mes_char = %subst(fecha_char:5:2);
             dia_char = %subst(fecha_char:7:2);
             peDemb.rsfadq = aÑo_char
                           + '-'
                           + mes_char
                           + '-'
                           + dia_char
                           + 'T00:00:00-03:00';
          endif;

       endif;

       return;
