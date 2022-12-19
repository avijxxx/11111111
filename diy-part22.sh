sed -i 's/192.168.6.1/192.168.10.12/g' package/base-files/files/bin/config_generate

cat >> .config <<EOF
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_luci-app-alist=y
CONFIG_PACKAGE_luci-app-openvpn-server=y
CONFIG_PACKAGE_luci-theme-bootstrap=n
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_luci-app-netspeedtest=y
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-vlmcsd=y
CONFIG_PACKAGE_luci-app-watchcat=y
CONFIG_PACKAGE_luci-app-zerotier=y
CONFIG_PACKAGE_luci-app-lucky=y
#测试的两个
CONFIG_PACKAGE_sing-box=y
CONFIG_PACKAGE_luci-app-myproxy=y
CONFIG_PACKAGE_sing-box=y
CONFIG_PACKAGE_lua-neturl=y
CONFIG_SDK=y
EOF


#测试
git clone https://github.com/xwcoco/myproxy package/myproxy
git clone https://github.com/xwcoco/sing-box package/sing-box


#增加alist
git clone https://github.com/sbwml/luci-app-alist package/alist
rm -rf feeds/packages/lang/golang
svn export https://github.com/sbwml/packages_lang_golang/branches/19.x feeds/packages/lang/golang

#增加mosdns
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone https://github.com/sbwml/luci-app-mosdns.git package/luci-app-mosdns
git clone https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata

#增加netspeedtest测试  luci-app-lucky
#git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go
git clone https://github.com/sirpdboy/netspeedtest package/netspeedtest
git clone  https://github.com/sirpdboy/luci-app-lucky package/luci-app-lucky

#增加argon
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
