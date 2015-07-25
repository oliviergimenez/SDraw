#' @export
#' 
#' @title Balanced Acceptance Sampling. 
#' 
#' @description Draw a BAS sample from a \code{SpatialPoints}, \code{SpatialLines}, 
#' or \code{SpatialPolygons} object. The same can be accomplished through \code{spsample} 
#' with \code{type="BAS"}.
#' 
#' @param n  Sample size.  Number of locations to draw from the spatial object. BAS
#' is fixed-size, so this is exact.
#' 
#' @param shp Name of the spatial object. This must be a \code{SpatialPoints}, \code{SpatialLines}, 
#' or \code{SpatialPolygons}.   \code{SpatialPointsDataFrame}, \code{SpatialLinesDataFrame}, 
#' and \code{SpatialPolygonsDataFrame} objects are also accepted. 
#' 
#'  @return A \code{SpatialPointsDataFrame} object.  At a minimum, the data frame 
#'  embedded in the returned object contains a column named \code{siteID} which 
#'  is a unique ID for the points. If \code{shp} is a \code{Spatial?DataFrame}, the return's  data
#'  frame contains all attributes of \code{shp} evaluated at the locations of the sample points.
#'  
#'  @author  Trent McDonald
#'  
#'  #'  @references 
#'  Robertson, B.L., J. A. Brown,  T. L. McDonald, and P. Jaksons (2013) “BAS: 
#'  Balanced Acceptance Sampling of Natural Resources”, Biometrics, v69, p. 776-784.
#'  
#'  @seealso  \code{\link{spsample}}, \code{\link{bas.point}}, \code{\link{bas.line}}, \code{\link{bas.polygon}}
#'  
#'  @examples
#'    
#'#   Polygons: Draw points from the polygons that make up Washington.  
#'data(WA)
#'WA.sample <- bas( 100, WA )
#'plot( WA )
#'points( WA.sample, pch=16, col="red" )
#'  
#'#   Count number of points in each polygon, and plot vs area.
#'#   n in each should be proportional to area.
#'area <- sapply(slot(WA, "polygons"), function(i) slot(i, "area"))
#'id <- sapply(slot(WA, "polygons"), function(i) slot(i, "ID"))
#'WA.polys <- data.frame(sp.object.ID=id, area=area)
#'WA.counts <- data.frame(table(WA.sample$sp.object.ID))
#'names(WA.counts) <- c("sp.object.ID", "n")
#'WA.counts <- merge(WA.polys, WA.counts, all.x=TRUE)
#'WA.counts$n[ is.na(WA.counts$n) ] <- 0
#'plot( WA.counts$area, WA.counts$n )
#'
#'\donttest{
#'#   Lines: Draw points along coastline of Hawaii
#'#   This takes approximately 60 seconds on a laptop
#'data(HI.coast)
#'HI.coast.samp <- bas( 100, HI.coast )
#'plot(HI.coast)
#'points(HI.coast.samp, col="red", pch=16 )
#'    
#'#   Points: Sample cities in Washington
#'#   This takes approx 2 minutes to run.
#'data(WA.cities)
#'WA.city.sample <- bas( 100, WA.cities )
#'plot( WA )
#'plot( WA.cities, add=T)
#'points( WA.city.sample, pch=16, col="red" )
#'}

bas <- function(n, shp){

    
    if( regexpr("SpatialPoints", class(shp)[1]) > 0 ){

        samp <- bas.point( n, shp )
        
    } else if (regexpr("SpatialLines", class(shp)[1]) > 0 ){

        samp <- bas.line( n, shp )
    
    } else if (regexpr("SpatialPolygons", class(shp)[1]) > 0 ){
    
        samp <- bas.polygon( n, shp )
    
    } else {
        stop( "Unknown spatial object type" )
    }
    
    samp
}
    

  


