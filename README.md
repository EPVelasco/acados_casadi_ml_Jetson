# ml-casadi_Jetson
This repository has Acados, Casadi and neural mpc in a dockerfile for NVIDIA Jetson. In addition, the basic version of ros noetic is installed. It has been tested on a Jetson Nano. 

## Clone repository and build docker
```
    cd ~/your_ws/
    git clone https://github.com/EPVelasco/ml-casadi_Jetson.git  
  
```
## Pull docker image
This will take several minutes (aprox 60 min), get a docker FROM nvcr.io/nvidia/l4t-pytorch:r35.2.1-pth2.0-py3
The image size is about 15GB, need to set aside enough space.
```
    cd ~/your_ws/ml-casadi_Jetson
    sudo docker build -t ml_casadi .    
```
## Create container
```
    sudo docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --rm -it --name ml_casadi_container --network host --cpuset-cpus="0" --runtime=nvidia -v ~/:/epvelasco --workdir=${HOME}/ml_casadi/src/Pendulum_cart/Invert_pendulum ml_casadi
