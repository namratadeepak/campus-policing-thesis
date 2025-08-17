#!/bin/bash
set -e

Rscript scripts/read_SCLEA2012.R
Rscript scripts/read_IPEDSdata2012.R
Rscript scripts/read_IPEDS_SCLEA_merge.R
Rscript scripts/read_Ed_Data_merge.R
Rscript scripts/read_Civilytics2016.R
Rscript scripts/read_Ed_SCLEA_IPEDS_merge.R
Rscript scripts/read_Civilytics_Ed_SCLEA_IPEDS.R