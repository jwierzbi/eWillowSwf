# eWillowSwf
Simple digital watch face for Garmin vívoactive® 3.

## Building

### Prerequisites

In Ubuntu 18.04 `connectiq` tool might not work due to newer version of
libpng. To fix that older version needs to be installed
(https://github.com/tcoopman/image-webpack-loader/issues/95):

    wget -q -O /tmp/libpng12.deb http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb \
        && dpkg -i /tmp/libpng12.deb \
        && rm /tmp/libpng12.deb

Also libwebkitgtk might be missing so:

    sudo apt install libwebkitgtk-1.0-0

Please do remember that Connect IQ SKD 2.4.9 (current stable version, at least
on 2018.08.05) requires JRE 8 and will not work with 9 or above.

To build the project and install it on the device also a developer key
needs to be created. This is explained here:
https://developer.garmin.com/connect-iq/programmers-guide/getting-started/.
After the key is created it should be placed in `other/developer_key`.

### Building

To build the app:

    make

To clean:

    make clean

To run the project open a second terminal and run:

    connectiq

and in project's directory:

    make run

### Installing

Connect your Garmin device via USB. It should appear as mass storage device.
Copy file `bin/eWillowSwf.prg` it's main directory. The watch face should be
installed automatically.
