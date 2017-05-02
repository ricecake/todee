%%%-------------------------------------------------------------------
%% @doc todee_web public API
%% @end
%%%-------------------------------------------------------------------

-module(todee_web_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
	case todee_web_sup:start_link() of
		{ok, Pid} ->
			ok = start_cowboy(),
			{ok, Pid}
	end.

%%--------------------------------------------------------------------
stop(_State) ->
	ok.

%%====================================================================
%% Internal functions
%%====================================================================

start_cowboy() ->
	{ok, Options} = determine_options(),
	Dispatch = cowboy_router:compile([
		{'_', [
			% Static File route
			{"/static/[...]", cowboy_static, {priv_dir, todee_web, "static/"}},
			{"/api/[...]",    todee_web_api_entry, []}
			% Dynamic Pages
		]}
	]),
	{ok, _} = cowboy:start_clear(todee_web, 25, Options, #{ env => #{ dispatch => Dispatch }}),
	ok.


determine_options() ->
	WithIp = case application:get_env(todee_web, ip) of
		undefined -> [];
		{ok, IpString} when is_list(IpString) ->
			{ok, Ip} = inet_parse:address(IpString),
			[{ip, Ip}];
		{ok, IpTuple} when is_tuple(IpTuple) -> [{ip, IpTuple}]
	end,
	Port = application:get_env(todee_web, port, 8080),
	{ok, maps:from_list([{port, Port} |WithIp])}.
