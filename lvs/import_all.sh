 #!/bin/bash

 if [[ $SHELL_NAME == "zsh" ]]; then
     LVS_REPO=$(realpath ${0:a:h}/..)
 else
     LVS_REPO="$(dirname $(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd))"
 fi

 CORES=$(nproc)

 CARAVEL_ROOT=~/caravel
 CARAVEL_GDS=$CARAVEL_ROOT/gds
 CARAVEL_VERILOG=$CARAVEL_ROOT/verilog/gl
 BLOCKS_GDS=($( ls $CARAVEL_GDS/*.gds ))
 BLOCKS_VERILOG=($( ls $CARAVEL_VERILOG/*.v ))
 TEST_CASES=$LVS_REPO/lvs/test_cases
 SPICE_LIB=~/openlane/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
 BLACK_BOX=true


import_blocks() {
    for block in "${BLOCKS_GDS[@]}"; do
        block_name=$(basename "$block")
        target_dir=$TEST_CASES/"${block_name%.*}"
        mkdir $target_dir
        cp $block $target_dir
    done
    
    for block in "${BLOCKS_VERILOG[@]}"; do
        block_name=$(basename "$block")
        echo $block_name
        target_dir=$TEST_CASES/"${block_name%.*}"
        python3 update_spice.py $SPICE_LIB $target_dir/$(basename "$SPICE_LIB")
        /home/marwan/sak/qflow/vlog2Spice -l $target_dir/sky130_fd_sc_hd.spice -o $target_dir/"${block_name%.*}".spice $block
    done
}

run_lvs(){
    TEST_CASES_GDS=($(ls $TEST_CASES/*/*.gds))
    for block in "${TEST_CASES_GDS[@]}"; do
        block_name="${$(basename "$block")%.*}"
        echo "running: $block_name"
        echo "design gds: $block"
        echo "report path: $(dirname $block)/lvs_report.lvsdb"
        klayout -b -rd input=$block -rd schematic=$block_name.spice -rd black_box=$BLACK_BOX -rd black_box_conb=$BLACK_BOX_CONB -rd thr=$CORES -r sky130A.lvs
    done
}