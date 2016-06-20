REBAR := `pwd`/rebar3

all: test release

compile:
	@$(REBAR) compile

doc:
	@$(REBAR) edoc

test:
	@$(REBAR) do xref, dialyzer, eunit #, ct, cover

release:
	@$(REBAR) release

tar:
	@$(REBAR) as prod tar

run:
	@$(REBAR) as dev run

clean:
	@$(REBAR) clean

shell:
	@$(REBAR) shell

.PHONY: release test all compile clean
