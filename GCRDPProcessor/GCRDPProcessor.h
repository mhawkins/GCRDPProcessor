//
//  GCRDPProcessor.h
//  GCRDPProcessor
//
//  Created by Matt Hawkins on 11/21/13.
//  Copyright (c) 2013 Matt Hawkins. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface GCRDPProcessor : NSObject

-(NSArray *)douglasPeckerWithLocations:(NSArray *)locations andEpsilon:(double)epsilonInMeters;

-(double)shortestDistanceToSegmentAtLocation1:(CLLocation *)location1 toLocation2:(CLLocation *)location2 fromPoint:(CLLocation *)location3;


@end
