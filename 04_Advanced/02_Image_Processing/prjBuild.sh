#!/bin/bash
# prjBuild.sh — 编译并运行本目录下的 Verilog Demo
# 用法: ./prjBuild.sh [run|build|wave|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"
VCD_FILE="${OUT_DIR}/sim.vcd"
V_FILES=$(ls "${PRJ_DIR}"/*.v 2>/dev/null)
mkdir -p "${OUT_DIR}"

compile() {
    echo "========================================"
    echo " Compiling: ${PRJ_DIR}"
    echo "========================================"
    PASS=0; FAIL=0
    for f in ${V_FILES}; do
        fname=$(basename "$f")
        iverilog -o "${OUT_DIR}/${fname%.v}.out" "$f" 2>/dev/null
        if [ $? -eq 0 ]; then echo "  ✅ ${fname}"; PASS=$((PASS+1))
        else echo "  ❌ ${fname}"; FAIL=$((FAIL+1)); fi
    done
    echo ""; echo "编译结果: ${PASS} 通过, ${FAIL} 失败"
    return $FAIL
}

auto_tb() {
    cat > "${OUT_DIR}/auto_tb.v" << TBEOF
\`timescale 1ns / 1ps
module auto_tb;
    reg clk = 0, rst_n = 0, valid_in = 0;
    reg [15:0] rgb565 = 16'hF800;
    wire [7:0] gray;
    always #5 clk = ~clk;
    rgb_to_gray u_dut (.clk(clk),.rst_n(rst_n),.rgb565(rgb565),.valid_in(valid_in),.gray(gray),.valid_out());
    integer i;
    initial begin
        \$dumpfile("${VCD_FILE}");
        \$dumpvars(0, auto_tb);
        #10; rst_n = 1; valid_in = 1;
        for (i = 0; i < 10; i = i + 1) begin
            rgb565 = \$random; #10;
            \$display("rgb=0x%04h, gray=%0d", rgb565, gray);
        end
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
    iverilog -o "${OUT_DIR}/sim_wave" "${OUT_DIR}/auto_tb.v" "${PRJ_DIR}/01_rgb_to_gray.v" 2>&1
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
