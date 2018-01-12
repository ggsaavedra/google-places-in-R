# Set working directory
setwd('/Users/maggiesaavedra/GitHub/gplace_inR/')

# Load require packages
library(googleway)
library(data.table)
library(mongolite)

# Set googple places api keys
# key <- c('AIzaSyD6iU9O03sGdnSARGSlrLcLCncmRn3Ejes') # maggie
# key <- c('AIzaSyCaKsmC0yi880Xbxp6-Tc6fd9Df8u2fGaw') # gay marie
key <- c('AIzaSyBAGtd1QtvJXMLrIRHWCZJPcqWS8R_BGSc')

# Randomize long lat for default long lat entry
# ll <- c(14.620448, 121.053393) # cubao
# ll <- c(14.556595, 121.024139) # makati
# ll <- c(14.576569, 121.052659) # ortigas
# ll <- c(14.577128, 121.033677) # mandaluyong

# ll <- c(14.606519, 120.984254) # manila
# ll <- c(14.536578, 120.991551) # pasay
# ll <- c(14.573249, 121.082198) # pasig
# ll <- c(14.650645, 121.049363) # quezon memorial cirle
# ll <- c(14.602690, 121.033207) # san juan city (restaurant next)
# ll <- c(14.650988, 121.115031) # marikina
# ll <- c(14.552853, 121.051530) # BGC
# ll <- c(14.545514, 121.068274) # pateros
# ll <- c(14.517990, 121.049635) # taguig
ll <- c(14.605458, 121.079994) # eastwood

# Set default radius in meters
rad <- 10000

# Relevant Place Type
p.types <- c('night_club')

# Dir for the radar data
radar_dir <- paste0('../../Moonlight/google-places/g_radar_', 'night_club.csv')

# connect to the db
mnew <- mongo(collection = 'g_place', db = 'googleplaces')

# Dir for the details data
details_dir <- paste0('../../Moonlight/google-places/g_places_', 'night_club.csv')


