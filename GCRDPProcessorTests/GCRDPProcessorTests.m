#import "Kiwi.h"
#import "GCRDPProcessor.h"

SPEC_BEGIN(GCRDPProcessorTests)

describe(@"An GCRDPProcessor", ^{
    GCRDPProcessor *rdpProcessor = [[GCRDPProcessor alloc] init];
    
    context(@"when processing an array of CLLocations", ^{
        
        // 10 kilometers
        double epsilon = 10000;
        
        // Route 30
        NSArray *locationsArray = @[
                                    [[CLLocation alloc] initWithLatitude:40.030662 longitude:-76.234261],
                                    [[CLLocation alloc] initWithLatitude:40.030744 longitude:-76.236439],
                                    [[CLLocation alloc] initWithLatitude:40.030613 longitude:-76.239057],
                                    [[CLLocation alloc] initWithLatitude:40.032223 longitude:-76.241407],
                                    [[CLLocation alloc] initWithLatitude:40.032683 longitude:-76.242909],
                                    [[CLLocation alloc] initWithLatitude:40.033587 longitude:-76.242759],
                                    [[CLLocation alloc] initWithLatitude:40.035460 longitude:-76.242898],
                                    [[CLLocation alloc] initWithLatitude:40.040306 longitude:-76.245569],
                                    [[CLLocation alloc] initWithLatitude:40.047008 longitude:-76.24999],
                                    [[CLLocation alloc] initWithLatitude:40.054342 longitude:-76.266158],
                                    ];
        
        // Simplified dataset
        NSArray *results = [rdpProcessor douglasPeckerWithLocations:locationsArray andEpsilon:epsilon];
        
        //
        it(@"has less points than our original dataset", ^{
            [[theValue(results.count < locationsArray.count) should] beTrue];
        });
        
        it(@"has at least two items", ^{
            [[theValue(results.count >= 2) should] beTrue];
        });
        
        pending_(@"remove points below epsilon", ^{
            CLLocation *firstLocation = results[0];
            CLLocation *secondLocation = results[1];
            CLLocation *lastLocation = results[results.count-1];
            
            double distance = [rdpProcessor shortestDistanceToSegmentAtLocation1:firstLocation toLocation2:lastLocation fromPoint:secondLocation];
            
            [[theValue(distance <= epsilon) should] beTrue];
        });
    });
    
    it(@"calculates a distance for a point from a line segement", ^{
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:0.0f longitude:0.0f];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:90.0f longitude:0.0f];
        CLLocation *location3 = [[CLLocation alloc] initWithLatitude:45.0f longitude:45.0f];
        
        double distance = [rdpProcessor shortestDistanceToSegmentAtLocation1:location1 toLocation2:location2 fromPoint:location3];
        
        // Return within 10 kilometer of true position
        [[theValue(distance) should] equal:3301000.0f withDelta:10000.0f];
        
    });
    
});

SPEC_END