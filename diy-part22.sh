sed -i 's/192.168.6.1/192.168.1.253/g' package/base-files/files/bin/config_generate
sed -i 's/SSID1=Redmi_AX6000_2.4G/SSID1=123123_2.4/g' package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
sed -i 's/SSID1=Redmi_AX6000_5G/SSID1=123123/g' package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat
sed -i 's/WPAPSK1=88888888/WPAPSK1=password/g' package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
sed -i 's/WPAPSK1=88888888/WPAPSK1=password/g' package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat
sed -i 's/AuthMode=OPEN/AuthMode=WPA2PSKWPA3PSK/g' package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat
sed -i 's/AuthMode=OPEN/AuthMode=WPA2PSKWPA3PSK/g' package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
sed -i 's/EncrypType=NONE/EncrypType=AES/g' package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat
sed -i 's/EncrypType=NONE/EncrypType=AES/g' package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
sed -i 's/PMFMFPC=0/PMFMFPC=1/g'  package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat
sed -i 's/PMFMFPC=0/PMFMFPC=1/g'  package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
sed -i 's/RekeyMethod=DISABLE/RekeyMethod=TIME/g'  package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat
sed -i 's/RekeyMethod=DISABLE/RekeyMethod=TIME/g'  package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat

cat >> package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat <<EOF
WpaMixPairCipher=
WEP1Type1=0
WEP4Type1=0
WEP3Type1=0
WEP2Type1=0
EOF

cat >> package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat <<EOF
WpaMixPairCipher=
WEP1Type1=0
WEP4Type1=0
WEP3Type1=0
WEP2Type1=0
EOF

cat >> .config <<EOF

# CONFIG_PACKAGE_luci-app-adbyby-fix is not set
# CONFIG_PACKAGE_luci-app-vssr_INCLUDE_ShadowsocksR_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-vssr_INCLUDE_Trojan is not set
# CONFIG_PACKAGE_luci-app-vssr_INCLUDE_Xray is not set
# CONFIG_PACKAGE_luci-app-vssr_INCLUDE_Xray_plugin is not set
CONFIG_PACKAGE_openssh-sftp-server=y
CONFIG_PACKAGE_luci-app-alist=y
CONFIG_PACKAGE_luci-app-openvpn-server=y
CONFIG_PACKAGE_luci-theme-bootstrap=n
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-argon-config=y
CONFIG_PACKAGE_luci-app-ddns-go=y
CONFIG_PACKAGE_luci-app-mosdns=y
CONFIG_PACKAGE_luci-app-netspeedtest=n
CONFIG_PACKAGE_luci-app-passwall=y
CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ChinaDNS_NG=y
CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy=y
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ChinaDNS_NG is not set
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Simple_Obfs is not set
# CONFIG_UnblockNeteaseMusic_Go is not set
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-vlmcsd=y
CONFIG_PACKAGE_luci-app-watchcat=y
CONFIG_PACKAGE_luci-app-zerotier=y
CONFIG_PACKAGE_luci-app-netspeedtest=y
EOF


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
#git clone https://github.com/sirpdboy/netspeedtest package/netspeedtest

find ./ | grep Makefile | grep argon | xargs rm -f
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
#取消bootstrap为默认主题：
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile



#移动测速到服务
#sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/controller/*.lua
#sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/model/cbi/netspeedtest/*.lua
#sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/view/netspeedtest/*.htm
