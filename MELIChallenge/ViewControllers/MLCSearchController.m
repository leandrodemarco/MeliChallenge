//
//  MLCSearchController.m
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import "MLCSearchController.h"
#import "MLCSearchTableViewCell.h"
#import "MLCApiClient.h"

@interface MLCSearchController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MLCItem *> *items;

@end

@implementation MLCSearchController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.searchBar.delegate = self;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  //[self.tableView registerClass:[MLCSearchTableViewCell class] forCellReuseIdentifier:kMLCSearchTableViewCellIdentifier];
}

#pragma MARK - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MLCSearchTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kMLCSearchTableViewCellIdentifier];
  MLCItem *cellItem = [self.items objectAtIndex:indexPath.row];
  [cell configureWithItem:cellItem];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 150.0f;
}

#pragma MARK - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma MARK - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSString *searchString = self.searchBar.text;
  if (searchString.length) {
    __weak typeof(self) weakSelf = self;
    [[MLCApiClient sharedInstance] performSearch:searchString withCompletion:^(NSArray<MLCItem *> *results) {
      if (weakSelf) {
        weakSelf.items = results;
        [weakSelf.tableView reloadData];
      }
    }];
  }
}


@end
