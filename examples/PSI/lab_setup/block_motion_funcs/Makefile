HOST       := c6025a-08
USER       := sandst_a
REMOTE_DIR := /tmp/asmtest
REMOTE     := $(USER)@$(HOST)

.PHONY: all deploy verify

all: deploy

deploy:
	#ssh "$(REMOTE)" 'rm -rf "$(REMOTE_DIR)" && mkdir -p "$(REMOTE_DIR)/cfg"'
	scp -r . "$(REMOTE):$(REMOTE_DIR)/"
	#scp ./startup.cmd ./test_block_motion_funcs.py ./README.md "$(REMOTE):$(REMOTE_DIR)/"

