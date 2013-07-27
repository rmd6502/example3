//
//  LaptimeDataSource.m
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import "LaptimeDataSource.h"
#import "NSNumber+Laptime.h"

#define LAPTIME_CELL_IDENTIFIER @"lapTimeCell"
#define DISPLAY_FONT @"HelveticaNeue-Light"
#define DISPLAY_SIZE 18.0f

@interface LaptimeDataSource () {
    CGFloat _rowHeight;
}
@property (nonatomic) NSMutableArray *lapTimes;
@end

@implementation LaptimeDataSource

- (id)init
{
    self = [super init];
    if (self) {
        _lapTimes = [NSMutableArray new];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lapTimes.count;
}

- (CGFloat)rowHeight
{
    if (_rowHeight == 0) {
        _rowHeight = [UIFont fontWithName:DISPLAY_FONT size:DISPLAY_SIZE].lineHeight;
    }
    return _rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LAPTIME_CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LAPTIME_CELL_IDENTIFIER];
        cell.textLabel.font = [UIFont fontWithName:DISPLAY_FONT size:DISPLAY_SIZE];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [_lapTimes[indexPath.row] formatLaptimeWithDigits:3];
    
    if (indexPath.row == _lapTimes.count - 1) {
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

- (void)addLaptime:(NSTimeInterval)lapTime
{
    [_lapTimes addObject:@(lapTime)];
}

- (void)clearLaptimes
{
    [_lapTimes removeAllObjects];
}
@end
