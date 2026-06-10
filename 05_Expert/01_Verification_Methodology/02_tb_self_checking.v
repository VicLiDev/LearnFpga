//--------------------------------------------------------------------------------------------------
// 02_tb_self_checking.v
// 自校验 Testbench — 自动判断测试通过/失败
//
// 特点:
//   - 遍历所有输入组合 (穷举测试, 适合小模块)
//   - 自动比较期望值与实际值
//   - 统计通过/失败数
//   - 最终输出 PASS/FAIL
//--------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_self_checking;

    // 信号
    reg  [3:0] a, b;
    reg        cin;
    wire [3:0] sum;
    wire       cout;

    // DUT
    ripple_carry_adder_4bit u_dut (
        .a(a), .b(b), .cin(cin), .sum(sum), .cout(cout)
    );

    // 测试统计
    integer pass_count;
    integer fail_count;
    integer total_count;

    // 期望值
    wire [4:0] expected = {1'b0, a} + {1'b0, b} + {4'd0, cin};
    wire [3:0] exp_sum  = expected[3:0];
    wire       exp_cout = expected[4];

    // 主测试循环
    integer ia, ib, ic;
    initial begin
        pass_count  = 0;
        fail_count  = 0;
        total_count = 0;

        $display("Starting self-checking test...");
        $display("%-10s %-10s %-10s %-10s %-10s %-10s",
                 "a", "b", "cin", "sum(exp)", "sum(act)", "cout");

        // 穷举: 4+4+1 = 9 bit = 512 种组合
        for (ia = 0; ia < 16; ia = ia + 1) begin
            for (ib = 0; ib < 16; ib = ib + 1) begin
                for (ic = 0; ic < 2; ic = ic + 1) begin
                    a   = ia;
                    b   = ib;
                    cin = ic;
                    total_count = total_count + 1;
                    #10;  // 等待组合逻辑稳定

                    if (sum === exp_sum && cout === exp_cout) begin
                        pass_count = pass_count + 1;
                    end else begin
                        fail_count = fail_count + 1;
                        $display("FAIL: a=%d, b=%d, cin=%b => sum=%d(exp:%d), cout=%b(exp:%b)",
                                 a, b, cin, sum, exp_sum, cout, exp_cout);
                    end
                end
            end
        end

        // 结果汇总
        $display("\n=========================================");
        $display("  Total: %0d, Pass: %0d, Fail: %0d",
                 total_count, pass_count, fail_count);
        if (fail_count == 0)
            $display("  *** ALL TESTS PASSED ***");
        else
            $display("  *** %0d TESTS FAILED ***", fail_count);
        $display("=========================================");
        $finish;
    end

    // 波形
    initial begin
        $dumpfile("tb_self_check.vcd");
        $dumpvars(0, tb_self_checking);
    end

endmodule
