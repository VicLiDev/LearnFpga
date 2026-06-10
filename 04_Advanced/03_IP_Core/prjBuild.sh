#!/bin/bash
# prjBuild.sh — IP 核调用示例
# 注意: IP 核示例需要 Vivado 环境和已生成的 IP, 无法用 iverilog 编译
# 用法: ./prjBuild.sh [info|clean]

PRJ_DIR=$(cd "$(dirname "$0")" && pwd)

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

clean() {
    rm -rf "${PRJ_DIR}/out"
    echo "✅ 已清理"
}

case "${1:-info}" in
    info)  info ;;
    clean) clean ;;
    *)     echo "用法: $0 [info|clean]"; exit 1 ;;
esac
