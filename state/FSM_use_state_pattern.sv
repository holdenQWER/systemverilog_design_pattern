package PKG;
import uvm_pkg::*;
`include "uvm_macros.svh"

`define INTERVALTIME #1ns

`define REGISTER_STATE(state,name) \
begin \
   state_``name fsm_``name; \
   fsm_``name = new(); \
   state_pool[STATE_``state] = fsm_``name; \
   fsm_``name.FSM = this; \
end

typedef enum {
   STATE_IDLE,STATE_A,STATE_B,STATE_C
} state_t;

typedef state_machine;

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
         fsm_inst.run();
      join_none
   endtask
endclass

virtual class state;

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
   pure virtual task do_something();
   pure virtual task request_state_change();
endclass

class state_idle extends state;

   task do_something();
      $display("STATE_IDLE : nothing to do!\n");
   endtask

   task request_state_change();
      state_t cur_state;
      fork: disable_fork
         begin
            to_state_a.wait_trigger();
            //$display("do something!\n");
            cur_state = STATE_A;
         end
      join_any
      FSM.set_state(cur_state);
   endtask
endclass

class state_a extends state;

   task do_something();
      $display("STATE_A : do something!\n");
   endtask

   task request_state_change();
      state_t cur_state;
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
      FSM.set_state(cur_state);
   endtask
endclass

class state_b extends state;

   task do_something();
      $display("STATE_B : do something!\n");
   endtask

   task request_state_change();
      state_t cur_state;
      fork: disable_fork
         begin
            to_state_c.wait_trigger();
            //$display("do something!\n");
            cur_state = STATE_C;
         end
         begin
            to_idle.wait_trigger();
            //$display("do something!\n");
            cur_state = STATE_IDLE;
         end
      join_any
      disable fork;
      FSM.set_state(cur_state);
   endtask
endclass

class state_c extends state;

   task do_something();
      $display("STATE_C : do something!\n");
   endtask

   task request_state_change();
      state_t cur_state;
      fork: disable_fork
         begin
            to_state_b.wait_trigger();
            //$display("do something!\n");
            cur_state = STATE_B;
         end
         begin
            to_idle.wait_trigger();
            //$display("do something!\n");
            cur_state = STATE_IDLE;
         end
      join_any
      disable fork;
      FSM.set_state(cur_state);
   endtask
endclass

class state_machine;

   local state state_m;
   state state_pool[state_t];

   function void set_state(state_t state);
      $display("Enter %s state!",state.name());
      state_m = state_pool[state];
   endfunction


   function void fsm_init();
      `REGISTER_STATE(IDLE,idle)
      `REGISTER_STATE(A,a)
      `REGISTER_STATE(B,b)
      `REGISTER_STATE(C,c)
      this.set_state(STATE_IDLE);
   endfunction

   task run();
      fsm_init();
      forever begin
         state_m.do_something();
         state_m.request_state_change();
      end
   endtask
endclass


endpackage : PKG

module top;

   import PKG::*;

   initial begin
      client client_inst;
      client_inst = new();
      client_inst.run_fsm();
   end
endmodule : top
