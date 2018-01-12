# Get place id of nearby places using Google Places Radar API
source('init.R')


# read the radar data with unfinished details
df <- fread(radar_dir)
df <- df[!duplicated(df), ]
attach(df)

details <- NULL
for (i in 1:length(place_id)) {
  tmp <-
    google_place_details(place_id = as.character(place_id[i]), key = key)
  if (length(tmp$result) != 0) {
    mnew$insert(tmp)
  } else{
    break
  }
  
  # Get google place name
  if (length(tmp$result$name) != 0) {
    name = tmp$result$name
  } else{
    name = "NULL"
  }
  det <- cbind(place_id = as.character(place_id[i]), name)
  
  
  # Get google contact number
  if (length(tmp$result$formatted_phone_number) != 0) {
    phone_number = tmp$result$formatted_phone_number
  } else{
    phone_number = "NULL"
  }
  det <- cbind(det, phone_number)
  
  
  # Get google contact number
  if (length(tmp$result$formatted_phone_number) != 0) {
    international_phone_number = tmp$result$formatted_phone_number
  } else{
    international_phone_number = "NULL"
  }
  det <- cbind(det, international_phone_number)
  
  
  # Get google place address
  if (length(tmp$result$formatted_address) != 0) {
    address = tmp$result$formatted_address
  } else{
    address = "NULL"
  }
  det <- cbind(det, address)
  
  
  # Get google place lat
  if (length(tmp$result$formatted_address) != 0) {
    lat = tmp$result$geometry$location$lat
  } else{
    lat = "NULL"
  }
  det <- cbind(det, lat)
  
  
  # Get google place long
  if (length(tmp$result$formatted_address) != 0) {
    long = tmp$result$geometry$location$lng
  } else{
    long = "NULL"
  }
  det <- cbind(det, long)
  
  
  # Get google place category
  if (length(tmp$result$formatted_address) != 0) {
    category = as.character(place_type[i])
  } else{
    category = "NULL"
  }
  det <- cbind(det, category)
  
  
  # Get google place icon link
  if (length(tmp$result$icon) != 0) {
    icon_link = tmp$result$icon
  } else{
    icon_link = "NULL"
  }
  det <- cbind(det, icon_link)
  
  
  # Get google place rating
  if (length(tmp$result$rating) != 0) {
    rating = tmp$result$rating
  } else{
    rating = "NULL"
  }
  det <- cbind(det, rating)
  
  
  # Get google places website
  if (length(tmp$result$website) != 0) {
    website = tmp$result$website
  } else{
    website = "NULL"
  }
  det <- cbind(det, website)
  
  
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
  
  fwrite(x = as.data.table(det),
         file = details_dir,
         append = TRUE)
  print(paste("Done Processing", i, "Places"))
  
  Sys.sleep(0.01)
}
