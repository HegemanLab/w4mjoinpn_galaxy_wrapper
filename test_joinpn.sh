#!/bin/bash
./w4mjoinpn.sh \
  dmneg test-data/input_dataMatrix_neg.tsv \
  dmpos test-data/input_dataMatrix_pos.tsv \
  dmout test-data/output_dataMatrix.tsv \
  smneg test-data/input_sampleMetadata_neg.tsv \
  smpos test-data/input_sampleMetadata_pos.tsv \
  smout test-data/output_sampleMetadata.tsv \
  vmneg test-data/input_variableMetadata_neg.tsv \
  vmpos test-data/input_variableMetadata_pos.tsv \
  vmout test-data/output_variableMetadata.tsv

./w4mjoinpn.sh \
  dmneg test-data/input_dataMatrix_neg.tsv \
  dmpos test-data/input_dataMatrix_pos.tsv \
  dmout test-data/output_dataMatrix_4col.tsv \
  smneg test-data/input_sampleMetadata_neg_4col.tsv \
  smpos test-data/input_sampleMetadata_pos.tsv \
  smout test-data/output_sampleMetadata_4col.tsv \
  vmneg test-data/input_variableMetadata_neg.tsv \
  vmpos test-data/input_variableMetadata_pos.tsv \
  vmout test-data/output_variableMetadata_4col.tsv
