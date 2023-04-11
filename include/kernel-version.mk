
# Use the default kernel version if the Makefile doesn't override it
LINUX_RELEASE?=1

ifdef CONFIG_TESTING_KERNEL
  KERNEL_PATCHVER:=$(KERNEL_TESTING_PATCHVER)
endif

#LINUX_VERSION-5.15 = .74

#LINUX_KERNEL_HASH-5.15.74 = 2c1539a2f85b835c36c4a07c8270b52b0bec38fdda7339477d07f0c3af8c4265
LINUX_VERSION-5.15 = .104
LINUX_KERNEL_HASH-5.15.104 = 71c532ce09992e470f3259ffeb38d2b5bba990c243a559e4726a57412bd36b54
#LINUX_VERSION-6.1 = .22
#LINUX_KERNEL_HASH-6.1.22 = 2be89141cef74d0e5a55540d203eb8010dfddb3c82d617e66b058f20b19cfda8
LINUX_VERSION-6.1 = .21
LINUX_KERNEL_HASH-6.1.21 = b33cb1b86ae13441db36f7e8099ff9edb10494bfd141b4efb41bc44bf815d93a

LINUX_VERSION-5.4 = .188

LINUX_KERNEL_HASH-5.4.188 = 9fbc8bfdc28c9fce2307bdf7cf1172c9819df673397a411c40a5c3d0a570fdbc

LINUX_VERSION-4.4 = .18

LINUX_VERSION-4.9 = .282

LINUX_VERSION-4.19 = .238

LINUX_KERNEL_HASH-4.19.238 = 83b74545c5d380384e09955c26e786bf9ee81a44bcf9347f2ca2ad3d31b46b7a

remove_uri_prefix=$(subst git://,,$(subst http://,,$(subst https://,,$(1))))
sanitize_uri=$(call qstrip,$(subst @,_,$(subst :,_,$(subst .,_,$(subst -,_,$(subst /,_,$(1)))))))

ifneq ($(call qstrip,$(CONFIG_KERNEL_GIT_CLONE_URI)),)
  LINUX_VERSION:=$(call sanitize_uri,$(call remove_uri_prefix,$(CONFIG_KERNEL_GIT_CLONE_URI)))
  ifeq ($(call qstrip,$(CONFIG_KERNEL_GIT_REF)),)
    CONFIG_KERNEL_GIT_REF:=HEAD
  endif
  LINUX_VERSION:=$(LINUX_VERSION)-$(call sanitize_uri,$(CONFIG_KERNEL_GIT_REF))
else
ifdef KERNEL_PATCHVER
  LINUX_VERSION:=$(KERNEL_PATCHVER)$(strip $(LINUX_VERSION-$(KERNEL_PATCHVER)))
endif
ifdef KERNEL_TESTING_PATCHVER
  LINUX_TESTING_VERSION:=$(KERNEL_TESTING_PATCHVER)$(strip $(LINUX_VERSION-$(KERNEL_TESTING_PATCHVER)))
endif
endif

split_version=$(subst ., ,$(1))
merge_version=$(subst $(space),.,$(1))
KERNEL_BASE=$(firstword $(subst -, ,$(LINUX_VERSION)))
KERNEL=$(call merge_version,$(wordlist 1,2,$(call split_version,$(KERNEL_BASE))))
KERNEL_PATCHVER ?= $(KERNEL)

# disable the md5sum check for unknown kernel versions
LINUX_KERNEL_HASH:=$(LINUX_KERNEL_HASH-$(strip $(LINUX_VERSION)))
LINUX_KERNEL_HASH?=x
