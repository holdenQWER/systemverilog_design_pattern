typedef class Soldier;
interface class Command;
    pure virtual function void execute();
endclass

class FireCommand implements Command;
    Soldier m_soldier;
    function new(Soldier soldier);
        m_soldier = soldier;
    endfunction
    virtual function void execute();
        m_soldier.fire();
    endfunction
endclass

class GoCommand implements Command;
    Soldier m_soldier;
    function new(Soldier soldier);
        m_soldier = soldier;
    endfunction
    virtual function void execute();
        m_soldier.go();
    endfunction
endclass

class Captain;
    Command m_cmd;
    function void setCommand(Command cmd);
        m_cmd = cmd;
    endfunction
    function void invoke();
        m_cmd.execute();
    endfunction
endclass

class Soldier;
    function void fire();
        $display("Soldier: execute command, Start Fire! ");
    endfunction
    function void go();
        $display("Soldier: execute command, GO! Go! Go! ");
    endfunction
endclass

module test;
    initial begin
        Soldier soldier = new();
        Captain captain = new();

        FireCommand firecommand = new(soldier);
        GoCommand gocommand = new(soldier);

        captain.setCommand(gocommand);
        captain.invoke();

        captain.setCommand(firecommand);
        captain.invoke();
    end
endmodule
