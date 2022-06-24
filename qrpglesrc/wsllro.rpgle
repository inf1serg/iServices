     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ********************************************************************** *
      * WSLLRO  : Tareas generales.                                            *
      *           WebService - Libros Rubricados retorna quincenas             *
      * ---------------------------------------------------------------------- *
      * Sergio Fernandez                                         * 03-Mar-2017 *
      *----------------------------------------------------------------------- *
      * Modificaciones:                                                        *
      * GIO 18/07/2018 Carga solo 24 Registros de SETLRO. Los mas recientes.   *
      *                Limite en $$Lim                                         *
      * ********************************************************************** *

     Fsetlro    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLLRO          pr                  ExtPgm('WSLLRO')
     D   peLqui                            likeds(setlro_t) dim($$Lim)
     D   peLquiC                     10i 0

     D WSLLRO          pi
     D   peLqui                            likeds(setlro_t) dim($$Lim)
     D   peLquiC                     10i 0

     D meses           s             10a   dim(12)

     d $$Lim           c                   const(24)

      /free

       *inLr = *On;

       clear peLqui;
       peLquiC = 0;

       meses(1) = 'Enero';
       meses(2) = 'Febrero';
       meses(3) = 'Marzo';
       meses(4) = 'Abril';
       meses(5) = 'Mayo';
       meses(6) = 'Junio';
       meses(7) = 'Julio';
       meses(8) = 'Agosto';
       meses(9) = 'Septiembre';
       meses(10)= 'Octubre';
       meses(11)= 'Noviembre';
       meses(12)= 'Diciembre';

       read setlro;
       dow not %eof;

         if peLquiC < $$Lim;

           peLquiC += 1;
           peLqui(peLquiC).fema = t@fema;
           peLqui(peLquiC).femm = t@femm;
           peLqui(peLquiC).quin = t@quin;
           peLqui(peLquiC).desc = %trim(meses(t@femm))
                                + '/'
                                + %editc(t@fema:'X')
                                + ' - Quincena '
                                + %char(t@quin);

         else;
           leave;
         endif;

        read setlro;
       enddo;

       return;

      /end-free
