# Basic instructions for setup of squeakroad

This project wraps the [squeakroad](https://github.com/yzernik/squeakroad) app for EmbassyOS.

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/tree/master/backend)
- [make](https://www.gnu.org/software/make/)

## Cloning

Clone the project locally. Note the submodule link to the original project(s).

```
git clone git@github.com:yzernik/squeakroad-wrapper.git
cd squeakroad-wrapper
git submodule update --init --recursive
docker run --privileged --rm tonistiigi/binfmt --install arm64,riscv64,arm
```

## Building

To build the project, run the following commands:

```
make
```

## Installing (on Embassy)

SSH into an Embassy device.
`scp` the `.s9pk` to any directory from your local machine.

```
scp squeakroad.s9pk root@<LAN ID>:/root
```

Run the following command to determine successful install:

```
embassy-cli auth login
embassy-cli package install squeakroad.s9pk
```
