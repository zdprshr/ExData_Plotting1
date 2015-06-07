# plot3.R - Plots the fourth plot (grid of 2x2 plots)

# Check and if not present, get from internet site, the data-set
zipfile <- "./exdata-data-household_power_consumption.zip"
dsfile <- "./household_power_consumption.txt"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!file.exists(dsfile)) {
  download.file(url, destfile=zipfile)
  unzip(zipfile)
}

# First Read only the date column of the data set
datesTable <- read.table(file=dsfile, sep=";", header=TRUE, colClasses=c("character", rep("NULL",8)))

# Then find the offset to 1/2/2007 in this column
offset1 <- grep("1/2/2007", datesTable$Date)[1]

offset2 <- grep("2/2/2007", datesTable$Date)[1]

# and the offset to 3/2/2007
offset3 <- grep("3/2/2007", datesTable$Date)[1]

# Since we know that the readings are in a time sequence, we can skip (offset1-1) rows and then read (offset3-offset1) number of rows. This way we read only the 2 day's worth of rows

# But before we do that, lets get the header from the file by reading only 1 row
table <- read.table(file=dsfile, sep=";", header=TRUE, nrows=1)
header <- names(table)

# Now lets read only 2 day's of data from the file
table <- read.table(file=dsfile, sep=";", header=TRUE, skip=(offset1-1), nrows=(offset3-offset1), col.names=header)

# Lets add another column with is POSIX DATETIME obtained by combining the existing Date and Time columsn using strptime()
# This allows us to plot against time
table$datetime <- strptime(paste(table$Date, table$Time), "%d/%m/%Y %H:%M:%S")

# Lets open PNG device and set to 480 x 480 px
png(width=480, height=480, file="./figure/plot4.png")

# set background to transparent
par(bg=NA)

# All set to do the fourth plot - 2x2 grid of plots
par(mfrow=c(2,2))
plot(table$datetime, table$Global_active_power, type="l", ylab="Global Active Power", xlab="")
plot(table$datetime, table$Voltage, type="l", ylab="Voltage", xlab="")
par(col="black")
plot(table$datetime, table$Sub_metering_1, type="n", ylab="Energy sub metering", xlab="")
lines(table$date, table$Sub_metering_1)
par(col="red")
lines(table$date, table$Sub_metering_2)
par(col="blue")
lines(table$date, table$Sub_metering_3)
par(col="black")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), lty=c(1,1,1), bty="n")
plot(table$datetime, table$Global_reactive_power, type="l", ylab="Global Reactive Power", xlab="")

# switch of the PNG device
dev.off()