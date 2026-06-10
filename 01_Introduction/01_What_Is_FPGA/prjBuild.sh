#!/bin/bash
# prjBuild.sh — 编译并运行本目录下的 Verilog Demo
# 用法: ./prjBuild.sh          (编译)
#       ./prjBuild.sh run      (编译 + 仿真)
#       ./prjBuild.sh clean    (清理)

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"
TB_FILE="02_led_blink_tb.v"

# 本目录所有 Verilog 源文件
V_FILES=$(ls "${PRJ_DIR}"/*.v 2>/dev/null)

mkdir -p "${OUT_DIR}"

compile() {
    echo "========================================"
    echo " Compiling: ${PRJ_DIR}"
    echo "========================================"
    iverilog -o "${OUT_DIR}/sim" ${V_FILES}
    if [ $? -eq 0 ]; then
        echo "✅ 编译成功: ${OUT_DIR}/sim"
    else
        echo "❌ 编译失败"
        exit 1
    fi
}

run() {
    compile
    echo ""
    echo "========================================"
    echo " Running Simulation"
    echo "========================================"
    vvp "${OUT_DIR}/sim"
    echo ""
    echo "========================================"
    echo " 仿真完成. 波形文件: ${OUT_DIR}/sim.vcd"
    echo " 查看波形: gtkwave ${OUT_DIR}/sim.vcd"
    echo "========================================"
}

clean() {
    rm -rf "${OUT_DIR}"
    echo "✅ 已清理 ${OUT_DIR}"
}

case "${1:-run}" in
    run)   run ;;
    build) compile ;;
    clean) clean ;;
    *)     echo "用法: $0 [run|build|clean]"; exit 1 ;;
esac
