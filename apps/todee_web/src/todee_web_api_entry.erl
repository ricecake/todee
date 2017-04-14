-module(todee_web_api_entry).

-export([
	init/2,
	content_types_provided/2,
	is_authorized/2,
	allowed_methods/2,
	content_types_accepted/2,
	resource_exists/2
]).

-export([
	list_entry_json/2,
	create_entry_json/2,
	list_entry_html/2,
	create_entry_form/2
]).


init(Req, Opts) -> {cowboy_rest, Req, Opts}.

is_authorized(Req, State) ->
	case cowboy_req:parse_header(<<"authorization">>, Req) of
		{basic, User, Pass} ->
			ValidUsers = application:get_env(todee_web, users, #{}),
			case maps:find(User, ValidUsers) of
				{ok, Pass} -> {true, Req, State#{ user => User }};
				_ -> {{false, <<"Basic realm=\"Todee\"">>}, Req, State}
			end;
		_ ->
			{{false, <<"Basic realm=\"Todee\"">>}, Req, State}
	end.

allowed_methods(Req, State) ->
	Methods = [<<"GET">>, <<"POST">>],
	{Methods, Req, State}.

content_types_provided(Req, State) ->
	Providers = [
		{<<"application/json">>, list_entry_json},
		{<<"text/html">>, list_entry_html}
	],
	{Providers, Req, State}.

content_types_accepted(Req, State) ->
	Types = [
		{{<<"application">>, <<"json">>, []}, create_entry_json},
		{{<<"application">>, <<"x-www-form-urlencoded">>, []}, create_entry_form}
	],
	{Types,	Req, State}.

resource_exists(Req, _State) ->
	case cowboy_req:binding(route, Req) of
		undefined ->
			{true, Req, index};
		Route ->{true, Req, Route}
	end.

list_entry_json(Req, index) ->
	Details = jsx:encode(#{}),
	{Details, Req, index};
list_entry_json(Req, Domain) ->
	Result = jsx:encode(#{}),
	{Result, Req, Domain}.

list_entry_html(Req, Domain) ->
	TemplateArgs = #{},
	{ok, Page} = todee_entry_dtl:render(TemplateArgs),
	{Page, Req, Domain}.

create_entry_json(Req, State) ->
	HasBody = cowboy_req:has_body(Req),
	if
		not HasBody -> {false, Req, State};
		HasBody ->
			{true, Req, State}
	end.

create_entry_form(Req, State) ->
	{ok, Input, Req2} = cowboy_req:read_urlencoded_body(Req),
	_Args = maps:from_list([ format_param(Param) || Param <- Input]),
	{true, Req2, State}.


format_param({Key, Value}) -> {binary_to_existing_atom(Key, utf8), Value}.
