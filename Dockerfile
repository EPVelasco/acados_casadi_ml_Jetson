FROM nvcr.io/nvidia/l4t-pytorch:r35.2.1-pth2.0-py3

# Set up time zone.
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

RUN apt-get update
RUN apt-get upgrade -y

ARG USER_ID
ARG GROUP_ID

RUN apt-get update && apt-get install -y apt-utils curl wget git bash-completion build-essential sudo && rm -rf /var/lib/apt/lists/*

# Change HOME environment variable
ENV HOME /home/epvs
RUN mkdir -p ${HOME}/ml_casadi/src

#acados requeriments
RUN apt-get update && apt-get -y install cmake && apt-get -y install make

RUN apt-get -y update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
# Install py39 from deadsnakes repository
RUN apt-get install -y python3.8
# Install pip from standard ubuntu packages
RUN apt-get install -y python3-pip
RUN apt-get install nano
RUN apt-get install bc 
RUN apt install -y liblapack-dev libopenblas-dev


#clone repository acados
RUN cd ${HOME}/ml_casadi/src/ && git clone https://github.com/EPVelasco/acados.git
RUN cd ${HOME}/ml_casadi/src/acados  && git submodule update --recursive --init && mkdir -p build
RUN cd ${HOME}/ml_casadi/src/acados/build && cmake -DACADOS_INSTALL_DIR="/home/epvs/ml_casadi/src/acados" ..
RUN cd ${HOME}/ml_casadi/src/acados/build && make install -j4
COPY ./Makefile.rule ${HOME}/ml_casadi/src/acados/ 
RUN cd ${HOME}/ml_casadi/src/acados && make shared_library
RUN cd ${HOME}/ml_casadi/src/acados && make examples_c
RUN pip3 install catkin_pkg
#install numpy
RUN pip3 install numpy>=1.20.0
RUN pip3 install -e /home/epvs/ml_casadi/src/acados/interfaces/acados_template

#clone repository ml casadi
RUN cd ${HOME}/ml_casadi/src/ && git clone https://github.com/EPVelasco/ml-casadi.git
COPY ./requirements.txt ${HOME}/ml_casadi/src/ml-casadi/
RUN cd ${HOME}/ml_casadi/src/ml-casadi/ && pip install -r requirements.txt
RUN cd ${HOME}/ml_casadi/src/ml-casadi/ && python3 setup.py build
RUN cd ${HOME}/ml_casadi/src/ml-casadi/ && python3 setup.py install

#Clone repository training
RUN cd ${HOME}/ml_casadi/src/ && git clone https://github.com/EPVelasco/neural-mpc.git
COPY ./neural-mpc/requirements.txt ${HOME}/ml_casadi/src/neural-mpc/
RUN cd ${HOME}/ml_casadi/src/neural-mpc/ && pip install -r requirements.txt

## ROS NOETIC INSTALL
# Minimal setup
RUN apt-get update \
 && apt-get install -y locales lsb-release
RUN dpkg-reconfigure locales
 
# Install ROS Noetic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update \
 && apt-get install -y --no-install-recommends ros-noetic-ros-base
RUN apt-get install -y --no-install-recommends python3-rosdep
RUN rosdep init \
 && rosdep fix-permissions \
 && rosdep update

RUN apt install -y vim

## Clone the drone reposiroty 
RUN cd ${HOME}/ml_casadi/src/ && git clone https://github.com/lfrecalde1/Pendulum_cart.git

# set up environment

COPY ./update_bashrc /sbin/update_bashrc
RUN sudo chmod +x /sbin/update_bashrc ; sudo chown ros /sbin/update_bashrc ; sync ; /bin/bash -c /sbin/update_bashrc ; sudo rm /sbin/update_bashrc

##### install Tera acados
COPY ./t_renderer ${HOME}/ml_casadi/src/acados/bin/ 
RUN sudo chmod 777  ${HOME}/ml_casadi/src/acados/bin/t_renderer

#### instal Latex for matplotlib
RUN apt-get update
RUN apt-get -y install dvipng texlive-latex-extra texlive-fonts-recommended cm-super

