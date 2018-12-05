-module(main). 															
-mode(compile).
-author("Lucas ReoloN").
-author("Vinicius DaNiel").

-export([start/0]).												

add_Fila([], Valor) -> 										
  {estava_vazio, [Valor]};

add_Fila(Fila, Valor) when length(Fila) < 5 ->     
  {ok, Fila ++ [Valor]};

add_Fila(Fila, _) -> 									
  {cheio, Fila}.

remov_Fila(Fila, Id) when length(Fila) =:= 5 ->
  io:format("Cosumidor ~p consumindo...~n~n", [Id]),
  [_|T] = Fila, 
  {T};

remov_Fila(Fila, Id) when length(Fila) > 0 ->
  io:format("Cosumidor ~p consumindo...~n~n", [Id]),
  [_|T] = Fila, 
  {T};

remov_Fila(Fila, Id) ->
  io:format("Cosumidor ~p nao consegue consumir a fila esta vazia !~n~n", [Id]),
  {Fila}. 

main_loop(Fila) ->                   						
  receive    
    {Id, Produtor, adiciona, Valor} ->										
	  io:format("Produtor ~p produziu: ~p~n~n", [Id, Valor]),
      
      {Status, NovoFila} = add_Fila(Fila, Valor),
	  if
        Status =:= cheio ->
          io:format("Fila cheia, descartando producao!~n~n");
        true ->
          ok
      end,
      io:format("Fila atual: "),
      io:write(NovoFila),
      io:format("~n~n"),
      
      Produtor ! {self(), Status},										
     
	  main_loop(NovoFila);
    
    {Id, p_espera} ->												
	  io:format("Produtor ~p esperando...~n~n", [Id]),
	  main_loop(Fila);

    {Id, Consumidor, remove} ->
      {NovoFila} = remov_Fila(Fila, Id),	
	  
      io:format("Fila atual: "),
      io:write(NovoFila),
      io:format("~n~n"),
	  
	  Consumidor ! {self(), acorda},
      main_loop(NovoFila);
    
    {Id, c_espera} ->												
	  io:format("Consumidor ~p esperando...~n~n", [Id]),
      main_loop(Fila)
  end.

cria_prod(Id, N, Fila) ->
  if Id =< N ->
		P = spawn(produtor, loop, [self(), 3, Id]),
		P ! {self(), acorda},
		cria_prod(Id + 1, N, Fila);
	true ->
		io:format("Produtores criados ~n",[])
  end.

cria_con(Id, N, Fila) ->
  if Id =< N ->
		C = spawn(consumidor, loop, [self(), 3, Id]),
	 	C ! {self(), tempo},
		cria_con(Id + 1, N, Fila);
	true ->
		io:format("Consumidores criados ~n~n",[])
  end.

start() ->
  io:format("Algoritmo Produtor/Consumidor~n"),
  io:format("Criando produtores e consumidores..~n~n"),
  
  FilaInicial = [],
  
  cria_prod(1, 5, FilaInicial),
  cria_con(1, 3, FilaInicial),
  
  io:format("Fila esperaNdo...~n~n"),
  																		
  main_loop(FilaInicial).