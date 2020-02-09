# Set elevations using Ordnance Survey NTF data

Calculate the elevation of point objects within Great Britain using the historical and now withdrawn Ordnance Survey Land-Form Panorama and Profile 10m and 50m NTF DTM files.

This will provide you the same elevations as the native `Set Elevation of Objects` function in InfoWorks.

Within `set_elevations.rb` set `ntf_folder` to the folder where you have the NTF files.

Scripts were converted from the QGIS plugin - [GBElevation](https://github.com/lbutler/GBElevation)

<img src="https://raw.githubusercontent.com/modelcreate/infoworks-ruby-scripts/master/imgs/GBElevation.png"/>

## Scripts

- **[set_elevations.rb](https://github.com/modelcreate/infoworks-ruby-scripts/blob/master/scripts/elevations_gb_os_ntf/set_elevations.rb)** - Main script that runs in InfoWorks, loops through all nodes and set their elevation using the OSNtfElevations class
- **[lib\os_ntf_elevations.rb](https://github.com/modelcreate/infoworks-ruby-scripts/blob/master/scripts/elevations_gb_os_ntf/lib/os_ntf_elevations.rb)** - Main class, accepts an array of X&Y hashes
- **[lib\os_ntf_elevations\BilinearInterpolation.rb](https://github.com/modelcreate/infoworks-ruby-scripts/blob/master/scripts/elevations_gb_os_ntf/lib/os_ntf_elevations/BilinearInterpolation.rb)** - Interpolates elevations between spacing nodes
- **[lib\os_ntf_elevations\OSGroundGrid.rb](https://github.com/modelcreate/infoworks-ruby-scripts/blob/master/scripts/elevations_gb_os_ntf/lib/os_ntf_elevations/OSGroundGrid.rb)** - Class to read NTF files
- **[lib\os_ntf_elevations\OSGroundGridCalculator.rb](https://github.com/modelcreate/infoworks-ruby-scripts/blob/master/scripts/elevations_gb_os_ntf/lib/os_ntf_elevations/OSGroundGridCalculator.rb)** - Class initiates OSGroundGrid object and returns elevations at X,Y within the tile
- **[lib\os_ntf_elevations\OSTileLocator.rb](https://github.com/modelcreate/infoworks-ruby-scripts/blob/master/scripts/elevations_gb_os_ntf/lib/os_ntf_elevations/OSTileLocator.rb)** - Finds the OS Tile the nodes are located in
