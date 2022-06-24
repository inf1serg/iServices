     H option(*srcstmt:*noshowcpy) actgrp(*new) dftactgrp(*no)
     H bnddir('HDIILE/HDIBDIR')
     H alwnull(*usrctl)
      * ************************************************************ *
      * WSPVST : Validación Cabecera Siniestro                       *
      * ------------------------------------------------------------ *
      * Nestor Nelson                        02/11/2021              *
      * ------------------------------------------------------------ *
      * Modificación:                                                *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/svptab_h.rpgle'
      /copy './qcpybooks/svpsuc_h.rpgle'
      /copy './qcpybooks/svpsin_h.rpgle'
      /copy './qcpybooks/svpemp_h.rpgle'
      /copy './qcpybooks/rest_h.rpgle'
      /copy './qcpybooks/svprest_h.rpgle'
      /copy './qcpybooks/cowlog_h.rpgle'

     d WSPVST          pr                  ExtPgm('WSPVST')
     d  peEmpr                        1a
     d  peSucu                        2a
     d  peRama                        2  0
     d  peSini                        7  0
     d  peNops                        7  0
     d  peMsgf                        6a
     d  peIdms                        7a

     d WSPVST          pi
     d  peEmpr                        1a
     d  peSucu                        2a
     d  peRama                        2  0
     d  peSini                        7  0
     d  peNops                        7  0
     d  peMsgf                        6a
     d  peIdms                        7a

      *                                                              *

      /free

       *inlr = *on;

       peMsgf = *blanks  ;
       peIdms = *blanks  ;

           if SVPEMP_getDatosDeEmpresa( peEmpr
                                      : *omit ) = *off;
             peMsgf = 'WSVMSG' ;
             peIdms = 'COW0113';

             return;

           endif;

           if   SVPSUC_getDatosDeSucursal( peEmpr
                                         : peSucu
                                         : *omit ) = *off ;
             peMsgf = 'WSVMSG' ;
             peIdms = 'COW0114';
             return;
           endif;

           if   SVPTAB_chkSet001( peRama ) = *on ;
             peMsgf = 'WSVMSG' ;
             peIdms = 'RAM0001';
             return;
           endif;

           if   SVPSIN_chkSini( peEmpr
                              : peSucu
                              : peRama
                              : peSini
                              : peNops ) = *off ;
             peMsgf = 'WSVMSG' ;
             peIdms = 'SIN0001';
             return;

           endif;


       return;
