#!/usr/bin/env bash
sphinx-build -b html docs build
cp -r scripts/ build/
mv build rocdocs
# make latexpdf
scp -r rocdocs root@39.105.40.54:/var/www/html/docs/