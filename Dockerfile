FROM opensuse/leap:15.1
MAINTAINER Dario Maiocchi <dmaiocchi@suse.com>
LABEL Description="Image used to create a GitHub action worker"

ARG GH_VERSION=2.169.1
ENV TOKEN=foo

# Install global dependencies, this dependencies are needed
RUN zypper --non-interactive --gpg-auto-import-keys ar http://download.suse.de/ibs/SUSE:/CA/openSUSE_Leap_15.1/SUSE:CA.repo && \
    zypper --non-interactive install ca-certificates-suse unzip tar gzip hostname  git-core curl libicu && \
    zypper clean

# Install terraform  and libvirt provider 
# we install in this container terraform and terraform libvirt as an example this packages are not mandatory
RUN mkdir -p /home/ci/.terraform.d/plugins && \
    zypper ar http://download.opensuse.org/repositories/systemsmanagement:/terraform/openSUSE_Leap_15.1/ terraform-stable && \
    zypper --non-interactive --gpg-auto-import-keys ref && \
    zypper --non-interactive install libvirt libxslt-tools terraform-provider-libvirt terraform && \
    zypper clean



# configure agent of github

# the agent cannot be used as root so we create some user
RUN useradd -ms /bin/bash CI
USER CI
WORKDIR /home/CI

RUN curl -O -L https://github.com/actions/runner/releases/download/$GH_VERSION/actions-runner-linux-$GH_VERSION.tar.gz
RUN tar xzf ./actions-runner-linux-x64-$GH_VERSION.tar.gz



# todo I didnd't check with the ENV var, is on my todo list
RUN ./config.sh --url https://github.com/MalloZup/ha-sap-terraform-deployments --token $TOKEN --unattended \
    --name shap-github-worker01



RUN ./run.sh
~                                                                                                                                                                                                                  
~                         
