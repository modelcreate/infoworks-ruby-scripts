# Model Build Script

This document provides an overview of the model build script and its components. The primary purpose of this script is to automate the creation of a water network model by importing, processing, and enriching data from various sources. It is designed to be run from within the InfoWorks WS Pro environment.

The script is initiated by the user, who is prompted to select a folder containing the necessary import files. Once the folder is selected, the main process begins, which can be broken down into several key stages:

1.  **Data Import**: The script starts by importing various network components such as hydrants, reservoirs, valves, pipes, and DMA polygons from shapefiles.
2.  **Network Processing**: After the initial import, the script performs several processing steps to ensure the network topology is correct. This includes splitting links at specified nodes and intersections and expanding certain nodes into links.
3.  **Data Enrichment**: The script then enriches the model with additional data. It renames nodes, sets pipe roughness based on material and age, and calculates node elevations using UK Ordnance Survey NTF elevation data.
4.  **Control File Creation**: Finally, the script generates a control file for the model, which defines the operational logic for control elements like valves.

The entire process is designed to be modular, with different components of the functionality encapsulated in separate Ruby classes. This makes the script easier to maintain and extend.

## Files

### Main Script

- **`build_model.rb`**: This is the main entry point for the model building process. It orchestrates the entire workflow by calling the various classes and methods in the correct sequence. It handles user interaction for selecting the import folder and manages the overall transaction flow.

### Libraries

- **`lib/iwp_build.rb`**: This file acts as a loader for all the modules within the `iwp_build` library. It uses `require` to load each component, making them available to the main script.
- **`lib/iwp_build/`**: This directory contains the individual modules that encapsulate the different functionalities of the model build process.
  - `importer.rb`: This class handles the import of data from shapefiles into the InfoWorks WS Pro network. It uses the `odic_import_ex` method from the WS Pro API to perform the imports. Each method in this class is responsible for importing a specific type of data (e.g., hydrants, pipes, valves). The import process for each data type is configured using a `.cfg` file and a VBScript callback (`.bas`) file.
  - `split_links.rb`: This class is responsible for ensuring the proper connectivity of the network by splitting existing links (pipes) to connect nodes that are not properly snapped. It contains methods to split links at specified node collections and at intersections. This is a crucial step to ensure a topologically correct network for simulation.
  - `expand_nodes.rb`: This module is responsible for expanding nodes into links. This is particularly useful for representing devices like valves and meters, which are often represented as nodes in GIS data but need to be represented as links in a hydraulic model.
    - `expand_nodes/node_to_be_expanded.rb`: This class contains the core logic for expanding a node into a link. It handles various scenarios, including nodes with one or two connections, and nodes with no connections (in which case it uses orientation data). It uses the `TrimLink` class to shorten the connecting links before creating the new link.
    - `expand_nodes/trim_link.rb`: This class is a utility used by `NodeToBeExpanded` to shorten a link by a specified amount. It calculates the new endpoint of the link, creates a new node at that point, and then updates the link's geometry.
  - `node_rename.rb`: This class is responsible for renaming nodes based on their coordinates. It generates a new node ID by concatenating the x and y coordinates of the node. If multiple nodes exist at the same location, it appends a suffix to ensure uniqueness. This provides a consistent and predictable naming convention for nodes.
  - `roughness.rb`: This class is responsible for setting the roughness value (Colebrook-White k) for pipes in the network. It uses a lookup table that contains roughness values for different pipe materials and ages. The script calculates the age of each pipe and assigns the appropriate roughness value based on this data.
  - `os_ntf_elevations.rb`: This module is responsible for setting the elevation of nodes in the network using Ordnance Survey National Transformation Format (NTF) data. It works by first locating the correct NTF tile for each node, then reading the elevation data from that tile, and finally calculating the elevation at the node's location, using bilinear interpolation if necessary.
    - `os_ntf_elevations/OSTileLocator.rb`: This class is used to determine the correct Ordnance Survey grid tile for a given coordinate. This is essential for locating the correct NTF file to use for elevation lookup.
    - `os_ntf_elevations/OSGroundGrid.rb`: This class reads an Ordnance Survey NTF file and parses it to create a grid of elevation points. It stores this data in memory, allowing for quick elevation lookups.
    - `os_ntf_elevations/OSGroundGridCalculator.rb`: This class calculates the elevation of a point within an OS ground grid. If the point falls directly on a grid intersection, it looks up the elevation directly. Otherwise, it uses bilinear interpolation to estimate the elevation based on the four surrounding grid points.
    - `os_ntf_elevations/BilinearInterpolation.rb`: This class performs bilinear interpolation to calculate an elevation value at a point within a grid, based on the elevations of the four surrounding grid points.
  - `control_file.rb`: This class is responsible for generating a CSV file that defines the control logic for valves in the network. It iterates through the valves in the network and, based on their properties, creates control rules for them (e.g., closed, pressure reducing, pressure sustaining). This CSV file can then be imported into InfoWorks WS Pro to apply the control rules to the model.
  - `spatial.rb`: This file acts as a loader for the spatial module. The spatial module is a collection of utility functions for performing various geometric calculations. These functions are essential for tasks like splitting links and calculating elevations.
    - `spatial/distance.rb`: Calculates the distance between two points.
    - `spatial/point_along_line.rb`: Calculates a point along a line at a specific distance.
    - `spatial/bearing.rb`: Calculates the bearing between two points.
    - `spatial/destination.rb`: Calculates a destination point given a starting point, distance, and angle.
    - `spatial/nearest_point_on_line.rb`: Finds the nearest point on a line (represented by a series of bends) to a given point.
    - `spatial/intersects.rb`: Determines if two lines intersect and, if they do, returns the intersection point.
  - `rename_nodes.rb`: This module provides a framework for renaming nodes in the network. It is an older implementation that has been largely superseded by the `NodeRename` class.
    - `rename_nodes/renamer.rb`: This class provides a base class for renaming nodes. It includes functionality to iterate through a collection of nodes, generate new IDs, and handle duplicates by appending a suffix.
    - `rename_nodes/xy.rb`: This class inherits from `Renamer` and implements the logic for renaming nodes based on their x and y coordinates.
  - `version.rb`: [Description to be added]

### Script Includes

- **`script_inc/`**:
  - **`cfg/`**: This directory contains the configuration files for the ODIC imports. These files define the mapping between the fields in the source shapefiles and the fields in the InfoWorks WS Pro network objects.
    - `hydrant.cfg`: Configuration for hydrant import.
    - `meter_node.cfg`: Configuration for meter node import.
    - `pipe.cfg`: Configuration for pipe import.
    - `polygon.cfg`: Configuration for polygon import.
    - `prv_node.cfg`: Configuration for PRV node import.
    - `reservoir.cfg`: Configuration for reservoir import.
    - `twp_node.cfg`: Configuration for TWP node import.
    - `valve_node.cfg`: Configuration for valve node import.
    - `wtw.cfg`: Configuration for WTW import.
  - **`callback/`**: This directory contains VBScript files that are used as callbacks during the ODIC import process. These scripts can be used to perform custom data manipulation during the import.
    - `hydrant_cb.bas`: VBScript callback for hydrant import.
      - **OnBeginRecordHydrant**: Skips the import of hydrants with a `d_operatio` status of "Abandoned" or "Proposed".
      - **OnEndRecordHydrant**: Sets the data flags for `construction_type`, `valve_diameter`, and `diameter` to "AV" (Assumed Value) and clears the flags for the x and y coordinates.
    * `meter_node_cb.bas`: VBScript callback for meter node import.
      - **OnBeginRecordNode**: Skips the import of meter nodes with a `d_operatio` of "Abandoned" or "Proposed", or a `d_type` of "Revenue" or "WET".
      - **OnEndRecordNode**: Converts the diameter to a numeric value in millimeters and stores it in the `user_text_9` field.
      - **DiameterToNum**: A helper function that converts diameter strings (e.g., "100mm", "4in", "4 1/2in") to numeric millimeter values.
      - **InchToMM**: A helper function that converts inch values (including fractions) to millimeters.
    * `pipe_cb.bas`: VBScript callback for pipe import.
      - **OnBeginRecordPipe**: Skips the import of pipes with a `d_operatio` of "Abandoned" or "Proposed", or a `d_type` of "Overflow", "Sludge", or "Drain".
      - **OnEndRecordPipe**: Performs several data cleaning and enrichment tasks, including converting the diameter to a numeric value, extracting the year laid, standardizing the material code, and calculating the internal diameter for PE pipes.
      - **GetMaterialForIW**: Maps material descriptions from the source data to standardized InfoWorks material codes.
      - **DiameterToNum**: Converts diameter strings (e.g., "100mm", "4in") to numeric millimeter values.
      - **InchToMM**: A helper function that converts inch values (including fractions) to millimeters.
      - **GetPeInternalDia**: Calculates the internal diameter of PE pipes based on their nominal diameter and pressure rating.
      - **Pe10Bar** and **Pe16Bar**: Helper functions containing lookup tables for the internal diameters of 10 Bar and 16 Bar PE pipes.
    * `polygon_cb.bas`: VBScript callback for polygon import.
      - **OnEndRecordPolygons**: Sets the `user_number_10` field to the current year and clears the flag for the `polygon_id`.
    * `prv_node_cb.bas`: VBScript callback for PRV node import.
      - **OnBeginRecordNode**: Skips the import of PRV nodes with a `d_operatio` of "Abandoned" or "Proposed".
      - **OnEndRecordNode**: Sets the `user_text_10` field to "PLUG" and converts the diameter to a numeric value in millimeters, storing it in the `user_text_9` field.
      - **DiameterToNum**: A helper function that converts diameter strings (e.g., "100mm", "4in", "4 1/2in") to numeric millimeter values.
      - **InchToMM**: A helper function that converts inch values (including fractions) to millimeters.
    * `reservoir_cb.bas`: VBScript callback for reservoir import.
      - **OnBeginRecordReservoir**: Skips the import of reservoirs based on a number of criteria, including if they are not of type "TWS", or if their status is "Abandoned", "Proposed", "Removed", "DECOMISSIONED", "REDUNDANT", "SOLD", or "MOTHBALLED".
      - **OnEndRecordReservoir**: Clears the flags for the `node_id`, `x`, and `y` fields.
    * `twp_node_cb.bas`: VBScript callback for TWP node import.
      - **OnBeginRecordNode**: Skips the import of TWP nodes based on a number of criteria, including if they are not of type "TWP", or if their status is "Abandoned", "Proposed", "Removed", "DECOMISSIONED", "REDUNDANT", "SOLD", or "MOTHBALLED".
      - **OnEndRecordReservoir**: This sub is empty and currently performs no action.
    * `valve_node_cb.bas`: VBScript callback for valve node import.
      - **OnBeginRecordNode**: Skips the import of valve nodes with a `d_operatio` of "Abandoned" or "Proposed".
      - **OnEndRecordNode**: Converts the diameter to a numeric value in millimeters and sets the valve type based on the `d_type` and `d_mechanis` fields.
      - **DiameterToNum**: A helper function that converts diameter strings (e.g., "100mm", "4in", "4 1/2in") to numeric millimeter values.
      - **InchToMM**: A helper function that converts inch values (including fractions) to millimeters.
    * `wtw_cb.bas`: VBScript callback for WTW import.
      - **OnBeginRecordFixedHead**: Skips the import of WTW nodes based on a number of criteria, including if they are not of type "WTW", or if their status is "Abandoned", "Proposed", "Removed", "DECOMISSIONED", "REDUNDANT", "SOLD", or "MOTHBALLED".
      - **OnEndRecordFixedHead**: This sub is empty and currently performs no action.
