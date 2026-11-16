report_dir="test-results/slit-hardware/stress-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$report_dir"

for iteration in $(seq 1 50); do
    echo "Motion test iteration $iteration / 50"

    python3 tests/integration/slit_hardware/run.py \
        --prefix HWSLIT: \
        --case motion \
        --case coupled_stop \
        --case concurrent \
        --case command_burst \
        --case virtual \
        --case native \
        --case target_write \
        --case motor \
        --report "$report_dir/run-$iteration.json" \
        --run > "$report_dir/run-$iteration.log" 2>&1

    status=$?
    if [ "$status" -ne 0 ]; then
        echo "Stopped: iteration $iteration, exit code $status"
        tail -n 80 "$report_dir/run-$iteration.log"
        break
    fi
done
