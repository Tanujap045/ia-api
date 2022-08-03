FROM mhart/alpine-node:14

RUN yarn global add @prisma/cli@2.13.0 \
    && yarn cache clean --all \
    && rm -rf /root/.cache \
    && rm -rf /tmp/v8-* \
    && rm -rf /usr/local/share/.config/yarn/global/node_modules/@prisma/engines/intro* \
    && rm -rf /usr/local/share/.config/yarn/global/node_modules/@prisma/engines/prisma-fmt* \
    && rm -rf /usr/local/share/.config/yarn/global/node_modules/@prisma/engines/query* \
    && rm -rf /usr/local/share/yarn

WORKDIR /db

COPY . .

CMD ["prisma", "migrate", "deploy", "--schema", "/db/schema.prisma", "--preview-feature"]
