#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add feed source
sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package\nsrc-git diy https://github.com/mlwrx1978/package' feeds.conf.default

# replace Kernel version
#sed -i 's/5.4/4.14/' target/linux/ramips/Makefile

# add to Xiaomi R3G factory
sed -i '/xiaomi_mir3g/{n;n;n;n;n;n;n;s/rootfs0.bin/& breed-factory.bin factory.bin/}' target/linux/ramips/image/mt7621.mk
sed -i '/xiaomi_mir3g/{n;n;n;n;n;n;n;n;n;n;s/metadata/&\n  IMAGE\/factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | append-ubi | check-size $$$$(IMAGE_SIZE)\n  IMAGE\/breed-factory.bin := append-kernel | pad-to $$(KERNEL_SIZE) | \\\n\t\t\t     append-kernel | pad-to $$(KERNEL_SIZE) | \\\n\t\t\t     append-ubi | check-size $$$$(IMAGE_SIZE)/}' target/linux/ramips/image/mt7621.mk

# Overclocking MT7621 1000Mhz--0x312 1100--0x362 1200Mhz--0x3B2
sed -i "/@@ static struct/c@@ -113,49 +113,93 @@ static struct rt2880_pmx_group mt7621_pi" target/linux/ramips/patches-5.4/102-mt7621-fix-cpu-clk-add-clkdev.patch
sed -i "s/bus_clk;/bus_clk,i;/" target/linux/ramips/patches-5.4/102-mt7621-fix-cpu-clk-add-clkdev.patch
sed -i "/REG_CPU_PLL);/a\\+\t\tpll &= ~(0x7ff);\n+\t\tpll |=  (0x362);\n+\t\trt_memc_w32(pll,MEMC_REG_CPU_PLL);\n+\t\tfor(i=0;i<1024;i++);" target/linux/ramips/patches-5.4/102-mt7621-fix-cpu-clk-add-clkdev.patch

# modify DHCP Configuration
sed -i "/filter_aaaa/a\\\tlist server\t\t'127.0.0.1#5053'\n\toption port \t'54'\n\toption cachesize\t'0'" package/network/services/dnsmasq/files/dhcp.conf
sed -i "/leasetime/a\\\tlist dhcp_option '6,192.168.1.1'" package/network/services/dnsmasq/files/dhcp.conf
