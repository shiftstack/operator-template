all: build
.PHONY: all

# Include the library makefile
include $(addprefix ./vendor/github.com/openshift/build-machinery-go/make/, \
	golang.mk \
	targets/openshift/deps-gomod.mk \
	targets/openshift/images.mk \
	targets/openshift/bindata.mk \
)

# Run core verification and all self contained tests.
#
# Example:
#   make check
check: | verify test-unit
.PHONY: check

IMAGE_REGISTRY?=registry.svc.ci.openshift.org

# This will call a macro called "build-image" which will generate image specific targets based on the parameters:
# $0 - macro name
# $1 - target name
# $2 - image ref
# $3 - Dockerfile path
# $4 - context directory for image build
# It will generate target "image-$(1)" for building the image and binding it as a prerequisite to target "images".
$(call build-image,openstack-cinder-csi-driver-operator,$(IMAGE_REGISTRY)/ocp/4.6:openstack-cinder-csi-driver-operator,./Dockerfile.rhel7,.)

# generate bindata targets
# $0 - macro name
# $1 - target suffix
# $2 - input dirs
# $3 - prefix
# $4 - pkg
# $5 - output
$(call add-bindata,generated,./assets/...,assets,generated,pkg/generated/bindata.go)

clean:
	$(RM) openstack-cinder-csi-driver-operator
.PHONY: clean

GO_TEST_PACKAGES :=./pkg/... ./cmd/...
