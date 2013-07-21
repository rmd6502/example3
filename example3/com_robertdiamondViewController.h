//
//  com_robertdiamondViewController.h
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface com_robertdiamondViewController : UIViewController

@property (nonatomic, readonly) UIButton *pressMe;
@property (nonatomic, readonly) UIButton *resetButton;
@property (nonatomic, readonly) UILabel *displayCount;

@property (nonatomic) NSTimeInterval count;
@end
