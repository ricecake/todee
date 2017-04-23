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
			Dispatch = cowboy_router:compile([
				{'_', [
					% Static File route
					{"/static/[...]", cowboy_static, {priv_dir, todee_web, "static/"}},
                                        {"/api/[...]",    todee_web_api_entry, []}
					% Dynamic Pages
				]}
			]),
			{ok, _} = cowboy:start_clear(todee_web, 25, #{ip => {127,0,0,1}, port => 8989},
							[{env, [{dispatch, Dispatch}]}]),
			{ok, Pid}
	end.

%%--------------------------------------------------------------------
stop(_State) ->
	ok.

%%====================================================================
%% Internal functions
%%====================================================================
