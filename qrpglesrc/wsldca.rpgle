     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSLDCA  : Tareas generales.                                  *
      *           WebService - Retorna detalle cobertura de autos.   *
      *                                                              *
      * ------------------------------------------------------------ *
      * Norberto Franqueira                            *22-Abr-2015  *
      * ------------------------------------------------------------ *
      * ************************************************************ *
     Fset2252   if   e           k disk
     Fset124    if   e           k disk

      /copy './qcpybooks/svpws_h.rpgle'

     D WSLDCA          pr                  ExtPgm('WSLDCA')
     D   peBase                            likeds(paramBase) const
     D   peCobl                       2    const
     D   peDcob                            likerec(s1t124) dim(999)
     D   peDcobC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSLDCA          pi
     D   peBase                            likeds(paramBase) const
     D   peCobl                       2    const
     D   peDcob                            likerec(s1t124) dim(999)
     D   peDcobC                     10i 0
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D kt124           ds                  likerec(s1t124:*key)

     D detalle         ds                  likerec(s1t124)

     D respue          s          65536
     d longm           s             10i 0

       *inLr = *On;

       peDcobC = *Zeros;
       peErro  = *Zeros;

       clear peDcob;
       clear peMsgs;

       if not SVPWS_chkParmBase ( peBase : peMsgs );
         peErro = -1;
         return;
       endif;

       setll ( peCobl ) set2252;

       if not %equal( set2252 );
          respue =  peCobl;
          longm  = 2 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COB0001' :
                          peMsgs : respue  : longm );
         peErro = -1;
         return;
       endif;

       chain ( peCobl ) set2252;

       kt124.t@rama = t@rama;
       kt124.t@tpcd = t@tpcd;

       setll %kds ( kt124 : 2 ) set124;

       if not %equal( set124 );
          respue =  peCobl + t@tpcd +
                    %editC(t@rama:'4':*ASTFILL);
          longm  = 6 ;
          SVPWS_getMsgs ( '*LIBL' : 'WSVMSG': 'COB0002' :
                          peMsgs : respue  : longm );
         peErro = -1;
         return;
       endif;

       reade %kds ( kt124 : 2 ) set124 detalle;

       dow ( not %eof ( set124 ) ) and ( peDcobC < 999 );

         peDcobC += 1;
         eval-corr peDcob(peDcobC) = detalle;

         reade %kds ( kt124 : 2 ) set124 detalle;

       enddo;

       return;
