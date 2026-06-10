#!/bin/bash
# prjBuild.sh — 编译并运行本目录下的 Verilog Demo
# 用法: ./prjBuild.sh [run|build|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"
mkdir -p "${OUT_DIR}"

compile() {
    echo "========================================"
    echo " Compiling: ${PRJ_DIR}"
    echo "========================================"
    PASS=0; FAIL=0

    # 独立模块
    for f in 01_full_adder.v 03_param_counter.v 04_button_led_top.v; do
        iverilog -o "${OUT_DIR}/${f%.v}.out" "${PRJ_DIR}/${f}" 2>/dev/null
        if [ $? -eq 0 ]; then echo "  ✅ ${f}"; PASS=$((PASS+1))
        else echo "  ❌ ${f}"; FAIL=$((FAIL+1)); fi
    done

    # 4bit 加法器 (依赖 full_adder)
    iverilog -o "${OUT_DIR}/02_4bit_adder.out" \
        "${PRJ_DIR}/01_full_adder.v" "${PRJ_DIR}/02_4bit_adder.v" 2>/dev/null
    if [ $? -eq 0 ]; then echo "  ✅ 02_4bit_adder.v (+ full_adder)"; PASS=$((PASS+1))
    else echo "  ❌ 02_4bit_adder.v"; FAIL=$((FAIL+1)); fi

    echo ""; echo "编译结果: ${PASS} 通过, ${FAIL} 失败"
    return $FAIL
}

run() {
    compile
    echo ""; echo "本目录为纯 RTL 模块, 无 Testbench"
}

clean() { rm -rf "${OUT_DIR}"; echo "✅ 已清理 ${OUT_DIR}"; }

case "${1:-run}" in
    run)   run ;; build) compile ;; clean) clean ;;
    *)     echo "用法: $0 [run|build|clean]"; exit 1 ;;
esac
