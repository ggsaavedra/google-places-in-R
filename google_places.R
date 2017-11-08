
# Long Lat of the center of Metro Manila (14.611863, 121.031443)
# API key: AIzaSyDBOH1li_o6CWA8REmO-zR4MdUbHxnJsIo


library(googleway)

key <- 'AIzaSyCxw1X96b8PL-qFG9PRBVo0OG2RNG5SOVU'
ll <- c(14.611863, 121.031443)
rad <- 50000
types <- c("airport","amusement_park","aquarium","art_gallery","atm","bakery","bank","bar","beauty_salon","bicycle_store","book_store","bowling_alley","bus_station","cafe","car_dealer","car_rental","car_repair","car_wash","casino","church","city_hall","clothing_store","convenience_store","department_store","electronics_store","embassy","florist","gas_station","grocery_or_supermarket(deprecated)","gym","hair_care","health (deprecated)","hospital","liquor_store","local_government_office","lodging","meal_delivery","meal_takeaway","movie_theater","museum","night_club","park","parking","pharmacy","police","post_office","restaurant","shoe_store","shopping_mall","spa","stadium","store","subway_station","taxi_stand","train_station","transit_station","zoo")

for(i in 1:length(types)){
  prel <- google_places(location = ll, radius = rad, place_type = types[i], key = key)
  
  out <- cbind(prel$results$geometry$location,
               prel$results$geometry$viewport$northeast,
               prel$results$geometry$viewport$southwest,
               prel$results$icon,
               prel$results$id, 
               prel$results$name,
               prel$results$place_id, 
               prel$results$reference,
               prel$results$scope, 
               prel$results$vicinity, 
               prel$results$rating,
               type = types[1])
    repeat{
      
      if (is.null(prel$next_page_token) == FALSE){
          
          temp <- sec <- google_places(location = ll, radius = rad, place_type = types[i], key = key, 
                                       page_token = prel$next_page_token)
          
          out <- rbind(cbind(temp$results$geometry$location,
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
                             type = types[i]))
      }else{break}
      
    }
  
}

n <- c("location_lat", "location_long",
       "northeast_lat", "northeast_long",
       "southeast_lat", "southeast_long",
       "icon", "id", "name", "place_id",
       "references", "scope", "vicinity",
       "rating", "type")

names(out) <- n
fwrite(test, 'Moonlight/google-places/google_places.csv')




