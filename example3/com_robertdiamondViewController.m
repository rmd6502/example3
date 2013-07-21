//
//  com_robertdiamondViewController.m
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import "com_robertdiamondViewController.h"
#import "LaptimeDataSource.h"
#import "NSNumber+Laptime.h"
#import "SecondViewController.h"

#define BUTTON_TOP_OFFSET 20
#define BUTTON_TO_LABEL_OFFSET 20
#define BUTTON_TO_BUTTON_SPACING 40
#define LABEL_LEFT_OFFSET 30
#define NS_PER_SECOND (1E9)

@interface com_robertdiamondViewController ()

@property (nonatomic) dispatch_queue_t timerq;
@property (nonatomic) dispatch_source_t timer;
@property (nonatomic) LaptimeDataSource *lapTimes;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	_pressMe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _pressMe.titleLabel.font = [UIFont fontWithName:@"GRAFFITI" size:20.0];
    [_pressMe setTitle:NSLocalizedString(@"Press Me!", @"") forState:UIControlStateNormal];
    [_pressMe setTitle:NSLocalizedString(@"Let Go!", @"") forState:UIControlStateHighlighted];
    [_pressMe sizeToFit];
    [_pressMe addTarget:self action:@selector(_buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _resetButton.titleLabel.font = [UIFont fontWithName:@"GRAFFITI" size:20.0];
    [_resetButton setTitle:NSLocalizedString(@"Reset", @"") forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(_reset) forControlEvents:UIControlEventTouchUpInside];
    [_resetButton sizeToFit];
    
    _displayCount = [UILabel new];
    _displayCount.backgroundColor = [UIColor blackColor];
    _displayCount.textColor = [UIColor whiteColor];
    _displayCount.text = @"You haven't pressed the button yet...";
    _displayCount.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    [_displayCount sizeToFit];
    
    CGFloat totalButtonWidth = _pressMe.bounds.size.width + _resetButton.bounds.size.width + BUTTON_TO_BUTTON_SPACING;
    
    _pressMe.frame = CGRectMake((self.view.bounds.size.width - totalButtonWidth)/2.0, BUTTON_TOP_OFFSET, _pressMe.bounds.size.width, _pressMe.bounds.size.height);
    
    _resetButton.frame = CGRectMake(_pressMe.frame.origin.x + _pressMe.frame.size.width + BUTTON_TO_BUTTON_SPACING, BUTTON_TOP_OFFSET, _resetButton.bounds.size.width, _resetButton.bounds.size.height);

    _displayCount.frame = CGRectMake(LABEL_LEFT_OFFSET, _pressMe.frame.origin.y + _pressMe.frame.size.height + BUTTON_TO_LABEL_OFFSET, _displayCount.bounds.size.width, _displayCount.bounds.size.height);

    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_pressMe];
    [self.view addSubview:_resetButton];
    [self.view addSubview:_displayCount];
    
    UIBarButtonItem *lapButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Lap", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(_lapButtonPressed)];
    self.navigationItem.rightBarButtonItem = lapButton;
    
    self.navigationItem.title = @"Stopwatch";
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
        dispatch_source_set_event_handler(_timer, ^{
            _count += .01;
            NSString *formatted = [@(_count) formatLaptime];
            dispatch_async(dispatch_get_main_queue(), ^{
                _displayCount.text = formatted;
            });
        });
        
        dispatch_source_set_cancel_handler(_timer, ^{
            [_pressMe setTitle:NSLocalizedString(@"Press Me!", @"") forState:UIControlStateNormal];
            _timer = nil;
        });
        
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, .01 * NS_PER_SECOND, .1 * NS_PER_SECOND);
        dispatch_resume(_timer);
    }
}

- (void)_lapButtonPressed
{
    [_lapTimes addLaptime:_count];
    [self.navigationController pushViewController:[[SecondViewController alloc] initWithLaptimes:_lapTimes] animated:YES];
}

- (void)_reset
{
    [_lapTimes clearLaptimes];
    dispatch_async(_timerq, ^{
        _count = 0.f;
        NSString *formatted = [@(_count) formatLaptime];
        dispatch_async(dispatch_get_main_queue(), ^{
            _displayCount.text = formatted;
        });
    });
}

@end
