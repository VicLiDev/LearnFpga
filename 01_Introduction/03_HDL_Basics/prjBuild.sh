#!/bin/bash
# prjBuild.sh — 编译并运行本目录下的 Verilog Demo
# 用法: ./prjBuild.sh [run|build|wave|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"
VCD_FILE="${OUT_DIR}/sim.vcd"
V_FILES=$(ls "${PRJ_DIR}"/*.v 2>/dev/null)
mkdir -p "${OUT_DIR}"

# 自动生成简易 TB (选择第一个非 _tb 的 .v 文件)
auto_tb() {
    local rtl_file=$(ls "${PRJ_DIR}"/[0-9]*_*.v 2>/dev/null | head -1)
    if [ -z "$rtl_file" ]; then echo "❌ 未找到 RTL 文件"; exit 1; fi
    local rtl_name=$(basename "$rtl_file" .v)
    cat > "${OUT_DIR}/auto_tb.v" << EOF
\`timescale 1ns / 1ps
module auto_tb;
    reg clk = 0;
    always #5 clk = ~clk;
    ${rtl_name} #() u_dut (/* 请根据端口补充连接 */);
    initial begin
        \$dumpfile("${VCD_FILE}");
        \$dumpvars(0, auto_tb);
        #1000;
        \$display("Simulation done. Open waveform with: gtkwave ${VCD_FILE}");
        \$finish;
    end
endmodule
EOF
    echo "  ℹ️  自动生成 TB: ${rtl_name} (端口未连接, 仅生成时钟波形)"
}

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

sim() {
    echo "========================================"
    echo " Auto-generating TB for waveform..."
    echo "========================================"
    auto_tb
    iverilog -o "${OUT_DIR}/sim_wave" "${OUT_DIR}/auto_tb.v" ${V_FILES} 2>&1
    if [ $? -ne 0 ]; then echo "❌ 波形编译失败"; exit 1; fi
    vvp "${OUT_DIR}/sim_wave" 2>/dev/null
    echo "✅ 仿真完成. 波形: ${VCD_FILE}"
}

wave() {
    sim
    echo ""; echo "Opening GTKWave..."; gtkwave "${VCD_FILE}" &
}

clean() { rm -rf "${OUT_DIR}"; echo "✅ 已清理 ${OUT_DIR}"; }

case "${1:-run}" in
    run)   compile; echo "本目录为纯 RTL 模块, 无 Testbench" ;;
    build) compile ;;
    wave)  wave ;;
    clean) clean ;;
    *)     echo "用法: $0 [run|build|wave|clean]"; exit 1 ;;
esac
