#!/bin/bash

if test "$#" -lt 3; then
    echo "Usage: ./scripts/prepare_labels_from_txt.sh <path_to_text_dir> <path_to_lab_dir> <path_to_global_conf_file>"
    exit 1
fi

### arguments
txt_dir=$1
lab_dir=$2
global_config_file=$3

if [ ! -f $global_config_file ]; then
    echo "Global config file doesn't exist"
    exit 1
else
    source $global_config_file
fi

if test "$#" -eq 3; then
    train=false
else
    train=$4
fi

frontend=${MerlinDir}/misc/scripts/frontend

# Define the file list
if [ "$train" = true ]; then
    file_id_scp=$WorkDir/experiments/$Voice/file_id_list.scp
else
    file_id_scp=$WorkDir/experiments/$Voice/test_synthesis/test_id_list.scp
fi

# Extract Full Labels
(
    mkdir -p $WorkDir/$lab_dir/label_no_align
    cd $MARY_DIR
    ./gradlew b -Plist_filename="$file_id_scp" \
                -Ptxt_dir="$WorkDir/$txt_dir" \
                -Plab_dir="$WorkDir/$lab_dir/label_no_align" \
                -Pconf="$WorkDir/$MaryConfiguration"
                # --stacktrace
                # -Dlog4j.level=INFO -Dlog4j.configurationFile=/home/sebastien/align/minimal_marytts/src/log4j2.xml
)


if [ "$train" = true ]; then
    ls -1 $WorkDir/$lab_dir/label_no_align | sed 's/.lab$//g' > $WorkDir/$lab_dir/file_id_list.scp
    echo "Labels are ready to be aligned"
else
    echo "Labels are ready to be synthesized"
    mkdir -p ${lab_dir}/prompt-lab
    cp -rf ${lab_dir}/label_no_align/* ${lab_dir}/prompt-lab
fi
