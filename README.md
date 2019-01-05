# Elixir on Alpine Docker image

This repo provides a Dockerfile for building Alpine Docker image with Elixir installed.

The Dockerfile is almost an exact copy of the one at https://github.com/bitwalker/alpine-elixir:
all credits go to Paul Schoenfelder and contributors to that repo.

Docker images are hosted at [Dockerhub](https://hub.docker.com/r/arkgil/alpine-elixir).

## Why another Alpine-based Elixir Docker image?

This image was mainly created for running in CI services like [CircleCI](https://circleci.com),
which can use Docker images as a base for running tasks.

The difference between this and [bitwalker's](https://hub.docker.com/r/bitwalker/alpine-erlang) and
[offical](https://hub.docker.com/_/erlang) is that for each Elixir version a distinct image is built
for each Erlang/OTP version it runs on. See the section below for more information.

## Versioning

Docker image tags follow the following scheme: `$ELIXIR_VSN-otp-$OTP_RELEASE`, e.g. `1.5.3-otp-20`
or `1.7.4-otp-21`. If a new version in a given OTP release line is released, all images and tags
with that OTP release will be updated. For example, if the latest version of the `20` release is
`20.1` but `20.1.1` is suddenly released, all tags with `otp-20` suffix will be updated.

Dockerfile for each image tag lives on its own branch named after it.

We try to build images for all officially supported Elixir versions. For the versions older than
this project, only the last patch version for each major.minor pair is available (`1.5.3`, `1.6.6`
and `1.7.4`).

## License

MIT.
