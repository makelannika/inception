#!/bin/sh
# Simple check if PHP-FPM is running
if pgrep php-fpm82 > /dev/null; then
    exit 0
else
    exit 1
fi
