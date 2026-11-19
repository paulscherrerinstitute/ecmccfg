HOST       := c6025a-08
USER       := sandst_a
REMOTE_DIR := /tmp/asmtest
REMOTE     := $(USER)@$(HOST)

.PHONY: all deploy verify

all: deploy verify

deploy:
	ssh "$(REMOTE)" 'rm -rf "$(REMOTE_DIR)" && mkdir -p "$(REMOTE_DIR)/cfg"'
	scp -r ./cfg "$(REMOTE):$(REMOTE_DIR)/"
	scp ./startup.cmd ./test_block_motion_funcs.py ./README.md "$(REMOTE):$(REMOTE_DIR)/"

verify:
	@echo "Remote PLC selection:"
	@ssh "$(REMOTE)" 'grep -n "loadPLCFile" "$(REMOTE_DIR)/startup.cmd"'
	@test "$$(sha256sum ./startup.cmd | awk '{print $$1}')" = \
	  "$$(ssh "$(REMOTE)" 'sha256sum "$(REMOTE_DIR)/startup.cmd"' | awk '{print $$1}')" || \
	  { echo "ERROR: remote startup.cmd differs from local source" >&2; exit 1; }
	@test "$$(sha256sum ./cfg/block_motion_funcs.plc | awk '{print $$1}')" = \
	  "$$(ssh "$(REMOTE)" 'sha256sum "$(REMOTE_DIR)/cfg/block_motion_funcs.plc"' | awk '{print $$1}')" || \
	  { echo "ERROR: remote block_motion_funcs.plc differs from local source" >&2; exit 1; }
	@echo "Verified remote startup.cmd and block_motion_funcs.plc checksums."
