     H actgrp(*caller) dftactgrp(*no)
     H option(*nodebugio:*srcstmt)
     H bnddir('HDIILE/HDIBDIR')
      * ************************************************************ *
      * COW0002 : Consulta General de Cotizaciones                   *
      *                  Asegurados                                  *
      * ------------------------------------------------------------ *
      * Luis R. Gomez                     13-Abr-2016                *
     ****************************************************************
     * Modificaciones:                                              *
     *  JSN 23/03/2021 - Se cambio el tipo de Adicional a Tomador   *
     ****************************************************************
     fcow0002m  cf   e             workstn infds(info)
     f                                     sfile(cow0002sf1:recnum1)
     f                                     sfile(cow0002sf2:recnum2)
     fctw003    if   e           k disk
     fctw004    if   e           k disk
     fsehni2    if   e           k disk
     fgnhdaf    if   e           k disk
     fgntrae    if   e           k disk
     fgntsex    if   e           k disk
     fgntesc    if   e           k disk
     fgnttdo    if   e           k disk
     fgntiv1    if   e           k disk
     fgnttce    if   e           k disk
     fgntpro01  if   e           k disk
     fgntprf02  if   e           k disk
     *
     d cow0002         pr                  extpgm('COW0002')
     d   peEmpr                       1    const
     d   peSucu                       2    const
     d   peNivt                       1  0 const
     d   peNivc                       5  0 const
     d   peNctw                       7  0 const

     d cow0002         pi
     d   peEmpr                       1    const
     d   peSucu                       2    const
     d   peNivt                       1  0 const
     d   peNivc                       5  0 const
     d   peNctw                       7  0 const
     *
     d recnum1         s              5i 0
     d recnum2         s              5i 0
     d xxiden          s              5i 0 inz(1)
     d tmpfec          s               d   datfmt(*iso) inz

     *
     d enter           c                   const(X'F1')
     *
     d @PsDs          sds                  qualified
     d   CurUsr                      10a   overlay(@PsDs:358)
     *
     d info            ds
     d cfkey                 369    369
     * ***************************************************************** *
     *                    <<<<<< COMIENZO >>>>>>                         *
     * ***************************************************************** *
     c                   dow       xxiden = 1
     c                   exsr      pant01
     c                   enddo
     c                   eval      *inlr = *on
     c                   return
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     sf1ini        begsr
      *
     c                   eval      recnum1 = *zeros
     c                   setoff                                       3031
     c                   seton                                        32
     c                   write     cow0002sc1
     c                   setoff                                       32
     c                   seton                                        31
      *
     c                   exsr      sf1car
      *
     c                   endsr
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     sf1car        begsr
      *
     c     k1y003        setll     ctw003
     c     k1y003        reade     ctw003
     c                   dow       not %eof
      *
     c                   exsr      mueve_datos
      *
     c                   seton                                        30
     c                   add       1             recnum1
     c                   write     cow0002sf1
      *
     c     k1y003        reade     ctw003
     c                   enddo
      *
     c                   eval      *in32 = %eof(ctw003)
     c                   endsr
     * ***************************************************************** *
     *  Mueve_datos: Mueve datos al subfile                              *
     * ***************************************************************** *
     c     mueve_datos   begsr
      *
     c                   eval      x1aseg = w3nomb
      *
     c                   eval      h1nase = w3nase
     c                   eval      H1asen = w3asen
     c                   if        w3nase = 1
     c                   eval      x1tase = 'Principal'
     c                   else
     c                   eval      x1tase = 'Tomador'
     c                   endif
      *
     c                   endsr
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     pant01        begsr
     c*
     c                   write     cow0002ca
     c                   write     cow0002p1
     c  n30              write     cow0002ne
     c                   exfmt     cow0002sc1
     c*
     c*                  clear                   xxmsg
     c*------------------------------------------------------- Enter, Valida
     c                   if        (cfkey = enter)
     c*
     c                   if        recnum1 > 0
     c                   exsr      opci01
     c                   endif
     c                   leaveSr
      *
     c                   endif
     c*------------------------------------------------------- F12, Retornar
     c                   if        *in12
     c                   clear                   xxiden
     c                   leaveSr
     c                   endif
      *
     c                   endsr
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     opci01        begsr
      *
     c                   readc     cow0002sf1
      *
     c                   dow       not %eof
     c                   select
     c                   when      x1opci = 5
     c                   eval      xxiden = 2
     c                   dow       xxiden = 2
     c                   exsr      carga_pant02
     c                   exsr      pant02
     c                   enddo
     c                   eval      x1opci = 0
     c                   update    cow0002sf1
     c                   endsl
      *
      *
     c                   readc     cow0002sf1
     c                   enddo
      *
     c                   endsr
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     carga_pant02  begsr
      *
     c                   clear                   x2nivt
     c                   clear                   x2nivc
     c                   clear                   x2nctw
     c                   clear                   x2nomd
     c                   clear                   x2asen
     c                   clear                   x2tiso
     c                   clear                   x2nomb
     c                   clear                   x2fnac
     c                   clear                   x2sexo
     c                   clear                   x2estc
     c                   clear                   x2tido
     c                   clear                   x2nrdo
     c                   clear                   x2cuit
     c                   clear                   x2njub
     c                   clear                   x2domi
     c                   clear                   x2copo
     c                   clear                   x2cops
     c                   clear                   x2prov
     c                   clear                   x2agre
     c                   clear                   x2civa
     c                   clear                   x2telp
     c                   clear                   x2telc
     c                   clear                   x2telt
     c                   clear                   x2naco
     c                   clear                   x2fein
     c                   clear                   x2nrin
     c                   clear                   x2feco
     c                   clear                   x2raae
     c                   clear                   x2cprf
     c                   clear                   x2ncbu
     c                   clear                   x2cbus
     c                   clear                   x2ruta
      *
     c     k1y0031       chain     ctw003
     c                   if        %found( ctw003 )
     c
     c                   eval      x2nivt  = w3nivt
     c                   eval      x2nivc  = w3nivc
     c                   eval      x2nctw  = w3nctw
     c                   eval      x2nomd  = x1nomd
     c                   eval      x2asen  = w3asen
     c                   eval      x2tiso  = w3tiso
     c                   eval      x2nomb  = w3nomb
     c                   monitor
     c                   eval      tmpfec = %date(w3fnac:*iso)
     c                   on-error
     c                   eval      tmpfec = %date(00010101: *iso)
     c                   endmon
     c                   eval      x2fnac  = %int(%char(tmpFec:*eur0))
     c     w3csex        chain     gntsex
     c                   if        %found( gntsex )
     c                   eval      x2sexo  = %trim( sedsex )
     c                   endif
     c     w3cesc        chain     gntesc
     c                   if        %found( gntesc )
     c                   eval      x2estc  = %trim( esdesc )
     c                   endif
     c     w3tido        chain     gnttdo
     c                   if        %found( gnttdo )
     c                   eval      x2tido  = %trim( gndatd )
     c                   endif
      *
     c                   eval      x2nrdo  = w3nrdo
     c                   monitor
      *
     c                   eval      x2cuit  = %int(w3cuit)
     c                   on-error
     c                   eval      x2cuit = 0
     c                   endmon
      *
     c                   eval      x2njub  = w3njub
     c                   eval      x2domi  = w3domi
     c                   eval      x2copo  = w3copo
     c                   eval      x2cops  = w3cops
     c
     c     w3rpro        chain     gntpro01
     c                   if        %found( gntpro01 )
     c                   eval      x2prov  = %trim( prprod )
     c                   endif
      *
     c                   eval      x2agre  = w3agre
     c     w3civa        chain     gntiv1
     c                   if        %found( gntiv1 )
     c                   eval      x2civa  = %trim( i1ncil )
     c                   endif
      *
     c                   eval      x2telp  = w3telp
     c                   eval      x2telc  = w3telc
     c                   eval      x2telt  = w3telt
     c                   eval      x2naco  = w3naco
     c                   monitor
     c                   eval      tmpfec = %date(w3fein:*iso)
     c                   on-error
     c                   eval      tmpfec = %date(00010101: *iso)
     c                   endmon
     c                   eval      x2fein  = %int(%char(tmpFec:*eur0))
     c                   eval      x2nrin  = w3nrin
     c                   monitor
     c                   eval      tmpfec = %date(w3feco:*iso)
     c                   on-error
     c                   eval      tmpfec = %date(00010101: *iso)
     c                   endmon
     c                   eval      x2feco  = %int(%char(tmpFec:*eur0))
     c     w3raae        chain     gntrae
     c                   if        %found( gntrae )
     c                   eval      x2raae  = aedeae
     c                   endif
     c     w3cprf        chain     gntprf02
     c                   if        %found( gntprf02 )
     c                   eval      x2cprf  = %trim( prdprf )
     c                   endif
     c
     c                   eval      x2ncbu  = w3ncbu
     c                   eval      x2cbus  = w3cbus
     c                   eval      x2ruta  = w3ruta
     c                   endif
     c
     c
     c                   endsr
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     pant02        begsr
     c                   write     cow0002ca
     c                   write     cow0002p2
     c                   exfmt     cow000202
     c
     c*------------------------------------------------------- F11, Mail
     c                   if        *in11
     c                   exsr      sf2ini
     c                   eval      xxiden = 3
     c                   dow       xxiden = 3
     c                   exsr      pant03
     c                   enddo
     c                   leaveSr
     c                   endif
      *
     c*------------------------------------------------------- F12, Retornar
     c                   if        *in12
     c                   eval      xxiden = 1
     c                   leaveSr
     c                   endif
      *
     c                   endsr
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     sf2ini        begsr
      *
     c                   eval      recnum2 = *zeros
     c                   setoff                                       4041
     c                   seton                                        42
     c                   write     cow0002sc2
     c                   setoff                                       42
     c                   seton                                        41
      *
     c                   exsr      sf2car
      *
     c                   endsr
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     sf2car        begsr
      *
     c     k1y004        setll     ctw004
     c     k1y004        reade     ctw004
     c                   dow       not %eof
     c                   clear                   cow0002sf2
      *
     c                   exsr      mueve_datos2
      *
     c                   seton                                        40
     c                   add       1             recnum2
     c                   write     cow0002sf2
      *
     c     k1y004        reade     ctw004
     c                   enddo
      *
     c                   eval      *in42 = %eof(ctw004)
     c                   endsr
     * ***************************************************************** *
     *  Mueve_datos: Mueve datos al subfile                              *
     * ***************************************************************** *
     c     mueve_datos2  begsr
      *
     c     w4ctce        chain     gnttce
     c                   if        %found( gnttce )
     c                   eval      x3dtce = cedtce
     c                   endif
     c                   eval      x3mail = w4mail
      *
     c                   endsr
     * ***************************************************************** *
     *                                                                   *
     * ***************************************************************** *
     c     pant03        begsr
     c                   exfmt     cow0002sc2
     c
     c*------------------------------------------------------- F12, Retornar
     c                   if        *in12
     c                   eval      xxiden = 2
     c                   leaveSr
     c                   endif
      *
     c                   endsr
     * ***************************************************************** *
     *  INZSR: Inicio de Proceso                                         *
     * ***************************************************************** *
     c     *inzsr        begsr
      *
     c     k1yni2        klist
     c                   kfld                    peEmpr
     c                   kfld                    peSucu
     c                   kfld                    peNivt
     c                   kfld                    peNivc
     c
     c     k1y003        klist
     c                   kfld                    peEmpr
     c                   kfld                    peSucu
     c                   kfld                    peNivt
     c                   kfld                    peNivc
     c                   kfld                    peNctw
     c     k1y0031       klist
     c                   kfld                    peEmpr
     c                   kfld                    peSucu
     c                   kfld                    peNivt
     c                   kfld                    peNivc
     c                   kfld                    peNctw
     c                   kfld                    h1nase
     c                   kfld                    h1asen
     c
     c     k1y004        klist
     c                   kfld                    peEmpr
     c                   kfld                    peSucu
     c                   kfld                    peNivt
     c                   kfld                    peNivc
     c                   kfld                    peNctw
     c                   kfld                    h1nase
      *
     c     k1yni2        chain     sehni2
     c     n2nrdf        chain     gnhdaf
     c                   eval      x1nivt = peNivt
     c                   eval      x1nivc = peNivc
     c                   eval      x1nctw = peNctw
     c                   eval      x1nomd = dfnomb
      *
     c                   call      'SP0000'
     c                   parm                    xxemsu
     c                   eval      xxiden = 1
     c                   eval      XXPGM = 'COW0002'
      * Inicio Subfile...
     c                   exsr      sf1ini
      *
     c                   endsr
