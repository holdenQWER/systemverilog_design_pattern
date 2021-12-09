package PKG;
import uvm_pkg::*;
`include "uvm_macros.svh"

typedef class state_machine;
`define INTERVALTIME #1ns
class client;

   state_machine FSM;
   uvm_event_pool events_pool;
   uvm_event to_idle,to_state_a,to_state_b,to_state_c;

   function new();
      events_pool = uvm_event_pool::get_global_pool();
      to_idle = events_pool.get("to_idle");
      to_state_a = events_pool.get("to_state_a");
      to_state_b = events_pool.get("to_state_b");
      to_state_c = events_pool.get("to_state_c");
   endfunction

   task rand_simulate(); 
      for (int i=0;i<2;i++) begin
      bit FLAG = 0;
      randsequence (stream)

         stream : first second third last;
         first  : state_a;
         second : state_b {FLAG = 1;} | state_c;
         third  : if (FLAG ==1) state_c else state_b;
         last   : state_idle;

         state_idle: {`INTERVALTIME;to_idle.trigger();};
         state_a   : {`INTERVALTIME;to_state_a.trigger();};
         state_b   : {`INTERVALTIME;to_state_b.trigger();};
         state_c   : {`INTERVALTIME;to_state_c.trigger();};

      endsequence
      end
   endtask

   task run_fsm();
      state_machine fsm_inst;
      fsm_inst = new();
      fork
         rand_simulate();
         fsm_inst.start();
      join_none
   endtask
endclass

class state_machine;

   typedef enum {
      IDLE,STATE_A,STATE_B,STATE_C
   } state_t;

   uvm_event_pool events_pool;
   uvm_event to_idle,to_state_a,to_state_b,to_state_c;

   local state_t cur_state;

   extern function new();
   extern function void start();
   extern function void request_state_change(state_t cur_state);
   extern task do_idle();
   extern task do_state_a();
   extern task do_state_b();
   extern task do_state_c();

endclass

function state_machine::new();
      events_pool = uvm_event_pool::get_global_pool();
      to_idle = events_pool.get("to_idle");
      to_state_a = events_pool.get("to_state_a");
      to_state_b = events_pool.get("to_state_b");
      to_state_c = events_pool.get("to_state_c");
endfunction

function void state_machine::start();
   cur_state = IDLE;
   request_state_change(cur_state);
endfunction

function void state_machine::request_state_change(state_t cur_state);
   case(cur_state)
      IDLE:begin
         fork
            begin
               $display("Enter %s state!",cur_state.name());
               do_idle();
            end
         join_none
         return;
      end
      STATE_A:begin
         fork
            begin
               $display("Enter %s state!",cur_state.name());
               do_state_a();
            end
         join_none
         return;
      end
      STATE_B:begin
         fork
            begin
               $display("Enter %s state!",cur_state.name());
               do_state_b();
            end
         join_none
         return;
      end
      STATE_C:begin
         fork
            begin
               $display("Enter %s state!",cur_state.name());
               do_state_c();
            end
         join_none
         return;
      end
      default : begin
            $display("Enter unknow state!");
            $finish;
      end
   endcase
endfunction

task state_machine::do_idle();
   state_t cur_state;
   $display("IDLE : nothing to do!\n");
   fork: disable_fork
      begin
         to_state_a.wait_trigger();
         //$display("do something!\n");
         cur_state = STATE_A;
      end
   join_any
   request_state_change(cur_state);
endtask

task state_machine::do_state_a();
   state_t cur_state;
   $display("STATE_A : do something!\n");
   fork: disable_fork
      begin
         to_state_b.wait_trigger();
         //$display("do something!\n");
         cur_state = STATE_B;
      end
      begin
         to_state_c.wait_trigger();
         //$display("do something!\n");
         cur_state = STATE_C;
      end
   join_any
   disable fork;
   request_state_change(cur_state);
endtask

task state_machine::do_state_b();
   state_t cur_state;
   $display("STATE_B : do something!\n");
   fork: disable_fork
      begin
         to_state_c.wait_trigger();
         //$display("do something!\n");
         cur_state = STATE_C;
      end
      begin
         to_idle.wait_trigger();
         //$display("do something!\n");
         cur_state = IDLE;
      end
   join_any
   disable fork;
   request_state_change(cur_state);
endtask

task state_machine::do_state_c();
   state_t cur_state;
   $display("STATE_C : do something!\n");
   fork: disable_fork
      begin
         to_state_b.wait_trigger();
         //$display("do something!\n");
         cur_state = STATE_B;
      end
      begin
         to_idle.wait_trigger();
         //$display("do something!\n");
         cur_state = IDLE;
      end
   join_any
   disable fork;
   request_state_change(cur_state);
endtask

endpackage : PKG

module top;

   import PKG::*;
   
   initial begin
      client client_inst;
      client_inst = new();
      client_inst.run_fsm();
   end
endmodule : top
