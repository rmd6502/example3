//
//  ABWatchView.m
//  example3
//
//  Created by Robert Diamond on 7/22/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ABWatchView.h"

@interface ABWatchView () {
    double _subCount;
}

@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UIImageView *backgroundView;
@property (nonatomic) UIView *handView;
@property (nonatomic) UIImageView *handImageView;

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
        
        _handView = [[UIView alloc] initWithFrame:self.bounds];
        _handView.opaque = NO;
        _handView.backgroundColor = [UIColor clearColor];
        _handImageView = [[UIImageView alloc] initWithImage:[self _handImage]];
        _handView.frame = self.bounds;
        [_handView addSubview:_handImageView];
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
    _handImageView.image = [self _handImage];
    _handView.layer.contentsGravity = kCAGravityTop;
    [self setNeedsLayout];
}
- (void)setCount:(NSTimeInterval)count
{
    if (_count != count) {
        _count = count;
        NSUInteger hours = count/3600;
        count -= hours * 3600;
        NSUInteger mins = count/60;
        count -= mins * 60;
        _subCount = count;
        _handView.layer.affineTransform = CGAffineTransformMakeRotation(count * M_PI/30.0);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        return;
    }
    _backgroundView.frame = self.bounds;
    if (_count == 0) {
        _handView.frame = self.bounds;
        _handImageView.frame = CGRectMake((self.bounds.size.width - _handImageView.image.size.width)/2-.5, 35, _handImageView.image.size.width, _handImageView.image.size.height);
    }
    
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
        _handImageView.image = [self _handImage];
    }
}

- (void)setHandStrokeColor:(UIColor *)handStrokeColor
{
    if (_handStrokeColor != handStrokeColor) {
        _handStrokeColor = handStrokeColor;
        _handImageView.image = [self _handImage];
    }
}

- (UIImage *)_backgroundImage
{
    if (self.bounds.size.width == 0 || self.bounds.size.height == 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);

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
    inner.size.width /= 2.0f;
    inner.size.height /= 2.0f;
    CGFloat radius = floor(MIN(inner.size.width, inner.size.height)) - 20.0;
    inner.size.width = 7.0;
    inner.size.height = radius;

    UIGraphicsBeginImageContextWithOptions(inner.size, NO, 0.0);

    UIBezierPath *path = [UIBezierPath bezierPath];

    // start left of center
    [path moveToPoint:CGPointMake(0, radius)];
    [path addLineToPoint:CGPointMake(4.0,0.0)];
    [path addLineToPoint:CGPointMake(7.0, radius)];
    [path closePath];
    path.lineWidth = 1.0f;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [_handStrokeColor setStroke];
    [_handFillColor setFill];
    [path fill];
    [path stroke];
    
    path = [UIBezierPath bezierPath];
    [[UIColor yellowColor] setFill];
    [path addArcWithCenter:CGPointMake(inner.size.width/2, inner.size.height*.9) radius:2.0 startAngle:0 endAngle:M_PI * 2.0 clockwise:YES];
    [path fill];

    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ret;
}
@end
