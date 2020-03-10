//
//  MLCItem.m
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import "MLCItem.h"

typedef enum {
  MLCItemConditionNew,
  MLCItemConditionUsed,
  MLCItemConditionRefurbished
} MLCItemCondition;

static const NSString *kPrizeKey = @"price";
static const NSString *kTitleKey = @"title";
static const NSString *kThumbnailURLKey = @"thumbnail";
static const NSString *kConditionKey = @"condition";
static const NSString *kStockKey = @"available_quantity";
static const NSString *kSoldUnitsKey = @"sold_quantity";
static const NSString *kFreeShippingKey = @"free_shipping";
static const NSString *kShippingInfoKey = @"shipping";

static NSString *kConditionNewStr = @"new";
static NSString *kConditionUsedStr = @"used";
static NSString *kConditionRefurbishedStr = @"refurbished";

@interface MLCItem ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSUInteger price;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic) MLCItemCondition condition;
@property (nonatomic) NSUInteger stock;
@property (nonatomic) NSUInteger soldUnits;
@property (nonatomic) BOOL freeShipping;

@end

@implementation MLCItem

- (instancetype)initWithData:(NSDictionary *)fetchedData {
  MLCItem *newItem = [super init];
  if (newItem) {
    newItem.price = ((NSNumber *)[fetchedData objectForKey:kPrizeKey]).unsignedIntegerValue;
    newItem.title = [fetchedData objectForKey:kTitleKey];
    newItem.thumbnailURL = [fetchedData objectForKey:kThumbnailURLKey];
    newItem.condition = [self conditionFromStringRepr:(NSString *)[fetchedData objectForKey:kConditionKey]];
    newItem.stock = ((NSNumber *)[fetchedData objectForKey:kStockKey]).unsignedIntegerValue;
    newItem.soldUnits = ((NSNumber *)[fetchedData objectForKey:kSoldUnitsKey]).unsignedIntegerValue;
    NSDictionary *shippingInfo = [fetchedData objectForKey:kShippingInfoKey];
    newItem.freeShipping = ((NSNumber *)[shippingInfo objectForKey:kFreeShippingKey]).unsignedIntegerValue;
  }
  
  return newItem;
}

- (NSString *)conditionStr {
  switch (self.condition) {
    case MLCItemConditionNew: return @"Nuevo";
    case MLCItemConditionUsed: return @"Usado";
    case MLCItemConditionRefurbished: return @"Acondicionado";
  }
}

- (MLCItemCondition)conditionFromStringRepr:(NSString *)stringRepr {
  MLCItemCondition result = MLCItemConditionNew; // New by default
  if ([stringRepr isEqualToString:kConditionUsedStr]) {
    result = MLCItemConditionUsed;
  } else if ([stringRepr isEqualToString:kConditionRefurbishedStr]) {
    result = MLCItemConditionRefurbished;
  }
  return result;
}

@end
