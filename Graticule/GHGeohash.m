//
//  GHGeohash.m
//  Graticule
//
//  Created by Wil Gieseler on 11/4/12.
//  Copyright (c) 2012 Wil Gieseler. All rights reserved.
//

#import "GHGeohash.h"
#import "NSString+MD5.h"

@implementation GHGeohash

-(float)dowStartForDate:(NSDate *)date {
    return 13233.39;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];

    NSString *serverAddress = [NSString stringWithFormat:@"http://geo.crox.net/djia/%@", [dateFormat stringFromDate:date]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:serverAddress]
//                                                           cachePolicy: NSURLRequestUseProtocolCachePolicy
//                                                       timeoutInterval: 10];
//    [request setHTTPMethod: @"GET"];
//    
//    NSError *requestError;
//    NSURLResponse *urlResponse = nil;
//    
//    
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];

    NSString *dowString = [NSString stringWithContentsOfURL:[NSURL URLWithString:serverAddress] encoding:NSUTF8StringEncoding error:nil];
    return [dowString floatValue];
}

-(long double)decimalFractionFromHexadecimalFraction:(NSString *)hexFracPart {
    int fracLen = [hexFracPart length];
    int myLen = fracLen - 1;
    long double sum = 0;
    for (int i = 0; i < myLen; i++) {
        unsigned int numSixteenths;
        [[NSScanner scannerWithString:[hexFracPart substringWithRange:NSMakeRange(i, 1)]] scanHexInt:&numSixteenths];
        long double conversionFactor = (long double)1.0 / pow((long double)16, (long double)(i + 1));
        sum = sum + numSixteenths * conversionFactor;
    }
    return sum;
}

- (CLLocationCoordinate2D)destinationForStartLocation:(CLLocationCoordinate2D)location date:(NSDate *)date {
    float dow = [self dowStartForDate:date];
    long double latBase = floor(location.latitude);
    long double lngBase = floor(location.longitude);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    NSString *prehash = [NSString stringWithFormat:@"%@-%.2f", [dateFormat stringFromDate:date], dow];
    NSString *md5 = [prehash md5];

    NSString *part1 = [md5 substringWithRange:NSMakeRange(0, 16)];
    NSString *part2 = [md5 substringWithRange:NSMakeRange(16, 16)];

    long double decimalLat = [self decimalFractionFromHexadecimalFraction:part1];
    long double decimalLng = [self decimalFractionFromHexadecimalFraction:part2];
    
    if (latBase < 0)
        decimalLat = decimalLat * -1;
    if (lngBase < 0)
        decimalLng = decimalLng * -1;

    CLLocationDegrees newLat = latBase + decimalLat;
    CLLocationDegrees newLng = lngBase + decimalLng;
    
    return CLLocationCoordinate2DMake(newLat, newLng);
}

-(BOOL)sharesGraticuleWith:(GHMeetup *)meetup{
    if (!meetup)
        return NO;
    return floor(self.destination.latitude) == floor(meetup.destination.latitude) &&
           floor(self.destination.longitude) == floor(meetup.destination.longitude);
}

-(MKPolygon *)boundingPolygon {
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * 4);
    coords[0] = CLLocationCoordinate2DMake(floor(self.destination.latitude), floor(self.destination.longitude));
    coords[1] = CLLocationCoordinate2DMake(floor(self.destination.latitude), ceil(self.destination.longitude));
    coords[2] = CLLocationCoordinate2DMake(ceil(self.destination.latitude),  ceil(self.destination.longitude));
    coords[3] = CLLocationCoordinate2DMake(ceil(self.destination.latitude),  floor(self.destination.longitude));
    return [MKPolygon polygonWithCoordinates:coords count:4];
}

-(CLLocationCoordinate2D)topLeftCorner {
    return self.destination;
}

-(CLLocationCoordinate2D)coordinate {
    return self.destination;
}

-(NSString *)title {
    return @"Location";
}

-(NSString *)description {
    return [NSString stringWithFormat:@"Geohash location: %f, %f, Graticule: %i, %i", self.destination.latitude, self.destination.longitude, (int)floor(self.destination.latitude), (int)floor(self.destination.longitude)];
}

@end
