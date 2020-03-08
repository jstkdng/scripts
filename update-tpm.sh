#!/bin/bash
tpm2_evictcontrol -c cryptroot.handle
tpm2_createpolicy -L policy.digest --policy-pcr -l sha1:0,2,3,7
tpm2_createprimary -C e -g sha256 -G rsa -c primary.ctx -L policy.digest
tpm2_create -g sha256 -C primary.ctx -u obj.pub -r obj.priv -a "noda|adminwithpolicy|fixedparent|fixedtpm" -L policy.digest -i cryptroot
tpm2_load -u obj.pub -r obj.priv -c key.ctx -C primary.ctx
tpm2_evictcontrol -C o -c key.ctx -o cryptroot.handle 0x81000000
