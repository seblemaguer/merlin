#!/bin/bash

if test "$#" -ne 1; then
    echo "################################"
    echo "Usage:"
    echo "./01_setup.sh <voice_name>"
    echo ""
    echo "Give a voice name eg., slt_arctic"
    echo "################################"
    exit 1
fi

current_working_dir=$(pwd)
merlin_dir=$(dirname $(dirname $(dirname $current_working_dir)))
experiments_dir=${current_working_dir}/experiments
data_dir=${current_working_dir}/database

voice_name=$1  # FIXME: for now force the voice name
voice_dir=${experiments_dir}/${voice_name}
acoustic_dir=${voice_dir}/acoustic_model
duration_dir=${voice_dir}/duration_model
synthesis_dir=${voice_dir}/test_synthesis

## Create directory architory

mkdir -p ${data_dir}
mkdir -p ${experiments_dir}
mkdir -p ${voice_dir}
mkdir -p ${acoustic_dir}
mkdir -p ${duration_dir}
mkdir -p ${synthesis_dir}
mkdir -p ${acoustic_dir}/data
mkdir -p ${duration_dir}/data
mkdir -p ${synthesis_dir}/txt

### Generate the list files ###
cp -rf ${data_dir}/test-txt/* ${synthesis_dir}/txt
ls -1 ${synthesis_dir}/txt | sed 's/.txt$//g' > ${synthesis_dir}/test_id_list.scp
ls -1 ${data_dir}/txt | sed 's/.txt$//g' > ${voice_dir}/file_id_list.scp

### default settings ###
global_config_file=conf/global_settings.cfg
echo "######################################" > $global_config_file
echo "############# PATHS ##################" >> $global_config_file
echo "######################################" >> $global_config_file
echo "" >> $global_config_file

echo "MerlinDir=${merlin_dir}" >>  $global_config_file
echo "WorkDir=${current_working_dir}" >>  $global_config_file
echo "" >> $global_config_file

echo "######################################" >> $global_config_file
echo "############# PARAMS #################" >> $global_config_file
echo "######################################" >> $global_config_file
echo "" >> $global_config_file

echo "Voice=${voice_name}" >> $global_config_file
echo "Labels=state_align" >> $global_config_file
# echo "QuestionFile=questions-mary_de.hed" >> $global_config_file
echo "QuestionFile=questions-mary_de.hed" >> $global_config_file
echo "Vocoder=WORLD" >> $global_config_file
echo "SamplingFreq=16000" >> $global_config_file
echo "SilencePhone='pau'" >> $global_config_file
echo "FileIDList=file_id_list.scp" >> $global_config_file
echo "MaryConfiguration=conf/mary.json" >> $global_config_file
echo "" >> $global_config_file

echo "######################################" >> $global_config_file
echo "######### No. of files ###############" >> $global_config_file
echo "######################################" >> $global_config_file
echo "" >> $global_config_file

echo "Train=1112" >> $global_config_file
echo "Valid=10" >> $global_config_file
echo "Test=10" >> $global_config_file
echo "" >> $global_config_file

echo "######################################" >> $global_config_file
echo "############# TOOLS ##################" >> $global_config_file
echo "######################################" >> $global_config_file
echo "" >> $global_config_file

echo "MARY_DIR=${merlin_dir}/tools/marytts-merlin-frontend" >> $global_config_file
echo "HTKDIR=${merlin_dir}/tools/bin/htk" >> $global_config_file
echo "" >> $global_config_file

echo "Step 1:"
echo "Merlin default voice settings configured in \"$global_config_file\""
