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
//    NSLog(@"------");
    float dow = [self dowStartForDate:date];
    long double latBase = floor(location.latitude);
    long double lngBase = floor(location.longitude);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];

    NSString *prehash = [NSString stringWithFormat:@"%@-%.2f", [dateFormat stringFromDate:date], dow];
//    NSLog(@"prehash: %@", prehash);
    NSString *md5 = [prehash md5];
//    NSLog(@"MD5: %@", md5);
    NSString *part1 = [md5 substringWithRange:NSMakeRange(0, 16)];
    NSString *part2 = [md5 substringWithRange:NSMakeRange(16, 16)];
//    NSLog(@"part1: %@", part1);
//    NSLog(@"part2: %@", part2);

    long double int1 = [self decimalFractionFromHexadecimalFraction:part1];
    long double int2 = [self decimalFractionFromHexadecimalFraction:part2];
//    NSLog(@"int1: %Lf", int1);
//    NSLog(@"int2: %Lf", int2);
    
    if (latBase < 0)
        int1 = int1 * -1;
    if (lngBase < 0)
        int2 = int2 * -1;

    CLLocationDegrees newLat = latBase + int1;
    CLLocationDegrees newLng = lngBase + int2;
    
    return CLLocationCoordinate2DMake(newLat, newLng);
}

@end
