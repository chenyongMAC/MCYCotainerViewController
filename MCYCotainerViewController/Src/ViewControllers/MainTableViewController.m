//
//  MainTableViewController.m
//  MCYCotainerViewController
//
//  Created by 陈勇 on 16/1/20.
//  Copyright © 2016年 陈勇. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *classNames;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    
    [self addCell:@"BackgroundSession" class:@"BackgroundViewController"];
    [self addCell:@"TintColor" class:@"TintColorViewController"];
    
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Background"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Background"];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.titles removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *vc = class.new;
        vc.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
