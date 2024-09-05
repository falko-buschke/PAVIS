#install.packages(c("maps","RColorBrewer"))
library(maps)
library(RColorBrewer)

# Read the data from the cleaned PAVIS Database
pavis <- read.csv("PAVIS.csv", na.strings = "NULL")

# Create a new
png(filename="Composite.png",width=28,height=28,units="cm",res=300)

#Set panel layout (bottom-left is left open to accommodate labels from panel G)
m <- (matrix(c(1,2,3,4,5,6,9,7,8), nrow = 3, ncol = 3, byrow = TRUE))
layout(mat = m)

#############################################
#                                           #
#               Panel A                     #
#                                           #
#############################################

# Plot margins
par(mai=c(0.85,0.65,0.3,0.10))

# Histogram of visitation record per year
hist(pavis$Year, main="", breaks=seq(1970, 2024,by=1),border="white",col="darkgrey",
     ylim=c(0,180),las=1,xlab="Year", ylab="Number of visitation records",   cex.axis=1.1, cex.lab= 1.5, mgp=c(3.2,0.6,0))

# Plot label
mtext("a",cex=1.4, font=2,side = 3, adj = -0.1, line = 0.5)

#############################################
#                                           #
#               Panel B                     #
#                                           #
#############################################

# Plot margins
par(mai=c(0.85,0.65,0.3,0.10))

# Histogram of visitation records 
hist(table(pavis$WDPAID), breaks=40, xlim=c(0,30),border="white",col="darkgrey",main="", las=1,ylim=c(0,60),
     xlab="Number of annual visitation records", ylab="Number of protected areas",   cex.axis=1.1, cex.lab= 1.5, mgp=c(3.2,0.6,0))

# Add a vertical line showing >5 records (these are the data plotted in panel F)
abline(v=5, lty=2, lwd=2)
# Plot label
mtext("b",cex=1.4, font=2,side = 3, adj = -0.1, line = 0.5)

#######################################################################################
#######################################################################################

# Reshape the data from long to wide format (i.e. a year by PA matrix)

# Separate the PA metadata from the visitation data
meta.dat <- pavis[2:12]
# Remove duplicates from the metadata
meta.dat.clean <- meta.dat[!duplicated(meta.dat),]

head(meta.dat.clean)

# Reshape the visitation data as a square PA x Year matrix
sq.dat <-  xtabs(Visitors~ WDPAID + Year ,pavis)

# Note, the metadata is ordered alphabetically by country, which differs for the visitation matrix.
# Thus, the data need to be aligned
visit.dat <- sq.dat[match(meta.dat.clean$WDPAID, row.names(sq.dat)),]

# Check that the WDPAIDs are the same
meta.dat.clean$WDPAID== row.names(visit.dat)

# Calcualte the average annual visiation per protected area
visit.ave <- apply(visit.dat,1,mean)

#############################################
#                                           #
#               Panel C                     #
#                                           #
#############################################

# Set this to prevent scientific notation in axis labels
options(scipen=5)

# Set plot margins
par(mai=c(0.85,0.65,0.3,0.10))

# Make plot of annual visitation vs. surface area of protected area (both axes on log-scale)
plot(meta.dat.clean$REP_AREA,visit.ave, log="xy", las=1,pch=16, col=rgb(0.25,0.25,0.25,0.65),
     xlab=expression("Surface area (km"^ 2*")"), ylab="Average annual visitors",cex=1.8,   
     cex.axis=1.1, cex.lab= 1.5, mgp=c(3.2,0.6,0), bty="n")

# Plot Label
mtext("c",cex=1.4, font=2,side = 3, adj = -0.1, line = 0.5)

#############################################
#                                           #
#               Panel D                     #
#                                           #
#############################################

# Create a vector with ISO codes for countries with data
ISO.code <- names(table(meta.dat.clean$ISO))

# Identify the full country names to match with base layers in 'maps' package
country.name <- iso.expand(ISO.code)

# The number of protected areas per countrye with visitor counts
pas <-  as.numeric(table(meta.dat.clean$ISO))

# Set plot margins
par(mai=c(0,0,0,0))

# Create basemap
map("world", fill=T, col="lightgrey", lwd=1, border="white",
    xlim=c(-20,55), ylim=c(-40,40))

# Select a colour ramp
ramp <- brewer.pal(6,"RdPu")

# Identify breaks for the colour ramp
brks <- as.numeric(cut(pas, c(0,1,2,5,10,25,50)))

# Labels for the legend
leg.txt <- c("<1", "1-2", "2-5", "5-10", "10-25", ">25")

# Match the values of each country to the colour ramp according to the predfiend breaks
colss <- brks[match(map("world", plot=FALSE)$names, country.name)]

# Map the number of protected areas with visitor data per country
map("world", fill=T, add=T,col=ramp[colss], lwd=1, border="white")#,xlim=c(-20,55), ylim=c(-40,40))

# Plot a legend
legend(-15,-10, pch=22, pt.cex=1.5, leg.txt,
       pt.bg=ramp, title="Number of\nprotected areas",bty="n")

# Label the panel
mtext("d",cex=1.4, font=2,side = 3, adj = 0.05, line = 0.5)

#############################################
#                                           #
#               Panel E                     #
#                                           #
#############################################

# Set plot margins
par(mai=c(0,0,0,0))

# Plot basemap
map("world", fill=T, col="lightgrey", lwd=1, border="white",
    xlim=c(-20,55), ylim=c(-40,40))

# Add points of protected area centroids, scaled by the average annual visitation
points(meta.dat.clean$Longitude, meta.dat.clean$Latitude,  cex=log(visit.ave+5)/3,pch=21, 
       bg=rgb(0.2,0.2,0.8,0.2), col=rgb(0.2,0.2,0.2,1), lwd=0.8)

# Add legend
legend(-15,-10, pch=21, pt.cex=log(c(10000,1000,100,10))/3, c("10000","1000","100","10"),
pt.bg=rgb(0.2,0.2,0.8,0.2), col=rgb(0.2,0.2,0.2,1), title="Mean annual\nvisitors",bty="n")

# Label plot
mtext("e",cex=1.4, font=2,side = 3, adj = 0.05, line = 0.5)

#############################################
#                                           #
#               Panel F                     #
#                                           #
#############################################

# Create a blank vector for standardized growth rates
growth.rate <- rep(NA,dim(visit.dat)[1] )
# A vector with year information 
yrs <- 1974:2023

# Run a loop to calcualte growth rates
for (i in 1: dim(visit.dat)[1]){
  # Vector of visitation data per protected areas
  vect <- visit.dat[i,]
  # If there are 5 or more records, fit a linear regression and estimate the slope parameter
  if (length(vect[which(vect!=0)])>=5) {
    growth.rate[i] <- lm(vect[which(vect!=0)]~yrs[which(vect!=0)])$coefficients[2]/max(vect[which(vect!=0)])
  }
}

# Set plot margins
par(mai=c(0,0,0,0))

# Plot basemap
map("world", fill=T, col="lightgrey", lwd=1, border="white",
    xlim=c(-20,55), ylim=c(-40,40))

# Add points with centroids of protected areas, coloured by direction adn scale by size of growth rate
points(meta.dat.clean$Longitude, meta.dat.clean$Latitude,  cex=abs(growth.rate)*20,pch=21, 
       col=rgb(0.2,0.2,0.2,1), bg=ifelse(growth.rate>=0,rgb(0,0,0.8,0.4),rgb(0.8,0,0,0.4)), lwd=0.8)

# Add legend
legend(-15,-10, pch=21, pt.cex=c(0.15,0.1,0.05,0.05,0.1,0.15)*20, c("0.15","0.1","0.05","-0.05","-0.1", "-0.15"),
       pt.bg=c(rgb(0,0,0.8,0.4),rgb(0,0,0.8,0.4),rgb(0,0,0.8,0.4), rgb(0.8,0,0,0.4),rgb(0.8,0,0,0.4),rgb(0.8,0,0,0.4))
       , col=rgb(0.2,0.2,0.2,1), title="Growth Rate\n(>4 counts)",bty="n")

# Label panel
mtext("f",cex=1.4, font=2,side = 3, adj = 0.05, line = 0.5)


#############################################
#                                           #
#               Panel G                     #
#                                           #
#############################################

# Set plot margins
par(mai=c(0.85,0.65,0.3,0.10))

# Create factors for governance categories
GOV_TYPE <- factor(meta.dat.clean$GOV_TYPE , levels=rev(c("Federal or national ministry or agency",
                                                          "Sub-national ministry or agency", "Government-delegated management", "Joint governance", "Collaborative governance",
                                                          "Individual landowners", "Local communities", "Not Applicable", "Not Reported")))

# Creat box plot
boxplot(visit.ave+1~GOV_TYPE, outline=F, frame=F, horizontal=T,las=1, ylim=c(0,60000),log="",lty=1,ylab="", 
        cex.axis=1.1, cex.lab= 1.5, mgp=c(3.2,0.6,0),xlab= "Average annual visitors", col="orange")

# Add points for individual protected areas
stripchart(visit.ave+1~GOV_TYPE,
           method = "jitter",jitter=0.2, 
           pch = 16, cex=1.5 , 
           col = rgb(0,0,0,0.25),  
           vertical = FALSE,   
           add = TRUE)

# Label panel
mtext("g",cex=1.4, font=2,side = 3, adj = -0.1, line = 0.5)

#############################################
#                                           #
#               Panel H                     #
#                                           #
#############################################

# Set plot margins
par(mai=c(0.85,0.65,0.3,0.10))

# Create factors of IUCN management categories
IUCN_Cat <- factor( meta.dat.clean$IUCN_Cat , levels=rev(c("Ib", "II", "III", "IV", "V", "VI", "Not Reported", "Not Applicable")))

# Make boxplot
boxplot(visit.ave+1~IUCN_Cat, outline=F, frame=F,,horizontal=T,las=1, ylim=c(0,60000),log="",lty=1,ylab="", 
        cex.axis=1.1, cex.lab= 1.5, mgp=c(3.2,0.6,0),xlab= "Average annual visitors", col="orange")

# Add poiunts for individual protectedd areas
stripchart(visit.ave+1~IUCN_Cat,
           method = "jitter",jitter=0.2, 
           pch = 16, cex=1.5 , 
           col = rgb(0,0,0,0.25),  
           vertical = FALSE,   
           add = TRUE)

# Label panel
mtext("h",cex=1.4, font=2,side = 3, adj = -0.1, line = 0.5)


# Close the plot device and save the image
dev.off()

#############################################################################################
