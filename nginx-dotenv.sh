#!/bin/sh

# BSD 2-Clause License
#
# Copyright (c) 2021, Fares Ahmed
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Export environment variables located at 'DOTENV' (defaults to '.env' in the
# current working directory). Errors are ignored such as:
# 'export: `...]': not a valid identifier'
export $(sed 's/\"//g;/^#/d' ${DOTENV:-.env} \
       | sed ':a;N;$!ba;s/\n/ /g') &> /dev/null

# Get the argument for '-c' from $* (All arguments chained together)
nginx_conf_path=$(echo $* | sed "/-c/s/.*-c \([^ ][^ ]*\)[ ]*.*/\1/")
# Get nginx.conf's file content
nginx_conf=`cat $nginx_conf_path`
         # $(<$nginx_conf_path) could be used but this
         # is only valid for 'bash', 'zsh'

# This while block replaces all matchs of '${STR_1}' with the
# environment variable inside '${...}'. Replaced with '' if
# the environment variable doesn't exist.
while [[ "$nginx_conf" =~ (\$\{[a-zA-Z_][a-zA-Z_0-9]*\}) ]] ; do
    LHS=${BASH_REMATCH[1]}
    RHS="$(eval echo "\"$LHS\"")"
    nginx_conf=${nginx_conf//$LHS/$RHS}
done

# Create a temporarily file to pass it to 'nginx -c ' argument
temp_conf=$(mktemp)
# The quotation marks are required to keep indentation and line
# breaks otherwise nginx throws unexpected end of file error
echo "$nginx_conf" >> $temp_conf

# Pass the temp_conf as the config file and all the other arguments passed
# to the script excluding '-c' and 'nginx_conf_path'.
nginx -c $temp_conf $(echo $* | sed "s/\-c//g;s/$nginx_conf_path//g")

# Remove the created temp_conf because too many files can be created when
# the script is used a lot since 'mktemp' does not delete temp files
# automatically. See also: https://linux.die.net/man/1/mktemp
rm $temp_conf

# For contributing or issues:
# https://github.com/FaresAhmedb/nginx-dotenv
