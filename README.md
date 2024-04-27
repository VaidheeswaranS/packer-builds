# packer-builds

- first created the `vaidhee-rg` and `vaidhee-shared-rg` resource group

- comment out the code block for `Built for 200 and FA` in the file `image-build.yml`

- run the github action with `build-baseline-image` and `build-generalized-image` option alone checked in

- check if the above action is successfully completed

- un-comment the `Built for 200 and FA` code block and comment out the code block for `Built for Shared Image Gallery for both Baseline and Generelized` in the file `image-build.yml`

- run the github action with `build-image` and `deploy-vm` option alone checked in

- check if the above action is successfully completed