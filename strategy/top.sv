interface class add_oil_behavior_interface;
    pure virtual function void add_oil();
endclass : add_oil_behavior_interface

class add_diesel implements add_oil_behavior_interface;
    virtual function void add_oil();
        $display("Please add diesel !\n");
    endfunction
endclass

class add_gasoline implements add_oil_behavior_interface;
    virtual function void add_oil();
        $display("Please add gasoline !\n");
    endfunction
endclass

virtual class car;
    protected add_oil_behavior_interface add_oil_behavior;
    function void request_add_oil();
        this.add_oil_behavior.add_oil();
    endfunction
    function void set_oil_type(add_oil_behavior_interface add_oil_behavior);
        this.add_oil_behavior = add_oil_behavior;
    endfunction
endclass

class sedan extends car;
    protected add_gasoline add_gasoline_h;
    function new();
        $display("This is sedan car!");
        add_gasoline_h = new();
        set_oil_type(add_gasoline_h);
    endfunction
endclass

class truck extends car;
    protected add_diesel add_diesel_h;
    function new();
        $display("This is truck car!");
        add_diesel_h = new();
        set_oil_type(add_diesel_h);
    endfunction 
endclass

module top;
    truck truck_h;
    sedan sedan_h;

    add_diesel   add_diesel_h;
    add_gasoline add_gasoline_h;

    initial begin

        add_gasoline_h = new();

        sedan_h = new();
        sedan_h.request_add_oil();

        truck_h = new();
        truck_h.request_add_oil();

        // add gasoline
        truck_h.set_oil_type(add_gasoline_h);
        truck_h.request_add_oil();

        // add diesel
        // truck_h.set_oil_type(truck_h.add_diesel_h);  // protected 
        //truck_h.request_add_oil();
    end
endmodule : top
