     H option(*nodebugio:*noshowcpy:*srcstmt)
     H dftactgrp(*no) actgrp(*new)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * WSPLRO  : Tareas generales.                                  *
      *           WebService - Libros Rubricados recibe solicitudes  *
      *           del productor                                      *
      * ------------------------------------------------------------ *
      * JSN                                         *11-Abr-2017     *
      * ------------------------------------------------------------ *
      * JSN - 13/06/2017 - Se agrega los parámetros tipo de libro    *
      *                    y tipo de salida.                         *
      *                    Validar que envie valores en los parame-  *
      *                    tros.                                     *
      * JSN - 10/01/2018 - Se agregar controlar por año y por mes    *
      *                    y no por mes solamente si es mayor al     *
      *                    actual                                    *
      *                                                              *
      * ************************************************************ *
     Fsehlro    if a e           k disk

      /copy './qcpybooks/dtaq_h.rpgle'
      /copy './qcpybooks/qusec_h.rpgle'
      /copy './qcpybooks/svpws_h.rpgle'

     D WSPLRO          pr                  ExtPgm('WSPLRO')
     D   peBase                            likeds(paramBase) const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peQuin                       1  0 const
     D   peTlib                       7a   const
     D   peTsal                       4a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D WSPLRO          pi
     D   peBase                            likeds(paramBase) const
     D   peFema                       4  0 const
     D   peFemm                       2  0 const
     D   peQuin                       1  0 const
     D   peTlib                       7a   const
     D   peTsal                       4a   const
     D   peErro                            like(paramErro)
     D   peMsgs                            likeds(paramMsgs)

     D SPT902          pr                  ExtPgm('SPT902')
     D   peTnum                       1a   const
     D   peNres                       7  0

     D PsDs           sds                  qualified
     D  jds_user                     10a   overlay(PsDs:254)
     D  sds_user                     10a   overlay(PsDs:358)

     D k1yLro          ds                  likerec ( s1hlro : *Key )

     D QUsec           ds                  likeds(QUsec_t)
     D Data            s             40a
     D @nres           s              7  0
     D rc              s             10i 0
     D @@Secu          s              3  0

      /free

       *inLr = *On;

       @@Secu = *Zeros;
       peErro = *Zeros;
       clear peMsgs;

       // Valida Parámetro Base

       if not SVPWS_chkParmBase ( peBase : peMsgs );
          peErro = -1;
          return;
       endif;

       // Valida que no esten vacios los parametros

       if peFema = *zeros or peFemm = *zeros or
          peTlib = *blanks or peTsal = *blanks;
         rc = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'LRO0001'
                             : peMsgs
                             : *omit
                             : *omit );
         peErro = -1;
         return;
       else;      // Valida los parametros para realizar la solicitud
         select;
           when peFema > *year;
             rc = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'LRO0002'
                             : peMsgs
                             : *omit
                             : *omit );
             peErro = -1;
             return;
           when peFema = *year and peFemm > *Month;
             rc = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'LRO0003'
                             : peMsgs
                             : *omit
                             : *omit );
             peErro = -1;
             return;
           when peQuin < 0 or peQuin > 2;
             rc = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'LRO0004'
                             : peMsgs
                             : *omit
                             : *omit );
             peErro = -1;
             return;
           when peTlib <> 'OPERACI' and peTlib <> 'COBRANZ';
             rc = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'LRO0005'
                             : peMsgs
                             : *omit
                             : *omit );
             peErro = -1;
             return;
           when peTsal <> 'XLSX' and peTsal <> 'XML';
             rc = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'LRO0006'
                             : peMsgs
                             : *omit
                             : *omit );
             peErro = -1;
             return;
         endsl;
       endif;

       // Valida que no haya solicitudes pendientes

       k1yLro.t@Empr = peBase.peEmpr;
       k1yLro.t@Sucu = peBase.peSucu;
       k1yLro.t@Nivt = peBase.peNivt;
       k1yLro.t@Nivc = peBase.peNivc;
       k1yLro.t@Nit1 = peBase.peNit1;
       k1yLro.t@Niv1 = peBase.peNiv1;
       k1yLro.t@Date = %int( %char( %date(): *iso0) );
       setll %kds ( k1yLro:7 ) sehlro;
       reade %kds ( k1yLro:7 ) sehlro;
       dow not %eof ( sehlro );
         if t@stat = '0' or t@stat = '3';
           rc = SVPWS_getMsgs( '*LIBL'
                             : 'WSVMSG'
                             : 'GEN0017'
                             : peMsgs
                             : *omit
                             : *omit );
           peErro = -1;
           return;
         endif;
         @@secu += 1;
         reade %kds ( k1yLro:7 ) sehlro;
       enddo;

       exsr GuardSolic;        // Guarda solicitud

       SPT902( 'L' : @nres );  // Busco valor del contador

       // Inserto Mensaje

       Data = %trim(peBase.peEmpr)
            + %trim(peBase.peSucu)
            + %trim(%editc(peBase.peNivt:'X'))
            + %trim(%editc(peBase.peNivc:'X'))
            + %trim(%editc(peBase.peNit1:'X'))
            + %trim(%editc(peBase.peNiv1:'X'))
            + %trim(%editc(peFema:'X'))
            + %trim(%editc(peFemm:'X'))
            + %trim(%editc(peQuin:'X'))
            + %trim(%editc(@nres:'X'))
            + %trim(peTlib)
            + %trim(peTsal);

       QSNDDTAQ( 'QUOMLRO01'
               : '*LIBL'
               : %len(%trim(data))
               : Data               );

       rc = SVPWS_getMsgs( '*LIBL'
                         : 'WSVMSG'
                         : 'GEN0018'
                         : peMsgs
                         : *omit
                         : *omit );

       return;

       //* -------------------------------------------------------------- *
       //* Guarda solicitud de productor en el archivo sehlro             *
       //* -------------------------------------------------------------- *
       begsr GuardSolic;

         t@Empr = peBase.peEmpr;
         t@Sucu = peBase.peSucu;
         t@Nivt = peBase.peNivt;
         t@Nivc = peBase.peNivc;
         t@Nit1 = peBase.peNit1;
         t@Niv1 = peBase.peNiv1;
         t@Fema = peFema;
         t@Femm = peFemm;
         t@Quin = peQuin;
         t@Date = %int( %char( %date(): *iso0) );
         t@Secu = @@Secu;
         t@Stat = '0';
         t@User = PsDs.sds_user;
         t@Time = %dec(%time);

         write s1hlro;

       endsr;

       //* -------------------------------------------------------------- *

      /end-free
