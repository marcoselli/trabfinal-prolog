/* html//1, reply_html_page  */
:- use_module(library(http/html_write)).
/* html_requires  */
:- use_module(library(http/html_head)).

:- ensure_loaded(gabarito(boot5rest)).


/* Página de cadastro de bookmark */
cadastro(_Pedido):-
    reply_html_page(
        boot5rest,
        [ title('Tbl Funcionario')],
        [ div(class(container),
              [ \html_requires(js('funcionario.js')),
                h1('CADASTRO FUNCIONARIO'),
                \form_funcionario
              ]) ]).

form_funcionario -->
    html(form([ id('funcionario-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/funcionario/') ],
              [ \metodo_de_envio('POST'),
                \campo(titulo, 'Titulo', text),
                \campo(url, 'URL', url),
                \enviar_ou_cancelar('/')
              ])).


enviar_ou_cancelar(RotaDeRetorno) -->
    html(div([ class('btn-group'), role(group), 'aria-label'('Enviar ou cancelar')],
             [ button([ type(submit),
                        class('btn btn-outline-primary')], 'Enviar'),
               a([ href(RotaDeRetorno),
                   class('ms-3 btn btn-outline-danger')], 'Cancelar')
            ])).



campo(Nome, Rotulo, Tipo) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label') ], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome)])
             ] )).



/* Página para edição (alteração) de um bookmark  */

editar(AtomId, _Pedido):-
    atom_number(AtomId, Id),
    ( funcionario:funcionario(Id, Titulo, URL)
    ->
    reply_html_page(
        boot5rest,
        [ title('funcionario')],
        [ div(class(container),
              [ \html_requires(js('funcionario.js')),
                h1('Relação de funcionarios'),
                \form_funcionario(Id, Titulo, URL)
              ]) ])
    ; throw(http_reply(not_found(Id)))
    ).


form_funcionario(Id, Titulo, URL) -->
    html(form([ id('funcionario-form'),
                onsubmit("redirecionaResposta( event, '/' )"),
                action('/api/v1/funcionario/~w' - Id) ],
              [ \metodo_de_envio('PUT'),
                \campo_nao_editavel(id, 'Id', text, Id),
                \campo(titulo, 'Titulo', text, Titulo),
                \campo(url,    'URL',    url,  URL),
                \enviar_ou_cancelar('/')
              ])).


campo(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome), name(Nome), value(Valor)])
             ] )).

campo_nao_editavel(Nome, Rotulo, Tipo, Valor) -->
    html(div(class('mb-3 w-25'),
             [ label([ for(Nome), class('form-label')], Rotulo),
               input([ type(Tipo), class('form-control'),
                       id(Nome),
                       % name(Nome),%  não é para enviar o id
                       value(Valor),
                       readonly ])
             ] )).

metodo_de_envio(Metodo) -->
    html(input([type(hidden), name('_método'), value(Metodo)])).