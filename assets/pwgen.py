#!/usr/bin/env python

#
# Copyright (C) 2015 ClassCat(R) Co.,Ltd. All rights reserved.
#

import os,sys

from IPython.lib import passwd

if len(sys.argv) != 2:
    sys.exit(-1)

pw = sys.argv[1].strip()

print(passwd(pw))

sys.exit(0)


### End of Script ###
