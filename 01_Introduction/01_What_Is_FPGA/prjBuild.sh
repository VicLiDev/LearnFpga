#!/bin/bash
# prjBuild.sh — 编译并运行本目录下的 Verilog Demo
# 用法: ./prjBuild.sh build  (编译)
#       ./prjBuild.sh run    (编译 + 仿真)
#       ./prjBuild.sh wave   (编译 + 仿真 + 打开波形)
#       ./prjBuild.sh clean  (清理)

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"
VCD_FILE="${OUT_DIR}/sim.vcd"

V_FILES=$(ls "${PRJ_DIR}"/*.v 2>/dev/null)
mkdir -p "${OUT_DIR}"

compile() {
    echo "========================================"
    echo " Compiling: ${PRJ_DIR}"
    echo "========================================"
    iverilog -o "${OUT_DIR}/sim" ${V_FILES}
    if [ $? -eq 0 ]; then echo "✅ 编译成功: ${OUT_DIR}/sim"
    else echo "❌ 编译失败"; exit 1; fi
}

sim() {
    echo "========================================"
    echo " Running Simulation"
    echo "========================================"
    cd "${OUT_DIR}" && vvp sim && cd - > /dev/null
    echo "✅ 仿真完成. 波形: ${VCD_FILE}"
}

wave() {
    compile
    sim
    echo ""
    echo "========================================"
    echo " Opening GTKWave..."
    echo "========================================"
    gtkwave "${VCD_FILE}" &
}

clean() { rm -rf "${OUT_DIR}"; echo "✅ 已清理 ${OUT_DIR}"; }

case "${1:-run}" in
    run)   compile; sim ;;
    build) compile ;;
    wave)  wave ;;
    clean) clean ;;
    *)     echo "用法: $0 [run|build|wave|clean]"; exit 1 ;;
esac
