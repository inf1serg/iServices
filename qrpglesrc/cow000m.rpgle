     H dftactgrp(*no) actgrp(*caller)
     H option(*nodebugio:*srcstmt)
      * ************************************************************** *
      * COW000M: QUOM Web                                              *
      *          Visualizar mensajes de cotización.                    *
      * -------------------------------------------------------------- *
      * Sergio Fernandez                   *18-Ene-2016                *
      * -------------------------------------------------------------- *
      *                                                                *
      * ************************************************************** *
     Fctwmsg    if   e           k disk
     Fctw000    if   e           k disk
     Fsehni201  if   e           k disk
     Fcow000mm  cf   e             workstn sfile(cow000s1:sf1rrn)

     D COW000M         pr                  extpgm('COW000M')
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     D COW000M         pi
     D  peEmpr                        1a   const
     D  peSucu                        2a   const
     D  peNivt                        1  0 const
     D  peNivc                        5  0 const
     D  peNctw                        7  0 const

     Dgira_fecha       pr             8  0
     D                                8  0 const
     D                                3a   const options(*rightadj)

     D pivse           s              5  0
     D uivse           s              5  0
     D xxiden          s              1  0
     D sf1rrn          s              2  0

     C                   eval      *inlr = *on
     C                   exsr      carg00
     C                   dow       not *inkc
     C                   select
     C                   when      xxiden = 1
     C                   exsr      pant01
     C                   when      xxiden = 2
     C                   exsr      pant02
     C                   endsl
     C                   enddo
     C                   return

     C     sf1car        begsr
     C                   exsr      sf1bor
     C     k1wmsg        setll     ctwmsg
     C     kxwmsg        reade     ctwmsg
     C                   dow       not %eof and
     C                             sf1rrn < 8
      *
     C                   eval      x1ivse = msivse
     C                   eval      x1ausu = msuser
     C                   eval      x1fech = gira_fecha(msdate:'DMA')
     C                   eval      x1time = mstime
     C                   eval      x@txmg = %subst(mstxmg:1:35)
     C                   eval      x1txmg = mstxmg
     C                   eval      x1cpgm = mscpgm
      *
     C                   seton                                        30
     C                   add       1             sf1rrn
     C                   write     cow000s1
      *
     C                   if        sf1rrn = 1
     C                   eval      pivse = msivse
     C                   endif
     C                   eval      uivse = msivse
      *
     C     kxwmsg        reade     ctwmsg
     C                   enddo
     C                   eval      *in32 = %eof
     C                   endsr

     C     sf1bor        begsr
     C                   eval      x1opci = *zeros
     C                   setoff                                       3031
     C                   seton                                        32
     C                   write     cow000c1
     C                   setoff                                       32
     C                   seton                                        31
     C                   eval      sf1rrn = *zeros
     C                   endsr

     C     avanc         begsr
     C     k2wmsg        setgt     ctwmsg
     C     kxwmsg        reade     ctwmsg
     C                   if        %eof
     C                   eval      uivse = pivse
     C                   else
     C                   eval      uivse = msivse
     C                   endif
     C                   exsr      sf1car
     C                   endsr

     C     retro         begsr
     C                   eval      sf1rrn = *zeros
     C                   eval      uivse = pivse
     C     k1wmsg        setll     ctwmsg
     C                   dow       sf1rrn < 8
     C     kxwmsg        readpe    ctwmsg
     C                   if        %eof
     C                   leave
     C                   else
     C                   add       1             sf1rrn
     C                   endif
     C                   eval      uivse = msivse
     C                   enddo
     C                   exsr      sf1car
     C                   endsr

     C     pant01        begsr
     C                   write     cow000ca
     C                   write     cow000p1
     C  n30              write     cow000ne
     C                   exfmt     cow000c1
     C                   exsr      apagar
     C                   select
      * Retroceso de Pagina...
     C                   when      *in27
     C                   exsr      retro
      * Avance de Pagina...
     C                   when      *in28
     C                   exsr      avanc
      * F3=Salir...
     C                   when      *inkc
     C                   other
     C                   exsr      opci01
     C                   endsl
     C                   endsr

     C     opci01        begsr
     C                   if        *in30
     C                   readc     cow000s1
     C                   select
      * Consultas...
     C                   when      x1opci = 5
     C                   eval      x2txmg = x1txmg
     C                   eval      xxiden = 2
      *
     C                   endsl
     C                   endif
     C                   endsr

     C     pant02        begsr
     C                   exfmt     cow00001
     C                   select
     C                   when      *inkl
     C                   eval      uivse = pivse
     C                   exsr      sf1car
     C                   eval      xxiden = 1
     C                   other
     C                   endsl
     C                   endsr

     C     apagar        begsr
     C                   endsr

     C     carg00        begsr
     C     k1w000        chain     ctw000
     C                   if        not %found
     C                   eval      *inkl = *on
     C                   leavesr
     C                   endif
     C                   eval      x1soln = w0soln
     C     k1hni2        chain     sehni201                           20
     C   20              eval      x1nomb = *all'*'
     C  n20              eval      x1nomb = dfnomb
     C                   endsr

     C     *inzsr        begsr
     C                   eval      xxiden = 1
     C                   exsr      sf1car
     C                   call      'SP0000'
     C                   parm                    xxemsu
     C     k1w000        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    penivt
     C                   kfld                    penivc
     C                   kfld                    penctw
     C     k1hni2        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    penivt
     C                   kfld                    penivc
     C     kxwmsg        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    penivt
     C                   kfld                    penivc
     C                   kfld                    penctw
     C     k1wmsg        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    penivt
     C                   kfld                    penivc
     C                   kfld                    penctw
     C                   kfld                    uivse
     C     k2wmsg        klist
     C                   kfld                    peempr
     C                   kfld                    pesucu
     C                   kfld                    penivt
     C                   kfld                    penivc
     C                   kfld                    penctw
     C                   kfld                    x1ivse
     C                   endsr

     P gira_fecha      B
     D gira_fecha      PI             8  0
     D @@feve                         8  0 CONST
     D @@tipo                         3A   CONST OPTIONS(*RIGHTADJ)
     D retField        S              8  0
     D                 ds                  inz
     Dp@famd                  01     08  0
     D@@aÑo                   01     04  0
     D@@mes                   05     06  0
     D@@dia                   07     08  0
     D                 ds                  inz
     Dp@fdma                  01     08  0
     D$$dia                   01     02  0
     D$$mes                   03     04  0
     D$$aÑo                   05     08  0
     *
     C                   select
     C                   when      @@tipo = 'AMD'
     C                   eval      p@fdma = @@feve
     C                   eval      @@aÑo = $$aÑo
     C                   eval      @@mes = $$mes
     C                   eval      @@dia = $$dia
     C                   eval      retfield = p@famd
     C                   when      @@tipo = 'DMA'
     C                   eval      p@famd = @@feve
     C                   eval      $$aÑo = @@aÑo
     C                   eval      $$mes = @@mes
     C                   eval      $$dia = @@dia
     C                   eval      retfield = p@fdma
     C                   endsl
     C                   RETURN    retField
     P gira_fecha      E
