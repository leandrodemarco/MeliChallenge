//
//  MLCApiClient.h
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLCItem.h"

@interface MLCApiClient : NSObject

+ (instancetype)sharedInstance;
- (void)performSearch:(NSString *)searchString withCompletion:(void (^)(NSArray<MLCItem *> *))completion;

@end
