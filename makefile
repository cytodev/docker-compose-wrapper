NAME=dockerw

PREFIX=/usr/local
BIN_DIR=${PREFIX}/bin
SHARE_DIR=${PREFIX}/share/${NAME}

.PHONY: install uninstall

install: uninstall
	mkdir -p ${BIN_DIR}
	install -m 755 ${NAME} ${BIN_DIR}/${NAME}
	mkdir -p ${SHARE_DIR}
	cp -r {config,containers,env,logs,shared} ${SHARE_DIR}
	find ${SHARE_DIR} -type d -exec chmod 755 {} +
	find ${SHARE_DIR} -type f -exec chmod 644 {} +
	find ${SHARE_DIR} -type f -executable -exec chmod +x {} +

uninstall:
	rm -f ${BIN_DIR}/${NAME}
	rm -rf ${SHARE_DIR}
