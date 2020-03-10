//
//  MLCDetailedItemViewController.m
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import "MLCDetailedItemViewController.h"
#import <SDWebImage/SDWebImage.h>

@interface MLCDetailedItemViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UILabel *conditionAndSoldLbl;
@property (nonatomic, weak) IBOutlet UILabel *titleLbl;
@property (nonatomic, weak) IBOutlet UILabel *priceLbl;
@property (nonatomic, weak) IBOutlet UILabel *stockAvailableLbl;

@end

@implementation MLCDetailedItemViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setupUI];
}

- (void)setupUI {
  MLCItem *item = self.item;
  [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.thumbnailURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    if (error) {
#ifdef DEBUG
      NSLog(@"Failed to load thumbnail from %@", item.thumbnailURL);
#endif
    }
  }];
  
  self.titleLbl.text = item.title;
  self.priceLbl.text = [NSString stringWithFormat:@"$%lu", item.price];
  self.stockAvailableLbl.text = item.stock > 0 ? @"Stock disponible" : @"Sin stock";
  self.conditionAndSoldLbl.text = [NSString stringWithFormat:@"%@ - %lu vendidos", item.conditionStr, item.soldUnits];
}

@end
