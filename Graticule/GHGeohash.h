//
//  GHGeohash.h
//  Graticule
//
//  Created by Wil Gieseler on 11/4/12.
//  Copyright (c) 2012 Wil Gieseler. All rights reserved.
//

#import "GHMeetup.h"
#import <MapKit/MapKit.h>

@interface GHGeohash : GHMeetup <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString* title;

-(MKPolygon *)boundingPolygon;
-(BOOL)sharesGraticuleWith:(GHMeetup *)meetup;

@end
