FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
# Install some utilities
RUN apt-get update && apt-get install -y -q --no-install-recommends \
    build-essential \
    cmake \
    less \
    git \
    wget \
    vim \
    bzip2 \
    libsm6 \
    libboost-all-dev \
    ocl-icd-libopencl1 \
    nvidia-opencl-dev \
    opencl-headers \
    clinfo \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

ENV DEBIAN_FRONTEND=

WORKDIR /dock

ENV GPU_INCLUDE_PATH /usr/local/cuda/include
ENV GPU_LIBRARY_PATH /usr/local/cuda/lib64

# Install OpenCL
RUN mkdir -p /etc/OpenCL/vendors/
RUN echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# Install Autodock-GPU
RUN git clone https://github.com/ccsb-scripps/AutoDock-GPU ; cd AutoDock-GPU ; make DEVICE=GPU NUMWI=128


# Install Vina-GPU-2.1
RUN cd /dock/ ; ls
RUN git clone https://github.com/ashtawy/Vina-GPU-2.1.git ; cd Vina-GPU-2.1 ; tar -zxvf partial_boost_1_84.tar.gz
RUN pwd ; cd /dock/QuickVina-W-GPU-2.1/ ; pwd ; make clean ; ls ; make source ; make
RUN pwd ; cd /dock/QuickVina2-GPU-2.1/ ; pwd ; make clean ; ls ; make source ; make
RUN pwd ; cd /dock/AutoDock-Vina-GPU-2.1/ ; pwd ; make clean ; ls ; make source ; make

# Build and run
# docker build -t vinagpu .
# docker run -it --gpus all vinagpu bash # ls /dock/QuickVina-W-GPU-2.1/