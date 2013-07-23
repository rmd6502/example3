//
//  LaptimeDataSource.h
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaptimeDataSource : NSObject<UITableViewDataSource>

@property (nonatomic,readonly) NSMutableArray *lapTimes;
@property (nonatomic,readonly) CGFloat rowHeight;

- (void)addLaptime:(NSTimeInterval)lapTime;
- (void)clearLaptimes;

@end
