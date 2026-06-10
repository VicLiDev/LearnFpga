#!/bin/bash
# prjBuild.sh — 编译并运行本目录下的 Verilog Demo
# 用法: ./prjBuild.sh [run|build|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"

# 本目录所有 Verilog 源文件
V_FILES=$(ls "${PRJ_DIR}"/*.v 2>/dev/null)

mkdir -p "${OUT_DIR}"

# 每个 demo 独立编译检查语法
compile() {
    echo "========================================"
    echo " Compiling: ${PRJ_DIR}"
    echo "========================================"
    PASS=0
    FAIL=0
    for f in ${V_FILES}; do
        fname=$(basename "$f")
        iverilog -o "${OUT_DIR}/${fname%.v}.out" "$f" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "  ✅ ${fname}"
            PASS=$((PASS + 1))
        else
            echo "  ❌ ${fname}"
            FAIL=$((FAIL + 1))
        fi
    done
    echo ""
    echo "编译结果: ${PASS} 通过, ${FAIL} 失败"
    return $FAIL
}

run() {
    compile
    echo ""
    echo "========================================"
    echo " 本目录为纯 RTL 模块, 无 Testbench"
    echo " 若需仿真, 请编写对应的 _tb.v 文件"
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
