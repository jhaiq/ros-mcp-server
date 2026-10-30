# AGIROS loong (ROS 2 Humble-generation compatible) dev container.
# Built from the official 25.12 LTS apt repo — same package source as the
# docker.agiros.org.cn/agiros/agiros-loong-ubuntu-desktop-full image, which can
# be used as FROM instead when the AGIROS docker registry is reachable.
FROM ubuntu:22.04

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Add the official AGIROS 25.12 LTS repo (root-user variant of setup-client.sh)
RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg \
    && curl -fsSL http://repo.agiros.org.cn/debrepo/agiros/ubuntu2204lts/2512/agiros.gpg \
       | gpg --dearmor -o /usr/share/keyrings/agiros-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/agiros-archive-keyring.gpg] http://repo.agiros.org.cn/debrepo/agiros/ubuntu2204lts/2512 jammy main" \
       > /etc/apt/sources.list.d/agiros.list

# Install dev tools, ROS2 extras, git, Python and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-colcon-common-extensions \
    python3-vcstool \
    python3-pip \
    git \
    build-essential \
    agiros-loong-rosbridge-server \
    agiros-loong-desktop \
    agiros-loong-ros2launch \
    agiros-loong-ros2run \
    # GUI + X11/WSL2 compatibility
    x11-apps \
    libx11-xcb1 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 \
    libxcb-randr0 libxcb-render-util0 libxcb-xinerama0 \
    mesa-utils \
    libgl1-mesa-glx \
    libglu1-mesa \
    libxext6 \
    libxrender1 \
    libxrandr2 \
    libxi6 \
    && rm -rf /var/lib/apt/lists/*

# Ensure pip is accessible as `pip`
RUN ln -sf /usr/bin/pip3 /usr/bin/pip

# Dependency resolution on AGIROS uses `agirosdep` (not rosdep). It is not an
# apt package and is absent from base images — it ships with AGIROS deployment
# images. Run `agirosdep update` once before first use if available.

# Install Ruff, pre-commit, uv globally
RUN pip install --no-cache-dir ruff pre-commit uv

# Add non-root user for VSCode devcontainer
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Auto-source AGIROS loong for all users
RUN echo "source /opt/agiros/loong/setup.bash" >> /etc/bash.bashrc

# Set locale
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Ensure Qt apps can run
ENV QT_X11_NO_MITSHM=1
ENV QT_QPA_PLATFORM=xcb
ENV LIBGL_ALWAYS_SOFTWARE=1
ENV QT_XCB_GL_INTEGRATION=none

# Create a workspace for the non-root user
RUN mkdir -p /home/$USERNAME/workspace \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/workspace

# Set workspace directory
WORKDIR /home/$USERNAME/workspace

# Switch to non-root user by default in devcontainer
USER $USERNAME

# Allow pre-commit to run even if no config exists
ENV PRE_COMMIT_ALLOW_NO_CONFIG=1

RUN git init . \
    && pre-commit install --allow-missing-config || true
