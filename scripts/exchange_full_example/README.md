# Exchange Full Model Build and Run Example

Create and run a model from raw data in the command line using Infoworks Exchange.

To use this script you must first [import the ground grid and create an inference](#import-ground-grid-and-inference), you can then run `run_exchange.bat`. This will create a new model in the current active master database.

<img src="https://raw.githubusercontent.com/modelcreate/infoworks-ruby-scripts/master/imgs/exchange_e2e_demo.gif"/>

## Steps completed within script

- Creates model group and other tree objects within the master database
- Imports raw GIS data and filters unwanted data
- Expands valves and meters
- Set elevations for nodes and customer points
- Creates closed valves and PRVs
- Sets a constant pressure at the fixed head
- Assigns live data links to meters
- Creates and sets live data configuration
- Import demand diagrams
- Allocates all customer points
- Validates network
- Creates and runs simulation

## Work in progress

The following items still need to be added to complete this example

- Create lookup for material
- Set pipe age based on construction date
- Set roughness for pipe based on lookup
- Import DMA polygons
- Assign customers within DMA polygon only
- Tanks and float valves

## Limitations

The following limitations were found in developing a full build from scratch (as of v4.5)

- Can not import ground grid in WS, only supported in ICM, these need to be manually imported before this script can be ran
- Can not create inference, the master database will require this to be created manually and set for elevations
- Demand diagrams can only be imported and not manually created, update from live data only works for direct profiles
- Can not split mains with points natively, the mains in this example were split at all valves, meters and tee intersections

## Import ground grid and inference

Currently it is not possible to import ground grids in InfoWorks Exchange WS, you will need to import the ASCII grid file in this repo before you run this example.

Find the files within [./source_data/ground/](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/exchange_full_example/source_data/ground/)

<img src="https://raw.githubusercontent.com/modelcreate/infoworks-ruby-scripts/master/imgs/exchange_e2e_ground_grid.PNG"/>
<img src="https://raw.githubusercontent.com/modelcreate/infoworks-ruby-scripts/master/imgs/exchange_e2e_inference.PNG"/>
