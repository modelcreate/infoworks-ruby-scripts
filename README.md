# Infoworks Ruby Scripts

A collection of useful Ruby scripts to help automate the building, calibrating and running of models in InfoWorks.

> **Have a script to share?** Submit a pull request, [open an issue](https://github.com/modelcreate/infoworks-ruby-scripts/issues) or send me an email - luke@matrado.ca

## Downloading and using scripts

<img src="https://raw.githubusercontent.com/modelcreate/infoworks-ruby-scripts/master/imgs/DownloadZip.png" alt="placeholder" height="150" align="right"/>

The simplest way to get all the scripts is to download the whole collection as a zip from GitHub.

Click `Clone or download` and then `Download Zip`.

To run a Ruby script in InfoWorks, click Network > Run Ruby Script in the toolbar and then select a .rb file.

## Suggest a new script

If you have an idea for a script that you want developed, please [open an issue](https://github.com/modelcreate/infoworks-ruby-scripts/issues) or send me an email - luke@matrado.ca

## List of scripts

### Simple

If you are a beginner and just learning Ruby these scripts can be used as a reference to learn how to automate simple tasks.

Each of these scripts will only complete a single task and the code within will be commented to provide context for those not familiar with coding in Ruby.

| Name                                                                                                                       | Purpose                                                                                                            |
| -------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [Modify Network Data](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/modify_network_data)       | Update pipe diameters based on information in the user text fields                                                 |
| [Create Network Objects](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/create_network_objects) | Create new network objects                                                                                         |
| [Modify Structured Data](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/modify_structured_data) | Update structured data, these fields are displayed as tables within InfoWorks, such as depth/volume for reservoirs |
| [Set Material Using Lookup](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/material_lookup)     | Update material field on pipes using a Ruby hash as a lookup table                                                 |
| [Expand Short Links](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/expand_short_links)         | Expands links to be a minimum size                                                                                 |
| [Trace Network](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/trace_network)                   | From a single pipe, use Ruby to trace a distribution network finding pipes of the same size or smaller             |
| [Validate Network](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/network_validations)          | Run a network validation from Ruby                                                                                 |

### Intermediate

Intermediate scripts attempt to automate realistic modelling tasks using Ruby. These scripts will contain multiple tasks that flow from each other. High-level comments are provided, though some experience with coding would be expected to modify or extend the scripts.

Config variables are generally added to the top of the script to allow some level of customisation and running the scripts directly by the end-user with minimal modification.

| Name                                                                                                                                 | Purpose                                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| [Open Data Import Centre](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/open_data_import_centre)         | Automate the import multiple of shape files, including filtering assets |
| [Demand Allocation - Exchange](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/exchange_demand_allocation) | Allocate customer points using Exchange                                 |

### Complex

| Name                                                                                                                                        | Purpose                                                                                      |
| ------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [Convert Network to GeoJSON](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/to_geojson)                          | Converts an InfoWorks network or simulation into a GeoJSON file                              |
| [ Set elevations using Ordnance Survey NTF](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/elevations_gb_os_ntf) | Calculate the elevation of point objects within Great Britain using Ordance Survey NTF files |
| [Demand Allocation - Custom](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/demand_allocation)                   | Allocate customer points to the nearest pipe                                                 |
| [Exchange Full Model Build and Run Example](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/exchange_full_example)                   | Create and run a model from raw data in the command line using Infoworks Exchange.

                                            |





