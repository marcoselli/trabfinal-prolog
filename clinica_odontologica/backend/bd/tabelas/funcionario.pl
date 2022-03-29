%-------------------------------------------------------------------
%Vitória Silva Cardoso
%11921BSI217
%--------------------------------------------------

:-module(
  funcionario, 
  [
    funcionario/3,
    insere_funcionario/3,
    remove_funcionario/1,
    atualiza_funcionario/3,
    sincroniza_funcionario/0
  ]).

:-use_module(library(persistency)).

:-use_module(chave, []).

:-persistent 
  funcionario(idfuncionario:positive_integer,
              nome:atom,
              cargo:atom
    ).

:- initialization( at_halt(db_sync(gc(always))) ).

insere_funcionario(IdFuncionario,Nome,Cargo):-
  chave:pk(funcionario, IdFuncionario),
  with_mutex(funcionario,
  assert_funcionario(IdFuncionario,Nome,Cargo)).

remove_funcionario(IdFuncionario):-
  with_mutex(funcionario,
  retract_funcionario(IdFuncionario,_Nome,_Cargo)).

atualiza_funcionario(IdFuncionario,Nome,Cargo):-
with_mutex(funcionario,
(retractall_funcionario(IdFuncionario,Nome,Cargo),
assert_funcionario(IdFuncionario,Nome,Cargo))).

%--------------------------------------------------


%-------------------------------------------------------------------