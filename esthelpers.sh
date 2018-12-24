#!/bin/bash
set -e
if [[ -z $EST_HOME ]];
then 
    EST_HOME="$HOME/.env"
fi

source $EST_HOME/variables.sh
source $EST_HOME/estlib.sh

if [[ $(which git | wc -l) == 0 ]];
then
    echo "EST is dependent to git if you want to use first install git"
    exit
fi
est_activate(){
    if ! [[ -d $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/ ]]
    then
        mkdir $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR
    fi
    est_check 
    if [[ $? == 0 ]]
    then
        ln -sf $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/;
        echo $EST_VENDOR/$EST_HELPER activated
        echo "This helper dont be activate until you restart your shell"
    fi
}
est_deactivate(){
    rm $EST_ACTIVE_HELPERS_DIR/$EST_VENDOR/$EST_HELPER
    echo "This helper dont be deactivate until you restart your shell"
}
est_download(){
    echo $EST_VENDOR/$EST_HELPER
    wget -O - -o /dev/null https://github.com/$EST_VENDOR/$EST_HELPER/archive/master.tar.gz > /tmp/estmaster.tar.gz
    mkdir -p $EST_HELPERS_DIR/$EST_VENDOR/
    tar -xvf /tmp/estmaster.tar.gz -C $EST_HELPERS_DIR/$EST_VENDOR/
    mv $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER{-master,}
}
est_install(){
    EST_VENDOR_DIR=$EST_HELPERS_DIR/$EST_VENDOR
    if ! [[ -d $EST_VENDOR_DIR ]];
    then
        mkdir $EST_VENDOR_DIR
    fi
    builtin cd $EST_VENDOR_DIR
    if [[ -d $EST_HELPER ]]
    then
        echo "already installed"
    fi
    echo downloading...
    est_download
    echo installing...
    est_activate
}
est_remove(){
    est_deactivate
    rm -rf $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER
}

est_version(){
    cat $EST_HOME/VERSION
}
est_help(){
    cat $EST_HOME/README.md
    exit
}

est_choose_from(){
    parameter=$1
    if [[ $parameter == github ]];
    then
        EST_FROM="https://github.com/"
    fi
}
est_edit(){
    if ! [[ -z $EST_EDITOR ]]
    then
        $EST_EDITOR $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER/est.sh
    else
        echo "your EST_EDITOR variable is unset"
    fi
}
est_rcfile(){
    echo $EST_HELPERS_DIR/$EST_VENDOR/$EST_HELPER/est.sh
}
est_actives(){
    for vendor in $(ls $EST_ACTIVE_HELPERS_DIR)
    do
        for helper in $(ls $EST_ACTIVE_HELPERS_DIR/$vendor)
        do 
            echo $vendor/$helper
        done
    done
}
est_upgrade(){

    #if [[ $(git remote show origin | grep "local out of date" | wc -l) > 0 ]]
    #then
        rm -rf $EST_HOME
        $(wget -O - -o /dev/null https://raw.githubusercontent.com/esthelpers/est/master/install.sh | bash > /dev/null)
    #fi
}
est_initialize(){
    return 0
}
home(){
    export 

}
est(){
    if [[ $# == 1 ]];
    then
        case "$1" in
            help)
                est_help
                ;;
            version)
                est_version
                ;;
            actives)
                est_actives
                ;;
            upgrade)
                est_upgrade
                ;;
            initialize)
                est_initialize
                ;;
            *)
                est_help
                ;;
        esac
        exit

    fi
    if [[ $# < 2 ]];
    then
        echo "EST gets at least two parameters"
        est_help
    fi

    cmd=$1
    shift
    helper=$1
    shift
    for additional in $@;do
        if [[ ${additional%:*} == from ]];
        then
            parameter=${additional#*:}
            est_choose_from $parameter
        fi
    done
    if [[ $helper =~ ^.*/.*$ ]]
    then
        export EST_VENDOR=${helper%/*}
    else
        export EST_VENDOR="esthelpers"
    fi
    export EST_HELPER=${helper#*/}
    case "$cmd" in
        install)
            echo $EST_VENDOR/$EST_HELPER installing...
            est_install
            ;;
        remove)
            echo $EST_VENDOR/$EST_HELPER removing...
            est_remove
            ;;
        activate)
            est_activate
            ;;
        deactivate)
            est_deactivate
            echo $EST_VENDOR/$EST_HELPER deactivated
            ;;
        reinstall)
            est_remove
            est_install
            echo $EST_VENDOR/$EST_HELPER reinstalled
            ;;
        rcfile)
            est_rcfile
            ;;
        edit)
            est_edit
            ;;
        home)
            est_home
            ;;
        *)
            est_help
            ;;
    esac
}
est $@
