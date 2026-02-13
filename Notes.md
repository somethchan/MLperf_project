*docker build [Dockerfile]* requires a directory <br>
  builds immutable images of Docker containers <br>
*docker images* or *docker image ls* to list built containers  <br>
*docker system prune --volumes* removes all 
  removes stopped containers and peripheral unused containers/volumes
*docker system prune -a --volumes* removes all container images
*docker buildx build <directory_path> -t <repo>:<tag> --load* builds with repo and tag listed for referencing and pruning. Loads single platform builds to Docker



buildx version warning: not important


