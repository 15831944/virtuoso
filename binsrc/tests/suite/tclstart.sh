#!/bin/sh
#
#  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
#  project.
#  
#  Copyright (C) 1998-2013 OpenLink Software
#  
#  This project is free software; you can redistribute it and/or modify it
#  under the terms of the GNU General Public License as published by the
#  Free Software Foundation; only version 2 of the License, dated June 1991.
#  
#  This program is distributed in the hope that it will be useful, but
#  WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#  General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License along
#  with this program; if not, write to the Free Software Foundation, Inc.,
#  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
#  
#  
PORT=${PORT-1111}
CLUSTER=yes
export CLUSTER
LOGFILE=tcl.output
export LOGFILE

SERVER=${SERVER-virtuoso-t}
case $SERVER in

  *virtuoso*)
	  echo Using virtuoso configuration | tee -a $LOGFILE
	  CFGFILE=virtuoso.ini
	  DBFILE=virtuoso.db
	  DBLOGFILE=virtuoso.trx
	  DELETEMASK="virtuoso.lck $DBLOGFILE $DBFILE virtuoso.tdb virtuoso.ttr"
	  SRVMSGLOGFILE="virtuoso.log"
	  TESTCFGFILE=virtuoso-1111.ini
          #TESTCFGFILEDS1=virtuoso-1111.ini
          #TESTCFGFILEDS2=virtuoso-1112.ini
	  BACKUP_DUMP_OPTION=+backup-dump
	  CRASH_DUMP_OPTION=+crash-dump

# only in that case
	  FOREGROUND_OPTION=+foreground
	  LOCKFILE=virtuoso.lck
	  export FOREGROUND_OPTION LOCKFILE
	  ;;
  *[Mm]2*)
	  echo Using M2 configuration | tee -a $LOGFILE
	  CFGFILE=wi.cfg
	  DBFILE=wi.db
	  DBLOGFILE=wi.trx
	  DELETEMASK="`ls wi.* witemp.* | grep -v wi.err`"
	  SRVMSGLOGFILE="wi.err"
	  TESTCFGFILE=witest.cfg
          #TESTCFGFILEDS1=witest.cfg
          #TESTCFGFILEDS2=witest.cfg
	  BACKUP_DUMP_OPTION=-d
	  CRASH_DUMP_OPTION=-D
	  unset FOREGROUND_OPTION
	  unset LOCKFILE
	  ;;

   *)
	  echo "***FAILED: Unknown server. Exiting" | tee -a $LOGFILE
	  exit 3;
	  ;;
esac

export CFGFILE DBFILE DBLOGFILE DELETEMASK SRVMSGLOGFILE #TESTCFGFILEDS1 TESTCFGFILEDS2
export BACKUP_DUMP_OPTION CRASH_DUMP_OPTION TESTCFGFILE SERVER

. $VIRTUOSO_TEST/testlib.sh
START_SERVER $PORT 1000
