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

# Now I create histogram 
with(elecDt, hist(Global_active_power, col = "red", main = "Global Active Power", breaks = 11, 
                  xlab = "Global Active Power (kilowatts)"))
# and then copy the plot to png device
dev.copy(png, file = "plot1.png")
dev.off()