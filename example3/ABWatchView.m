//
//  ABWatchView.m
//  example3
//
//  Created by Robert Diamond on 7/22/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import "ABWatchView.h"

@interface ABWatchView ()

@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) UIImageView *handView;

@end

@implementation ABWatchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _innerCircleColor = [UIColor lightGrayColor];
        _outerCircleColor = [UIColor whiteColor];
        _tickColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor blackColor];
        _handFillColor = [UIColor darkGrayColor];
        _handStrokeColor = [UIColor whiteColor];
        
        _backgroundView = [[UIImageView alloc] initWithImage:[self _backgroundImage]];
        _backgroundView.frame = self.bounds;
        
        _handView = [[UIImageView alloc] initWithImage:[self _handImage]];
        _handView.frame = self.bounds;
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        [self addSubview:_backgroundView];
        [self addSubview:_handView];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _backgroundView.image = [self _backgroundImage];
    _handView.image = [self _handImage];
    [self setNeedsLayout];
}
- (void)setCount:(NSTimeInterval)count
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        return;
    }
    _backgroundView.frame = self.bounds;
    _handView.frame = CGRectMake(0, 0, _handView.image.size.width, _handView.image.size.height);
}

- (void)setInnerCircleColor:(UIColor *)innerCircleColor
{
    if (_innerCircleColor != innerCircleColor) {
        _innerCircleColor = innerCircleColor;
        _backgroundView.image = [self _backgroundImage];
    }
}

- (void)setOuterCircleColor:(UIColor *)outerCircleColor
{
    if (_outerCircleColor != outerCircleColor) {
        _outerCircleColor = outerCircleColor;
        _backgroundView.image = [self _backgroundImage];
    }
}

- (void)setTickColor:(UIColor *)tickColor
{
    if (_tickColor != tickColor) {
        _tickColor = tickColor;
        _backgroundView.image = [self _backgroundImage];
    }
}

- (void)setHandFillColor:(UIColor *)handFillColor
{
    if (_handFillColor != handFillColor) {
        _handFillColor = handFillColor;
        _handView.image = [self _handImage];
    }
}

- (void)setHandStrokeColor:(UIColor *)handStrokeColor
{
    if (_handStrokeColor != handStrokeColor) {
        _handStrokeColor = handStrokeColor;
        _handView.image = [self _handImage];
    }
}

- (UIImage *)_backgroundImage
{
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContext(self.bounds.size);

    // add a thick circle
    CGRect outer = self.bounds;
    outer.origin.x += 3.0f;
    outer.origin.y += 3.0f;
    outer.size.height -= 6.0f;
    outer.size.width -= 6.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:outer];
    path.lineWidth = 3.0f;
    [_outerCircleColor setStroke];
    [path stroke];

    // add a thinner circle within
    CGRect inner = outer;
    inner.origin.x += 4.0f;
    inner.origin.y += 4.0f;
    inner.size.height -= 8.0f;
    inner.size.width -= 8.0f;
    path = [UIBezierPath bezierPathWithOvalInRect:inner];
    path.lineWidth = 1.0f;
    [_innerCircleColor setStroke];
    [path stroke];

    inner.origin.x += 5.0f;
    inner.origin.y += 5.0f;
    inner.size.height -= 10.0f;
    inner.size.width -= 10.0f;

    CGFloat xSize = inner.size.width / 2.0f;
    CGFloat ySize = inner.size.height / 2.0f;
    // TODO: this fudge factor compensates for the line widths - figure out why
    CGFloat xOffset = xSize + 11.0f;
    CGFloat yOffset = ySize + 11.0f;
    CGFloat radiansPerTick = 2.0f * M_PI / 180;

    for (int tickNumber = 0; tickNumber < 180; ++tickNumber) {
        path = [UIBezierPath bezierPath];
        CGFloat x = xSize * cos(radiansPerTick * tickNumber);
        CGFloat y = ySize * sin(radiansPerTick * tickNumber);
        
        [path moveToPoint:CGPointMake(xOffset + ceil(x), yOffset + ceil(y))];
        [path addLineToPoint:CGPointMake(xOffset + ceil(0.85f * x), yOffset + ceil(0.85f * y))];
        if ((tickNumber % 3) == 0) {
            path.lineWidth = 2.0f;
        } else {
            path.lineWidth = 1.0f;
        }
        [_tickColor setStroke];
        [path stroke];
    }

    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}

- (UIImage *)_handImage
{
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        return nil;
    }
    CGRect inner = self.bounds;
    CGFloat xOffset = inner.size.width / 2.0f;
    CGFloat yOffset = inner.size.height / 2.0f;
    CGFloat radius = floor((MIN(xOffset,yOffset) - 24.0));
    inner.size.height = radius + 10.0;
    inner.size.width = radius + 10.0;
    xOffset = inner.size.width / 2.0f;
    yOffset = inner.size.height / 2.0f;

    UIGraphicsBeginImageContext(inner.size);

    UIBezierPath *path = [UIBezierPath bezierPath];

    // start left of center
    [path moveToPoint:CGPointMake(xOffset-3.0f, yOffset + 10.0)];
    [path addLineToPoint:CGPointMake(xOffset,yOffset - radius - 10.0)];
    [path addLineToPoint:CGPointMake(xOffset+3.0f, yOffset+10.0)];
    [path closePath];
    path.lineWidth = 1.0f;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [_handStrokeColor setStroke];
    [_handFillColor setFill];
    [path fill];
    [path stroke];

    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}
@end
