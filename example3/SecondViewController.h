//
//  SecondViewController.h
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LaptimeDataSource;
@interface SecondViewController : UIViewController<UITableViewDelegate>

- (id)initWithLaptimes:(LaptimeDataSource *)lapTimes;

@end
