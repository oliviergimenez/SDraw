bas.polygon <- function( n, shp ){
#
#   Take a BAS sample from a polygon.
#
#   input:
#   n = desired sample size,
#   shp = a SpatialPolygonsDataFrame object, according to package sp.
#
#   output a data frame containing the BAS sample.

#   Check n
if( n < 1 ){
    n <- 1
    warning("Sample size less than one has been reset to 1")
}

#   Find bounding box around everything
bb <- bbox( shp )

#   Find area of all polygons
area <- 0
for( i in 1:length(shp) ){
    area <- area + shp@polygons[[i]]@area
}

#   Find fraction of the bounding box covered by the polygons
p <- min(1, area / prod(diff(t(bb))))

#   Maximum number for random start.  Random start is uniform on integers between 1 and this number. 
max.u <- 10e7

#   Draw initial random start
my.dim <- 2 # number of dimensions we are sampling
m <- ceiling(max.u * runif( my.dim ))

#   Take initial number of Halton numbers that is approximately correct
#   This is number of samples to take to be Alpha% sure that we get n points in the study area.
q <- 1 - p
z <- qnorm(0.99)
n.init <- (n / p) + (q*z*z/(2*p)) + (z / p)*sqrt(z*z*q*q/4 + q*n)  # term in sqrt is >0 because we have control on all terms
n.init <- ceiling(n.init)
halt.samp <- halton( n.init, my.dim, m )

#   Convert from [0,1] to [bbox]
halt.samp <- bb[,"min"] + t(halt.samp) * c(diff(t(bb)))
halt.samp <- t(halt.samp)

#   Check which are in the polygon, after first converting halt.samp to SpatialPoints
crs.obj <- CRS(shp@proj4string@projargs)
halt.pts <- SpatialPointsDataFrame(halt.samp, proj4string=crs.obj, bbox = bb, data=data.frame(siteID=1:nrow(halt.samp)) )

in.poly <- over( halt.pts, shp )

#   Reject the points outside the polygon, and attach other attributes if present
keep <- !is.na(in.poly[,1])
halt.pts@data <- data.frame( in.poly )
halt.pts <- halt.pts[ keep, ]



#   The way we computed n.init, there should be more points in halt.pts than we need. Keep the initial ones.
if( nrow(halt.pts) >= n ){
    halt.pts <- halt.pts[1:n,]
    halt.pts$siteID <- 1:n   # renumber the site ID's because some (those outside polygon) were tossed above
} else {
    warning(paste("Fewer than", n, "points realized. Run again and append or increase sample size."))
}

attr(halt.pts, "halton.seed") <- m

halt.pts

}
