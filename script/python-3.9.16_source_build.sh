#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
WHITE_BOLD='\033[1;37m'
LIGHT_GREY='\033[0;90m'
NC='\033[0m'

# Define paths
PYTHON_TAR="Python-3.9.16.tgz"
PYTHON_DIR=${PYTHON_TAR%.tgz}

# Helper function to install package
install_package() {
    local package=$1

    printf "${WHITE_BOLD}Installing ${package}...${NC}\n"

    if yum install -y "$package" &>/dev/null; then
        printf "${LIGHT_GREY}${package} installed successfully.${NC}\n"
    else
        printf "${RED}Failed to install ${package}.${NC}\n"
        exit 1
    fi
}

# Helper function to check and install package
check_and_install_package() {
    local package=$1

    printf "${WHITE_BOLD}Checking for ${package}...${NC}\n"

    if yum list installed "$package" &>/dev/null; then
        printf "${LIGHT_GREY}${package} is already installed.${NC}\n"
    else
        install_package "$package"
    fi
}

# Check if Development Tools package is installed
check_and_install_package "Development Tools"

# Check for dependencies
packages=("openssl-devel" "bzip2-devel" "libffi-devel")
for package in "${packages[@]}"; do
    check_and_install_package "$package"
done

# Check gcc version
check_and_install_package "gcc"

printf "${WHITE_BOLD}Extracting Python binaries...${NC}\n"
# Extract Python source
if tar -xvf $PYTHON_TAR |& tee /dev/tty; then
    printf "${LIGHT_GREY}Extraction completed successfully.${NC}\n"
else
    printf "${RED}Extraction failed.${NC}\n"
    exit 1
fi

if [ ! -d "$PYTHON_DIR" ]; then
    printf "${RED}Python source directory does not exist. Exiting...${NC}\n"
    exit 1
fi

cd $PYTHON_DIR

# Configure Python build
printf "${WHITE_BOLD}Configuring Python build...${NC}\n"
if ! ./configure --enable-optimisations; then
    printf "${RED}Python configuration failed. Exiting...${NC}\n"
    exit 1
fi

# Compile Python
printf "${WHITE_BOLD}Compiling Python with altinstall...${NC}\n"
if ! make altinstall; then
    printf "${RED}Python compilation failed. Exiting...${NC}\n"
    exit 1
fi

# Check python
printf "${WHITE_BOLD}Checking Python version...${NC}\n"
${PYTHON_DIR}/python --version

# Check for any errors in checking python version
if [ $? -ne 0 ]; then
    printf "${RED}Error while checking Python version. Exiting...${NC}\n"
    exit 1
fi
printf "${GREEN}===> Python compiled and installed successfully! <===${NC}\n"
