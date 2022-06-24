     H option(*nodebugio:*srcstmt)
     H actgrp(*new) dftactgrp(*no)
     H bnddir ( 'HDIILE/HDIBDIR' )
      * ************************************************************ *
      * APIDOC:  WebService                                          *
      *          APIS - Listado de documentos.                       *
      * ------------------------------------------------------------ *
      * Sergio Fernandez                         *27-Jul-2017        *
      * ------------------------------------------------------------ *
      * Modificaciones:                                              *
      * LRG 28-05-2018: Se cambia llamada _listaTiposDeDocumento     *
      *                                   _listaTiposDeDocumentoWeb  *
      * ************************************************************ *

      /copy './qcpybooks/wsltab_h.rpgle'

     D APIDOC          pr                  ExtPgm('APIDOC')
     D   peLtdo                            likeds(gnttdo_t) dim(99)
     D   peLtdoC                     10i 0

     D APIDOC          pi
     D   peLtdo                            likeds(gnttdo_t) dim(99)
     D   peLtdoC                     10i 0

      /free

       *inlr = *on;
       clear peLtdo;
       clear peLtdoC;

       WSLTAB_listaTiposDeDocumentoWeb( peLtdo
                                      : peLtdoC );
       peLtdoC +=1;
       peLtdo(peLtdoC).tido =  98;
       peLtdo(peLtdoC).datd = 'CUI';
       peLtdo(peLtdoC).dtdo = 'CUIT';

       return;

      /end-free
