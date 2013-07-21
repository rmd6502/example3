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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _clearTable = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _clearTable.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
    [_clearTable setTitle:NSLocalizedString(@"Clear", @"") forState:UIControlStateNormal];
    [_clearTable sizeToFit];
    
    _clearTable.frame = CGRectMake((self.view.bounds.size.width - _clearTable.bounds.size.width)/2, BUTTON_TOP_OFFSET, _clearTable.bounds.size.width, _clearTable.bounds.size.height);
    [_clearTable addTarget:self action:@selector(_clearLaptimes) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    CGFloat tableY = _clearTable.frame.size.height + _clearTable.frame.origin.y + BUTTON_TO_LABEL_OFFSET;
    _tableView.frame = CGRectMake(0, tableY, self.view.frame.size.width, self.view.bounds.size.height - tableY);
    _tableView.delegate = self;
    _tableView.dataSource = _lapTimes;
    _tableView.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:_clearTable];
    [self.view addSubview:_tableView];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleDone target:self action:@selector(_returnToTimer)];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_clearLaptimes
{
    [_lapTimes clearLaptimes];
    [self.tableView reloadData];
}

- (void)_returnToTimer
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
