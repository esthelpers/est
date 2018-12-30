FROM ubuntu:latest
RUN apt update
RUN apt install -y git wget
RUN echo echoooo
COPY $HOME/.config/est/helpers/esthelpers/est/ /root/.config/est/helpers/esthelpers/est/
RUN echo 'export EST_EDITOR=vim' >> $HOME/.bashrc
RUN echo 'export EST_HOME=/root/.config/est/helpers/esthelpers/est' >> $HOME/.bashrc
RUN echo 'source /root/.config/est/helpers/esthelpers/est/estlib.sh' >> $HOME/.bashrc
RUN echo 'est_session' >> $HOME/.bashrc

WORKDIR /root
CMD bash
