     H option(*nodebugio: *srcstmt: *noshowcpy)
     H dftactgrp(*no) actgrp(*caller)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSLVIG:  WebService                                          *
      *          Retorna Días a Sumar/Restar Vigencia y frecuencia   *
      *          de refacturación.                                   *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                   *14-Dic-2016              *
      * ------------------------------------------------------------ *
      * JSN 26/12/2016 - Se realiza busqueda de días de anticipación *
      *                  y posterior a la fecha de vigencia en el    *
      *                  archivo SET630                              *
      * ************************************************************ *
     Fset621    if   e           k disk
     Fset630    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLVIG          pr                  ExtPgm('WSLVIG')
     D   peArcd                       6  0 const
     D   peDsum                       2  0
     D   peDres                       2  0
     D   peFrec                      50a
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLVIG          pi
     D   peArcd                       6  0 const
     D   peDsum                       2  0
     D   peDres                       2  0
     D   peFrec                      50a
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D @@repl          s          65536a

      /free

       *inlr = *on;

       peDsum = 0;
       peDres = 0;
       peFrec = *blanks;
       peErro  = 0;
       clear peMsgs;

       chain peArcd set621;
       if not %found;
          %subst(@@repl:1:6) = %trim(%char(peArcd));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0000'
                       : peMsgs
                       : @@repl
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       endif;

       select;
        when t@dupe = 1;
             peFrec = 'Mensual';
        when t@dupe = 2;
             peFrec = 'Bimestral';
        when t@dupe = 3;
             peFrec = 'Trimestral';
        when t@dupe = 4;
             peFrec = 'Cuatrimestral';
        when t@dupe = 6;
             peFrec = 'Semestral';
        when t@dupe = 12;
             peFrec = 'Anual';
       endsl;

       chain peArcd set630;
       if not %found;
          %subst(@@repl:1:6) = %trim(%char(peArcd));
          SVPWS_getMsgs( '*LIBL'
                       : 'WSVMSG'
                       : 'COW0000'
                       : peMsgs
                       : @@repl
                       : %len(%trim(@@repl)) );
          peErro = -1;
          return;
       else;
         peDres = t@davg;        //* Días Anticipado a la Vigencia
         peDsum = t@dpvg;        //* Días Posterior a la Vigencia
       endif;

       return;

      /end-free
