require(tidyr)
require(dplyr)

setwd("C:/Users/jenng/OneDrive/School/Class of 2017 (UT)/CS 329E - Data Visualization/Projects/dv_rproject2/01 Data")
file_name <- "GASISData.csv"

df <- read.csv(file_name, stringsAsFactors = FALSE)
names(df)

for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}
str(df)

dimensions <- c("STATE", "FLDNAME", "RESNAME", "R_STUDY", "PLAYNAME", "PLAYCOD" , "ERANM", "SUBPLAYN","SYSNM", "SERNM","S_POR", "S_PERM")

measures <- setdiff(names(df), dimensions)

measures

if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
  }
  if( length(measures) > 1 || ! is.na(measures)) {
    for(m in measures) {
      df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
    }
  }
  
  write.csv(df, paste(gsub(".csv", "", file_name), ".reformatted.csv", sep=""), row.names=FALSE, na = "")
  
  tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_name)))
  sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
  if( length(measures) > 1 || ! is.na(dimensions)) {
    for(d in dimensions) {
      sql <- paste(sql, paste(d, "varchar2(4000),\n"))
    }
  }
  if( length(measures) > 1 || ! is.na(measures)) {
    for(m in measures) {
      if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
      else sql <- paste(sql, paste(m, "number(38,4)\n"))
    }
  }
  sql <- paste(sql, ");")
  cat(sql)
  
  #Write data frame to a file
  df <- data.frame(fromJSON(getURL(URLencode('oraclerest.cs.utexas.edu:5001/rest/native/?query="select * from GASISDATA"'),httpheader=c(DB='jdbc:oracle:thin:@aevum.cs.utexas.edu:1521/f16pdb', USER='cs329e_qmn76', PASS='orcl_qmn76', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))
  saveRDS(df, '../01 Data/dataframe.rds')
  