#!/bin/bash
tppmktop \
	-s database \
	-u $MYSQL_USER \
	-p $MYSQL_PASSWORD \
	--sqldb $MYSQL_DATABASE \
	$@
