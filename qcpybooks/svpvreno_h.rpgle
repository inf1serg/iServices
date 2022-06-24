      ****************************************************************
      *  Recuperar si una póliza es o no renovable.
      *  Pedido de desarrollo 3303
      *
      *  Inf1Marc  17/01/2014
      ****************************************************************
     D SVPVRENO_SuperPolizaRenovable...
     D                 pr             1n
     D   Peempr                       1    const
     D   Pesucu                       2    const
     D   Pearcd                       6P 0 const
     D   Pespol                       9P 0 const
     D   peAudi                            likeds(Audit_t)
     D                                     options(*nopass:*omit)
     D SVPVRENO_PolizaRenovable...
     D                 pr             1n
     D Peempr                         1    const
     D Pesucu                         2    const
     D Perama                         2P 0 const
     D Pepoli                         7P 0 const
     D Pefchamd                       8P 0 const options(*nopass:*omit)
     D   peAudi                            likeds(Audit_t)
     D                                     options(*nopass:*omit)
     D SVPVRENO_Fecha_de_emision...
     D                 pr             8P 0
     D Peempr                         1    const
     D SVPVRENO_inz    pr
     D SVPVRENO_End    pr

     D SVPVRENO_Error  pr            80a
     D   peEnbr                      10i 0 options(*nopass:*omit)

     D Audit_t         ds                  qualified based(template)
     D  Moti                        350a
     D  User                         10a
     D  Fech                          8  0
     D  Hora                          6  0

