#!/bin/bash

python2 network.py --config_file config/fr-guo-id.cfg > saves/fr-guo-id/train.log

python2 network.py --config_file config/es-guo-id.cfg > saves/es-guo-id/train.log

python2 network.py --config_file config/pt-guo-id.cfg > saves/pt-guo-id/train.log

python2 network.py --config_file config/it-guo-id.cfg > saves/it-guo-id/train.log