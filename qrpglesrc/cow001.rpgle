     H actgrp(*caller) dftactgrp(*no)
     *****************************************************************
     *  COW001  : Confirmacion de SuperPoliza                        *
     *                                                               *
     *  Alvarez Fernando                      *03/12/2015            *
     *****************************************************************
     Fcow001fm  cf   e             workstn
     Fpahec0    if   e           k disk
     Fpahed0    if   e           k disk
     Fset620    if   e           k disk
     Fset630    if   e           k disk
     Fgntpgm    if   e           k disk

     DCOW001           pr                  extpgm('COW001')
     D   empr                         1    const
     D   sucu                         2    const
     D   arcd                         6  0 const
     D   spoL                         9  0 const

     DCOW001           pi
     D peEmpr                         1    const
     D peSucu                         2    const
     D peArcd                         6  0 const
     D peSpol                         9  0 const

     DPAR310X          pr                  extpgm('PAR310X')
     D  empr                          1
     D  sucu                          2
     D  arcd                          6  0
     D  spo1                          9  0
     D  spol                          9  0
     D  sspo                          3  0
     D  modo                          3a
     D  epgm                          3a
     D  spo2                          9  0 options(*nopass)

     D                uds
     D  usempr               401    401
     D  ussucu               402    403

     D @PsDs          sds                  qualified
     D   CurUsr                      10a   overlay(@PsDs:358)
     D   pgmname                     10a   overlay(@PsDs:1)

     D $$arcd          s              6  0
     D $$spo1          s              9  0

     D $$endp          s              3    inz('   ')
     D $$mod1          s              3    inz('INT')

     D @@spo2          s              9  0

     D xxiden          s              2  0

     C                   eval      *inkc = *Off
     C                   eval      *inkl = *On
     C                   eval      x1arcd = peArcd
     C                   eval      x1spo1 = peSpol
1b C                   dow       not *inkc                                    P----------01
     C                   select
3b C                   when      xxiden = 1                                   P--------03||
     C                   exsr      pant01
     C                   endsl
1e C                   enddo                                                  F----------01
     C                   return

     C     *inzsr        begsr
     C     k1ypgm        klist
     C                   kfld                    pgausu
     C                   kfld                    pgtsbs
     C                   kfld                    pgipgm
     C     k1yec0        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1arcd
     C                   kfld                    x1spo1
     C     k1yed0        klist
     C                   kfld                    usempr
     C                   kfld                    ussucu
     C                   kfld                    x1arcd
     C                   kfld                    x1spo1
     C                   eval      xxiden = 1
     C                   call      'SP0000'
     C                   parm                    @@emsu           80
     C                   movel     @@emsu        xxemsu
     C                   eval      pgausu = @PsDs.CurUsr
     C                   eval      pgtsbs = 02
     C                   eval      pgipgm = 'COW310A'
     C     k1ypgm        chain     g1tpgm
     C                   if        not %found or pgtalt = 'N'
     C                   eval      *inkc = *On
     C                   endif
     C                   exsr      borr01
     C                   endsr

     C     pant01        begsr
     C                   exfmt     cow00101
     C                   select
     C                   when      *inkc
     C                   when      *inke
     C                   other
     C                   exsr      vali01                                                   |
     C                   endsl
     C                   endsr

     C     borr01        begsr
     C                   clear                   x1arcd
     C                   clear                   x1arno
     C                   clear                   x1spo1
     C                   setoff                                           90
     C                   endsr

     C     vali01        begsr
     C                   setoff                                       505152
     C                   setoff                                       535455
     C     x1arcd        chain     set620
     C                   if        not %found ( set620 )
     c                   eval      x1arno = *Blanks
     C                   seton                                        5051
     C                   else
     C     x1arcd        chain     set630
     c                   eval      x1arno = t@arno
     C                   endif
     C                   write     cow00101
     C                   if        not *in50
     C     k1yec0        setll     pahec0
     C                   if        not %equal ( pahec0 )
     C                   seton                                        5052
     C                   endif
     C                   endif
     C                   if        not *in50
     C     k1yed0        setgt     pahed0
     C     k1yed0        readpe    pahed0
     C                   if        d0poli <> *Zeros
     C                   seton                                        5053
     C                   endif
     C                   endif
     C                   if        not *in50
     C                   if        x1arcd = $$arcd and
     C                             x1spo1 = $$spo1
     C                   setoff                                           90
     C                   exsr      grab01
     C                   else
     C                   eval      $$arcd = x1arcd
     C                   eval      $$spo1 = x1spo1
     C                   seton                                            90
     C                   endif
     C                   endif
     C                   endsr

     C     grab01        begsr
     C                   if        t@ma44 = '2'
     C                   eval      $$spo1 = *Zeros
     C                   callp     PAR310X ( usempr : ussucu : x1arcd
     C                                     : x1spo1 : x1spo1 : d0sspo
     C                                     : $$mod1 : $$endp : $$spo1 )
     C                   else
     C                   callp     PAR310X ( usempr : ussucu : x1arcd
     C                                     : x1spo1 : x1spo1 : d0sspo
     C                                     : $$mod1 : $$endp )
     C                   endif
     C                   eval      *inkc = *On
     C                   endsr
