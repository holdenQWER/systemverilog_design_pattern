package pkg;

class logger;
    local static logger log_h; 
    int file_h;
    
    local function new();
        file_h= $fopen ("log.txt","w"); 
    endfunction
    
    static function logger get_log_h(); 
        if (log_h== null) begin
            log_h= new();
            $display ("create log_h!");
        end
        return log_h; 
    endfunction

    function write (string str);
        $fdisplay (file_h, "write : %s",str); 
    endfunction
endclass

class userA; 
    logger log_h; 
    function new ();
        log_h = logger::get_log_h(); 
    endfunction
endclass

class userB; 
    logger log_h; 
    function new ();
        log_h= logger::get_log_h(); 
    endfunction
endclass

endpackage

module top;
    import pkg::*;

    userA a_h;
    userB b_h;

    initial begin
        a_h = new();
        b_h = new();
        fork
            a_h.log_h.write("AAA");
            b_h.log_h.write("BBB");
        join
        #1;
        $finish();
    end
endmodule
