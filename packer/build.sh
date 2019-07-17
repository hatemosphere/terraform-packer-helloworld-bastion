#!/usr/bin/env bash

set -e

function usage() {
    cat <<EOF
Usage: $0 [ec2ami]

Env Vars:

PACKER_BUILD_REF - Reference to use when tagging/naming build artifacts - Default: Current git commit SHA

ec2ami:

PACKER_AWS_REGION - AWS region
PACKER_AWS_VPC_ID - VPC ID (must be in configured region)
PACKER_AWS_SUBNET_ID - VPC Subnet ID (must be in configured region and VPC)
PACKER_AWS_SECURITY_GROUP_ID - VPC Security Group ID (must be in configured region and VPC)
PACKER_AWS_INSTANCE_TYPE - EC2 Instance type used to build AMI
EOF
    exit 1
}

command -v packer >/dev/null || {
    echo "ERROR: 'packer' executable not found. Download and install packer before continuing."
    exit 1
}
[[ -z ${PACKER_BUILD_REF+x} ]] || [[ ${PACKER_BUILD_REF} == "" ]] && export PACKER_BUILD_REF=$(git rev-parse --short HEAD)

if [[ $1 == "ec2ami" ]]; then
    [[ -z ${PACKER_AWS_REGION+x} ]] || [[ ${PACKER_AWS_REGION} == "" ]] && {
        echo "ERROR: 'PACKER_AWS_REGION' environment variable not defined"
        usage
    }
    [[ -z ${PACKER_AWS_SECURITY_GROUP_ID+x} ]] || [[ ${PACKER_AWS_SECURITY_GROUP_ID} == "" ]] && {
        echo "ERROR: 'PACKER_AWS_SECURITY_GROUP_ID' environment variable not defined"
        usage
    }
    [[ -z ${PACKER_AWS_SUBNET_ID+x} ]] || [[ ${PACKER_AWS_SUBNET_ID} == "" ]] && {
        echo "ERROR: 'PACKER_AWS_SUBNET_ID' environment variable not defined"
        usage
    }
    [[ -z ${PACKER_AWS_VPC_ID+x} ]] || [[ ${PACKER_AWS_VPC_ID} == "" ]] && {
        echo "ERROR: 'PACKER_AWS_VPC_ID' environment variable not defined"
        usage
    }
    shift 1
    packer build "$@" ./build.json
else
    usage
fi
