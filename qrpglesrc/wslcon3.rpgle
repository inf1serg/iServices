     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCON3: WebService                                          *
      *          Gen.de Certificados: Wrapper para _incon().         *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                       10-Nov-2015        *
      * ************************************************************ *

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/wslcer_h.rpgle'

     D SPWLIBLC        pr                  ExtPgm('TAATOOL/SPWLIBLC')
     D   peEnto                       1a   const

     D WSLCON3         pr                  ExtPgm('WSLCON3')
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
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)

     D WSLCON3         pi
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
     D   peClan                       9a   dim(30) options(*omit)
     D   peClanC                     10i 0 options(*omit)
     D   peMsgs                            likeds(paramMsgs)

       *inlr = *on;

       SPWLIBLC('P');

       callp WSLCER_incon(peBase:
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

       return;
