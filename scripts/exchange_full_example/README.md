# Exchange Full Example

Create and run a model from raw data in the command line using Infoworks Exchange.

<img src="https://raw.githubusercontent.com/modelcreate/infoworks-ruby-scripts/master/imgs/exchange_e2e_demo.gif"/>

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

## Ground grid and inference for model

Currently it is not possible to import ground grids in InfoWorks Exchange WS, you will need to import the ASCII grid file in this repo before you run this example.

Find the files within [./source_data/ground/](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/exchange_full_example/source_data/ground/)

<img src="https://raw.githubusercontent.com/modelcreate/infoworks-ruby-scripts/master/imgs/exchange_e2e_ground_grid.PNG"/>
<img src="https://raw.githubusercontent.com/modelcreate/infoworks-ruby-scripts/master/imgs/exchange_e2e_inference.PNG"/>
