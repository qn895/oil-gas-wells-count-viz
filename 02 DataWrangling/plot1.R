require("dplyr")
require('ggplot2')
require('reshape2')

df = readRDS('../01 Data/dataframe.rds')
porosity_and_permeability <- df %>% dplyr::select(AVPOR, AVPERM) %>% dplyr::arrange(AVPOR)  %>% dplyr::filter(AVPOR > 0 & AVPERM > 0) %>% tbl_df 

p1 <- ggplot() +
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_log10() +
  labs(title='Permeability vs Porosity') +
  labs(x="Porosity", y="Permeability") +
  layer(data=porosity_and_permeability, 
        mapping=aes(x=as.numeric(AVPOR), y=as.numeric(AVPERM)), 
        stat="identity", 
        geom="point",
        position=position_jitter(width=0, height=0)
  )
p1
