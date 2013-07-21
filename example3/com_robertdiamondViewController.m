//
//  com_robertdiamondViewController.m
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import "com_robertdiamondViewController.h"

#define BUTTON_TOP_OFFSET 20
#define BUTTON_TO_LABEL_OFFSET 20
#define LABEL_LEFT_OFFSET 30

@interface com_robertdiamondViewController ()

@end

@implementation com_robertdiamondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_pressMe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _pressMe.titleLabel.font = [UIFont fontWithName:@"GRAFFITI" size:20.0];
    [_pressMe setTitle:NSLocalizedString(@"Press Me!", @"") forState:UIControlStateNormal];
    [_pressMe setTitle:NSLocalizedString(@"Let Go!", @"") forState:UIControlStateHighlighted];
    [_pressMe sizeToFit];
    [_pressMe addTarget:self action:@selector(_buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    _displayCount = [UILabel new];
    _displayCount.backgroundColor = [UIColor blackColor];
    _displayCount.textColor = [UIColor whiteColor];
    _displayCount.text = @"You haven't pressed the button yet...";
    _displayCount.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    [_displayCount sizeToFit];
    
    _pressMe.frame = CGRectMake((self.view.bounds.size.width - _pressMe.bounds.size.width)/2.0, BUTTON_TOP_OFFSET, _pressMe.bounds.size.width, _pressMe.bounds.size.height);
    
    _displayCount.frame = CGRectMake(LABEL_LEFT_OFFSET, _pressMe.frame.origin.y + _pressMe.frame.size.height + BUTTON_TO_LABEL_OFFSET, _displayCount.bounds.size.width, _displayCount.bounds.size.height);

    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_pressMe];
    [self.view addSubview:_displayCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_buttonPressed
{
    ++_count;
    _displayCount.text = [NSString stringWithFormat:@"%d", _count];
}

@end
