//
//  GCRDPProcessor.m
//  GCRDPProcessor
//
//  Created by Matt Hawkins on 11/21/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import "GCRDPProcessor.h"

static const double EARTH_RADIUS_IN_METERS = 6373000.0;

@implementation GCRDPProcessor

-(NSArray *)douglasPeckerWithLocations:(NSArray *)locations andEpsilon:(double)epsilonInMeters
{
    double distanceMax = 0.0;
    NSUInteger currentIndex = 0;
    NSUInteger end = locations.count - 1;
    
    // Get the first and last locations
    CLLocation *startLocation = locations[currentIndex];
    CLLocation *endLocation = locations[end];
    
    for(NSUInteger index = 1; index < (end-1); index++)
    {
        CLLocation *currentLocation = locations[index];
        double distance = [self shortestDistanceToSegmentAtLocation1:startLocation toLocation2:endLocation fromPoint:currentLocation];
        if(distance > distanceMax)
        {
            currentIndex = index;
            distanceMax = distance;
        }
    }
    
    if(distanceMax > epsilonInMeters)
    {
        // Process the left of our pivot point
        NSArray *leftLocations = [locations subarrayWithRange:NSMakeRange(0, currentIndex+1)];
        NSArray *resultsLeft = [self douglasPeckerWithLocations:leftLocations andEpsilon:epsilonInMeters];
        
        // Process the right of our pivot point
        NSArray *rightLocations = [locations subarrayWithRange:NSMakeRange(currentIndex, locations.count - currentIndex)];
        NSArray *resultsRight = [self douglasPeckerWithLocations:rightLocations andEpsilon:epsilonInMeters];
        
        // Combine our results
        NSMutableArray *combinedMutableResults = [NSMutableArray array];
        
        // Don't duplicate our pivot point
        resultsLeft = [resultsLeft subarrayWithRange:NSMakeRange(0, resultsLeft.count-1)];
        [combinedMutableResults addObjectsFromArray:resultsLeft];
        [combinedMutableResults addObjectsFromArray:resultsRight];
        
        // Return immutable copy
        return [NSArray arrayWithArray:combinedMutableResults];
    }
    else
    {
        // Return only first and last points
        return @[startLocation, endLocation];
    }
}

-(double)shortestDistanceToSegmentAtLocation1:(CLLocation *)location1 toLocation2:(CLLocation *)location2 fromPoint:(CLLocation *)location3
{
    // Convert to coordinates
    CLLocationCoordinate2D point1 = location1.coordinate;
    CLLocationCoordinate2D point2 = location2.coordinate;
    CLLocationCoordinate2D point3 = location3.coordinate;
    
    // Calculate the deltas
    CLLocationDegrees deltaLatitude = point2.latitude - point1.latitude;
    CLLocationDegrees deltaLongitude = point2.longitude - point1.longitude;
    
    
    CLLocationDegrees u =   (
                             (point3.latitude - point1.latitude) *
                             (point2.latitude - point1.latitude) +
                             (point3.longitude - point1.longitude) *
                             (point2.longitude - point1.longitude)
                             ) /
    (
     pow(deltaLatitude, 2.0f) + pow(deltaLongitude, 2.0f)
     );
    
    // Keep u within a range of 0 to 1
    u = MIN(u, 1.0f);
    u = MAX(0.0f, u);
    
    // Calculate the latitude and longitude of our intersection coordinate
    CLLocationDegrees intersectionLatitude = point1.latitude + u * deltaLatitude;
    CLLocationDegrees intersectionLongitude = point1.longitude + u * deltaLongitude;
    
    // Haversine distance
    CLLocationDegrees haversineDeltaLongitude = point3.longitude - intersectionLongitude;
    double d = acos(
                    sin(point3.latitude) * sin(intersectionLatitude) +
                    cos(point3.latitude) * cos(intersectionLatitude) * cos(haversineDeltaLongitude)
                    ) * EARTH_RADIUS_IN_METERS;
    return d;
}

@end
