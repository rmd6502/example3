//
//  NSNumber+Laptime.m
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import "NSNumber+Laptime.h"

@implementation NSNumber (Laptime)

- (NSString *) formatLaptime
{
    NSTimeInterval tc = self.doubleValue;
    NSUInteger h,m,s,ms;
    h = floor(tc / 3600);
    tc -= h * 3600;
    m = floor(tc / 60);
    tc -= m * 60;
    s = floor(tc);
    ms = (tc - floor(tc)) * 1000;
    return [NSString stringWithFormat:@"%02d:%02d:%02d.%03d",
                              h,m,s,ms];
}

@end
