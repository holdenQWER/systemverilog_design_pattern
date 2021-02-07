package pkg;

    typedef Element;

    interface class Visitor;
        pure virtual function void visit(Element element); 
    endclass

    interface class Element;
        pure virtual function void accept(Visitor visitor);
        pure virtual function string getrole();
    endclass

    class Teacher implements Element;

        static const string role = "teacher";
        local string name;
        local int score;
        local int papercount;

        function new (string name,int score,int papercount);
            this.name = name;
            this.score = score;
            this.papercount = papercount;
        endfunction

        virtual function void accept (Visitor visitor);
            visitor.visit(this);
        endfunction

        virtual function string getrole();
            return this.role;
        endfunction

        virtual function int getname();
            return this.name;
        endfunction

        virtual function int getscore();
            return this.score;
        endfunction

        virtual function int getpapercount();
            return this.papercount;
        endfunction 
endclass

class Student implements Element;

    static const local string role = "student";
    local string name;
    local int score;
    local int papercount;

    function new (string name,int score,int papercount);
        this.name = name;
        this.score = score;
        this.papercount = papercount;
    endfunction

    virtual function void accept (Visitor visitor);
        visitor.visit(this);
    endfunction

    virtual function string getrole();
        return this.role;
    endfunction
    
    virtual function int getname();
        return this.name;
    endfunction

    virtual function int getscore();
        return this.score;
    endfunction

    virtual function int getpapercount();
        return this.papercount;
    endfunction
endclass

class GradeSelection implements Visitor;
    virtual function void visit(Element element);
    case (element.getrole())
        "teacher" : begin
                        Teacher teacher;
                        $cast(teacher,element);
                        if(teacher.getscore() > 85)
                        $display("Teacher:%0s score:%0d, acquire Award!\n",teacher.getname(),teacher.getscore());
                    end
        "student" : begin
                        Student student;
                        $cast(student,element);
                        if (student.getscore() > 90)
                        $display("Student:%0s score:%0d, acquire Award!\n",student.getname(),student.getscore());
                    end
            default : $display("No such role!");
        endcase 
    endfunction 
endclass

class ResearcherSelection implements Visitor;

    virtual function void visit(Element element);
        case (element.getrole())
            "teacher" : begin
                            Teacher teacher;
                            $cast(teacher,element);
                            if (teacher.getpapercount() >= 2)
                            $display("Teacher:%0s papercount:%0d, acquire 1W YUAN!\n",teacher.getname(),teacher.getpapercount());
                        end
            "student" : begin
                            Student student;
                            $cast(student,element);
                            if (student. getpapercount() >= 1)
                            $display("Student:%0s papercount:%0d, acquire 1W YUAN!\n",student.getname(),student.getpapercount());
                        end
            default : $display("No such role!");
        endcase 
    endfunction 
endclass

class Objectstructure;

    Element element_q[$];

    virtual function void accept(Visitor visitor);
        foreach(element_q[i]) begin
            Element element = element_q[i];
            element.accept(visitor);
        end 
    endfunction 

    virtual function void addElement(Element element);
        element_q.push_back(element);
    endfunction 
endclass 

endpackage : pkg

module Visitorclient;

    import pkg::*;

    initial begin
        Student student1 = new(.name("Jim"),.score(92),.papercount(0));
        Student student2 = new(.name("Ana"),.score(88),.papercount(2));
        Teacher teacher1 = new(.name("May"),.score(86),.papercount(1));
        Teacher teacher2 = new(.name("Lee"),.score(75),.papercount(3));

        GradeSelection gradeselection = new();
        ResearcherSelection researcherselection= new();

        Objectstructure structure = new();
        structure.addElement(student1);
        structure.addElement(student2);
        structure.addElement(teacher1);
        structure.addElement(teacher2);

        structure.accept(researcherselection);
        structure.accept(gradeselection);
    end
endmodule

