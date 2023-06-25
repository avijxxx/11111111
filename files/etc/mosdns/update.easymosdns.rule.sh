#!/bin/bash
# Powered by Apad.pro
# https://apad.pro/easymosdns
#
mkdir -p /tmp/easymosdns && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/china_domain_list.txt > /tmp/easymosdns/china_domain_list.txt && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/gfw_domain_list.txt > /tmp/easymosdns/gfw_domain_list.txt && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/cdn_domain_list.txt > /tmp/easymosdns/cdn_domain_list.txt && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/china_ip_list.txt > /tmp/easymosdns/china_ip_list.txt && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/gfw_ip_list.txt > /tmp/easymosdns/gfw_ip_list.txt  && curl https://raw.githubusercontent.com/pmkol/easymosdns/rules/ad_domain_list.txt > /tmp/easymosdns/ad_domain_list.txt && \cp -rf /tmp/easymosdns/*.txt /etc/mosdns/rule && rm -rf /tmp/easymosdns/* && echo 'update successful'
