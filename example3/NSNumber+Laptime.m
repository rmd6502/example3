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
    NSUInteger h,m;
    h = floor(tc / 3600);
    tc -= h * 3600;
    m = floor(tc / 60);
    tc -= m * 60;
    return [NSString stringWithFormat:@"%02d:%02d:%02.*f",
                              h,m,digits,tc];
}

@end
