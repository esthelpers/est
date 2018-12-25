if [[ $(which git | wc -l) == 0 ]];
then
    echo "EST is dependent to git if you want to use first install git"
    exit
fi

cd $HOME
if [[ -z $EST_HOME ]]
then
    export EST_HOME=$HOME/.est
fi
if [[ -d $EST_HOME ]]
then
    echo "you have already $EST_HOME"
    exit
else
    mkdir $EST_HOME
fi
$(git clone https://github.com/esthelpers/est $EST_HOME > /dev/null)


chmod +x $EST_HOME/esthelpers.sh
mkdir $EST_HOME/bin
ln -sf $EST_HOME/esthelpers.sh $EST_HOME/bin/esthelpers
est initialize
echo "# put this source in your rc file"
echo "export EST_EDITOR=vim"
echo "export EST_HOME=\$HOME/.est"
echo "source \$EST_HOME/estlib.sh"
