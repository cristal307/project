# Graph des tamano de monitoreo en fonction des combinaisons

func_plot_TME <- function(vgam.salida_ajust){
library(plyr)

incMedia <-  aggregate(data.frame(p=vgam.salida_ajust$p),
                        by=list(Fec=vgam.salida_ajust$Fec),
                        mean,na.rm=T)

# df_sorted <- arrange(vgam.salida_ajust, Fec, FACTOR)
df_sorted <- arrange(vgam.salida_ajust, Fec, desc(FACTOR))

df_cumsum <- ddply(df_sorted, "Fec",
                   transform, label_TM_cum=cumsum(TM_ajustado))
                   # transform, label_TM_cum=cumsum(TM))
df_cumsum$TM_arr <- ceiling(df_cumsum$TM_ajustado)
# df_cumsum$TM_arr <- floor(df_cumsum$TM)

# !!!!! Ajuster echelle incidence echelle parcelle

# Plot
ggplot() +
  # geom_bar(data=df_cumsum, aes(x=Fec, y=TM, fill=FACTOR),stat="identity")+
  geom_bar(data=df_cumsum, aes(x=Fec, y=TM_ajustado, fill=FACTOR),stat="identity")+
  geom_text(data=df_cumsum,aes(x=Fec, y=label_TM_cum, label=TM_arr), vjust=1,
            color="white", size=3.5)+
  # scale_fill_brewer("Categorias",palette="YlOrRd")+
  scale_colour_gradientn(colours=rainbow(4))+
  geom_line(data=incMedia, aes(x=Fec,y=p*100*max(df_cumsum$label_TM_cum)/(max(incMedia$p)*100)),
            size=1)+
  geom_point(data=incMedia, aes(x=Fec,y=p*100*max(df_cumsum$label_TM_cum)/(max(incMedia$p)*100)),
             size=2, shape=21)+
  scale_x_continuous(name = "Meses de monitoreo",
                     breaks=seq(1, 12, 1),
                     labels=c("Ene","Feb","Mar","Abr","May","Jun",
                              "Jul","Aug","Sep","Oct","Nov","Dec"))+
  scale_y_continuous(name = "Numero de parcelas", 
                     breaks=seq(0, max(df_cumsum$label_TM_cum+50), 100),
                     # sec.axis = sec_axis(~./1, name = "Incidencia",
                     sec.axis = sec_axis(~.*(max(incMedia$p)*100)/max(df_cumsum$label_TM_cum), name = "Incidencia",
                     breaks=seq(0, max(incMedia$p)*100, ceiling(max(incMedia$p)*100/10))))+
  theme_minimal()

}

