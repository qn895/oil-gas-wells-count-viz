require("dplyr")
require('ggplot2')
require('reshape2')

df = readRDS('../01 Data/dataframe.rds')
wells_in_state <- df %>% group_by(STATE) %>% dplyr::summarise(n = n()) %>% dplyr::arrange(desc(n)) %>% tbl_df


p2 <- ggplot() +
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_log10() +
  labs(title='Wells in States') +
  labs(x="State", y="Wells") +
  layer(data=wells_in_state, 
        mapping=aes(x=STATE, y=as.numeric(n)), 
        stat="identity", 
        geom="bar",
        position=position_jitter(width=0, height=0)
  )

p2 <- p2  + theme(axis.text.x = element_text(angle = 90, hjust = 1))
p2
