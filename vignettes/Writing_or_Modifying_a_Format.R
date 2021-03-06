## ----packages, echo=FALSE------------------------------------------------
library(DGVMTools, quietly = TRUE, warn.conflicts = FALSE)
#library(raster, quietly = TRUE, warn.conflicts = FALSE)
#library(data.table, quietly = TRUE, warn.conflicts = FALSE)
#library(plyr, quietly = TRUE, warn.conflicts = FALSE)
#library(viridis, quietly = TRUE, warn.conflicts = FALSE)
#library(Cairo, quietly = TRUE, warn.conflicts = FALSE)


## ----setup, include=FALSE------------------------------------------------

## ----accessing a slot, echo=TRUE-----------------------------------------
GUESS@id

## ----get PFTs, echo=TRUE-------------------------------------------------
original.PFTs <- GUESS@default.pfts

str(original.PFTs)

## ----modify PFTs, echo=TRUE----------------------------------------------
new.PFT =  new("PFT",
               id = "NewPFT",
               name = "Some New Tree PFT",
               growth.form = "Tree",
               leaf.form = "Broadleaved",
               phenology = "Summergreen",
               colour = "red",
               climate.zone = "Temperate",
               shade.tolerance = "None"
)

new.PFT.list <- append(original.PFTs, new.PFT)

print(str(new.PFT.list))

GUESS@default.pfts <- new.PFT.list


## ----id slot, echo=TRUE--------------------------------------------------
id_NewFormat <- "Example_Format"

## ----default.pfts slot, echo=TRUE----------------------------------------
PFTs_NewFormat <- list(
  
  # A couple of tree PFTs
  
  TeBE = new("PFT",
             id = "TeBE",
             name = "Temperate Broadleaved Evergreen Tree",
             growth.form = "Tree",
             leaf.form = "Broadleaved",
             phenology = "Evergreen",
             climate.zone = "Temperate",
             colour = "darkgreen",
             shade.tolerance = "None"
  ),
  
  
  TeBS = new("PFT",
             id = "TeBS",
             name = "Temperate Broadleaved Summergreen Tree",
             growth.form = "Tree",
             leaf.form = "Broadleaved",
             phenology = "Summergreen",
             colour = "darkolivegreen3",
             climate.zone = "Temperate",
             shade.tolerance = "None"
  ),
  
  
  # And a couple of grasses
  
  C3G = new("PFT",
            id = "C3G",
            name = "Boreal/Temperate Grass",
            growth.form = "Grass",
            leaf.form = "Broadleaved",
            phenology = "GrassPhenology",
            climate.zone = "NA",
            colour = "lightgoldenrod1",
            shade.tolerance = "None"
  ),
  
  C4G = new("PFT",
            id = "C4G",
            name = "Tropical Grass",
            growth.form = "Grass",
            leaf.form = "Broadleaved",
            phenology = "GrassPhenology",
            climate.zone = "NA",
            colour = "sienna2",
            shade.tolerance = "None"
  )
  
)

# Now take a look at them
for(PFT in PFTs_NewFormat) {
  print(PFT)
}


## ----quantities slot, echo=TRUE------------------------------------------
quantities_NewFormat <- list(
  
  # Just a couple of example quantities
  
  new("Quantity",
      id = "LAI",
      name = "LAI",
      units = "m^2/m^2",
      colours = reversed.viridis,
      format = c("Example_Format"),
      cf.name = "leaf_area_index"),
  
  new("Quantity",
      id = "Veg_C",
      name = "Vegetation Carbon Mass",
      units = "kgC/m^2",
      colours = viridis::viridis,
      format = c("Example_Format"))
)

# Now take a look at them
for(quant in quantities_NewFormat ) {
  print(quant)
}

## ----determine PFTs, echo=TRUE-------------------------------------------
determinePFTs_NewFormat <- function(x, names = TRUE){
  
  # typical stuff 
  run.dir <- x@dir
  
  # all possible PFTs present 
  PFTs.possible <- x@pft.set
  
  # code to look for and open a commen per-PFT output file (for example LAI) 
  # typical files to check could be specified in 'additional.args' argument for example
  # ...
  
  # code check the ASCII header or netCDF meta info to see what PFTs are present
  # ...
  PFTs.present <- list() # dummy code
  
  return(PFTs.present)
  
} 

## ----available Quantities, echo=TRUE-------------------------------------
availableQuantities_NewFormat <- function(x, additional.args){ 
  
  # typical stuff 
  # * get a list of files in the directory
  # * scan the files for different variables
  # * build a list of qunatities present in the model output / dataset
  
  # dummy code
  Quantities.present <- list()
  return(Quantities.present)
  
} 

## ----get Field, echo=TRUE------------------------------------------------
getField_NewFormat <- function(source, quant, sta.info, verbose, ...){ 
  
  # open the file and read the data with ncvar_get() or read.table() or whatever
  
  # code needs to get the data as a data.table so reformat it
  # data.tables should be melted down to one column for Lat, Lon, Year, Month and Day (as appropriate).
  # days run from 1-365, and if data is daily no Month column should be used
  
  # dummy code
  dt <- data.table()
 
  
  # also an STAInfo object
  # define this properly based on the actual data in the data.table
  return.sta.info <- new("STAInfo",
                         first.year = 1901, # let's say
                         last.year = 2018, # let's say
                         year.aggregate.method = "none", # see NOTE 1 below
                         spatial.extent = extent(dt), # raster::extent function has been define for data.tables, might be useful
                         spatial.extent.id = character(0), # see NOTE 2 below
                         spatial.aggregate.method = "none", # see NOTE 1 below
                         subannual.resolution = "monthly", # let's say
                         subannual.aggregate.method = "none", # see NOTE 1 below
                         subannual.original = "monthly" # let's say
                         )
  
   # NOTE 1: normally there is no reason to do any aggregation in this function since it will be done later (and doesn't save any disk reading)
   # NOTE 2: if no spatial cropping at this stage set this to be the empty character string "character(0)", if spatial cropping was done, set it to the spatail.extent.id argument of the target sta.info object
  
  
  # make the Field ID based on the STAInfo and 
  field.id <- makeFieldID(source = source, var.string = quant@id, sta.info = sta.info)
    
  # build a new Field
  return.Field <- new("Field",
                      id = field.id,
                      quant = quant,
                      data = dt,
                      sta.info = return.sta.info,
                      source = source)

   
  return(return.field)
  
} 

## ----Builing the Format, echo=TRUE---------------------------------------
NewFormat <- new("Format", 
                 id = id_NewFormat,
                 default.pfts = PFTs_NewFormat, 
                 quantities = quantities_NewFormat, 
                 determinePFTs = determinePFTs_NewFormat, 
                 availableQuantities = availableQuantities_NewFormat, 
                 getField =getField_NewFormat)

## ----Final print, echo=TRUE----------------------------------------------
print(NewFormat)

