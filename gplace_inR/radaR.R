
# Get place id of nearby places using Google Places Radar API 
source('init.R')

# longlat is should be a vector of longatitude and latitude
# rad is numeric value in meter unit that determines the boundery from the center
# p.types is the type of places that will be included in the query
# getting all pace types
radar <- NULL
for (i in 1:length(p.types)){
  df <- google_places(location = ll, radar = TRUE, radius = rad, place_type = p.types[i], key = key)
  if (length(df$results)!=0){
    df_ <- cbind(df$results$geometry$location, 
                 id = df$results$id, 
                 place_id = df$results$place_id,
                 place_type = p.types[i])
    radar <- rbind(radar, df_)
    fwrite(df_, radar_dir, append = TRUE)
    print(paste('Found', nrow(df_), 'places under place type', p.types[i]))
  } else{
    print(paste('Type', p.types[i], 'cannot be found in this area'))
  }
  Sys.sleep(1)
}