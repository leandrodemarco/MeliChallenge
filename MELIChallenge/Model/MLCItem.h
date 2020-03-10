//
//  MLCItem.h
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLCItem : NSObject

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, readonly) NSUInteger price;
@property (nonatomic, strong, readonly) NSString *conditionStr;
@property (nonatomic, strong, readonly) NSString *thumbnailURL;
@property (nonatomic, readonly) NSUInteger stock;
@property (nonatomic, readonly) NSUInteger soldUnits;
@property (nonatomic, readonly) BOOL freeShipping;

- (instancetype)initWithData:(NSDictionary *)fetchedData;

@end
