# Digital DC/DC control

Modeling and design of the DC/DC power stage in e.g. Libre Solar charge controllers for improved control in nanogrid and/or MPPT applications.

## Discrete time model

**Purpose:** Layout of PID controller

This simulation is still work in progress. It is currently based on Matlab, but should be converted to GNU Octave in the future.

Some preliminary documentation of the approach can be found [here](http://learn.libre.solar/b/dc-control/development/digital_control.html).

## Firmware-in-the-loop model

**Purpose:** Co-simulation of controller firmware implementation (C/C++) and SPICE model

See `model` subfolder.

Based on: https://www.isotel.eu/mixedsim/embedded/motorforce/index.html#
