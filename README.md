[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1038289.svg)](https://doi.org/10.5281/zenodo.1038289) Latest release

[![Build Status](https://travis-ci.org/HegemanLab/w4mjoinpn_galaxy_wrapper.svg?branch=master)](https://travis-ci.org/HegemanLab/w4mjoinpn_galaxy_wrapper) Current build status for master branch on GitHub

# w4mjoinpn_galaxy_wrapper

This tool joins two sets of MS1 datasets for **exactly** the same set of samples, where one was gathered in positive 
ionization-mode and the other in negative ionization-mode, for reasons set forth below.  

Workflow4Metabolomics (W4M, Giacomoni *et al.*, 2014, http://dx.doi.org/10.1093/bioinformatics/btu813; http://workflow4metabolomics.org; 
https://github.com/workflow4metabolomics) provides a suite of Galaxy tools for processing and analyzing metabolomics data.
  
W4M uses the XCMS package (Smith *et al.*, 2006 http://dx.doi.org/10.1021/ac051437y) to extract features and align 
their retention times among multiple samples. 

After peak extraction and alignment, W4M uses the CAMERA package (Kuhl *et al.*, 2012, http://dx.doi.org/10.1021/ac202450g) 
"to postprocess XCMS feature lists and to collect all features related to a compound into a compound spectrum."

Both of these steps are done using data collected in a single ionization mode (i.e., only negative or only positive)
because it would not make sense to attempt to use CAMERA otherwise.

However, multivariate analysis in general, and particularly the "False Discovery Rate" adjustment in hypothesis testing,
would both benefit from having all variables (features), negative and positive, combined for one analysis.  It is also
cumbersome to be forced to do an analysis twice, once for each ionization mode.

This tool will fail:
 * when the samples are not listed in exactly the same order in the negative-mode dataMatrix and the positive-mode dataMatrix
 * when the samples are not listed in exactly the same order in the negative-mode sampleMetadata and the positive-mode sampleMetadata

Otherwise
  * the two dataMatrix files are concatenated, and the names of features identified from positive ionization-mode data
are prefixed with "P"; negative, with "N".
  * the two variableMetadata files are concatenated, and the names of features are prefixed in the same way.
  * if sampleMetadata has a polarity column, its value is set to "posneg" in the output.
    * Technically, the sampleMetadata file in the output is derived from the negative ionization-mode sampleMetadata.

# Releases

## 0.98.2 

Updates for conformance with iuc (Intergalactic Utilities Commission) best-practices

## 0.98.1

First release
