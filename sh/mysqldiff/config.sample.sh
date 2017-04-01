#!/bin/bash
export PATH=$PATH:/opt/mysql/bin/mysql:/usr/local/bin
src="-h HOST -P PORT -u USER -pPASSWORD_OR_BLANK DB_NAME"
dst="-h HOST -P PORT -u USER -pPASSWORD_OR_BLANK DB_NAME"
worker="-h HOST -P PORT -u USER -p PASSWORD_OR_BLANK"
