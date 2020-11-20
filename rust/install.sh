#!/bin/sh -e

curl -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y

rustup override set stable
rustup update stable
