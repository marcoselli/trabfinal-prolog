/* http_parameters   */
:- use_module(library(http/http_parameters)).
/* http_reply        */
:- use_module(library(http/http_header)).
/* reply_json_dict   */
:- use_module(library(http/http_json)).


:- use_module(bd(funcionario), []).

/*
   GET api/v1/funcionarios/
   Retorna uma lista com todos os funcionarios.
*/
funcionarios(get, '', _Pedido):- !,
    envia_tabela.

/*
   GET api/v1/funcionarios/Id
   Retorna o `bookmark` com Id 1 ou erro 404 caso o `bookmark` não
   seja encontrado.
*/
funcionarios(get, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    envia_tupla(Id).

/*
   POST api/v1/funcionarios
   Adiciona um novo bookmark. Os dados deverão ser passados no corpo da
   requisição no formato JSON.

   Um erro 400 (BAD REQUEST) deve ser retornado caso a URL não tenha sido
   informada.
*/
funcionarios(post, _, Pedido):-
    http_read_json_dict(Pedido, Dados),
    !,
    insere_tupla(Dados).

/*
  PUT api/v1/funcionarios/Id
  Atualiza o bookmark com o Id informado.
  Os dados são passados no corpo do pedido no formato JSON.
*/
funcionarios(put, AtomId, Pedido):-
    atom_number(AtomId, Id),
    http_read_json_dict(Pedido, Dados),
    !,
    atualiza_tupla(Dados, Id).

/*
   DELETE api/v1/funcionarios/Id
   Apaga o bookmark com o Id informado
*/
funcionarios(delete, AtomId, _Pedido):-
    atom_number(AtomId, Id),
    !,
    bookmark:remove(Id),
    throw(http_reply(no_content)).

/* Se algo ocorrer de errado, a resposta de método não
   permitido será retornada.
 */

funcionarios(IdFuncionario,Nome,Cargo) :-
    throw(http_reply(method_not_allowed(IdFuncionario,Nome,Cargo))).


insere_tupla(IdFuncionario,Nome,Cargo):-
    % Validar URL antes de inserir
    funcionario:insere_funcionario(IdFuncionario,Nome,Cargo)
    -> envia_tupla(Id)
    ;  throw(http_reply(bad_request('URL ausente'))).

atualiza_tupla(IdFuncionario,Nome,Cargo):-
       funcionario:atualiza_funcionario(IdFuncionario,Nome,Cargo)
    -> envia_tupla(Id)
    ;  throw(http_reply(not_found(IdFuncionario))).


envia_tupla(Id):-
       bookmark:bookmark(IdFuncionario,Nome,Cargo)
    -> reply_json_dict(_{IdFuncionario,Nome,Cargo})
    ;  throw(http_reply(not_found(IdFuncionario))).


envia_tabela :-
    findall( _{IdFuncionario,Nome,Cargo},
             funcionario:funcionario(IdFuncionario,Nome,Cargo),
             Tuplas ),
    reply_json_dict(Tuplas).
