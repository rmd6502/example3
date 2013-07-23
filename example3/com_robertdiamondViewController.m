//
//  com_robertdiamondViewController.m
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import "ABWatchView.h"
#import "com_robertdiamondViewController.h"
#import "LaptimeDataSource.h"
#import "NSNumber+Laptime.h"
#import "SecondViewController.h"

#define BUTTON_TOP_OFFSET 20
#define BUTTON_TO_LABEL_OFFSET 20
#define BUTTON_TO_CLOCK_OFFSET 40
#define BUTTON_TO_BUTTON_SPACING 60
#define LABEL_LEFT_OFFSET 30
#define CLOCK_LEFT_OFFSET 10
#define NS_PER_SECOND (1E9)
#define COUNT_RESOLUTION (.01f)

@interface com_robertdiamondViewController ()

@property (nonatomic) dispatch_queue_t timerq;
@property (nonatomic) dispatch_source_t timer;
@property (nonatomic) LaptimeDataSource *lapTimes;
@property (nonatomic) UIBarButtonItem *lapButton;
@property (nonatomic) ABWatchView *watchView;

@end

@implementation com_robertdiamondViewController

- (id) init
{
    self = [super init];
    if (self) {
        _timerq = dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL);
        _lapTimes = [LaptimeDataSource new];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_pressMe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _pressMe.titleLabel.font = [UIFont fontWithName:@"GRAFFITI" size:20.0];
    [_pressMe setTitle:NSLocalizedString(@"Press Me!", @"") forState:UIControlStateNormal];
    [_pressMe setTitle:NSLocalizedString(@"Let Go!", @"") forState:UIControlStateHighlighted];
    [_pressMe setTitleShadowColor:[UIColor redColor] forState:UIControlStateNormal];
    [_pressMe sizeToFit];
    [_pressMe addTarget:self action:@selector(_buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _resetButton.titleLabel.font = [UIFont fontWithName:@"GRAFFITI" size:20.0];
    [_resetButton setTitle:NSLocalizedString(@"Reset", @"") forState:UIControlStateNormal];
    [_pressMe setTitleShadowColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(_reset) forControlEvents:UIControlEventTouchUpInside];
    [_resetButton sizeToFit];
    
    _displayCount = [UILabel new];
    _displayCount.backgroundColor = [UIColor blackColor];
    _displayCount.textColor = [UIColor whiteColor];
    _displayCount.text = @"You haven't pressed the button yet...";
    _displayCount.font = [UIFont fontWithName:@"AndroidClock_Solid" size:16.0];
    _displayCount.textAlignment = NSTextAlignmentCenter;
    [_displayCount sizeToFit];

    _watchView = [[ABWatchView alloc] initWithFrame:CGRectZero];
    _watchView.tickColor = [UIColor colorWithRed:0.1 green:0.6 blue:1.0 alpha:1.0];
    [self.view addSubview:_watchView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_pressMe];
    [self.view addSubview:_resetButton];
    [self.view addSubview:_displayCount];
    
    _lapButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Lap", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(_lapButtonPressed)];
    self.navigationItem.rightBarButtonItem = _lapButton;
    
    self.navigationItem.title = NSLocalizedString(@"Stopwatch", @"");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_buttonPressed
{
    if (_timer) {    // stop the timer
        dispatch_source_cancel(_timer);
    } else {                // start the timer
        [_pressMe setTitle:NSLocalizedString(@"Stop Timer", @"") forState:UIControlStateNormal];
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _timerq);
        
        __weak com_robertdiamondViewController *weakSelf = self;
        dispatch_source_set_event_handler(_timer, ^{
            com_robertdiamondViewController *strongSelf = weakSelf;
            if (strongSelf) {
                NSString *formatted = [@(strongSelf.count) formatLaptimeWithDigits:2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.displayCount.text = formatted;
                    _watchView.count = strongSelf.count;
                });
            }
        });
        
        dispatch_source_set_cancel_handler(_timer, ^{
            com_robertdiamondViewController *strongSelf = weakSelf;
            if (strongSelf) {
                strongSelf.timer = nil;
                strongSelf.startTime = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongSelf.pressMe setTitle:NSLocalizedString(@"Press Me!", @"") forState:UIControlStateNormal];
                });
            }
        });

        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, COUNT_RESOLUTION * NS_PER_SECOND, .1 * NS_PER_SECOND);
        _startTime = [NSDate date];
        dispatch_resume(_timer);
    }
}

- (void)_lapButtonPressed
{
    if (_timer != nil) {
        [_lapTimes addLaptime:self.count];
    }
    [self.navigationController pushViewController:[[SecondViewController alloc] initWithLaptimes:_lapTimes] animated:YES];
}

- (void)_reset
{
    __weak com_robertdiamondViewController *weakSelf = self;
    dispatch_async(_timerq, ^{
        com_robertdiamondViewController *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.startTime = [NSDate date];
            NSString *formatted = [@(strongSelf.count) formatLaptimeWithDigits:2];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.displayCount.text = formatted;
            });
        }
    });
}

- (NSTimeInterval)count
{
    if (_startTime) {
        return [[NSDate date] timeIntervalSinceDate:_startTime];
    } else {
        return 0.f;
    }
}

- (void)_layout
{
    CGFloat totalButtonWidth = _pressMe.bounds.size.width + _resetButton.bounds.size.width + BUTTON_TO_BUTTON_SPACING;

    _pressMe.frame = CGRectMake((self.view.bounds.size.width - totalButtonWidth)/2.0, BUTTON_TOP_OFFSET, _pressMe.bounds.size.width, _pressMe.bounds.size.height);

    _resetButton.frame = CGRectMake(_pressMe.frame.origin.x + _pressMe.frame.size.width + BUTTON_TO_BUTTON_SPACING, BUTTON_TOP_OFFSET, _resetButton.bounds.size.width, _resetButton.bounds.size.height);

    _displayCount.frame = CGRectMake(LABEL_LEFT_OFFSET, _pressMe.frame.origin.y + _pressMe.frame.size.height + BUTTON_TO_LABEL_OFFSET, self.view.bounds.size.width - LABEL_LEFT_OFFSET * 2.0, _displayCount.bounds.size.height);

    CGFloat displayCountBottom = _displayCount.frame.origin.y + _displayCount.frame.size.height + BUTTON_TO_CLOCK_OFFSET;
    _watchView.frame = CGRectMake(CLOCK_LEFT_OFFSET, displayCountBottom, self.view.bounds.size.width - CLOCK_LEFT_OFFSET * 2.0, self.view.bounds.size.height - displayCountBottom - BUTTON_TO_CLOCK_OFFSET);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self _layout];
}
@end
