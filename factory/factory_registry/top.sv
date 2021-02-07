virtual class Object; 
endclass 

virtual class ObjectProxy;
    pure virtual function Object createObj();
endclass


ObjectProxy factory[ObjectProxy];

class objectRegistry #(type T) extends ObjectProxy;

    virtual function Object createObj();
        T obj;
        obj = new();
        return obj;
    endfunction

    local static objectRegistry#(T) me = get();

    static function objectRegistry#(T) get();
        if (me == null) begin
            me = new();
            factory[me] = me;
        end
        return me;
    endfunction : get

    static function T create();
        T obj_h;
        $cast(obj_h, factory[get()].createObj());
        //me.createObj();
        return obj_h;
    endfunction : create
endclass

class A extends Object;
    typedef objectRegistry#(A) typeId;
    virtual function void display();
        $display("This is class A !");
    endfunction
endclass

class B extends Object;
    typedef objectRegistry#(B) typeId;
    virtual function void display();
        $display("This is class B !");
    endfunction
endclass

class C extends A;
    typedef objectRegistry#(C) typeId;
    function void display();
        $display("This is class C !");
    endfunction
endclass 

module test;

initial begin
    A a_h;
    B b_h;
    a_h = A::typeId::create();
    a_h.display();
    b_h = B::typeId::create();
    b_h.display();
    factory[A::typeId::get()] = C::typeId::get();
    a_h = A::typeId::create();
    a_h.display();
end
endmodule

