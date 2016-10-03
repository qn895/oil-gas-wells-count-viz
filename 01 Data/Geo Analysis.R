require("RCurl")
require("jsonlite")
require("dplyr")

# Read in data from DB
df <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from GASISDATA"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

# Display a subset and summary of the data frame 
summary(df)
head(df)

subset <- subset(df, HIPERM > .5)
head(subset)

subset <- subset(df, SYSNM == 'CRETACEOUS')
head(subset)

# Describe at least 3 INTERESTING data wrangling sets of operations using %>% in each. There should be a group_by in at least one of them.
df %>% dplyr::select(AVPOR, AVPERM,FLDNAME) %>% dplyr::filter(FLDNAME == "WEST DELTA BLK 30") %>% tbl_df

# Get the resevoir temperation, etc. for data in Texas only
df %>% dplyr::select(RESTEMP, ERANM,PLAYNAME,SYSNM,STATE) %>% dplyr::filter(STATE == "TEXAS") %>% tbl_df

# Arrange the data from lowest avg porosity to highest
df %>% dplyr::arrange(AVPOR) %>% tbl_df 

# Select columns and display it from highest average permeability to lowest
df %>% dplyr::select(AVPOR, AVPERM, HIPOR, LOPOR, LOPERM, HIPERM, FLDNAME) %>% dplyr::arrange(desc(AVPERM)) %>% tbl_df # Equivalent SQL:  dplyr::select * from diamonds order by carat;

# Get a summary of count of rows/data for each fieldname from each state
df %>% group_by(STATE,FLDNAME) %>% dplyr::summarise(n = n()) %>% dplyr::arrange(desc(n)) %>% tbl_df

# Get a summary of count of rows/data for each geologic era
df %>% group_by(ERANM,SYSNM,SERNM) %>% dplyr::summarise(n = n()) %>% dplyr::arrange(desc(n)) %>% tbl_df
