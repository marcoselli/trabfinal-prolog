
%-------------------------------------------------------------------
%Vitória Silva Cardoso
%11921BSI217
%--------------------------------------------------

:-module(
  agenda, 
  [
    agenda/8,
    insere_agenda/8,
    remove_agenda/1,
    atualiza_agenda/8,
    sincroniza_agenda/0
  ]).

:-use_module(library(persistency)).
:-use_module(funcionario).
/*:-use_module(paciente).*/

:-use_module(chave, []).

:-persistent 
  agenda(idAgenda:positive_integer,
          id:positive_integer,
          idfuncionario:positive_integer,
          horas:nonneg,
          minutos:nonneg,
          dia:nonneg,
          mes:nonneg,
          ano:nonneg
  ).

:- initialization( at_halt(db_sync(gc(always))) ).

carrega_tab(ArqTabela):-
    db_attach(ArqTabela, []).

insere_agenda(IdAgenda,IdPaciente,IdFuncionario,Horas,Minutos,Dia,Mes,Ano):-
  chave:pk(agenda, IdAgenda),
  with_mutex(agenda,(
    \+agenda(IdAgenda,_IdPaciente,IdFuncionario,_Horas,_Minutos,_Dia,_Mes,_Ano),
    paciente(IdPaciente, Nome, _DataNascimento, _Genero,
                      _EstadoCivil, _Profissao, _IdEndereco, _Telefone,
                      _LocalTrabalho, _TelefoneTrabalho, _TipoBeneficiario,
                      _NumeroBeneficiario, _RecomendadoPor, _Data,
                      _IdFuncionario),
    funcionario(IdFuncionario,Nome,_Cargo),
  assert_agenda(IdAgenda,IdPaciente,IdFuncionario,Horas,Minutos,Dia,Mes,Ano))).

remove_agenda(IdAgenda):-
  with_mutex(agenda,
  retract_agenda(IdAgenda,_IdPaciente,_IdFuncionario,_Horas,_Minutos,_Dia,_Mes,_Ano)).

atualiza_agenda(IdAgenda,IdPaciente,IdFuncionario,Horas,Minutos,Dia,Mes,Ano):-
with_mutex(agenda,(remove_agenda(Id),
insere_agenda(IdAgenda,IdPaciente,IdFuncionario,Horas,Minutos,Dia,Mes,Ano))).


%--------------------------------------------------


%-------------------------------------------------------------------