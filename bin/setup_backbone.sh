#!/bin/bash

EXTERNALS_PATH=externals
TOOLS_PATH=tools
SRC_PATH=client_src/js
MIN_PATH=client_min/js

if [ ! -d "client_src" ]
then
	echo "Usage: bin/setup_backbone.sh"
	echo "    Download and set up Backbone JavaScript Library."
	echo "    This script should be run from the root of the git repo."
	echo
	exit -1
fi

function __create_folder__ {
	FOLDER=$1
	TAB=$2
	if [ ! -d $FOLDER ]
	then
		echo "${TAB}Creating folder: $FOLDER"
		mkdir $FOLDER
	fi
}

function __setup_backbone__ {
	EXTERNALS_SUBPATH=$EXTERNALS_PATH/backbone-1.1.0
	TOOLS_SUBPATH=$TOOLS_PATH/backbone-1.1.0
	SYMLINK_SUBPATH=$TOOLS_PATH/backbone
	SYMLINK=backbone-1.1.0
	
	echo "# Downloading Backbone javascript library..."
	if [ ! -f "$EXTERNALS_SUBPATH/backbone-1.1.0.zip" ]
	then
		__create_folder__ $EXTERNALS_SUBPATH "    "
		curl --insecure --location https://github.com/jashkenas/backbone/archive/1.1.0.zip > $EXTERNALS_SUBPATH/backbone-1.1.0.zip

		echo "    Extracting Backbone license..."
		unzip $EXTERNALS_SUBPATH/backbone-1.1.0.zip backbone-1.1.0/LICENSE -d $EXTERNALS_SUBPATH &&\
			mv $EXTERNALS_SUBPATH/backbone-1.1.0/LICENSE $EXTERNALS_SUBPATH &&\
			rmdir $EXTERNALS_SUBPATH/backbone-1.1.0
	else
		echo "    Already downloaded: $EXTERNALS_SUBPATH/backbone-1.1.0.zip"
	fi
	echo

	echo "# Setting up Backbone..."
	if [ ! -d "$TOOLS_SUBPATH" ]
	then
		__create_folder__ $TOOLS_SUBPATH "    "
		echo "    Uncompressing Backbone..."
		unzip $EXTERNALS_SUBPATH/backbone-1.1.0.zip backbone-1.1.0/backbone.js -d $TOOLS_SUBPATH &&\
		unzip $EXTERNALS_SUBPATH/backbone-1.1.0.zip backbone-1.1.0/backbone-min.js -d $TOOLS_SUBPATH &&\
			mv $TOOLS_SUBPATH/backbone-1.1.0/backbone.js $TOOLS_SUBPATH &&\
			mv $TOOLS_SUBPATH/backbone-1.1.0/backbone-min.js $TOOLS_SUBPATH/backbone.min.js &&\
			rmdir $TOOLS_SUBPATH/backbone-1.1.0
		ln -s $SYMLINK $SYMLINK_SUBPATH
		ln -s ../../$SYMLINK_SUBPATH/backbone.js $SRC_PATH/backbone.js
		ln -s ../../$SYMLINK_SUBPATH/backbone.min.js $MIN_PATH/backbone.js
	else
		echo "    Already available: $TOOLS_SUBPATH"
	fi
	echo
}

__create_folder__ $EXTERNALS_PATH
__create_folder__ $TOOLS_PATH
__setup_backbone__
