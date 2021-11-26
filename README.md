# readme

Программа считывает топологию подготовленной системы мономеров (box.top) и координаты атомоы (test.gro).
В функции bonding(cbox, "mOal", "uOe","uCu", "uCu", 0.2, "results") задается название групп по которым проиходит химическое связывание ("mOal" и "uCu") в случае если данный атом меняет тип топлогии указывается новое название атома ("uOe" и "uCu") 0.2 - [нм] растояние меньше которого происходит связывание.

Результаты сшитого полимера записываются в файлы "outbox.top" и "outtest.gro"



The program reads the topology of the monomer system (box.top) and the coordinates of the atom (test.gro).
The function bonding(cbox, "mOal", "uOe", "uCu", "uCu", 0.2, "results") sets the name of the groups for which chemical bonding takes place ("mOal" and "uCu") if this atom changes the type of topology the new name of the atom is indicated ("uOe" and "uCu"), 0.2 - [nm] distance less than which binding occurs. 

Crosslinked polymer results are written to files "outbox.top" and "outtest.gro" 


This work was supported by the Russian Science Foundation (grant no. 19-19-00136)
