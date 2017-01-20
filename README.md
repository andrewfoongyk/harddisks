# harddisks

Introduction

This is a simple molecular dynamics simulator created to study the statistical properties of ideal gases. It simulates a collection of atoms in a box in 2 dimensions that behaves as hard disks colliding elastically with the walls and each other.


How to use the simulator

Open the file 'harddisks_main.m'. First set the parameters of the model. The size of the box should be left unchanged. The number of hard disks in the simulation and the size of the disks can be varied. The number should be a perfect square for the default initial conditions to work. The variable 'I' controls the number of iterations that will be simulated, that is the number of collisions to be simulated before the program halts. The variable 'dt' determines how smooth the playback of the simulation will be. This does not effect the simulation itself, but only the playback afterwards - a smaller value of dt will lead to a smoother playback.

Next the initial conditions can be set. By default, the disks all begin in the left half of the box in a uniform grid. The directions of the velocities of the disks are chosen randomly but the magnitude is set to the variable s, which can be adjusted. Alternatively, you can set your own initial conditions. The array r(disk number, dimension, iteration) can be set manually. For instance r(20,2,1) will set the y-coordinate (2) of the 20th disk in the simulation at iteration 1 (that is, the initial condition). Similar rules apply for the array rdot.

Next there are several pieces of information that can be displayed after the simulation is complete. By default, a slideshow of the disks moving in the box will be shown. The rest are commented out by default. The other items that can be displayed include a slideshow of the instantaneous velocity, speed and energy histograms of the disks (the speed histograms could be compared with the Maxwell-Boltzmann distribution), and a view of the evolution of the system in velocity space.

After setting all the parameters and initial conditions, the program will simulate the system for I iterations. The progress in iteration number will be displayed. When the simulation is complete, press any key to begin playing the slideshows. A measure of the 'pressure' of the gas is also displayed, which can be used to test the ideal gas relation.


Principles of Operation

This simulator uses an events driven approach to calculate the time evolution of the system. In the event driven approach, after each event (such as the collision between two discs or a collision between a disc and the wall of the container) the velocities and positions of all particles are updated. The details of the algorithm are taken from Krauth, Statistical mechanics: algorithms and computations. OUP Oxford, 2006. 

After each event, the time taken for every pair of particles to collide (assuming that they were the only two particles in existence) and the time taken for each particle to collide with one of the walls of the container (assuming that no other particles existed) is calculated. These represent ‘possible events’. Out of all these possible events, the possible event corresponding to the shortest time taken is identified as the actual event that will occur next. Once this event is identified, the resultant effect on the velocities is computed. For example, if the next event is a pair collision, the new velocities for the discs that collide are computed. All other velocities are left unchanged. The positions of the particles are then updated by projecting them forward along their trajectories using the knowledge of their velocities and the time interval between events.




