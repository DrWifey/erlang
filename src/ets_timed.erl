-module(ets_timed).
-compile(export_all).

%% Example of using:
%% ets_timed:ets_start().
%% ets_timed:ets_key_add(timed_table).
%% ets_timed:ets_key_get(timed_table).
%% ets_timed:ets_key_get(timed_table, 15).

ets_start() ->
  ets:new(time_table, [public, named_table, ordered_set]).
%
ets_key_add(TblName) ->
  ets:insert(TblName, {get_current_date(), val}).
%
ets_key_get(TblName) ->
  ets:select(TblName, [{{'$1', '$2'}, [], ['$$']}]). % returns all keys
%
ets_key_get(TblName, Time) ->
  ets:select(TblName, [{{'$1', '$2'}, [{'>=', '$1', get_current_date() - Time}], ['$$']}]). % return keys that are newer than specified Time in seconds
%
get_current_date() ->
  Current = calendar:local_time(),
  Seconds = calendar:datetime_to_gregorian_seconds(Current) - 62167219200,
  Seconds.




