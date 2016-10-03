require("dplyr")
require('ggplot2')
require('reshape2')

df = readRDS('../01 Data/dataframe.rds')

averages_by_state <- df  %>% dplyr::select(STATE, AVPOR, AVPERM) %>% dplyr::filter(AVPOR > 0 & AVPERM > 0) %>% group_by(STATE) %>% summarise_each(funs(mean(., na.rm=TRUE)), -STATE)

x = melt(averages_by_state)

plot3 <- ggplot(x,aes(x=STATE,y=value,fill=factor(variable)))+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_discrete(name="Reservoir Property",
                      breaks=c('AVPOR', 'AVPERM'),
                      labels=c("Average Porosity", "Average Permeability"))+
  xlab("State")+ylab("Value")

plot3 <- plot3 + theme(axis.text.x = element_text(angle = 90, hjust = 1))
plot3