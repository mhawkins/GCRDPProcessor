GCRDPProcessor
==============

A library that process an array of CLLocation objects using the Ramer-Douglas-Peucker algorithm.

Synopsis
========

Create a processor:
`GCRDPProcessor *rdpProcessor = [[GCRDPProcessor alloc] init];`

Pass it an array of CLLocation objects
`NSArray *locations = @[ [[CLLocation alloc] initWithLatitude:40.030744 longitude:-76.236439], .... ];
double episilonInMeters = 500.0;
NSArray *lessLocations = [rdpProcessor douglasPeckerWithLocations:locationsArray andEpsilon:episilonInMeters];
`

Note
====

Please note this library is using the Haversine formulate to calculate distance between CLLocation objects.