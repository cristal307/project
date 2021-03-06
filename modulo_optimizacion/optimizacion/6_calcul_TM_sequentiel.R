# calcul du tamano de monitoreo a partir des donnees

TME_sequencial <- function(analyse_vgam,
                           analyse_vgam2) {
  
  analyse_vgam$TM_ajustado2 <- ceiling(analyse_vgam$TM_ajustado)
  analyse_vgam2$TM_ajustado2 <- ceiling(analyse_vgam2$TM_ajustado)
  
  subVgam1 <- subset(analyse_vgam,select=c(FACTOR,Fec,TM_ajustado2))
  subVgam2 <- subset(analyse_vgam2,select=c(FACTOR,Fec,TM_ajustado2))

    monitSequencial <- merge(subVgam1,subVgam2,by=c("FACTOR","Fec"))
    monitSequencial$monit_pendiente <- ifelse(monitSequencial$TM_ajustado2.x>=monitSequencial$TM_ajustado2.y,
                                             "Ok!",ceiling(monitSequencial$TM_ajustado2.y-monitSequencial$TM_ajustado2.x))
    
    names(monitSequencial) <- c("Categorias","Mes","Num. parcelas efectuado", 
                                "Num. parcelas necesario",
                                "Num. parcelas pendiente")

  return(monitSequencial)
}