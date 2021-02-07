
virtual class Observer;
    protected string m_name;
    pure virtual function void update(string message);
    pure virtual function string getname();
endclass

class Investor extends Observer;
    function new(string name);
        m_name = name;
    endfunction

    virtual function void update(string message);
        $display ("%4s receive message: \"%s\" ", m_name, message);
    endfunction

    virtual function string getname();
        return m_name;
    endfunction
endclass

virtual class Subject;
    pure virtual function void addObserver(Observer observer);
    pure virtual function void deleteObserver(Observer observer);
    pure virtual function void notifyObserver(string message);
    pure virtual function void change(int price);
endclass

class Stock extends Subject;

    protected Observer m_observer_hash[string];

    virtual function void change(int price);
        if (price > 20)
            notifyObserver("The stock price > 20 Yuan !");
        else if (price < 10)
            notifyObserver("The stock price < 10 Yuan !");
    endfunction

    virtual function void addObserver(Observer observer);
        m_observer_hash[observer.getname()] = observer;
    endfunction

    virtual function void deleteObserver(Observer observer);
        m_observer_hash.delete(observer.getname());
    endfunction

    virtual function void notifyObserver(string message);
        foreach(m_observer_hash[i])
        m_observer_hash[i].update(message);
    endfunction
endclass

module test;
    initial begin
        Investor investor1 = new("Jack");
        Investor investor2 = new("Tom");

        Stock stock = new();

        stock.addObserver(investor1);
        stock.addObserver(investor2);

        stock.change(21);
        stock.change(9) ;
    end
endmodule
