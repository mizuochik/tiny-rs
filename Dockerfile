FROM rust AS rust
RUN rustup target add x86_64-unknown-linux-musl
RUN rustup target add aarch64-unknown-linux-musl
WORKDIR /build
COPY . ./
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=target \
    TARGET=$(uname -m)-unknown-linux-musl \
    && cargo build --release --target $TARGET \
    && mv target/$TARGET/release/tiny-rs /tmp

FROM alpine
WORKDIR /app
COPY --from=rust /tmp/tiny-rs .
ENTRYPOINT [ "/app/tiny-rs" ]
