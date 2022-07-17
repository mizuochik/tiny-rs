FROM rust AS rust
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
