     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLVHB  : Tareas generales.                                  *
      *           WebService - Retorna Bonific./Recargos Vehiculo.   *
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *22-Abr-2015  *
      * ------------------------------------------------------------ *
      * SGF 04/05/2015: Refresco descripción desde SET250.           *
      * SGF 11/05/2015: Todo desde archivos de GAUS.                 *
      * SGF 16/11/2021: No mostrar TOP.                              *
      *                                                              *
      * ************************************************************ *
     Fset001    if   e           k disk
     Fset250    if   e           k disk
     Fpahet995  if   e           k disk
     Fpahet4    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svpvls_h.rpgle'

     D WSLVHB          pr                  ExtPgm('WSLVHB')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peBveh                            likeds(pahaut1_t) dim(999)
     D   peBvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLVHB          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peSpol                       9  0 const
     D   pePoco                       4  0 const
     D   peBveh                            likeds(pahaut1_t) dim(999)
     D   peBvehC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D k1t250          ds                  likerec(s1t250   : *key)
     D k1het9          ds                  likerec(p1het9   : *key)
     D k1het4          ds                  likerec(p1het4   : *key)

     D respue          s          65536
     d longm           s             10i 0
     d @@poco          s              6  0
     d @@vsys          s            512a

       *inLr = *On;

       peBvehC = *Zeros;
       peErro  = *Zeros;

       clear peBveh;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       chain (peRama) set001;
       if %found( set001 ) and t@rame <> 4;
          respue =  %editC(peRama:'4':*ASTFILL) +
                    %editC(pePoli:'4':*ASTFILL);
          longm  = 9 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'POL0003' :
                          peMsgs : respue  : longm );
         peErro = -1;
         return;
       endif;

       k1het9.t9empr = peBase.peEmpr;
       k1het9.t9sucu = peBase.peSucu;
       k1het9.t9rama = peRama;
       k1het9.t9poli = pePoli;
       k1het9.t9spol = peSpol;
       k1het9.t9poco = pePoco;
       chain %kds(k1het9:6) pahet995;
       if not %found;
          @@poco = pePoco;
          respue =  %editC(@@Poco:'4':*ASTFILL)
                 +  %editC(peRama:'4':*ASTFILL)
                 +  %editc(pePoli:'4':*ASTFILL);
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'BIE0001'
                       : peMsgs
                       : respue
                       : %len(%trim(respue)) );
          peErro = -1;
          return;
       endif;

       @@vsys = 'N';
       if SVPVLS_getValSys( 'HSHOWTOPEP'
                          : *omit
                          : @@vsys       ) = *off;
          @@vsys = 'N';
       endif;

       k1het4.t4empr = peBase.peEmpr;
       k1het4.t4sucu = peBase.peSucu;
       k1het4.t4arcd = t9arcd;
       k1het4.t4spol = t9spol;
       k1het4.t4sspo = t9sspo;
       k1het4.t4rama = t9rama;
       k1het4.t4arse = t9arse;
       k1het4.t4oper = t9oper;
       k1het4.t4suop = t9sspo;
       k1het4.t4poco = t9poco;
       setll %kds(k1het4:10) pahet4;
       reade %kds(k1het4:10) pahet4;
       dow not %eof and peBvehC < 999;

           k1t250.stempr = t4empr;
           k1t250.stsucu = t4sucu;
           k1t250.starcd = t4arcd;
           k1t250.strama = t4rama;
           k1t250.stccbp = t4ccbp;
           k1t250.stmar1 = 'C';
           chain %kds(k1t250) set250;
           if %found;

              if stccbe <> 'TOP' or
                 (stccbe = 'TOP' and @@vsys = 'S');

                 peBvehC += 1;

                 peBveh(peBvehC).auempr = t4empr;
                 peBveh(peBvehC).audcbp = stdcbp;
                 peBveh(peBvehC).ausucu = t4sucu;
                 peBveh(peBvehC).aurama = t4rama;
                 peBveh(peBvehC).aupoli = t4poli;
                 peBveh(peBvehC).aupoco = t4poco;
                 peBveh(peBvehC).aucert = t4cert;
                 peBveh(peBvehC).auarcd = t4arcd;
                 peBveh(peBvehC).auspol = t4spol;
                 peBveh(peBvehC).auarse = t4arse;
                 peBveh(peBvehC).auoper = t4oper;
                 peBveh(peBvehC).auccbp = t4ccbp;
                 peBveh(peBvehC).aupcbp = t4pcbp;
                 peBveh(peBvehC).aupori = t4pori;
                 peBveh(peBvehC).aumcbp = t4mcbp;
                 peBveh(peBvehC).auts20 = 0;

              endif;

           endif;

        reade %kds(k1het4:10) pahet4;
       enddo;

       return;
