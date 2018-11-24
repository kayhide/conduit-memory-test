build:
	stack build --profile --work-dir .stack-work-profile
.PHONY: build

PROFILES := 0-60000 20000-60000
OUTPUT_DIR := tmp
OUTPUT_FILES := $(PROFILES:%=$(OUTPUT_DIR)/%.ps)

run: $(OUTPUT_FILES)
.PHONY: run

clean:
	rm $(OUTPUT_FILES:%.ps=%.*)
.PHONY: clean

%.ps: %.hp
	hp2ps -c $*
	mv $(notdir $*).* $(OUTPUT_DIR)

%.hp:
	$(eval count = $(word 1,$(subst -, ,$(notdir $*))))
	$(eval total = $(word 2,$(subst -, ,$(notdir $*))))
	stack exec --work-dir .stack-work-profile -- conduit-memory-test $(count) $(total) +RTS -hc
	mv conduit-memory-test.hp $@

open:
	open $(OUTPUT_FILES)
