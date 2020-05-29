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

# Now to create Plot 2
# first I installed 'lubridate' package for convenience
if(!"lubridate" %in% rownames(installed.packages())) {install.packages(lubridate)}
# and load the package just installed
library(lubridate)

# Since, the date and time variables are all character strings,
# they should be converted to date class and save it to 'DateTime' variable
elecDt$DateTime <- with(elecDt, dmy(Date) + hms(Time))

# now with the new variable, I created the line graph
with(elecDt, plot(DateTime, Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)"))
dev.copy(png, file = "plot2.png")
dev.off()

