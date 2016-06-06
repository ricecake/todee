%%%-------------------------------------------------------------------
%% @doc todee_data public API
%% @end
%%%-------------------------------------------------------------------

-module(todee_data_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    todee_data_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
