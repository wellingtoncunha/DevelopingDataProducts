library(UsingR)
library("plyr")

GDPFile <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
GDP <- read.csv(GDPFile, skip=5, header = FALSE, nrows=190)
GDP <- GDP[, c(1, 2, 4, 5)]
colnames(GDP) <- c("Code", "Ranking", "Country", "GDP")
GDP$Ranking <- as.integer(GDP$Ranking)
GDP$GDP <- as.numeric(gsub(",", "", gsub(" ", "", GDP$GDP)))


EDUFile <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
EDU <- read.csv(EDUFile)
mergedData <- merge(GDP, EDU, by.x="Code", by.y="CountryCode")


shinyServer(
    function(input, output) {

        
         GetGDPByCountry <- function(min, max)({
             GDPByCountry <- mergedData[order(mergedData$Ranking), ]
             GDPByCountry <- GDPByCountry[,c(2,3,4,6,7)]
             GDPByCountry <- subset(GDPByCountry, GDP > min & GDP < max)
             GDPByCountry
             
         })
         
#          output$test = renderText({
#              input$InfoSelect
#          })
         
        output$TotalByIncomeGroup <- renderPlot({
             GDPByIncomeGroup <- mergedData[, c(4,6)]
             GDPByIncomeGroup <- subset(GDPByIncomeGroup, GDP > input$Range[1] & GDP < input$Range[2])
             GDPByIncomeGroup <- ddply(GDPByIncomeGroup, .(Income.Group), colwise(sum))
             GDPByIncomeGroup$GDP <- GDPByIncomeGroup$GDP / 1000 
             GDPByIncomeGroup <- GDPByIncomeGroup[order(GDPByIncomeGroup$GDP),]
             MaxValue <- max(GDPByIncomeGroup$GDP)
             xLeg <- rep(MaxValue * .55, nrow(GDPByIncomeGroup))
             yLeg <- rep(1:nrow(GDPByIncomeGroup), 1) - .5
             barplot(
                 GDPByIncomeGroup$GDP, 
                 col="Light Green", 
                 space=0, 
                 horiz=TRUE,
                 xlab="GDP (Millions of Dollars)",
                 ylab="Income Group",
                 main="GDP by Income Group",
                 axisnames=FALSE)
             text(
                 cex=0.8, 
                 x=xLeg,#c(22500, 22500, 22500, 22500, 22500), 
                 y=yLeg,#c(0.5,1.5,2.5,3.5,4.5), 
                 GDPByIncomeGroup$Income.Group,
                 xpd=TRUE) 
             })
         
         output$TotalByRegion <- renderPlot({
             GDPByRegion <- mergedData[, c(4, 7)]
            GDPByRegion <- subset(GDPByRegion, GDP > input$Range[1] & GDP < input$Range[2])
            GDPByRegion <- ddply(GDPByRegion, .(Region), colwise(sum))
            GDPByRegion$GDP <- GDPByRegion$GDP / 1000 
            GDPByRegion <- GDPByRegion[order(GDPByRegion$GDP),]
            MaxValue <- max(GDPByRegion$GDP)
            xLeg <- rep(MaxValue * .55, nrow(GDPByRegion))
            yLeg <- rep(1:nrow(GDPByRegion), 1) - .5
            barplot(
                GDPByRegion$GDP, 
                col="Light Green", 
                space=0, 
                horiz=TRUE,
                xlab="GDP (Millions of Dollars)",
                ylab="Region",
                main="GDP by Region",
                axisnames=FALSE)
            text(
                cex=0.8, 
                x=xLeg,#c(10000, 10000, 10000, 10000, 10000), 
                y=yLeg,#c(0.5,1.5,2.5, 3.5, 4.5, 5.5, 6.5), 
                GDPByRegion$Region,
                xpd=TRUE) 
            })
        
        output$Ranking <- renderDataTable({
                
            GetGDPByCountry(input$Range[1], input$Range[2])
            
            })
        outputOptions(output, 'TotalByIncomeGroup', suspendWhenHidden=TRUE)
        outputOptions(output, 'TotalByIncomeGroup', suspendWhenHidden=FALSE)
        outputOptions(output, 'Ranking', suspendWhenHidden=TRUE)
    })
        

