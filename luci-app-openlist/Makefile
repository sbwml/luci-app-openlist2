# Copyright (C) 2016 Openwrt.org
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-openlist
PKG_VERSION:=4.0.3
PKG_RELEASE:=1

LUCI_TITLE:=LuCI support for openlist
LUCI_DEPENDS:=+openlist

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
$(eval $(call BuildPackage,$(PKG_NAME)))
