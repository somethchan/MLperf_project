docker run -it --gpus all \
  --cap-add=SYS_ADMIN \
  --security-opt seccomp=unconfined \
   f9e7195e2020 bash
