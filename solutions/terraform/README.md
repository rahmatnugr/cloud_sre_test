# Terraform directory for Solution 2

There are two subdirectories for terraform implementation of Solution 2, [/modules](/modules) and [/project](/project).

## [/modules](/solutions/terraform/modules) directory

This directory consist of terraform module for reusable component on this project. Each module will be used in project.

## [/project](/solutions/terraform/project) directory

This directory contains main infrastructure stack of Chatapp. Separated by it's part (core network, app cluster, distribution, etc.), each of the part should be executed with terraform command in order to make AWS infrastucture provisioned and configured properly.
