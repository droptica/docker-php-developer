#!/usr/bin/python

import sys
import subprocess

if len(sys.argv) == 4:
    docker_image = sys.argv[1]
    test = sys.argv[2]
    expected = sys.argv[3]
else:
    sys.exit("3 arguments expected. 1. docker image 2. test type (php/apache2/xdebug/xhprof) 3. expected output value")

if test == 'apache2':
    bashCommand = "docker run {} dpkg --get-selections".format(docker_image)
    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
    output, error = process.communicate()
    if error:
        sys.exit('Docker process did not execute correctly. Error: {}'.format(error))
    else:
        installed = False
        lines = output.split('\n')
        for line in lines:
            sanitized = line[:-7].rstrip()
            if expected == sanitized:
                installed = True
                print("{} found!".format(expected))
        if installed is not True:
            sys.exit('{} not installed'.format(expected))

if test == 'php':
    bashCommand = "docker run {} php --version".format(docker_image)
    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
    output, error = process.communicate()
    if error:
        sys.exit('Docker process did not execute correctly. Error: {}'.format(error))
    else:
        installed = False
        lines = output.split('\n')
        if expected == lines[0][:7]:
            installed = True
            print("{} found!".format(expected))
        if installed is not True:
            sys.exit('{} not installed'.format(expected))

if test == 'php-extension':
    bashCommand = "docker run {} php -m -c".format(docker_image)
    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
    output, error = process.communicate()
    if error:
        sys.exit('Docker process did not execute correctly. Error: {}'.format(error))
    else:
        installed = False
        lines = output.split('\n')
        for line in lines:
            sanitized = line.rstrip()
            if expected == sanitized:
                installed = True
                print("{} found!".format(expected))
        if installed is not True:
            sys.exit('{} not installed'.format(expected))