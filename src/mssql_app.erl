%%%-------------------------------------------------------------------
%% @doc mssql public API
%% @end
%%%-------------------------------------------------------------------

-module(mssql_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    mssql_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
