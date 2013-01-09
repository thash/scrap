#Set colour prompt using the name, platform or instance id and avzone
# usage: put this file in /etc/profile.d/
#
# PLATFORM: development, staging, production

if [ -f "/etc/AWS-INSTID" ]; then
        export INSTID=`cat /etc/AWS-INSTID`
else
        export INSTID=`curl -s --fail http://169.254.169.254/latest/meta-data/instance-id`
fi
if [ -f "/etc/AWS-AVZONE" ]; then
        export AVZONE=`cat /etc/AWS-AVZONE`
else
        export AVZONE=`curl -s --fail http://169.254.169.254/latest/meta-data/placement/availability-zone`
fi
PLATFORM=""
if [ -f "/etc/AWS-PLATFORM" ]; then
        PLATFORM=`cat /etc/AWS-PLATFORM`
fi
NAME=""
if [ -f "/etc/AWS-NAME" ]; then
        NAME=`cat /etc/AWS-NAME`
else
        NAME=`hostname`
fi

# Define colours
RED=31
GREEN=32
ORANGE=33
BLUE=34
PURPLE=35
CYAN=36

# Use NAME and PLATFORM if defined - otherwise use the instance ID
# or the availability zone.  Set the platform colour according to the
# platform.

if [[ "$NAME" == "" ]]; then
        NAME=$INSTID
fi
export NAME

if [[ "$PLATFORM" != "" ]]; then
        PLAT=`echo $PLATFORM | tr '[a-z]' '[A-Z]'`
        case $PLAT in
                TEST*|STAGE*)   PLATCOL=$GREEN
                        NAMECOL=$CYAN
                        ;;
                UAT*|PREPROD*)  PLATCOL=$ORANGE
                        NAMECOL=$PURPLE
                        ;;
                LIVE*|PROD*)    PLATCOL=$RED
                        NAMECOL=$BLUE
                        ;;
                *)      PLATCOL=$BLUE
                        NAMECOL=$GREEN
                        ;;
        esac
else
        PLAT=$AVZONE
        PLATCOL=$CYAN
        NAMECOL=$ORANGE
fi
export PLAT
export PLATCOL
export NAMECOL

case $TERM in
    vt100)
      PS1="\[\033]0;$PLAT-$NAME\007\]\[\033[0;${PLATCOL}m\]$PLAT\[\033[0;38m\]-\[\033[0;${NAMECOL}m\]$NAME\[\033[0;38m\] [\u:\W]$ "
      ;;
    xtermc)
      export TERM=xterm
      PS1="\[\033]0;$PLAT-$NAME\007\]\[\033[0;${PLATCOL}m\]$PLAT\[\033[0;38m\]-\[\033[0;${NAMECOL}m\]$NAME\[\033[0;38m\] [\u:\W]$ "
      ;;
    xterm*)
      PS1="\[\033]0;$PLAT-$NAME\007\]\[\033[0;${PLATCOL}m\]$PLAT\[\033[0;38m\]-\[\033[0;${NAMECOL}m\]$NAME\[\033[0;38m\] [\u:\W]$ "
      ;;
    *)
      PS1="[\u@i-fa5f36f9 \W]$ "
      ;;
esac
shopt -s checkwinsize
[ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
export PS1
