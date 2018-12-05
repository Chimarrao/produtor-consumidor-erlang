-module(consumidor).
-mode(compile).
-author("Lucas Reolon").
-author("Vinicius Daniel").
-export([loop/3]).

loop(Mestre, Tempo, Id) -> 											
  receive
    {Mestre, vazio} -> 												
      Mestre ! {Id, c_espera},										
	  loop(Mestre, Tempo, Id); 										
    {Mestre, _} ->													
	  Mestre ! {Id, self(), remove},								
      random:seed(now()), 											
      timer:sleep(round(timer:seconds(random:uniform(Tempo))) + 3),
      loop(Mestre, Tempo, Id)
  end.