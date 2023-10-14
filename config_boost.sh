#!/bin/bash

# created for small brain to not forgot how to install boost!!!

# this is the install path
BOOST_ROOT="~/boost_1_81_0_install"
# this is the boost files location
BOOST="~/boost_1_81_0"

#TODO: set compiler and set up std version
#      i.e., no boost auto pointer

echo "$@"

function HELP_MENU() {
    echo "options:"
    echo "-h    help show this menu"
    echo "-c    configure boost"
    echo "-i    install boost"
    echo "Examples:"
    echo "./config_boost.sh -c"
    echo "./config_boost.sh -i"
    echo "./config_boost.sh -i -c"
    echo "NOTE:"
    echo "Do not forget to set vars BOOST_ROOT and BOOST"
}

config_flag=false;
install_flag=false;

while getopts ":hci" option; do
    case $option in
        h)
            HELP_MENU;
            exit;
            ;;
        c)
            config_flag=true;
            ;;
        i)
            install_flag=true;
            ;;
        ?)
            echo "unknown switch";
            HELP_MENU;
            ;;
    esac
done

function mk_boostFolder() {
    if [ -d "$BOOST_ROOT" ];
    then
        # echo "$BOOST_ROOT exits"
        rm -rvf "$BOOST_ROOT";
        mkdir -pv "$BOOST_ROOT";
    else
        # echo "$BOOST_ROOT does not exits"
        mkdir -pv "$BOOST_ROOT";
    fi
}


function config_boost() {
    local current_dir=$PWD;
    cd $BOOST
    #export CXX=g++
    #export CXXFLAGS="-std=c++17"
    "$BOOST/bootstrap.sh" --prefix="$BOOST_ROOT" \
                         --includedir="$BOOST_ROOT/include" \
                         --libdir="$BOOST_ROOT/lib" \
                         --with-python=python3
    cd $current_dir
}

if [ "$config_flag" = true ];
then
    mk_boostFolder;
    config_boost;
fi

function install_boost() {
    local current_dir=$PWD;
    cd $BOOST
    $BOOST/b2 -j$(nproc) --prefix="$BOOST_ROOT" \
                         --includedir="$BOOST_ROOT/include" \
                         --libdir="$BOOST_ROOT/lib" \
                         install
    cd $current_dir
}

if [ "$install_flag" = true ];
then
    install_boost;
fi

