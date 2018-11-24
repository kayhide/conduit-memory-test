build:
	stack build --profile --work-dir .stack-work-profile
.PHONY: build

run: tmp-dir
	stack exec --work-dir .stack-work-profile -- conduit-memory-test 0 60000 +RTS -hc
	mv conduit-memory-test.hp conduit-memory-test-0-60000.hp
	hp2ps -c conduit-memory-test-0-60000
	mv conduit-memory-test-0-60000.* tmp/
.PHONY: run

tmp-dir:
	mkdir -p tmp
