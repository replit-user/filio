#!/bin/bash

# Install filio library

git https://github.com/replit-user/filio ./tmp
cd tmp/build

# Copy the shared library to /usr/local/lib (preferred over /usr/lib)
sudo cp filio-linux.so /usr/local/lib/filio.so

# Update linker cache
sudo ldconfig

cd ../include

# Copy header to /usr/local/include/filio/ so user can do #include <filio/filio.hpp>
sudo mkdir -p /usr/local/include/filio
sudo cp filio.hpp /usr/local/include/filio/

cd ../..
rm -rf tmp

echo "Filio successfully installed"