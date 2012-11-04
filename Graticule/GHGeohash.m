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

-(NSUInteger)integerFromHexString:(NSString *)string {
    NSUInteger result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    
    [scanner setScanLocation:0]; // bypass '#' character
    [scanner scanHexInt:&result];
    
    return result;
}

- (CLLocationCoordinate2D)destinationForStartLocation:(CLLocationCoordinate2D)location date:(NSDate *)date {
    float dow = [self dowStartForDate:date];
    NSInteger latBase = floor(location.latitude);
    NSInteger lngBase = floor(location.longitude);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    NSString *md5 = [[NSString stringWithFormat:@"%@-%.2f", [dateFormat stringFromDate:date], dow] md5];
    NSString *part1 = [md5 substringWithRange:NSMakeRange(0, 16)];
    NSString *part2 = [md5 substringWithRange:NSMakeRange(15, 16)];
    
    NSUInteger int1 = [self integerFromHexString:part1];
    NSUInteger int2 = [self integerFromHexString:part2];
    
    CLLocationDegrees newLat = [[NSString stringWithFormat:@"%i.%i", latBase, int1] doubleValue];
    CLLocationDegrees newLng = [[NSString stringWithFormat:@"%i.%i", lngBase, int2] doubleValue];
    
    return CLLocationCoordinate2DMake(newLat, newLng);
}

@end
