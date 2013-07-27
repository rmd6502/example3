//
//  SecondViewController.m
//  example3
//
//  Created by Robert Diamond on 7/21/13.
//  Copyright (c) 2013 Robert Diamond. All rights reserved.
//

#import "SecondViewController.h"
#import "LaptimeDataSource.h"

@interface SecondViewController ()

@property (nonatomic) UIButton *clearTable;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) LaptimeDataSource *lapTimes;

@end

#define BUTTON_TOP_OFFSET 20
#define BUTTON_TO_LABEL_OFFSET 20

@implementation SecondViewController

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithLaptimes:(LaptimeDataSource *)lapTimes
{
    self = [self init];
    if (self) {
        _lapTimes = lapTimes;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"rect %@", NSStringFromCGRect(self.view.frame));
    [self _layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.opaque = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleDone target:self action:@selector(_returnToTimer)];
    self.navigationItem.title = NSLocalizedString(@"Lap Times", @"");
    NSLog(@"rect %@", NSStringFromCGRect(self.view.frame));

    _clearTable = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _clearTable.titleLabel.font = [UIFont fontWithName:@"HelveticaNeueLight" size:18.0];
    [_clearTable setTitle:NSLocalizedString(@"Clear", @"") forState:UIControlStateNormal];
    [_clearTable sizeToFit];
    
    [_clearTable addTarget:self action:@selector(_clearLaptimes) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = _lapTimes;
    _tableView.backgroundColor = [UIColor blackColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = _lapTimes.rowHeight;
    
    [self.view addSubview:_clearTable];
    [self.view addSubview:_tableView];
    
    NSLog(@"rect %@", NSStringFromCGRect(self.view.frame));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_clearLaptimes
{
    NSMutableArray *clearArray = [NSMutableArray new];
    [_lapTimes.lapTimes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [clearArray addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    [_lapTimes clearLaptimes];
    [_tableView deleteRowsAtIndexPaths:clearArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)_returnToTimer
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)_layout
{
    [_clearTable sizeToFit];
    CGFloat buttonTopOffset = BUTTON_TOP_OFFSET + self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    _clearTable.frame = CGRectMake((self.view.bounds.size.width - _clearTable.bounds.size.width)/2, buttonTopOffset, _clearTable.bounds.size.width, _clearTable.bounds.size.height);
    CGFloat tableY = _clearTable.frame.size.height + _clearTable.frame.origin.y + BUTTON_TO_LABEL_OFFSET;
    _tableView.frame = CGRectMake(0, tableY, self.view.frame.size.width, self.view.bounds.size.height - tableY - self.view.frame.origin.y);
    if (_lapTimes.lapTimes.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_lapTimes.lapTimes.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}
@end
