//
//  GHMeetup.h
//  Graticule
//
//  Created by Wil Gieseler on 11/4/12.
//  Copyright (c) 2012 Wil Gieseler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GHMeetup : NSObject
@property CLLocationCoordinate2D destination;

// Locate a meetup for a given date.
+(id)meetupForStartLocation:(CLLocationCoordinate2D)location date:(NSDate *)date;

// Convenience method for today.
+(id)currentMeetupForStartLocation:(CLLocationCoordinate2D)location;

-(id)initWithStartLocation:(CLLocationCoordinate2D)location date:(NSDate *)date;

@end
