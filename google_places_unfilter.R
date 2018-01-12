library(googleway)

key <- 'AIzaSyBuZDSM2WazKlJdcng-QxdzRb8qWWj8otE'
ll <- c(14.6091, 121.0223)
manda.ll <- c(14.5794, 121.0359)
qc.ll <- c(14.651527, 121.049393)
rad <- 2000

n <- c("location_lat", "location_long",
       "northeast_lat", "northeast_long",
       "southeast_lat", "southeast_long",
       "icon", "id", "name", "place_id",
       "references", "scope", "vicinity",
       "rating", "type")
types <- c("airport","amusement_park","aquarium","art_gallery","atm","bakery","bank","bar","beauty_salon","bicycle_store","book_store","bowling_alley","bus_station","cafe","car_dealer","car_rental","car_repair","car_wash","casino","church","city_hall","clothing_store","convenience_store","department_store","electronics_store","embassy","florist","gas_station","grocery_or_supermarket(deprecated)","gym","hair_care","health (deprecated)","hospital","liquor_store","local_government_office","lodging","meal_delivery","meal_takeaway","movie_theater","museum","night_club","park","parking","pharmacy","police","post_office","restaurant","shoe_store","shopping_mall","spa","stadium","store","subway_station","taxi_stand","train_station","transit_station","zoo")

temp_res <- NULL

temp <- google_places(location = ll, radius = rad, key = key)
out <- cbind(temp$results$geometry$location,
             temp$results$geometry$viewport$northeast,
             temp$results$geometry$viewport$southwest,
             temp$results$icon,
             temp$results$id, 
             temp$results$name,
             temp$results$place_id, 
             temp$results$reference,
             temp$results$scope, 
             temp$results$vicinity, 
             temp$results$rating,
             unlist(lapply(temp$results$types, paste, collapse = ',')))
names(out) <- n

Sys.sleep(1)

repeat{
  temp <- google_places(location = ll, radius = rad, key = key, 
                        page_token = temp$next_page_token)
  temp_res <- c(temp_res,temp$next_page_token)
  if(is.null(temp$next_page_token) == FALSE){
    out_ <- cbind(temp$results$geometry$location,
                  temp$results$geometry$viewport$northeast,
                  temp$results$geometry$viewport$southwest,
                  temp$results$icon,
                  temp$results$id, 
                  temp$results$name,
                  temp$results$place_id, 
                  temp$results$reference,
                  temp$results$scope, 
                  temp$results$vicinity, 
                  temp$results$rating,
                  unlist(lapply(temp$results$types, paste, collapse = ',')))
    names(out_) <- n
    out <- rbind(out, out_)
    Sys.sleep(1)
  }else{}
  
  if(is.null(temp$next_page_token) == TRUE){
    break
  }
  
}


fwrite(out, 'Moonlight/google-places/google_places2.csv')




