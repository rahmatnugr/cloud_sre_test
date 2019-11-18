[
  {
    "name": "${app_name}",
    "image": "${app_image}",
    "cpu": ${cpu},
    "memory": ${memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/cb-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "environment": [
      {
        "name": "APP_PORT",
        "value": "${app_port}"
      },
      {
        "name": "MYSQL_HOST",
        "value": "${mysql_host}"
      },
      {
        "name": "MYSQL_HOST_READONLY",
        "value": "${mysql_host_readonly}"
      },
      {
        "name": "MYSQL_USERNAME",
        "value": "${mysql_username}"
      },
      {
        "name": "MYSQL_PASSWORD",
        "value": "${mysql_username}"
      },
      {
        "name": "REDIS_HOST",
        "value": "${redis_host}"
      }
    ]
  }
]