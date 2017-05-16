REBAR := `pwd`/rebar3

all: test release

compile:
	@$(REBAR) compile

doc:
	@$(REBAR) edoc

test:
	@$(REBAR) do xref, dialyzer, eunit

release:
	@$(REBAR) release


run:
	@$(REBAR) as dev run

clean:
	@$(REBAR) clean

shell:
	@$(REBAR) shell

.PHONY: release test all compile clean
