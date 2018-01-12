
# Long Lat of the center of Metro Manila (14.611863, 121.031443)
# API key: AIzaSyDBOH1li_o6CWA8REmO-zR4MdUbHxnJsIo
library(googleway)

key <- 'AIzaSyBuZDSM2WazKlJdcng-QxdzRb8qWWj8otE'
ll <- c(14.611863, 121.031443)
rad <- 50000
types <- c("airport","amusement_park","aquarium","art_gallery","atm","bakery","bank","bar","beauty_salon","bicycle_store","book_store","bowling_alley","bus_station","cafe","car_dealer","car_rental","car_repair","car_wash","casino","church","city_hall","clothing_store","convenience_store","department_store","electronics_store","embassy","florist","gas_station","grocery_or_supermarket(deprecated)","gym","hair_care","health (deprecated)","hospital","liquor_store","local_government_office","lodging","meal_delivery","meal_takeaway","movie_theater","museum","night_club","park","parking","pharmacy","police","post_office","restaurant","shoe_store","shopping_mall","spa","stadium","store","subway_station","taxi_stand","train_station","transit_station","zoo")
n <- c("location_lat", "location_long",
       "northeast_lat", "northeast_long",
       "southeast_lat", "southeast_long",
       "icon", "id", "name", "place_id",
       "references", "scope", "vicinity",
       "rating", "type")

result <- NULL
for(i in 1:2){
  temp <- google_places(location = ll, radius = rad, place_type = types[i], key = key)
  
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
               type = types[i])
  names(out) <- n
  print(paste('Done initiate:', types[i]))
  Sys.sleep(1)
    repeat{
          
          if(is.null(temp$next_page_token) == FALSE){
            temp <- google_places(location = ll, radius = rad, place_type = types[i], key = key, 
                                  page_token = temp$next_page_token)
            print(temp$next_page_token)
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
                          type = types[i])
            names(out_) <- n
            dim(out_)
            out <- rbind(out, out_)
            Sys.sleep(1)
            
          }else{
            break
          }
    }
  print(paste('Completed:', types[i]))
  result <- rbind(result, out)
  
  i = i+1
  i
  dim(result)
  
}

n <- c("location_lat", "location_long",
       "northeast_lat", "northeast_long",
       "southeast_lat", "southeast_long",
       "icon", "id", "name", "place_id",
       "references", "scope", "vicinity",
       "rating", "type")

names(result) <- n
fwrite(result, 'Moonlight/google-places/google_places.csv')




