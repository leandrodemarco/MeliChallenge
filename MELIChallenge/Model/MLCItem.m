//
//  MLCItem.m
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import "MLCItem.h"

static const NSString *kPrizeKey = @"price";
static const NSString *kTitleKey = @"title";
static const NSString *kThumbnailURLKey = @"thumbnail";

@interface MLCItem ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSUInteger price;
@property (nonatomic, strong) NSString *thumbnailURL;

@end

@implementation MLCItem

- (instancetype)initWithData:(NSDictionary *)fetchedData {
  MLCItem *newItem = [super init];
  if (newItem) {
    newItem.price = ((NSNumber *)[fetchedData objectForKey:kPrizeKey]).unsignedIntegerValue;
    newItem.title = [fetchedData objectForKey:kTitleKey];
    newItem.thumbnailURL = [fetchedData objectForKey:kThumbnailURLKey];
  }
  
  return newItem;
}

@end
