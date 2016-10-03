df = readRDS('../01 Data/dataframe.rds')
# Display a subset and summary of the data frame 
summary(df)
head(df)

subset <- subset(df, HIPERM > .5)
head(subset)