#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Add diy package
git clone https://github.com/mlwrx1978/package.git diy
rm -rf feeds/lienol/package/chinadns-ng
mv diy/chinadns-ng feeds/lienol/package/
rm -rf  feeds/packages/net/smartdns
mv diy/smartdns feeds/packages/net/
mv diy/* package/
rm -rf diy

# open sfe
sed -i "/114.114/d" package/lean/luci-app-sfe/root/etc/config/sfe
sed -i "s/wifi '0'/wifi '1'/" package/lean/luci-app-sfe/root/etc/config/sfe
sed -i "s/bbr '0'/bbr '1'/" package/lean/luci-app-sfe/root/etc/config/sfe

# upgrade chiandns-ng list file
cd feeds/lienol/package/chinadns-ng
./update-list.sh
