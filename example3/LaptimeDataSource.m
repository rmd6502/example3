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

@interface LaptimeDataSource ()
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LAPTIME_CELL_IDENTIFIER];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LAPTIME_CELL_IDENTIFIER];
    }
    cell.textLabel.text = [_lapTimes[indexPath.row] formatLaptime];
    
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
