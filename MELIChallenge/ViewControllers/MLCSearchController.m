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
#import "MLCDetailedItemViewController.h"

@interface MLCSearchController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<MLCItem *> *items;
@property (nonatomic, strong) MLCDetailedItemViewController *detailedItemVC;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingSpinner;

@end

@implementation MLCSearchController

static NSString *detailedVCIdentifier = @"detailedVCIdentifier";
- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"MELI Challenge";
  [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil]];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.searchBar.delegate = self;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.detailedItemVC = [self.storyboard instantiateViewControllerWithIdentifier:detailedVCIdentifier];
  [self setupLoadingView];
}

- (void)setupLoadingView {
  UIView *loadingView = [UIView new];
  loadingView.hidden = YES;
  [self.view addSubview:loadingView];
  loadingView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
  
  loadingView.translatesAutoresizingMaskIntoConstraints = NO;
  [loadingView.leadingAnchor constraintEqualToAnchor:self.tableView.leadingAnchor].active = YES;
  [loadingView.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
  [loadingView.topAnchor constraintEqualToAnchor:self.tableView.topAnchor].active = YES;
  [loadingView.bottomAnchor constraintEqualToAnchor:self.tableView.bottomAnchor].active = YES;
  
  UILabel *loadingLbl = [UILabel new];
  loadingLbl.translatesAutoresizingMaskIntoConstraints = NO;
  [loadingView addSubview:loadingLbl];
  loadingLbl.text = @"Buscando";
  loadingLbl.textAlignment = NSTextAlignmentCenter;
  loadingLbl.font = [UIFont boldSystemFontOfSize:17.0f];
  [loadingLbl sizeToFit];
  [loadingLbl.centerXAnchor constraintEqualToAnchor:loadingView.centerXAnchor].active = YES;
  [loadingLbl.centerYAnchor constraintEqualToAnchor:loadingView.centerYAnchor].active = YES;

  UIActivityIndicatorView *loadingSpinner = nil;
  if (@available(iOS 13.0, *)) {
    loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
  } else {
    loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  }
  [loadingView addSubview:loadingSpinner];
  loadingSpinner.translatesAutoresizingMaskIntoConstraints = NO;
  [loadingSpinner.topAnchor constraintEqualToAnchor:loadingLbl.bottomAnchor constant:8.0f].active = YES;
  [loadingSpinner.centerXAnchor constraintEqualToAnchor:loadingView.centerXAnchor].active = YES;
  
  self.loadingView = loadingView;
  self.loadingSpinner = loadingSpinner;
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
static NSString *showDetailedProductSegueIdentifier = @"showDetailedProductSegueIdentifier";
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.searchBar resignFirstResponder]; // Avoid table to scroll back to top when coming back
  MLCItem *selectedItem = [self.items objectAtIndex:indexPath.row];
  self.detailedItemVC.item = selectedItem;
  [self.navigationController pushViewController:self.detailedItemVC animated:YES];
  [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma MARK - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSString *searchString = self.searchBar.text;
  if (searchString.length) {
    self.loadingView.hidden = NO;
    [self.loadingSpinner startAnimating];
    __weak typeof(self) weakSelf = self;
    [[MLCApiClient sharedInstance] performSearch:searchString withCompletion:^(NSArray<MLCItem *> *results) {
      if (weakSelf) {
        [weakSelf.loadingSpinner stopAnimating];
        weakSelf.loadingView.hidden = YES;
        weakSelf.items = results;
        [weakSelf.tableView reloadData];
      }
    }];
  }
}


@end
