     H option(*nodebugio: *srcstmt: *noshowcpy)
     H dftactgrp(*no) actgrp(*caller)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLCON6: WebService                                          *
      *          Retorna Datos para Certificado de Cobertura "A" para*
      *          póliza en trámite.                                  *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                   *12-Dic-2016              *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *
     Fctw000    if   e           k disk
     Fctw003    if   e           k disk
     Fctwet0    if   e           k disk
     Fset621    if   e           k disk
     Fset211    if   e           k disk
     Fset225    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'
      /copy './qcpybooks/svplrc_h.rpgle'

     D WSLCON6         pr                  ExtPgm('WSLCON6')
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   pePoco                       4  0 const
     D   peData                            likeds(DataCertRc_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLCON6         pi
     D   peBase                            likeds(paramBase) const
     D   peNctw                       7  0 const
     D   peRama                       2  0 const
     D   pePoco                       4  0 const
     D   peData                            likeds(DataCertRc_t)
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     Dgira_fecha       pr             8  0
     D                                8  0 const
     D                                3a   const options(*rightadj)

     D SP0001          pr                  extpgm('SP0001')
     D  p@parf                        8  0
     D  p@parm                        2  0
     D  p@fpgm                        3a   options(*nopass)

     D k1wet0          ds                  likerec(c1wet0:*key)
     D k1w003          ds                  likerec(c1w003:*key)
     D k1w000          ds                  likerec(c1w000:*key)
     D k1t621          ds                  likerec(s1t621:*key)

     D svrcli          s             15  2
     D peHast          s              8  0
     D @@hast          s              8  0
     D @@desd          s              8  0
     D @@repl          s          65536a

     Is1t211
     I              t@date                      tzdate

      /free

       *inlr = *on;

       clear peData;
       clear peMsgs;
       peErro = 0;

       k1w000.w0empr = peBase.peEmpr;
       k1w000.w0sucu = peBase.peSucu;
       k1w000.w0nivt = peBase.peNivt;
       k1w000.w0nivc = peBase.peNivc;
       k1w000.w0nctw = peNctw;
       chain %kds(k1w000:5) ctw000;
       if not %found;
          %subst(@@repl:1:7) = %trim(%char(peNctw));
          %subst(@@repl:8:1) = %trim(%char(peBase.peNivt));
          %subst(@@repl:9:5) = %trim(%char(peBase.peNivc));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0008'
                       : peMsgs
                       : @@repl
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       if (w0cest = 5 and w0cses = 3) or
          (w0cest = 5 and w0cses = 4) or
          (w0cest = 7 and w0cses = 4) or
          (w0cest = 7 and w0cses = 5);
        else;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0029'
                       : peMsgs   );
          peErro = -1;
          return;
       endif;

       k1t621.t@arcd = w0arcd;
       k1t621.t@rama = peRama;
       k1t621.t@arse = 1;
       chain %kds(k1t621) set621;
       if not %found;
          t@dupe = 6;
       endif;

       peHast = gira_fecha(w0vdes:'DMA');
       SP0001( peHast : t@dupe );
       @@desd = gira_fecha(w0vdes:'DMA');
       @@hast = peHast;

       peData.peFdes = %editc(@@desd:'Y');
       peData.peFhas = %editc(@@hast:'Y');

       k1wet0.t0empr = peBase.peEmpr;
       k1wet0.t0sucu = peBase.peSucu;
       k1wet0.t0nivt = peBase.peNivt;
       k1wet0.t0nivc = peBase.peNivc;
       k1wet0.t0nctw = peNctw;
       k1wet0.t0rama = peRama;
       k1wet0.t0poco = pePoco;
       chain %kds(k1wet0:7) ctwet0;
       if not %found;
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'CON0003'
                       : peMsgs   );
          peErro = -1;
          return;
       endif;

       k1w003.w3empr = peBase.peEmpr;
       k1w003.w3sucu = peBase.peSucu;
       k1w003.w3nivt = peBase.peNivt;
       k1w003.w3nivc = peBase.peNivc;
       k1w003.w3nctw = peNctw;
       k1w003.w3nase = 0;
       chain %kds(k1w003:6) ctw003;
       if %found;
          peData.peNase = w3nomb;
       endif;

       peData.pePoli = 'En Trámite';
       peData.peNase = w3nomb;
       peData.peHdes = '12';
       peData.peHhas = '12';
       peData.peVhde = t0vhde;
       peData.peNmat = t0nmat;
       peData.peMoto = t0moto;
       peData.peChas = t0chas;
       peData.peVhvu = '0';
       peData.peAcct = 'NO';
       peData.peAccp = 'NO';
       peData.peIncp = 'NO';
       peData.peInct = 'NO';
       peData.peRobp = 'NO';
       peData.peRobt = 'NO';

       chain t0vhuv set211;
       if %found;
          peData.peVhdu = t@vhdu;
       endif;

       t@cobl = 'A';
       chain t@cobl set225;
       if %found;
          peData.peCobd = t@cobd;
       endif;

       svrcli = SVPLRC_getLimiteRc( peBase.peEmpr
                                  : peBase.peSucu
                                  : *omit         );
       peData.peRcli = %trim(%editw(svrcli:' .   .   .   . 0 ,  '));

       return;

      /end-free

     P gira_fecha      B
     D gira_fecha      PI             8  0
     D @@feve                         8  0 CONST
     D @@tipo                         3A   CONST OPTIONS(*RIGHTADJ)
     D* Local fields
     D retField        S              8  0
     D* AÑO-MES-DIA...
     D                 ds                  inz
     Dp@famd                  01     08  0
     D@@aÑo                   01     04  0
     D@@mes                   05     06  0
     D@@dia                   07     08  0
     D* DIA-MES-AÑO...
     D                 ds                  inz
     Dp@fdma                  01     08  0
     D$$dia                   01     02  0
     D$$mes                   03     04  0
     D$$aÑo                   05     08  0
      *
      * Girar según como se pida...
     C                   select
      * Pasar a AÑO-MES-DIA...
     C                   when      @@tipo = 'AMD'
     C                   eval      p@fdma = @@feve
     C                   eval      @@aÑo = $$aÑo
     C                   eval      @@mes = $$mes
     C                   eval      @@dia = $$dia
     C                   eval      retfield = p@famd
      * Pasar a DIA-MES-AÑO...
     C                   when      @@tipo = 'DMA'
     C                   eval      p@famd = @@feve
     C                   eval      $$aÑo = @@aÑo
     C                   eval      $$mes = @@mes
     C                   eval      $$dia = @@dia
     C                   eval      retfield = p@fdma
     C                   endsl
     C                   RETURN    retField
     P gira_fecha      E
