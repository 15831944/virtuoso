--
--  $Id$
--
--  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
--  project.
--
--  Copyright (C) 1998-2006 OpenLink Software
--
--  This project is free software; you can redistribute it and/or modify it
--  under the terms of the GNU General Public License as published by the
--  Free Software Foundation; only version 2 of the License, dated June 1991.
--
--  This program is distributed in the hope that it will be useful, but
--  WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
--  General Public License for more details.
--
--  You should have received a copy of the GNU General Public License along
--  with this program; if not, write to the Free Software Foundation, Inc.,
--  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
--

-----------------------------------------------------------------------------
--
ODRIVE.WA.exec_no_error('
  create table ODRIVE.WA.GROUPS (
    USER_ID  integer references DB.DBA.SYS_USERS(U_ID) on delete cascade,
    GROUP_ID integer references DB.DBA.SYS_USERS(U_ID) on delete cascade,

    primary key (GROUP_ID)
  )
');

-----------------------------------------------------------------------------
--
ODRIVE.WA.exec_no_error('
  create table ODRIVE.WA.FOAF_GROUPS (
    FG_ID integer identity,
    FG_USER_ID integer not null,
    FG_NAME varchar not null,
    FG_DESCRIPTION long varchar,
    FG_WEBIDS long varchar,

    constraint FK_ODRIVE_FOAF_GROUPS_01 FOREIGN KEY (FG_USER_ID) references DB.DBA.SYS_USERS(U_ID) on delete cascade,

    primary key (FG_ID)
  )
');

AB.WA.exec_no_error ('
  create unique index SK_ODRIVE_FOAF_GROUPS_01 on ODRIVE.WA.FOAF_GROUPS (FG_USER_ID, FG_NAME)
');

-----------------------------------------------------------------------------
--
ODRIVE.WA.exec_no_error ('
  create table ODRIVE.WA.SETTINGS (
    USER_ID   integer references DB.DBA.SYS_USERS(U_ID) on delete cascade,
    USER_SETTINGS long varchar,

    PRIMARY KEY (USER_ID)
  )
');

ODRIVE.WA.exec_no_error ('
  create index SYS_USERS_HOME on DB.DBA.SYS_USERS (U_HOME)
');