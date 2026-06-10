#!/bin/bash
# prjBuild.sh — 时序约束文件说明
# 注意: XDC 文件是 Vivado 约束文件, 不能用 iverilog 编译
# 用法: ./prjBuild.sh [info|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"

info() {
    echo "========================================"
    echo " Timing Constraints (XDC)"
    echo "========================================"
    echo ""
    echo "本目录包含 Xilinx Design Constraints 文件:"
    echo ""
    echo "  01_basic_constraints.xdc"
    echo "    - 主时钟定义 (create_clock)"
    echo "    - IO 引脚分配 (PACKAGE_PIN)"
    echo "    - 输入/输出延迟约束"
    echo "    - 复位虚假路径"
    echo ""
    echo "  02_advanced_constraints.xdc"
    echo "    - 多时钟域约束"
    echo "    - 跨时钟域虚假路径"
    echo "    - 多周期路径 (set_multicycle_path)"
    echo "    - 虚拟时钟"
    echo ""
    echo "使用方法:"
    echo "  1. 在 Vivado 工程中添加 .xdc 文件"
    echo "  2. 运行综合/实现后查看 Timing Report"
    echo "  3. 确保所有路径 WNS (Worst Negative Slack) >= 0"
    echo ""
}

wave() {
    echo "⚠️  XDC 约束文件无法生成仿真波形"
    echo "   波形查看请在 Vivado 中使用 Simulation 功能"
    info
}

clean() { rm -rf "${OUT_DIR}"; echo "✅ 已清理"; }

case "${1:-info}" in
    run)   info ;; build) info ;; wave) wave ;; clean) clean ;;
    *)     echo "用法: $0 [run|build|wave|clean]"; exit 1 ;;
esac
