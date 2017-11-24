#!/bin/bash

# Command line part
if test "$#" -ne 3; then
    echo "################################"
    echo "Usage:"
    echo "./01_setup.sh <voice_name> <align> <wav_dir>"
    echo ""
    echo "Give a voice name eg., slt_arctic"
    echo "align can be \"state\" or \"phone\""
    echo "default path to wav dir(Input): database/wav"
    echo "################################"
    exit 1
fi

voice_name=$1
align_type=$2
wav_dir=$3

# Directory architecture
current_working_dir=$(pwd)
merlin_dir=$(dirname $(dirname $(dirname $current_working_dir)))
experiments_dir=${current_working_dir}/experiments
data_dir=${current_working_dir}/database

voice_dir=${experiments_dir}/${voice_name}

acoustic_dir=${voice_dir}/acoustic_model
duration_dir=${voice_dir}/duration_model
synthesis_dir=${voice_dir}/test_synthesis

mkdir -p ${data_dir}
mkdir -p ${experiments_dir}
mkdir -p ${voice_dir}
mkdir -p ${acoustic_dir}
mkdir -p ${duration_dir}
mkdir -p ${synthesis_dir}
mkdir -p ${acoustic_dir}/data
mkdir -p ${duration_dir}/data
mkdir -p ${synthesis_dir}/txt

### create some test files ###
echo "Hello world." > ${synthesis_dir}/txt/test_001.txt
echo "Hi, this is a demo voice from Merlin." > ${synthesis_dir}/txt/test_002.txt
echo "Hope you guys enjoy free open-source voices from Merlin." > ${synthesis_dir}/txt/test_003.txt
printf "test_001\ntest_002\ntest_003" > ${synthesis_dir}/test_id_list.scp

### Settings ###
global_config_template=conf/global_settings.cfg.template
global_config_file=conf/global_settings.cfg

cp $global_config_template $global_config_file

# Paths
sed -i "s%#MERLIN_DIR#%${merlin_dir}%g" $global_config_file
sed -i "s%#WORK_DIR#%${current_working_dir}%g" $global_config_file

# Parameters
sed -i "s%#VOICE_NAME#%${voice_name}%g" $global_config_file
sed -i "s%#ALIGN_TYPE#%${align_type}%g" $global_config_file

# Corpus
nb_total=`ls -1 "$wav_dir"/*.wav | wc -l`
nb_valid=`echo "$nb_total * 5 / 100" | bc`
nb_test=$nb_valid
nb_train=`echo "$nb_total - (2*$nb_valid)"|bc`
sed -i "s%#NB_TRAIN#%${nb_train}%g" $global_config_file
sed -i "s%#NB_VALID#%${nb_valid}%g" $global_config_file
sed -i "s%#NB_TEST#%${nb_test}%g" $global_config_file

# Tools
#  - speech tools
est_dir=${merlin_dir}/tools/speech_tools
if [[ ! -d ${est_dir} ]]
then
    echo "[needed for phone_align] speech tools is not available (you have to run compile_other_tools.sh in the ${merlin_dir}/tools)"
    if [[ $align_type == "phone" ]]
    then
	exit -1
    fi
fi
sed -i "s%#EST_DIR#%${est_dir}%g" $global_config_file

#  - festival
fest_dir=${merlin_dir}/tools/festival
if [[ ! -d ${fest_dir} ]]
then
    echo "[needed for phone_align] festival is not available (you have to run compile_other_tools.sh in the ${merlin_dir}/tools)"
    if [[ $align_type == "phone" ]]
    then
	exit -1
    fi
fi
sed -i "s%#FEST_DIR#%${fest_dir}%g" $global_config_file

#  - festvox
festvox_dir=${merlin_dir}/tools/festvox
if [[ ! -d ${festvox_dir} ]]
then
    echo "[needed for phone_align] festvox is not available (you have to run compile_other_tools.sh in the ${merlin_dir}/tools)"
    if [[ $align_type == "phone" ]]
    then
	exit -1
    fi
fi
sed -i "s%#FESTVOX_DIR#%${festvox_dir}%g" $global_config_file

#  - HTK
htk_dir=${merlin_dir}/tools/bin/htk/
if [[ ! -d ${htk_dir} ]]
then
    echo "[needed for state_align] htk is not available (you have to run compile_htk.sh in the ${merlin_dir}/tools)"
    if [[ $align_type == "state" ]]
    then
	exit -1
    fi
fi
sed -i "s%#HTK_DIR#%${htk_dir}%g" $global_config_file


echo "Step 1:"
echo "Merlin default voice settings configured in \"$global_config_file\""
echo "Modify these params as per your data..."
echo "eg., sampling frequency, no. of train files etc.,"
echo "setup done...!"
