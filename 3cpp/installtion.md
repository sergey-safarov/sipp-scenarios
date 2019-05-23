Install FreeSwitch 1.6.20

```sh
yum install -y http://files.freeswitch.org/freeswitch-release-1-6.noarch.rpm epel-release
yum install -y freeswitch-config-vanilla freeswitch-lua
```

Then need to uncomment `enable-3pcc` param in `/etc/freeswitch/sip_profiles/external.xml` file
```
<param name="enable-3pcc" value="true"/>
```

Then unpack archive with SIPP scripts
```
tar xzf sipp_scripts.tar.gz
```

Run install script from A-side folder or from B-side
```
./load-tools/A-side/install.sh
```

And start test script from A-side folder or from B-side
```
./load-tools/A-side/run_test.sh
```
