#install nvidia cuda toolkit
sudo apt-get install nvidia-cuda-toolkit 

#update g++ for cuda compilation
sudo apt-get install gcc-4.6 g++-4.6 gcc-4.6-multilib g++-4.6-multilib

#install atlas
sudo apt-get install libatlas-base-dev

#install other dependencies
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libboost-all-dev libhdf5-serial-dev
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler

#install python related dependencies prerequisite
sudo apt-get install python-dev python-pip

#install anaconda (optional)
#wget http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-2.0.1-Linux-x86_64.sh
#sudo bash Anaconda-2.0.1-Linux-x86_64.sh

#install python requirements
sudo apt-get install gfortran python-numpy python-matplotlib
sudo pip install -r ./python/requirements.txt


# settings 
echo "*****************************************************"
echo "IMPORTANT!!! Set CUDA_DIR=/usr CUSTOM_CXX=/usr/bin/g++-4.6 in Makefile.config"
echo "You may wish to add below line into your ~/.bashrc:"
echo "export PYTHONPATH=/path/to/caffe/python:\$PYTHONPATH"

#install matlab

