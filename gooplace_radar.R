## DB connection
library(RMySQL)
dbConnect(MySQL(), 
          user="databfor_bigdata", 
          password="Sc8C?{KxhUTb", 
          host="database.gekkowebhosting.com",
          port = 3306,
          dbname="databfor_bigdatab")

####
## Google places Radar
library(googleway) # load the required library
library(data.table)

# google places api key
key <- 'AIzaSyD6iU9O03sGdnSARGSlrLcLCncmRn3Ejes'

ll <- c(14.620448, 121.053393) # long-lat preferences
rad <- 2000  # radius is 2 km

# Relevant Place Type using Radar API
p.types <- c("airport","amusement_park","aquarium","art_gallery","atm","bakery","bank","bar","beauty_salon","bicycle_store","book_store","bowling_alley","bus_station","cafe","car_dealer","car_rental","car_repair","car_wash","casino","church","city_hall","clothing_store","convenience_store","department_store","electronics_store","embassy","florist","gas_station","grocery_or_supermarket","gym","hair_care","health","hospital","liquor_store","local_government_office","lodging","meal_delivery","meal_takeaway","movie_theater","museum","night_club","park","parking","pharmacy","police","post_office","restaurant","shoe_store","shopping_mall","spa","stadium","store","subway_station","taxi_stand","train_station","transit_station","zoo")

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
    fwrite(df_, 'Moonlight/google-places/google_place_radar2.csv', append = TRUE)
    print(paste('Found', nrow(df_), 'places under place type', p.types[i]))
  } else{
    print(paste('Type', p.types[i], 'cannot be found in this area'))
  }
  Sys.sleep(1)
}

# Getting only the unique rows: df_ <- df_[!duplicated(df_),]
#                               res_ <- res_[!duplicated(res_),]


### Getting place information
# read the file first containing the radar search output

library(mongolite)
library(googleway) # load the required library
library(data.table)

# read the radar data with unfinished details
df <- fread('Moonlight/google-places/google_place_radar_unfinished.csv')
attach(df)

# connect to the db
mnew <- mongo(collection = 'g_place', db = 'googleplaces')

# MSC Directory
msc_directory <- fread('Moonlight/msc_directory.csv')

# Google API key
key <- 'AIzaSyDDNphD_0Eu_o1U-oY3zsn66pw133QFEu8'

details <- NULL
for (i in 10:length(place_id)){
  
  tmp <- google_place_details(place_id = as.character(place_id[i]), key = key)
    if (length(tmp$result) != 0){
      mnew$insert(tmp)
    }else{break}
  
  # Get google place name
        if (length(tmp$result$name)!=0){
          name = tmp$result$name
        }else{
          name = "NULL"
        }
  det <- cbind(place_id = as.character(place_id[i]), name)

  
  # Get google contact number
        if (length(tmp$result$formatted_phone_number)!=0){
          phone_number = tmp$result$formatted_phone_number
        }else{
          phone_number = "NULL"
        }
  det <- cbind(det, phone_number)
  
  
  # Get google contact number
        if (length(tmp$result$formatted_phone_number)!=0){
          international_phone_number = tmp$result$formatted_phone_number
        }else{
          international_phone_number = "NULL"
        }
  det <- cbind(det, international_phone_number)
  
  
  # Get google place address
        if (length(tmp$result$formatted_address)!=0){
          address = tmp$result$formatted_address
        }else{
          address = "NULL"
        }
  det <- cbind(det, address)
  
  
  # Get google place lat
        if (length(tmp$result$formatted_address)!=0){
          lat = tmp$result$geometry$location$lat
        }else{
          lat = "NULL"
        }
  det <- cbind(det, lat)

  
  # Get google place long
        if (length(tmp$result$formatted_address)!=0){
          long = tmp$result$geometry$location$lng
        }else{
          long = "NULL"
        }
  det <- cbind(det, long)

  
  # Get google place category
        if (length(tmp$result$formatted_address)!=0){
          category = as.character(place_type[i])
        }else{
          category = "NULL"
        }
  det <- cbind(det, category)
  

  # Get google place icon link        
        if (length(tmp$result$icon)!=0){
          icon_link = tmp$result$icon
        }else{
          icon_link = "NULL"
        }
  det <- cbind(det,icon_link)
        
  
  # Get google place rating
        if (length(tmp$result$rating)!=0){
          rating = tmp$result$rating
        }else{
          rating = "NULL"
        }
  det <- cbind(det,rating)


  # Get google places website        
        if (length(tmp$result$website)!=0){
          website = tmp$result$website
        }else{
          website = "NULL"
        }
  det <- cbind(det,website)

  
  #       if (length(tmp$result$id)!=0){
  #         id = tmp$result$id
  #       }else{
  #         id = "NULL"
  #       }
  # det <- cbind(det,id)
  
  # # Get google place url
  #       if (length(tmp$result$url)!=0){
  #         url = tmp$result$url
  #       }else{
  #         url = "NULL"
  #       }
  # det <- cbind(det,url)
  
  details <- rbind(details, det)
  
  fwrite(x = as.data.table(det), file = 'Moonlight/google-places/g_places.csv', append = TRUE)
  print(paste("Done Processing", i, "Places"))
}
