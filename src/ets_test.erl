-module(ets_test).
-compile(export_all).
%
get_timestamp() ->
  {Mega, Sec, Micro} = os:timestamp(),
  (Mega * 1000000 + Sec) * 1000 + round(Micro / 1000).
%
msToDate(DateTimeSTamp) ->
  BaseDate = calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}}),
  Seconds = BaseDate + (DateTimeSTamp div 1000),
  {Date, Time} = calendar:gregorian_seconds_to_datetime(Seconds),
  Date, Time.
%
ets_start() ->
  ets:new(time_table, [public, named_table, ordered_set]).
%
ets_key_add(TblName) ->
  ets:insert(TblName, {get_current_date(), val}).

ets_key_get(TblName, Mode, Time) ->
  case Mode of
    all -> ets:select(TblName, [{{'$1', '$2'}, [], ['$$']}]);
    fresh -> ets:select(TblName, [{{'$1', '$2'}, [{'>=', '$1', get_current_date() - Time}], ['$$']}])
  end.

date_compare(D2) ->
  D1 = calendar:local_time(),
  {_Days, {_Hour, _Min, Sec}} = calendar:time_difference(D1, D2),
  60 - Sec.

date_to_sec(Date) ->
  calendar:datetime_to_gregorian_seconds(Date) - 62167219200.

get_current_date() ->
  Current = calendar:local_time(),
  Seconds = calendar:datetime_to_gregorian_seconds(Current) - 62167219200,
  Seconds.
%% 62167219200 == calendar:datetime_to_gregorian_seconds({{1970, 1, 1}, {0, 0, 0}})
%{Seconds div 1000000, Seconds rem 1000000, 0}.


