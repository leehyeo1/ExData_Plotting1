# To download the file from the web
if(!file.exists("./data")) {dir.create("data")}
if(!file.exists("./data/household_power_consumption.txt")) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile = "./data/elecDt.zip")
        # To unzip the file we downloaded
        zFilepath <- "./data/elecDt.zip"
        unzDt <- "./data"
        unzip(zFilepath, exdir = unzDt)
}

# Now to load the downloaded file into R
# First I saved path to a data file
filePath <- "./data/household_power_consumption.txt" 
# To read ONLY the data from date of "01/02/2007" and "02/02/2007" 
# skip the rows right before of "01/02/2007"
# and specify the number of rows to read in from the start point
elecDt <- read.table(filePath, sep = ";", col.names = c("Date", "Time", "Global_active_power", 
                                                        "Global_reactive_power", "Voltage", "Global_intensity",
                                                        "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                     skip = grep("^1/2/2007", readLines(con = filePath))[1] - 1, 
                     nrows = length(grep("^1/2/2007|^2/2/2007", 
                                         readLines(con = filePath)))
)

# Now to create Plot 3
# first I installed 'lubridate' package for convenience
if(!"lubridate" %in% rownames(installed.packages())) {install.packages(lubridate)}
# and load the package just installed
library(lubridate)

# Since, the date and time variables are all character strings,
# they should be converted to date class and save it to 'DateTime' variable
elecDt$DateTime <- with(elecDt, dmy(Date) + hms(Time))

# To laungh file device
png(filename = "plot4.png")
# To set the layout of screen device for placing four plots
par(mfrow = c(2, 2))
# To create multiple plots
with(elecDt, {
        # top left plot
        plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power", xlab = "")
        # top right plot
        plot(DateTime, Voltage, type = "l", xlab = "datetime")
        # bottom left plot
        plot(DateTime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
        points(DateTime, Sub_metering_2, type = "l", col = "red")
        points(DateTime, Sub_metering_3, type = "l", col = "blue")
        legend("topright", lty = c(1, 1, 1), col = c("black", "red", "blue"), 
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
        plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime")
})
# copy the plot to png file device
dev.off()