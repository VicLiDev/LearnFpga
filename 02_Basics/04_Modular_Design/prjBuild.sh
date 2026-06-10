#!/bin/bash
# prjBuild.sh — 编译并运行本目录下的 Verilog Demo
# 用法: ./prjBuild.sh [run|build|wave|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"
VCD_FILE="${OUT_DIR}/sim.vcd"
mkdir -p "${OUT_DIR}"

compile() {
    echo "========================================"
    echo " Compiling: ${PRJ_DIR}"
    echo "========================================"
    PASS=0; FAIL=0
    for f in 01_full_adder.v 03_param_counter.v 04_button_led_top.v; do
        iverilog -o "${OUT_DIR}/${f%.v}.out" "${PRJ_DIR}/${f}" 2>/dev/null
        if [ $? -eq 0 ]; then echo "  ✅ ${f}"; PASS=$((PASS+1))
        else echo "  ❌ ${f}"; FAIL=$((FAIL+1)); fi
    done
    iverilog -o "${OUT_DIR}/02_4bit_adder.out" \
        "${PRJ_DIR}/01_full_adder.v" "${PRJ_DIR}/02_4bit_adder.v" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ 02_4bit_adder.v (+ full_adder)"; PASS=$((PASS+1))
    else echo "  ❌ 02_4bit_adder.v"; FAIL=$((FAIL+1)); fi
    echo ""; echo "编译结果: ${PASS} 通过, ${FAIL} 失败"
    return $FAIL
}

auto_tb() {
    cat > "${OUT_DIR}/auto_tb.v" << TBEOF
\`timescale 1ns / 1ps
module auto_tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] sum;
    wire cout;
    adder_4bit u_dut (.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    initial begin
        \$dumpfile("${VCD_FILE}");
        \$dumpvars(0, auto_tb);
        a=5; b=3; cin=0; #10;
        a=9; b=7; cin=1; #10;
        a=15; b=1; cin=0; #10;
        a=0; b=0; cin=0; #10;
        \$display("Simulation done.");
        \$finish;
    end
endmodule
TBEOF
}

sim() {
    echo "========================================"
    echo " Auto-generating TB for waveform..."
    echo "========================================"
    auto_tb
    iverilog -o "${OUT_DIR}/sim_wave" "${OUT_DIR}/auto_tb.v" \
        "${PRJ_DIR}/01_full_adder.v" "${PRJ_DIR}/02_4bit_adder.v" 2>&1
    if [ $? -ne 0 ]; then echo "❌ 波形编译失败"; exit 1; fi
    cd "${OUT_DIR}" && vvp sim_wave && cd - > /dev/null
    echo "✅ 仿真完成. 波形: ${VCD_FILE}"
}

wave() {
    sim
    echo ""
    echo "Opening GTKWave..."
    gtkwave "${VCD_FILE}" &
}
clean() { rm -rf "${OUT_DIR}"; echo "✅ 已清理 ${OUT_DIR}"; }

case "${1:-run}" in
    run)   compile; echo "本目录为纯 RTL 模块, 无 Testbench" ;;
    build) compile ;;
    wave)  wave ;;
    clean) clean ;;
    *)     echo "用法: $0 [run|build|wave|clean]"; exit 1 ;;
esac
