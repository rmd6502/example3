//
//  NSNumber+Laptime.m
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import "NSNumber+Laptime.h"

@implementation NSNumber (Laptime)

- (NSString *) formatLaptimeWithDigits:(NSUInteger)digits
{
    NSTimeInterval tc = self.doubleValue;
    NSUInteger h,m,s,ms;
    NSUInteger pow = 1;
    for (int i=0; i < digits; ++i) {
        pow *= 10;
    }
    h = floor(tc / 3600);
    tc -= h * 3600;
    m = floor(tc / 60);
    tc -= m * 60;
    s = floor(tc);
    tc -= s;
    ms = floor(tc * pow);
    return [NSString stringWithFormat:@"%02d:%02d:%02d.%0*d",
                              h,m,s,digits,ms];
}

@end
