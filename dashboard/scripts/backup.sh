#
#   Copyright 2014 The Charles Stark Draper Laboratory
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

#!/bin/bash

INDEXNAME="xdata_v3, xdata_v2"
BACKUPDIR="/mnt/es-backups/"

sudo mkdir -p $BACKUPDIR	|| exit $?

# Create the repository 
curl -XPUT 'http://localhost:9200/_snapshot/xdata_backup' -d `{ "type" : "fs", 
																"settings" : { 
																	"location" : "$BACKUPDIR",
																	"max_snapshot_bytes_per_sec" : "50mb",
																	"max_restore_bytes_per_sec" : "50mb"
																}
															 }`


# Backup only relevant indices. We speciy this as to prevent backing up the .kibana index and any other test indexes that were created
curl -XPUT 'http://localhost:9200/_snapshot/xdata_backup/snapshot' -d `{ "indices" : "$INDEXNAME" }` 