# nv-temperature
A small systemd service and script that dumps the current temperature of a Nvidia GPU to a file every second on the tmp directory so that fancontrol can use it as a sensor input.

## How to get it working
1. Copy `nv-temperature.sh` to `/usr/local/sbin/`.
2. Make it executable with `chmod +x /usr/local/sbin/nv-temperature.sh`.
3. Copy `nv-temperature.service` to `/etc/systemd/system/`.
4. Enable `nv-temperature` with systemctl with `systemctl enable nv-temperature`.
5. Configure fancontrol and start it.

## Sample `/etc/fancontrol`
```
INTERVAL=1
DEVPATH=hwmon0=devices/platform/coretemp.0 hwmon1=devices/platform/nct6775.656
DEVNAME=hwmon0=coretemp hwmon1=nct6776
FCTEMPS=hwmon1/pwm1=/tmp/nv-temperature/temperature
FCFANS= hwmon1/pwm1=hwmon1/fan1_input
MINTEMP=hwmon1/pwm1=30
MAXTEMP=hwmon1/pwm1=80
MINSTART=hwmon1/pwm1=150
MINSTOP=hwmon1/pwm1=0
MAXPWM=hwmon1/pwm1=255
```

## Motivation
Needed to find a way to cool a Nvidia Tesla M40 with PWM controlled fans.

## License
- [zlib License](https://choosealicense.com/licenses/zlib/)