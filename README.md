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

| Name                                                                                                                 | Purpose                                                            |
| -------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| [Modify Network Data](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/modify_network_data) | Update pipe diameters based on information in the user text fields |

### Intermediate

Intermediate scripts attempt to automate realistic modelling tasks using Ruby. These scripts will contain multiple tasks that flow from each other. High-level comments are provided, though some experience with coding would be expected to modify or extend the scripts.

Config variables are generally added to the top of the script to allow some level of customisation and running the scripts directly by the end-user with minimal modification.

| Name                                                                                                                         | Purpose                                                                 |
| ---------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| [Open Data Import Centre](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/open_data_import_centre) | Automate the import multiple of shape files, including filtering assets |

### Complex

| Name                                                                                                                                        | Purpose                                                                                      |
| ------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [Convert Network to GeoJSON](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/to_geojson)                          | Converts an InfoWorks network or simulation into a GeoJSON file                              |
| [ Set elevations using Ordnance Survey NTF](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/elevations_gb_os_ntf) | Calculate the elevation of point objects within Great Britain using Ordance Survey NTF files |
| [Demand Allocation](https://github.com/modelcreate/infoworks-ruby-scripts/tree/master/scripts/demand_allocation)                            | Allocate customer points to the nearest pipe                                                 |
