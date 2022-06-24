     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCON1: WebService                                          *
      *          Gen.de Certificados: Wrapper para _autos().         *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                       10-Nov-2015        *
      * ************************************************************ *

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/wslcer_h.rpgle'

     D SPWLIBLC        pr                  ExtPgm('TAATOOL/SPWLIBLC')
     D   peEnto                       1a   const

     D WSLCON1         pr                  ExtPgm('WSLCON1')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certAut_t)
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0
     D   peMsgs                            likeds(paramMsgs)

     D WSLCON1         pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const options(*omit)
     D   peSpol                       9  0 const
     D   peSspo                       3  0 const
     D   pePoco                       4  0 const
     D   peDsFi                            likeds(certAut_t)
     D   peDcob                      80    dim(999)
     D   peDcobC                     10i 0
     D   peMsgs                            likeds(paramMsgs)

       *inlr = *on;

       SPWLIBLC('P');

       callp WSLCER_autos(peBase:
                          peRama:
                          pePoli:
                          peSpol:
                          peSspo:
                          pePoco:
                          peDsFi:
                          peDcob:
                          peDcobC:
                          peMsgs);

       return;
