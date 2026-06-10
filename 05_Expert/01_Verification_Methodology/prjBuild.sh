#!/bin/bash
# prjBuild.sh — 编译并运行 Testbench
# 用法: ./prjBuild.sh [run|build|wave|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"
PRJ_ROOT=$(cd "${PRJ_DIR}/../.." && pwd)
VCD_FILE="${OUT_DIR}/tb_basic.vcd"
mkdir -p "${OUT_DIR}"

compile() {
    echo "========================================"
    echo " Compiling Testbenches"
    echo "========================================"
    PASS=0; FAIL=0

    iverilog -o "${OUT_DIR}/tb_basic.out" \
        "${PRJ_ROOT}/02_Basics/01_Combinational_Logic/02_full_adder.v" \
        "${PRJ_ROOT}/02_Basics/01_Combinational_Logic/03_ripple_carry_adder.v" \
        "${PRJ_DIR}/01_tb_basic.v" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ 01_tb_basic.v"; PASS=$((PASS+1))
    else echo "  ❌ 01_tb_basic.v"; FAIL=$((FAIL+1)); fi

    iverilog -o "${OUT_DIR}/tb_self_check.out" \
        "${PRJ_ROOT}/02_Basics/01_Combinational_Logic/02_full_adder.v" \
        "${PRJ_ROOT}/02_Basics/01_Combinational_Logic/03_ripple_carry_adder.v" \
        "${PRJ_DIR}/02_tb_self_checking.v" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ 02_tb_self_checking.v"; PASS=$((PASS+1))
    else echo "  ❌ 02_tb_self_checking.v"; FAIL=$((FAIL+1)); fi

    iverilog -o "${OUT_DIR}/tb_coverage.out" \
        "${PRJ_ROOT}/03_Core/01_Finite_State_Machine/02_sequence_detector.v" \
        "${PRJ_DIR}/03_tb_coverage.v" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ 03_tb_coverage.v"; PASS=$((PASS+1))
    else echo "  ❌ 03_tb_coverage.v"; FAIL=$((FAIL+1)); fi

    echo ""; echo "编译结果: ${PASS} 通过, ${FAIL} 失败"
    return $FAIL
}

sim() {
    compile
    echo ""
    echo "========================================"
    echo " Running Testbenches"
    echo "========================================"
    echo ""; echo "--- 01 Basic Testbench ---"
    vvp "${OUT_DIR}/tb_basic.out" 2>/dev/null
    echo ""; echo "--- 02 Self-Checking Testbench ---"
    vvp "${OUT_DIR}/tb_self_check.out" 2>/dev/null
    echo ""; echo "--- 03 Coverage Testbench ---"
    vvp "${OUT_DIR}/tb_coverage.out" 2>/dev/null
    echo ""; echo "✅ 波形文件: ${OUT_DIR}/*.vcd"
}

wave() {
    sim
    echo ""
    echo "========================================"
    echo " Opening GTKWave..."
    echo "========================================"
    gtkwave "${OUT_DIR}/tb_self_check.vcd" &
}

clean() { rm -rf "${OUT_DIR}"; echo "✅ 已清理 ${OUT_DIR}"; }

case "${1:-run}" in
    run)   sim ;;
    build) compile ;;
    wave)  wave ;;
    clean) clean ;;
    *)     echo "用法: $0 [run|build|wave|clean]"; exit 1 ;;
esac
