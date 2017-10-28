#!/bin/bash
# join positive and negative ionization-mode XCMS datasets for a common set of samples
# summary:
#   - parse and validate arguments (or abort)
#   - check that the same samples are present in the same order in both the positive and negative mode data matrices (or abort)

# Parse arguments
#   ref: https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash/14203146#14203146
POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    dmpos)
      DMPOS="$2"
      shift # past argument
      shift # past value
      ;;
    dmneg)
      DMNEG="$2"
      shift # past argument
      shift # past value
      ;;
    dmout)
      DMOUT="$2"
      shift # past argument
      shift # past value
      ;;
    smpos)
      SMPOS="$2"
      shift # past argument
      shift # past value
      ;;
    smneg)
      SMNEG="$2"
      shift # past argument
      shift # past value
      ;;
    smout)
      SMOUT="$2"
      shift # past argument
      shift # past value
      ;;
    vmpos)
      VMPOS="$2"
      shift # past argument
      shift # past value
      ;;
    vmneg)
      VMNEG="$2"
      shift # past argument
      shift # past value
      ;;
    vmout)
      VMOUT="$2"
      shift # past argument
      shift # past value
      ;;
    *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters
if [[ -n $1 ]]; then
  echo "unexpected argument $1"
  echo "arguments supplied: $@"
  exit 1
fi

# Validate that we got the expected args
set -- ${DMPOS} ${DMNEG} ${DMOUT} ${SMPOS} ${SMNEG} ${SMOUT} ${VMPOS} ${VMNEG} ${VMOUT}
if [[ ! -n $9 ]]; then
  echo "expecting nine arguments"
  echo "parsed arguments: $@"
  exit 1
fi

# Show them what we got
echo "dataMatrix       positive_mode ${DMPOS}"
echo "dataMatrix       negative_mode ${DMNEG}"
echo "dataMatrix       joined_modes  ${DMOUT}"
echo "sampleMetadata   positive_mode ${SMPOS}"
echo "sampleMetadata   negative_mode ${SMNEG}"
echo "sampleMetadata   joined_modes  ${SMOUT}"
echo "variableMetadata positive_mode ${VMPOS}"
echo "variableMetadata negative_mode ${VMNEG}"
echo "variableMetadata joined_modes  ${VMOUT}"

# Check that sample names are the same, in the same order, for both datasets
diff -q <( head -n 1 ${DMPOS}) <( head -n 1 ${DMNEG} ) || { echo samplenames in dataMatrix files differ; exit 1; }
diff -q <( cut -f 1 ${SMPOS} ) <( cut -f 1 ${SMNEG}  ) || { echo samplenames in sampleMetadata files differ; exit 1; }

# Concatenate variableMetadata datasets to respective output file
cat  <( head -n 1 ${VMNEG} )   <( sed -n -e '1 d; s/^/N/; p;' ${VMNEG} )  <( sed -n -e '1 d; s/^/P/; p;' ${VMPOS} ) > ${VMOUT}

# Concatenate dataMatrix datasets to respective output file
cat  <( head -n 1 ${DMNEG} )   <( sed -n -e '1 d; s/^/N/; p;' ${DMNEG} )  <( sed -n -e '1 d; s/^/P/; p;' ${DMPOS} ) > ${DMOUT}

# Determine whether negative ionization-mode sampleMetadata file's column three is titled "polarity"
set -- `head -n 1 ${SMNEG} | cut -f 3`
echo args are now: $@
if [ "$1" = "polarity" ]; then
  # Replace all entries in column three of negative ionization-mode sampleMetadata file with "posneg" in respective output file
  if [[ -n $4 ]]; then
    paste <( cut -f 1-2 ${SMNEG} ) <( cut -f 3 ${SMNEG} | sed -n -e '2,$ s/.*/posneg/; p;' )  <( cut -f 4- ${SMNEG} )  > ${SMOUT}
  else
    paste <( cut -f 1-2 ${SMNEG} ) <( cut -f 3 ${SMNEG} | sed -n -e '2,$ s/.*/posneg/; p;' )  > ${SMOUT}
  fi
else
  # Copy negative ionization-mode sampleMetadata file to the respective output file
  cp ${SMNEG} ${SMOUT}
fi

exit 0
