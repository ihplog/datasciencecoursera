y <- 4
class(y)

z <- 1:4 
w <- 2:3
z+w

x <- hw1_data
x[47,1]
sum(is.na(x$Ozone))
bad <-is.na(x[ ,1])
(x[ ,1])[!bad]
mean((x[ ,1])[!bad])

dataSolar <- x[x$Ozone > 31, , drop=FALSE]
dataTemp <- dataSolar[dataSolar$Temp > 90, , drop=FALSE]
dataST <- na.omit(dataTemp)
mean(dataST$Solar.R)

datajune <- x[x$Month == 6, , drop = FALSE]
datajune0 <- na.omit(datajune)
mean(datajune0$Temp)

datamay <- x[x$Month == 5, , drop = FALSE]
datamay0 <- na.omit(datamay)
max(datamay0$Ozone)