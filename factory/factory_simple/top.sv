virtual class Object;
endclass

class A extends Object; 
    function void display();
        $display("This is class A!"); 
    endfunction
endclass

class B extends Object; 
    function void display();
        $display("This is class B !"); 
    endfunction
endclass

class Factory;

    static function Object create(string name);
        A a_h;
        B b_h;

        case (name) 
            "A" : begin a_h= new(); 
                  return a_h;
                  end
            "B" : begin b_h = new(); 
                  return b_h; 
                  end
        default:  $display ("No such type class "); 
        endcase
    endfunction 
endclass

module top;
    initial begin
        A a_h;
        B b_h;
        $cast(a_h,Factory::create("A"));
        $cast(b_h,Factory::create("B")); 
        a_h.display();
        b_h.display();
        $cast(b_h,Factory::create("C")); 
    end
endmodule


