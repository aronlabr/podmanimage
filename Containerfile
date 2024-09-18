FROM docker.io/library/node:22.9.0-alpine3.20

RUN apk --no-cache upgrade \
    && apk --no-cache add bash curl git inotify-tools unzip

# # NodeJS
# ARG NODE_VERSION=22
# ARG FNM_DIR=/opt/fnm
# ARG FNM_INTERACTIVE_CLI=false
# ENV PATH=${FNM_DIR}:${PATH}
# RUN mkdir -p ${FNM_DIR} \
#     && curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir $FNM_DIR --skip-shell \
#     && ln -s $FNM_DIR/fnm /usr/bin/ && chmod +x /usr/bin/fnm \
#     && eval(`fnm env`) \
#     && fnm install $NODE_VERSION \
#     && fnm alias default $NODE_VERSION \
#     && fnm use default \
#     && node --version

RUN rm -rf /tmp/* /var/cache/apk/* /tmp/common-setup.sh /tmp/node-setup.sh

RUN curl -fsSL https://get.pnpm.io/install.sh | sh -
ENV PATH="/root/.local/share/pnpm:$PATH"
RUN pnpm --version

ENV APP_HOME=/app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN git clone https://github.com/containers/podman-desktop.git $APP_HOME

RUN pnpm install

CMD ["pnpm", "watch"]