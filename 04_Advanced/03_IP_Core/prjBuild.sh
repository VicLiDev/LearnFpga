#!/bin/bash
# prjBuild.sh — IP 核调用示例
# 注意: IP 核示例需要 Vivado 环境和已生成的 IP, 无法用 iverilog 编译
# 用法: ./prjBuild.sh [info|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)
OUT_DIR="${PRJ_DIR}/out"

info() {
    echo "========================================"
    echo " IP Core 调用示例"
    echo "========================================"
    echo ""
    echo "本目录包含 IP 核调用示例代码, 需要 Vivado 环境支持:"
    echo ""
    echo "  01_bram_ip_example.v    Block RAM IP 调用"
    echo "  02_fifo_ip_example.v    FIFO IP 调用"
    echo "  03_pll_ip_example.v     PLL (Clocking Wizard) IP 调用"
    echo ""
    echo "使用步骤:"
    echo "  1. 打开 Vivado → Create Project"
    echo "  2. IP Catalog → 生成所需 IP (BRAM/FIFO/PLL)"
    echo "  3. 将本目录的 .v 文件添加到工程"
    echo "  4. 修改 IP 例化名称与生成的 IP 一致"
    echo "  5. 综合 → 实现 → 生成比特流"
    echo ""
}

wave() {
    echo "⚠️  IP 核示例需要 Vivado 环境, 不支持 gtkwave 波形查看"
    echo "   请使用 Vivado 的仿真功能查看波形"
    info
}

clean() { rm -rf "${OUT_DIR}"; echo "✅ 已清理"; }

case "${1:-info}" in
    run)   info ;;
    build) info ;;
    wave)  wave ;;
    clean) clean ;;
    *)     echo "用法: $0 [run|build|wave|clean]"; exit 1 ;;
esac
