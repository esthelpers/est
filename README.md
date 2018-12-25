# EST SHELL TOOLS
  
  * est install vendor/helper  
  * est remove vendor/helper  
  * est reinstall vendor/helper  
  * est activate vendor/helper  
  * est deactivate vendor/helper  
  * est rcfile vendor/helper  
  * est edit vendor/helper  
   
  * est version
  * est upgrade 
  * est actives
  * est help
  
est is a shell source tool  
it download github repo's and source if it has `est.sh`

# STILL IN DEVELOPMENT


# Installation

```
wget -O - -o /dev/null https://raw.githubusercontent.com/esthelpers/est/master/install.sh | bash
```
### add to rc file
export EST_EDITOR=vim  
export EST_HOME=$HOME/.est  
source $EST_HOME/estlib.sh  
est_session
