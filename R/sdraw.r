#' @title Sample draws from spatial objects.
#'
#' @description Draw samples (point locations) from \code{SpatialPoints}, \code{SpatialLines}, 
#' \code{SpatialPolygons}, and the \code{*DataFrame} varieties of each. 
#'  
#'  
#' @param x A spatial object.  Methods are implemented for \code{SpatialPoints}, 
#' \code{SpatialPointsDataFrame}, \code{SpatialLines}, \code{SpatialLinesDataFrame}, 
#' \code{SpatialPolygons}, and 
#' \code{SpatialPolygonsDataFrame} objects. 
#' @param n Desired sample size.  Some \code{type}'s of samples are fixed-size (see DETAILS), 
#' in which case 
#' exactly \code{n} points are returned.  Other \code{type}'s are variable-size, 
#' and this number is the expected sample size (i.e., average over many repititions). 
#' @param type Character, naming the type of sample to draw. Valid \code{type}'s are:
#' \itemize{
#' \item \code{"HAL"}  : HAlton Lattice sampling (Robertson et al., (Forthcoming)) 
#' \item \code{"BAS"}  : Balanced Acceptance Sampling (Robertson et al., 2013) 
#' \item \code{"SSS"}  : Simple Systematic (grid) Sampling, with random start and orientation 
#' \item \code{"GRTS"} : Generalized Random Tesselation Stratified sampling 
#'      (Stevens and Olsen, 2004) 
#' \item \code{"SRS"}  : Simple Random Sampling 
#' }
#'
#' @param ... Optional arguments passed to underlying sample type method.  See DETAILS.
#'  
#' @details This is a S4 generic method for types \code{SpatialPoints*}, \code{SpatialLines*}, 
#' and \code{SpatialPolygons*} objects.  
#'  
#' \code{HAL, BAS, GRTS, SRS} are fixed-size designs (return exactly \code{n} points).
#' \code{SSS} is variable-sized. 
#'
#' Options which determine characteristics of each 
#' sample time are passed via \code{...}.  For example, 
#' spacing and "shape" of the grid in \code{sss.*} are controled via
#' \code{spacing=} and \code{triangular=}, while the
#' \code{J} and \code{eta} parameters (which determine box sizes) 
#' are passed to \code{hal.*}.  See documentation for 
#' \code{hal.*}, \code{bas.*}, \code{sss.*}, \code{grts.*}, and \code{sss.*} 
#' for the full list of  
#' parameters which determine sample characteristics.  
#'  
#'
#' @return A \code{SpatialPointsDataFrame} object.  At a minimum, the data frame 
#' embedded in the \code{SpatialPoints} object contains a column named \code{siteID} which 
#' numbers the points. If \code{x} is a \code{Spatial*DataFrame}, the return's  data
#' frame contains all attributes of \code{x} evaluated at the locations of the sample points.
#' After \code{siteID} and existing attributes, the sampling routine may add attributes 
#' that are pertenent to the design. For example, the \code{grts.*} routines add
#' a \code{pointType} attribute.  See documentation for the underlying sampling routine
#' to interpret extra output point attributes.  
#' 
#' @author Trent McDonald
#'
#' @references 
#'  Robertson, B.L., J. A. Brown,  T. L. McDonald, and P. Jaksons (2013) "BAS: 
#'  Balanced Acceptance Sampling of Natural Resources", Biometrics, v69, p. 776-784.
#'  
#'  Stevens D. L. Jr. and A. R. Olsen (2004) "Spatially Balanced Sampling of Natural Resources", 
#'  Journal of the American Statistical Association, v99, p. 262-278.
#'  
#' @seealso 
#'  \code{\link{bas.polygon}}, \code{\link{bas.line}}, \code{\link{bas.point}},
#' \code{\link{hal.polygon}}, \code{\link{hal.line}}, \code{\link{hal.point}}, 
#' \code{\link{sss.polygon}}, \code{\link{sss.line}},  \code{\link{sss.point}},
#' \code{\link{grts.polygon}}, \code{\link{grts.line}}, \code{\link{grts.point}}
#'    
#' @examples 
#'  WA.sample <- sdraw(WA, 100, "HAL")
#'  WA.sample <- sdraw(WA, 100, "SSS", spacing=c(1,2))
#'  
#' @name sdraw
#'  
#' @aliases sdraw sdraw.SpatialLines sdraw.SpatialPoints sdraw.SpatialPolygons
#'  
#' @export
#' 
#' @docType methods

sdraw <- function(x, n, type="BAS", ...) UseMethod("sdraw")

setMethod("sdraw", c(x="SpatialPolygons"), sdraw.SpatialPolygons)

setMethod("sdraw", c(x="SpatialLines"), sdraw.SpatialLines)

setMethod("sdraw", c(x="SpatialPoints"), sdraw.SpatialPoints)

