-module(todee_web_entry).

-export([init/2]).

init(Request, Args)->{ok, cowboy_req:reply(200 [], Request), Args}.
