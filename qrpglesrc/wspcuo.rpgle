     H option(*nodebugio:*noshowcpy:*srcstmt)
     H alwnull(*usrctl) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )

      * ************************************************************ *
      * WSPCUO  : Tareas generales.                                  *
      *           WebService - Solicitud de generación de archivo    *
      *           de cuotas.                                         *
      *                                                              *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                               *11-Sep-2015  *
      * ------------------------------------------------------------ *
      *                                                              *
      * ************************************************************ *

      /copy './qcpybooks/dtaq_h.rpgle'
      /copy './qcpybooks/qusec_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D WSPCUO          pr                  ExtPgm('WSPCUO')
     D   peBase                            likeds(paramBase) const
     D   peTipo                       1a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSPCUO          pi
     D   peBase                            likeds(paramBase) const
     D   peTipo                       1a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPT902          pr                  ExtPgm('SPT902')
     D   peTnum                       1a   const
     D   peNres                       7  0

     D QUsec           ds                  likeds(QUsec_t)
     D Data            s             33a
     D @nres           s              7  0
     D rc              s             10i 0

     D PsDs           sds                  qualified
     D  CurUsr                       10a   overlay(PsDs:358)

      /free

       *inlr = *ON;

       // --------------------------------------
       // Reset incial
       // --------------------------------------
       peErro  = *Zeros;
       clear peMsgs;

       // --------------------------------------
       // Valido Parámetro Base
       // --------------------------------------
       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       if ( peTipo <> 'X' and
            peTipo <> 'S' and
            peTipo <> 'C' );
            rc = SVPWS_getMsgs( '*LIBL'
                              : 'WSVMSG'
                              : 'GEN0014'
                              : peMsgs
                              : *omit
                              : *omit );
            peErro = -1;
            return;
       endif;

       // --------------------------------------
       // Robo contador
       // --------------------------------------
       SPT902( 'U' : @nres );

       // --------------------------------------
       // Inserto Mensaje
       // --------------------------------------
       Data = %trim(peBase.peEmpr)
            + %trim(peBase.peSucu)
            + %trim(%editc(peBase.peNivt:'X'))
            + %trim(%editc(peBase.peNivc:'X'))
            + %trim(%editc(peBase.peNit1:'X'))
            + %trim(%editc(peBase.peNiv1:'X'))
            + %trim(peTipo)
            + %trim(%editc(@nres:'X'))
            + 'GENARCCUO ';
       QSNDDTAQ( 'QUOMCUO01'
               : '*LIBL'
               : %len(%trim(data))
               : Data               );

       rc = SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'GEN0015'
                         : peMsgs
                         : *omit
                         : *omit );

       return;

      /free
