     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLPPP  : Tareas generales.                                  *
      *           WebService - Retorna Lista de PDFs de póliza.      *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *03-Feb-2017        *
      * ------------------------------------------------------------ *
      * SGF 17/03/2017: Verificar que la póliza pertenezca a los dos *
      *                 intermediarios de peBase.                    *
      *                                                              *
      * JSN 31/03/2017: Se elimino la lectura del archivo pahec1     *
      * SGF 11/05/2017: Incluyo a los 3/90.                          *
      *                                                              *
      * ************************************************************ *
     Fpahed004  if   e           k disk    rename(p1hed004:p1hed0)
     Fpahec1    if   e           k disk
     Fpahpol    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLPPP          pr                  ExtPgm('WSLPPP')
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peLpdf                            likeds(pdfPol_t) dim(1000)
     D   peLpdfC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLPPP          pi
     D   peBase                            likeds(paramBase) const
     D   peRama                       2  0 const
     D   pePoli                       7  0 const
     D   peLpdf                            likeds(pdfPol_t) dim(1000)
     D   peLpdfC                     10i 0
     D   peMore                        n
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @repl           s          65535a
     D k1hed0          ds                  likerec(p1hed0 : *key)
     D k1hec1          ds                  likerec(p1hec1 : *key)
     D k1hpol          ds                  likerec(p1hpol : *key)

       *inLr = *On;

       peLpdfC = *Zeros;
       peErro  = *Zeros;
       clear peLpdf;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       k1hed0.d0empr = peBase.peEmpr;
       k1hed0.d0sucu = peBase.peSucu;
       k1hed0.d0rama = peRama;
       k1hed0.d0poli = pePoli;
       k1hed0.d0suop = 0;
       setll %kds(k1hed0:4) pahed004;
       if not %equal;
          %subst(@repl:01:2) = %editc(peRama:'X');
          %subst(@repl:03:7) = %trim(%char(pePoli));
          %subst(@repl:10:1) = %trim(%char(peBase.peNivt));
          %subst(@repl:11:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl))  );
          peErro = -1;
          return;
       endif;

       k1hpol.poempr = peBase.peEmpr;
       k1hpol.posucu = peBase.peSucu;
       k1hpol.ponivt = peBase.peNivt;
       k1hpol.ponivc = peBase.peNivc;
       k1hpol.porama = peRama;
       k1hpol.popoli = pePoli;
       setll %kds(k1hpol:6) pahpol;
       if not %equal;
          %subst(@repl:01:2) = %editc(peRama:'X');
          %subst(@repl:03:7) = %trim(%char(pePoli));
          %subst(@repl:10:1) = %trim(%char(peBase.peNivt));
          %subst(@repl:11:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl))  );
          peErro = -1;
          return;
       endif;

       k1hpol.ponivt = peBase.peNit1;
       k1hpol.ponivc = peBase.peNiv1;
       setll %kds(k1hpol:6) pahpol;
       if not %equal;
          %subst(@repl:01:2) = %editc(peRama:'X');
          %subst(@repl:03:7) = %trim(%char(pePoli));
          %subst(@repl:10:1) = %trim(%char(peBase.peNivt));
          %subst(@repl:11:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'POL0001'
                       : peMsgs
                       : %trim(@repl)
                       : %len(%trim(@repl))  );
          peErro = -1;
          return;
       endif;

       setll %kds(k1hed0:4) pahed004;
       reade %kds(k1hed0:4) pahed004;
       dow not %eof;
              if peLpdfC <= 1000;
                 peLpdfC += 1;
                 peLpdf(peLpdfC).rama = d0rama;
                 peLpdf(peLpdfC).poli = d0poli;
                 peLpdf(peLpdfC).suop = d0suop;
                 peLpdf(peLpdfC).arcd = d0arcd;
                 peLpdf(peLpdfC).spol = d0spol;
                 peLpdf(peLpdfC).sspo = d0sspo;
                 peLpdf(peLpdfC).dpdf = 'POLIZA_'
                                      + %editc(d0arcd:'X')
                                      + '_'
                                      + %editc(d0spol:'X')
                                      + '_'
                                      + %editc(d0sspo:'X')
                                      + '_'
                                      + %editc(d0rama:'X')
                                      + '_'
                                      + %editc(d0poli:'X')
                                      + '_'
                                      + %editc(d0suop:'X')
                                      + '.pdf';
              endif;
        reade %kds(k1hed0:4) pahed004;
       enddo;

       return;

