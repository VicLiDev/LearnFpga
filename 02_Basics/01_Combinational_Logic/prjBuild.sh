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
    for f in 01_half_adder.v 04_alu.v; do
        iverilog -o "${OUT_DIR}/${f%.v}.out" "${PRJ_DIR}/${f}" 2>/dev/null
        if [ $? -eq 0 ]; then echo "  ✅ ${f}"; PASS=$((PASS+1))
        else echo "  ❌ ${f}"; FAIL=$((FAIL+1)); fi
    done
    iverilog -o "${OUT_DIR}/02_full_adder.out" "${PRJ_DIR}/02_full_adder.v" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ 02_full_adder.v"; PASS=$((PASS+1))
    else echo "  ❌ 02_full_adder.v"; FAIL=$((FAIL+1)); fi
    iverilog -o "${OUT_DIR}/03_ripple_carry_adder.out" \
        "${PRJ_DIR}/02_full_adder.v" "${PRJ_DIR}/03_ripple_carry_adder.v" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ 03_ripple_carry_adder.v (+ full_adder)"; PASS=$((PASS+1))
    else echo "  ❌ 03_ripple_carry_adder.v"; FAIL=$((FAIL+1)); fi
    echo ""; echo "编译结果: ${PASS} 通过, ${FAIL} 失败"
    return $FAIL
}

auto_tb() {
    local rtl="${PRJ_DIR}/03_ripple_carry_adder.v"
    local dep="${PRJ_DIR}/02_full_adder.v"
    cat > "${OUT_DIR}/auto_tb.v" << 'EOF'
`timescale 1ns / 1ps
module auto_tb;
    reg [3:0] a, b;
    reg       cin;
    wire [3:0] sum;
    wire       cout;
    ripple_carry_adder_4bit u_dut (.a(a),.b(b),.cin(cin),.sum(sum),.cout(cout));
    initial begin
        $dumpfile("OUT_DIR/sim.vcd");
        $dumpvars(0, auto_tb);
        a=4'd3; b=4'd4; cin=0; #10;
        a=4'd15; b=4'd1; cin=0; #10;
        a=4'd7; b=4'd8; cin=1; #10;
        a=4'd0; b=4'd0; cin=0; #10;
        $display("Simulation done.");
        $finish;
    end
endmodule
EOF
    sed -i "s|OUT_DIR|${OUT_DIR}|g" "${OUT_DIR}/auto_tb.v"
}

sim() {
    echo "========================================"
    echo " Auto-generating TB for waveform..."
    echo "========================================"
    auto_tb
    iverilog -o "${OUT_DIR}/sim_wave" "${OUT_DIR}/auto_tb.v" \
        "${PRJ_DIR}/02_full_adder.v" "${PRJ_DIR}/03_ripple_carry_adder.v" 2>&1
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
