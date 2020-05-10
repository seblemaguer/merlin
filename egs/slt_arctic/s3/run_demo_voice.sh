#!/bin/bash

voice_name="css-10"
setup_data=true
train_tts=true
run_tts=true

# train tts system
if [ "$setup_data" = true ]; then
    # step 1: run setup
    ./01_setup.sh $voice_name

    # step 2: prepare labels
    ./02_prepare_labels.sh database/wav database/txt database/labels
    
    # step 3: extract acoustic features
    ./03_prepare_acoustic_features.sh database/wav database/feats
fi

# train tts system
if [ "$train_tts" = true ]; then
    # step 4: prepare config files for training and testing
    ./04_prepare_conf_files.sh conf/global_settings.cfg

    # step 5: train duration model
    ./05_train_duration_model.sh conf/duration_${voice_name}.conf

    # step 6: train acoustic model
    ./06_train_acoustic_model.sh conf/acoustic_${voice_name}.conf
fi

# run tts
if [ "$run_tts" = true ]; then
    basename --suffix=.txt -- experiments/${voice_name}/test_synthesis/txt/* > experiments/${voice_name}/test_synthesis/test_id_list.scp

    # step 7: run text to speech
   ./07_run_merlin.sh experiments/${voice_name}/test_synthesis/txt conf/test_dur_synth_${voice_name}.conf conf/test_synth_${voice_name}.conf
fi

echo "done...!"
