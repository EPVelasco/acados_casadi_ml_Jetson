# acados_casadi_ml_Jetson
This repository has Acados, Casadi and neural mpc in a dockerfile for NVIDIA Jetson. In addition, the basic version of ros noetic is installed. It has been tested on a Jetson Nano and Jetson Orin NX. 

## Clone repository and build docker
```
    cd ~/your_ws/
    git clone https://github.com/EPVelasco/acados_casadi_ml_Jetson.git  
  
```
## Pull docker image
This will take several minutes (aprox 60 min), get a docker FROM nvcr.io/nvidia/l4t-pytorch:r35.2.1-pth2.0-py3
The image size is about 15GB, need to set aside enough space.
```
    cd ~/your_ws/acados_casadi_ml_Jetson
    sudo docker build -t acados_casadi_ml .    
```
## Create container
```
    sudo docker run --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 --rm -it --name acados_casadi_ml_container --network host --cpuset-cpus="0"  -v ~/:/epvelasco --workdir=/epvelasco/Controller_Onboard/Servo_MPC_UAV_Acados acados_casadi_ml
