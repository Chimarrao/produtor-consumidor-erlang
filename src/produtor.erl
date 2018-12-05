-module(produtor).
-mode(compile).
-author("Lucas Reolon").
-author("Vinicius Daniel").
-export([loop/3]).

produzir() ->												
	List =[feijao,arroz,carne,queijo,leite,pao,mortadela],
	Index = rand:uniform(length(List)),
	lists:nth(Index,List).

loop(Mestre, Tempo, Id) -> 											
  receive
    {Mestre, cheio} -> 											
      Mestre ! {Id, p_espera}, 								
      loop(Mestre, Tempo, Id); 										
    {Mestre, _} -> 												
      random:seed(now()),
      timer:sleep(round(timer:seconds(random:uniform(Tempo))) + 3 ), 
      Valor = produzir(), 										
      Mestre ! {Id, self(), adiciona, Valor}, 						
      loop(Mestre, Tempo, Id)
  end.