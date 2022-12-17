sed -i 's/192.168.6.1/192.168.10.12/g' package/base-files/files/bin/config_generate


#增加alist
git clone https://github.com/sbwml/luci-app-alist package/alist
rm -rf feeds/packages/lang/golang
svn export https://github.com/sbwml/packages_lang_golang/branches/19.x feeds/packages/lang/golang

#增加mosdns
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns.git package/luci-app-mosdns
git clone https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata

git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go
git clone https://github.com/sirpdboy/netspeedtest package/netspeedtest

find ./ | grep Makefile | grep argon | xargs rm -f
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
#取消bootstrap为默认主题：
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile



#移动测速到服务
sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/controller/*.lua
sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/model/cbi/netspeedtest/*.lua
sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/view/netspeedtest/*.htm
