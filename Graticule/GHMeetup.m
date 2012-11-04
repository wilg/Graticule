//
//  GHMeetup.m
//  Graticule
//
//  Created by Wil Gieseler on 11/4/12.
//  Copyright (c) 2012 Wil Gieseler. All rights reserved.
//

#import "GHMeetup.h"

@interface GHMeetup() {
    CLLocationCoordinate2D _startLocation;
    NSDate *_date;
}

@end

@implementation GHMeetup

+(id)meetupForStartLocation:(CLLocationCoordinate2D)location date:(NSDate *)date {
    return [[[self class] alloc] initWithStartLocation:location date:date];
}

// Convenience method for today.
+(id)currentMeetupForStartLocation:(CLLocationCoordinate2D)location {
    return [[self class] meetupForStartLocation:location date:[NSDate date]];
}

-(id)initWithStartLocation:(CLLocationCoordinate2D)location date:(NSDate *)date {
    if (self = [super init]) {
        _startLocation = location;
        _date = date;
        self.destination = [self destinationForStartLocation:_startLocation date:_date];
    }
    return self;
}

- (CLLocationCoordinate2D)destinationForStartLocation:(CLLocationCoordinate2D)location date:(NSDate *)date {
    // Override in subclass.
    return location;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Meetup location: %f, %f", self.destination.latitude, self.destination.longitude];
}

@end
