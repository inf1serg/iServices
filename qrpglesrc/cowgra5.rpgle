     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
     H actgrp(*new)
      * ********************************************************* *
      * COWGRA5: Obtiene poliza de superpoliza                    *
      * --------------------------------------------------------- *
      * Julio Barranco                       22-Sep-2015          *
      * ********************************************************* *

      *Parametros
     DCOWGRA5          pr                  extpgm('COWGRA5')
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pePoli                            likeds(spolizas) Dim(100)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

     DCOWGRA5          pi
     D   peBase                            likeds(paramBase) const
     D   peArcd                       6  0 const
     D   peSpol                       9  0 const
     D   pePoli                            likeds(spolizas) Dim(100)
     D   peErro                      10i 0
     D   peMsgs                            likeds(paramMsgs)

      *--- Copy H -------------------------------------------------- *

      /copy './qcpybooks/cowgrai_h.rpgle'

      /free

       *inlr = *on;

       COWGRAI_getPolizasDeSuperpoliza ( peBase :
                                         peArcd :
                                         peSpol :
                                         pePoli :
                                         peErro :
                                         peMsgs);

       COWGRAI_End();

       Return;

      /end-free
