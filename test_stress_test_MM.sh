cd ~/gitsrc/tools/qvs/stress/tests/stability/
sudo cp $P4ROOT/sw/apps/embedded/autosan/Scripts/stability/nvqm_3/stress_common.py .
sudo cp $P4ROOT/sw/apps/embedded/autosan/Scripts/test_case_plugin.py ../dbapi/

echo "====Test audio===="
sleep 20
python test_multimedia.py -d 4 --test_module audiostress --testplan 4307 --testid 92076 --uart_port /dev/ttyS0 --product_out $EXP_DIR/tests_output/out/target/product/vcm31t186/nvidia_tests/ --seed 0

echo "====Test video===="
sleep 20
python test_multimedia.py -d 4 --test_module videostress --testplan 4307 --testid 92079 --uart_port /dev/ttyS0 --product_out $EXP_DIR/tests_output/out/target/product/vcm31t186/nvidia_tests/ --seed 0
