     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCON2: WebService                                          *
      *          Gen.de Certificados: Wrapper para _cofli().         *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                       10-Nov-2015        *
      * ************************************************************ *
     Fpahed004  if   e           k disk
     Fpaher9    if   e           k disk
     Fgnhdaf    if   e           k disk

      /copy './qcpybooks/wslcer_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D SPWLIBLC        pr                  ExtPgm('TAATOOL/SPWLIBLC')
     D   peEnto                       1a   const

     D WSLCON2         pr                  ExtPgm('WSLCON2')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30)
     D   peClanC                     10i 0
     D   peNacr                      40a
     D   peMsgs                            likeds(paramMsgs)

     D WSLCON2         pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certRvs_t)
     D   peDsLc                            likeds(listCob_t) dim(50)
     D   peDsLcC                     10i 0
     D   peClau                       3a   dim(30)
     D   peClauC                     10i 0
     D   peClan                       9a   dim(30)
     D   peClanC                     10i 0
     D   peNacr                      40a
     D   peMsgs                            likeds(paramMsgs)

     D k1hed0          ds                  likerec(p1hed004:*key)
     D k1her9          ds                  likerec(p1her9  :*key)

       *inlr = *on;

       SPWLIBLC('P');

       peNacr = '*NO REGISTRA*';

       callp WSLCER_cofli(peBase:
                          peRama:
                          pePoli:
                          peSpol:
                          peSspo:
                          pePoco:
                          peDsFi:
                          peDsLc:
                          peDsLcC:
                          peClau:
                          peClauC:
                          peClan:
                          peClanC:
                          peMsgs);

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       chain %kds(k1hed0:4) pahed004;
       if %found;
          k1her9.r9empr = d0empr;
          k1her9.r9sucu = d0sucu;
          k1her9.r9arcd = d0arcd;
          k1her9.r9spol = d0spol;
          setll %kds(k1her9:4) paher9;
          reade %kds(k1her9:4) paher9;
          dow not %eof;
              if r9poco = pePoco;
                 if r9acrc <> 0;
                    chain r9acrc gnhdaf;
                    if %found;
                       peNacr = dfnomb;
                       leave;
                    endif;
                 endif;
              endif;
           reade %kds(k1her9:4) paher9;
          enddo;
       endif;

       return;
