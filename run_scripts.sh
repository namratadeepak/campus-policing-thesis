#!/usr/bin/env bash
set -Eeuo pipefail

cd "$(dirname "$0")"

git lfs install --local
git lfs pull

echo "==> Restoring R packages (if using renv)"
Rscript -e "if (!requireNamespace('renv', quietly=TRUE)) install.packages('renv', repos='https://cloud.r-project.org'); if (file.exists('renv.lock')) renv::restore(prompt = FALSE)"

echo "==> Running pipeline"
Rscript scripts/read_SCLEA2012.R
Rscript scripts/read_IPEDSdata2012.R
Rscript scripts/read_Civilytics2016.R
Rscript scripts/read_Ed_Data_2012_merge.R
Rscript scripts/read_IPEDS_SCLEA_2012_merge.R
Rscript scripts/read_Ed_SCLEA_IPEDS_2012_merge.R
Rscript scripts/read_Civilytics_Ed_SCLEA_IPEDS_2012.R
Rscript scripts/read_UCR_2012.R
Rscript scripts/merge_UCR_Civilytics_Ed_IPEDS_SCLEA_2012.R

echo "==> Done"
