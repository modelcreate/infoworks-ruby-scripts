# Allocating customer points with Ruby

Customer demand allocation Ruby script for InfoWorks WS Pro.

Allocates customers within a selected polygon to any pipes with the same area code of the polygon.

> **Warning before use**: There is an undocumented native function in Ruby by Innovyze that does customer allocation, you should probably use that over this script

## User guide

The scripts are documented though a user guide will come soon.

## Limitations

Consider this script a proof of concept and a demostration of using spatial functions to allocate customer points, they are not tested and may not fully work. While these scripts does 80% of what the native function can achieve, if you are running a production model build you should probably use the native functions when they become public.

Some known issues are:

- Customers can be allocated to tanks and fixed heads
- No maximum connections per node
