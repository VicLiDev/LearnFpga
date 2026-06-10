//--------------------------------------------------------------------------------------------------
// 03_tb_coverage.v
// 简易功能覆盖率框架
//
// 覆盖率类型:
//   - 行覆盖 (Line Coverage): 每行代码是否被执行
//   - 分支覆盖 (Branch Coverage): if/else 每个分支是否被覆盖
//   - 条件覆盖 (Condition Coverage): 每个条件是否为真/假
//   - 状态覆盖 (FSM Coverage): 每个状态是否被进入
//   - 翻转覆盖 (Toggle Coverage): 每个 net 是否翻转
//
// 本例实现一个简单的状态覆盖统计
//--------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_coverage;

    // 信号
    reg        clk;
    reg        rst_n;
    reg        start;
    wire       found;

    // DUT: 序列检测器 (检测 "1011")
    sequence_detector u_dut (
        .clk(clk), .rst_n(rst_n), .din(start), .found(found)
    );

    // 时钟
    initial clk = 0;
    always #5 clk = ~clk;

    // 状态覆盖统计
    reg [3:0] state_seen [0:3];
    integer i;
    integer covered;

    // 监测状态覆盖 (通过检查 DUT 内部状态)
    // 注意: 仿真中可以直接访问层次化信号
    always @(posedge clk) begin
        case (u_dut.state)
            2'd0: state_seen[0] <= 1'b1;  // S_IDLE
            2'd1: state_seen[1] <= 1'b1;  // S_1
            2'd2: state_seen[2] <= 1'b1;  // S_10
            2'd3: state_seen[3] <= 1'b1;  // S_101
        endcase
    end

    // 测试激励: 发送多种序列
    initial begin
        // 初始化覆盖数组
        for (i = 0; i < 4; i = i + 1)
            state_seen[i] = 1'b0;

        rst_n  = 0;
        start  = 0;
        #20;
        rst_n  = 1;

        // 发送序列: 1, 0, 1, 1 → 应检测到 "1011"
        $display("Sending sequence: 1 0 1 1");
        start = 1; #10;
        start = 0; #10;
        start = 1; #10;
        start = 0; #10;
        start = 1; #10;
        start = 1; #10;

        // 发送一些干扰序列
        $display("Sending random data...");
        repeat(20) begin
            start = $random;
            #10;
        end

        // 再次发送 1011
        $display("Sending sequence: 1 0 1 1 again");
        start = 1; #10;
        start = 0; #10;
        start = 1; #10;
        start = 0; #10;
        start = 1; #10;
        start = 1; #10;

        #50;

        // 打印覆盖率报告
        $display("\n========== Coverage Report ==========");
        $display("State S_IDLE : %s", state_seen[0] ? "COVERED" : "NOT COVERED");
        $display("State S_1    : %s", state_seen[1] ? "COVERED" : "NOT COVERED");
        $display("State S_10   : %s", state_seen[2] ? "COVERED" : "NOT COVERED");
        $display("State S_101  : %s", state_seen[3] ? "COVERED" : "NOT COVERED");

        covered = state_seen[0] + state_seen[1] + state_seen[2] + state_seen[3];
        $display("\nState Coverage: %0d / 4 = %0d%%", covered, covered * 25);
        $display("======================================");

        $finish;
    end

    // 波形
    initial begin
        $dumpfile("tb_coverage.vcd");
        $dumpvars(0, tb_coverage);
    end

endmodule
