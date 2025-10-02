# Ted's Tools for Calcium Counting - 2T2C

# About

This is a data processing pipeline for Calcium signalling data. It's original aim is to count the number and frequency of calcium for multiple cells within a calcium signalling time series.

# Installation

## prerequisites

-   Fiji (latest version)

    -   necessary for using any of the Image processing Macros

    -   can use standard ImageJ with

## Taking images

***When taking images try to insure your images match as closely as possible to these parameters:***

-   ***files are less than 4gb after maximum intensity projection, if not they will be automatically binned either 2\*2 or 3\*3 before stabilisation is applied***

# Preparing data with Fiji/ ImageJ

Im the "ImageJ Macros" folder, there are a variety of macros for automating various tasks in Fiji/ ImageJ.

#### stabilisation

Stabilisation automatically uses channel 2, which is why it's important to put your signal for any cell identifying markers in this channel. In the case that your image only has 1 channel it will instead automatically use channel 1 instead.

## Using the R code

### Initialisation
