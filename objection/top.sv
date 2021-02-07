class comp;
    static int count = -1;

    task do_driver();
        repeat(20)
        #1;
        $display("do_driver exit time:%0t",$time);
    endtask

    task do_monitor();
        while(1)
        #1;
        $display("do_monitro exit time:%0t",$time);
    endtask

    static function void raise_objection();
        count++;
        $display("raise_objection time:%0t count:%0d",$time,count); 
    endfunction

    static function void drop_objection();
        count--;
        $display("drop_objection time:%0t count:%0d",$time,count);
    endfunction
endclass

module top;

    comp driver;
    comp monitor;
    process pro1;
    process pro2;

    initial begin 
        int count;
        driver  = new();
        monitor = new();

        fork
            begin : driver_main_phase
                pro1 = process::self();
                //#5;
                comp::raise_objection();
                driver.do_driver();
                comp::drop_objection();
            end
            begin : monitor_main_phase
                pro2 = process::self();                                 
                //comp::raise_objection();
                monitor.do_monitor();
                //comp::drop_objection();
            end
        join_none
        begin : process_control
            fork
                begin
                    wait(comp::count == -1) begin
                        pro1.kill();
                        pro2.kill();
                    end
                end
            join_any
            $display("time:%0t enter next phase ",$time);
        end
    end
endmodule
