%%%-------------------------------------------------------------------
%%% @author dmitriy
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Dec 2019 3:52 PM
%%%-------------------------------------------------------------------
-module(mssql_SUITE).
-author("dmitriy").

%% API
-compile(export_all).
-compile(nowarn_export_all).

-include_lib("common_test/include/ct.hrl").

all() ->
  [test].

init_per_suite(Config) ->
  ok = application:start(odbc),
  ok = application:start(poolboy),
  ok = application:start(mssql),
  Config.

end_per_suite(Config) ->
  ok = application:stop(odbc),
  ok = application:stop(poolboy),
  ok = application:stop(mssql),
  Config.

init_per_testcase(_, Config) ->
  Config.

end_per_testcase(_, Config) ->
  Config.

test(Config) ->
  ok = select_1(1000),
  ok = select_2(1000),
  Config.

select_1(0) ->
  ok;
select_1(N) ->
  {selected, [[]], [{1}]} = mssql:sql_query(test_pool, "SELECT 1"),
  select_1(N-1).

select_2(0) ->
  ok;
select_2(N) ->
  {selected, [[]], [{1}]} = mssql:sql_query(test_pool, "SELECT 1", 100),
  select_2(N-1).