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
# CONFIG_PACKAGE_luci-app-ddns-go is not set
CONFIG_PACKAGE_luci-app-lucky=y
# CONFIG_PACKAGE_luci-app-cpufreq is not set
# CONFIG_PACKAGE_luci-app-adbyby-fix is not set
# CONFIG_PACKAGE_luci-app-vssr_INCLUDE_ShadowsocksR_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-vssr_INCLUDE_Trojan is not set
# CONFIG_PACKAGE_luci-app-vssr_INCLUDE_Xray is not set
# CONFIG_PACKAGE_luci-app-vssr_INCLUDE_Xray_plugin is not set
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ChinaDNS_NG is not set
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Libev_Client is not set
# CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks_Simple_Obfs is not set
# CONFIG_UnblockNeteaseMusic_Go is not set
EOF

git clone https://github.com/douglarek/luci-app-homeproxy package/luci-app-homeproxy

#增加alist
git clone https://github.com/sbwml/luci-app-alist package/alist
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 20.x feeds/packages/lang/golang


#增加mosdns 4.5.3
find ./ | grep Makefile | grep v2ray-geodata | xargs rm -f
find ./ | grep Makefile | grep mosdns | xargs rm -f
git clone -b v4 https://github.com/sbwml/luci-app-mosdns.git package/luci-app-mosdns
git clone https://github.com/sbwml/v2ray-geodata.git package/v2ray-geodata
   #添加easymosdns更新rule
mkdir -p files/etc/mosdns/rule
mkdir -p files/etc/crontabs
touch files/etc/mosdns/update.easymosdns.rule.sh
touch files/etc/mosdns/config_custom.yaml
touch files/etc/crontabs/root
mkdir -p /tmp/easymosdns && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/china_domain_list.txt > /tmp/easymosdns/china_domain_list.txt && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/cdn_domain_list.txt > /tmp/easymosdns/cdn_domain_list.txt &&  \cp -rf /tmp/easymosdns/*.txt files/etc/mosdns/rule && rm -rf /tmp/easymosdns/* && echo 'update successful'
echo '0 1 * * * chmod +x etc/mosdns/update.easymosdns.rule.sh && etc/mosdns/update.easymosdns.rule.sh' > files/etc/crontabs/root

cat>files/etc/mosdns/update.easymosdns.rule.sh<<-\EOF
#!/bin/bash
# Powered by Apad.pro
# https://apad.pro/easymosdns
#
mkdir -p /tmp/easymosdns && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/china_domain_list.txt > /tmp/easymosdns/china_domain_list.txt && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/cdn_domain_list.txt > /tmp/easymosdns/cdn_domain_list.txt &&  \cp -rf /tmp/easymosdns/*.txt etc/mosdns/rule && rm -rf /tmp/easymosdns/* && echo 'update successful'
EOF

cat>files/etc/mosdns/config_custom.yaml<<-\EOF
# EasyMosdns Client v3.0
log:
    file: "/tmp/mosdns.log"
    level: info
data_providers:
  - tag: chinalist
    file: /etc/mosdns/rule/china_domain_list.txt
    auto_reload: true
  - tag: cdncn
    file: /etc/mosdns/rule/cdn_domain_list.txt
    auto_reload: true
plugins:
  # 乐观缓存的插件
  - tag: cache
    type: cache
    args:
      size: 5000
      compress_resp: true
      lazy_cache_ttl: 86400
      cache_everything: true
      lazy_cache_reply_ttl: 3
  # IP反查缓存的插件
  - tag: reverse_lookup
    type: reverse_lookup
    args:
      size: 1000
      ttl: 3600
      handle_ptr: true
  # 匹配emby域名的插件
  - tag: emby
    type: query_matcher
    args:
      domain:
        - "domain:odysseyplus.site"
        - "full:cf.odysseyplus.site"

  # 匹配BPCDN域名的插件
  - tag: bpcdn
    type: query_matcher
    args:
      domain:
        - "domain:szbdyd.com"
        - "full:mcdn.bilivideo.cn"
        - "regexp:.+pcdn.+.biliapi.net$"

  # 调整TTL的插件
  - tag: ttl_long
    type: ttl
    args:
      minimal_ttl: 600
      maximum_ttl: 86400
  # 转发AliDNS的插件
  - tag: forward_alidns
    type: fast_forward
    args:
      upstream:
        - addr: "223.5.5.5"
  # 转发DNSPod的插件
  - tag: forward_dnspod
    type: fast_forward
    args:
      upstream:
        - addr: "tls://1.12.12.12:853"
          enable_pipeline: true
  # 转发远程服务器的插件
  - tag: forward_remote
    type: fast_forward
    args:
      upstream:
        - addr: "tls://8.8.4.4:853"
          enable_pipeline: true
  # 转发分流服务器的插件
  - tag: forward_apad_pro
    type: fast_forward
    args:
      upstream:
        - addr: "https://doh.apad.pro/dns-query"
          bootstrap: "119.29.29.29"
          enable_http3: false
  # 匹配本地域名的插件
  - tag: query_is_local_domain
    type: query_matcher
    args:
      domain:
        - "provider:chinalist"
  # 匹配CDN域名的插件
  - tag: query_is_cdn_cn_domain
    type: query_matcher
    args:
      domain:
        - "provider:cdncn"
  # 主要的运行逻辑插件
  - tag: main_sequence
    type: sequence
    args:
      exec:
        # 缓存
        - reverse_lookup
        - cache
        # B站PCDN
        - if: bpcdn
          exec:
          - _new_nxdomain_response
          - _return

        # emby
        - if: emby
          exec:
          - forward_remote
          - _return

        # 本地域名与CDN域名处理
        - if: "(query_is_local_domain) || (query_is_cdn_cn_domain)"
          exec:
            - primary:
                # 优先用AliDNS解析
                - forward_alidns
              secondary:
                # 超时用DNSPod解析
                - forward_dnspod
              fast_fallback: 50
              always_standby: true
            - _return
        # 剩下的域名处理
        - primary:
            # 优先用分流服务器解析
            - forward_apad_pro
          secondary:
            # 超时用远程服务器解析
            - forward_remote
          fast_fallback: 500
          always_standby: false
        - ttl_long
servers:
  - exec: main_sequence
    timeout: 5
    # 监听地址配置
    listeners:
      - protocol: udp
        addr: "0.0.0.0:5335"
      - protocol: tcp
        addr: "0.0.0.0:5335"
EOF

#增加luci-app-lucky
git clone https://github.com/sirpdboy/luci-app-lucky package/lucky

#增加netspeedtest测试
#git clone https://github.com/sirpdboy/luci-app-ddns-go.git package/ddns-go
#git clone https://github.com/sirpdboy/netspeedtest package/netspeedtest

#sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/controller/*.lua
#sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/model/cbi/netspeedtest/*.lua
#sed -i 's/network/services/g' package/netspeedtest/luci-app-netspeedtest/luasrc/view/netspeedtest/*.htm

#增加argon
find ./ | grep Makefile | grep argon | xargs rm -f
git clone https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon

#取消bootstrap为默认主题：
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' ./feeds/luci/collections/luci/Makefile


