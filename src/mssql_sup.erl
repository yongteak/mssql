%%%-------------------------------------------------------------------
%% @doc mssql top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(mssql_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
  {ok, Pools} = application:get_env(pools),
  PoolSpecs = lists:map(fun({Name, SizeArgs, WorkerArgs}) ->
    PoolArgs = [{name, {local, Name}},
      {worker_module, mssql}] ++ SizeArgs,
    poolboy:child_spec(Name, PoolArgs, WorkerArgs)
                        end, Pools),
  {ok, {{one_for_one, 10, 10}, PoolSpecs}}.

%% internal functions
