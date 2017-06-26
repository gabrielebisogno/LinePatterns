append([], L, L).

append([E|Es], L, [E|Rs]):-
  append(Es, L, Rs).
  
