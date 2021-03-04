

#####
#####

##### The functions below are used as source code in the illustration markdown file.



####  Function to calculate the median 2D Euclidean distance
plane_distance <- function(sp1,sp2){
  
    # calculate Euclidean distance between two sets of points 
  distances <- proxy::dist(sp1,sp2,method = 'Euclidean')
  
    # find the median distance from the first set
  medianfromsp1 <- median(apply(distances, 1, median))
  
    # select the median from the first set
  return(medianfromsp1)
}

####  Function to calculate max distance between two sets of points
####    used to scale the measure.
max_dist <- function(pts){
  
    #calculate Euclidean distances between all points
  distances <- proxy::dist(pts %>% dplyr::select(dim1,dim2),
                           pts %>% dplyr::select(dim1,dim2))
  
    # select the maximum distance
  return(max(distances))
}

####  Return a sf minimum bounding convex polygon from a set of coordinates
sp_as_sf <- function(sp){
  
    #find the coordinates for the vertices of the minimum bounding convex polygon
  sp_hull <- sp %>% 
    slice(chull(sp))
   
    # create an sf object from the polygon coordinates
  sp.sf <- st_as_sf(sp_hull,coords=c("dim1","dim2"))
  sp.sf <- st_combine(sp.sf$geometry) %>% 
    st_cast("POLYGON")
  
    #return the sf polygon
  return(sp.sf)
}



####  Function calculating the overlap of species
RAD_index <- function(sp1, sp2){
  
    # select the coordinates for each record
  sp1 <- sp1 %>% dplyr::select(dim1,dim2)
  sp2 <- sp2 %>% dplyr::select(dim1,dim2)
  
    # create sf polygon object for each set of coordinates
  x <- sp_as_sf(sp1)
  y <- sp_as_sf(sp2)
  
    # calculate the area of each sf polygon
  sp.a1 <- st_area(x)
  sp.a2 <- st_area(y)
  
    # calculate the amount of overlap between the two polygons
  interxy <- st_intersection(x,y)
  interxy <- sum(sf::st_area(interxy))
  
    # calculate the relative overlap (RO) from A with respect to B
  ROab <- 1 - as.numeric(((sp.a1 - interxy) / sp.a1))
  
    # adjust the distance from A to B by the amount of overlap
  distAB <- plane_distance(sp1,sp2) * (1-ROab)
  
    # scale the distance with reference to the maximum distance in between the two points
  scaled_distAB <- distAB/(max_dist(rbind(sp1,sp2)))
  
    # take the reciprocal of the distance to compare with similar indices
  RAD.i <- 1-scaled_distAB

    # select the RAD-i
  return(RAD.i)
  
}


# Function to calculate Schoener D and Warren I including p-values.
DI_dist <- function(sp1, sp2){
  
    # Model the first species using the ecospat function
  z1 <- ecospat.grid.clim.dyn(background_env_xy %>% 
                                select(dim1,dim2),
                              background_env_xy %>% 
                                select(dim1,dim2),
                              sp1 %>% 
                                dplyr::select(dim1,dim2),
                              R=100)
  
    # Model the second species using the ecospat function
  z2 <- ecospat.grid.clim.dyn(background_env_xy %>% 
                                select(dim1,dim2),
                              background_env_xy %>% 
                                select(dim1,dim2),
                              sp2 %>% 
                                dplyr::select(dim1,dim2),
                              R=100)
  
    # Model the p-value using simulation test
  sim.test <- ecospat.niche.similarity.test(z1,z2,rep=1000)
    
    # Model the Schoener D and Warren I indices 
  overDI <- ecospat.niche.overlap(z1,z2,cor=TRUE)
  
    # Select values for each index including their p-values
  return(data.frame(overDI[1],sim.test[3],overDI[2],sim.test[4]))
  
}




