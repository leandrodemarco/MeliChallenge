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
@property (nonatomic, strong, readonly) NSString *thumbnailURL;

- (instancetype)initWithData:(NSDictionary *)fetchedData;

@end
