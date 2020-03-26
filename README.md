# Digital DC/DC control

Modeling and design of the DC/DC power stage in e.g. Libre Solar charge controllers for improved control in nanogrid and/or MPPT applications.

## Control model and analysis

**Purpose:** Layout of PID controller

This model is developed using GNU Octave (similar to Matlab).

Some preliminary documentation of the control strategy can be found [here](http://learn.libre.solar/b/dc-control/development/digital_control.html).

## Firmware-in-the-loop model

**Purpose:** Co-simulation of controller firmware implementation (C/C++) and Ngspice model

See `ngspice` subfolder.

Based on: https://www.isotel.eu/mixedsim/embedded/motorforce/index.html#
