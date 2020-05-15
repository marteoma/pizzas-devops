#!/bin/bash
echo ECS_CLUSTER=${ecs_cluster} >> /etc/ecs/ecs.config
echo ECS_IMAGE_PULL_BEHAVIOR=always >> /etc/ecs/ecs.config
