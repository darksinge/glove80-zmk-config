TIMESTAMP := $(shell date -u +"%Y%m%d%H%M%S")
detected_OS := $(shell uname)  # Classify UNIX OS
ifeq ($(strip $(detected_OS)),Darwin) #We only care if it's OS X
SELINUX1 :=
SELINUX2 :=
else
SELINUX1 := :z
SELINUX2 := ,z
endif

VOLUME_NAME := nix
EXISTING_VOLUME := $(shell docker volume ls -q -f name=$(VOLUME_NAME))

.PHONY: all clean

all:
	mkdir firmware 2>/dev/null || true
	docker build --tag glove80zmk .
	docker run --rm -it --name glove80zmk \
		-v $(PWD)/firmware:/app/firmware$(SELINUX1) \
		-v $(PWD)/config:/app/config:ro$(SELINUX2) \
		-e TIMESTAMP=$(TIMESTAMP) \
		glove80zmk

clean:
	rm -f firmware/*.uf2
	docker image rm glove80zmk
	docker image rm nixos/nix
	docker volume rm $(VOLUME_NAME)
