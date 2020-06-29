SELECT now(), timeuuidfield, dateOf(timeuuidfield),
 unixTimestampOf(timeuuidfield),
 minTimeuuid(dateOf(timeuuidfield)),
 maxTimeuuid(dateOf(timeuuidfield))
 FROM table01;
 