//
//  MLCSearchTableViewCell.m
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import "MLCSearchTableViewCell.h"
#import <SDWebImage/SDWebImage.h>

static const CGFloat thumbnailSideSize = 95.0f;
static const CGFloat prizeLabelHeight = 21.0f;

@interface MLCSearchTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *prizeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImgView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation MLCSearchTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setupConstraints];
  self.spinner.hidden = YES;
}

- (void)setupConstraints {
  self.thumbnailImgView.translatesAutoresizingMaskIntoConstraints = NO;
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.prizeLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
  
  // Thumbnail Image View
  [self.thumbnailImgView.widthAnchor constraintEqualToConstant:thumbnailSideSize].active = YES;
  [self.thumbnailImgView.heightAnchor constraintEqualToConstant:thumbnailSideSize].active = YES;
  [self.thumbnailImgView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:8.0f].active = YES;
  [self.thumbnailImgView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
  
  // Prize Label
  [self.prizeLabel.bottomAnchor constraintEqualToAnchor:self.thumbnailImgView.bottomAnchor].active  = YES;
  [self.prizeLabel.heightAnchor constraintEqualToConstant:prizeLabelHeight].active = YES;
  [self.prizeLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8.0f].active = YES;
  [self.prizeLabel.leadingAnchor constraintEqualToAnchor:self.thumbnailImgView.trailingAnchor constant:8.0f].active = YES;
  
  // Title Label
  [self.titleLabel.topAnchor constraintEqualToAnchor:self.thumbnailImgView.topAnchor].active = YES;
  [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.thumbnailImgView.trailingAnchor constant:16.0f].active = YES;
  [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-8.0f].active = YES;
  [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.prizeLabel.topAnchor constant:-8.0f].active = YES;
  
  // Spinner
  [self.spinner.centerXAnchor constraintEqualToAnchor:self.thumbnailImgView.centerXAnchor].active = YES;
  [self.spinner.centerYAnchor constraintEqualToAnchor:self.thumbnailImgView.centerYAnchor].active = YES;
}

- (void)configureWithItem:(MLCItem *)item {
    
  [self.titleLabel setText:item.title];
  [self.prizeLabel setText:[NSString stringWithFormat:@"%lu", item.price]];
  
  self.spinner.hidden = NO;
  [self.spinner startAnimating];
  __weak typeof(self) weakSelf = self;
  [self.thumbnailImgView sd_setImageWithURL:[NSURL URLWithString:item.thumbnailURL] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [weakSelf.spinner stopAnimating];
      weakSelf.spinner.hidden = YES;
    });
  }];
  
}

@end
