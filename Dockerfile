# Use ROS Noetic as base image
FROM ros:noetic-ros-core-focal

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Set the working directory inside the container
WORKDIR /root

# Install necessary packages and system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    build-essential \
    cmake \
    ros-noetic-catkin \
    ros-noetic-roscpp \
    ros-noetic-geometry-msgs \
    ros-noetic-sensor-msgs \
    ros-noetic-std-msgs \
    ros-noetic-message-generation \
    ros-noetic-message-runtime \
    ros-noetic-velodyne-pointcloud \
    ros-noetic-nodelet \
    ros-noetic-dynamic-reconfigure \
    ros-noetic-grid-map-core \
    ros-noetic-grid-map-ros \
    ros-noetic-grid-map-cv \
    ros-noetic-grid-map-loader \
    ros-noetic-grid-map-msgs \
    ros-noetic-grid-map-rviz-plugin \
    ros-noetic-grid-map-visualization \
    ros-noetic-cv-bridge \
    ros-noetic-pcl-ros \
    && rm -rf /var/lib/apt/lists/*

# Install RViz and other visualization dependencies
RUN apt-get update && apt-get install -y \
    ros-noetic-rviz \
    ros-noetic-rqt \
    ros-noetic-rqt-common-plugins \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /root/groundgrid/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Setup ROS environment (source ROS setup script)
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

# Install catkin_tools for catkin build
RUN apt-get update && apt-get install -y python3-catkin-tools