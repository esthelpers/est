FROM ubuntu:latest
RUN apt-get update
RUN apt-get install -y git wget vim
RUN PATH=$PATH:/root/.config/est/helpers/esthelpers/est
RUN echo 'export EST_EDITOR=vim' >> $HOME/.bashrc
RUN echo 'export EST_HOME=/root/.config/est/helpers/esthelpers/est' >> $HOME/.bashrc
RUN echo 'source /root/.config/est/helpers/esthelpers/est/estlib.sh' >> $HOME/.bashrc
RUN echo 'est_session' >> $HOME/.bashrc
WORKDIR /root

COPY ./* /root/.config/est/helpers/esthelpers/est/
CMD bash
