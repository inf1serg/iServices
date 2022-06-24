     H option(*nodebugio:*noshowcpy:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ('HDIILE/HDIBDIR')
      * ************************************************************ *
      * PRS001:  WebService                                          *
      *          Pre-Denuncia de Siniestro                           *
      *          SVPPDS_SetPreDen()                                  *
      * ------------------------------------------------------------ *
      * Jennifer Segovia                         *26-Jun-2017        *
      * ************************************************************ *

      /copy './qcpybooks/svppds_h.rpgle'

     D PRS001          pr                  ExtPgm('PRS001')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   peCaus                       4  0 const
     D   peFpdf                    1028a   const
     D   pePdff                            likeds(pds001_t) dim(10)
     D   pePdffC                     10i 0
     D   peNpds                       7  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D PRS001          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   pePate                      25    const
     D   peFocu                       8  0 const
     D   peHocu                       6  0 const
     D   peCaus                       4  0 const
     D   peFpdf                    1028    const
     D   pePdff                            likeds(pds001_t) dim(10)
     D   pePdffC                     10i 0
     D   peNpds                       7  0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLOG           pr                  ExtPgm('QUOMDATA/WSLOG')
     D  peMsg                       512a   const

      /free

       *inlr = *on;

       clear peMsgs;
       peErro = 0;
       peNpds = 0;

       SVPPDS_setPreDenWeb( peBase
                          : peRama
                          : pePoli
                          : pePate
                          : peFocu
                          : peHocu
                          : peCaus
                          : peFpdf
                          : pePdff
                          : pePdffC
                          : peNpds
                          : peErro
                          : peMsgs  );

       return;

      /end-free
