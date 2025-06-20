IMAGE_NAME=debian-with-disks

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run --privileged -it $(IMAGE_NAME)

lint:
	docker run --rm -v $(shell pwd):/mnt $(IMAGE_NAME) bash -c "apt-get update && apt-get install -y shellcheck && shellcheck /mnt/scripts/pve-install.sh"

# Clean up built images (optional)
clean:
	docker rmi $(IMAGE_NAME) || true
