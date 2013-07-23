//
//  ABWatchView.h
//  example3
//
//  Created by Robert Diamond on 7/22/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABWatchView : UIView

@property (nonatomic) NSTimeInterval count;
@property (nonatomic) UIColor *outerCircleColor;
@property (nonatomic) UIColor *innerCircleColor;
@property (nonatomic) UIColor *tickColor;
@property (nonatomic) UIColor *handStrokeColor;
@property (nonatomic) UIColor *handFillColor;

@end
