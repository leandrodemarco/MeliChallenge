//
//  MLCApiClient.m
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import "MLCApiClient.h"
#import <AFNetworking/AFNetworking.h>


static const NSString *kResultsKey = @"results";

@interface MLCApiClient ()

@property (nonatomic, strong) AFURLSessionManager *manager;

@end

@implementation MLCApiClient

+ (instancetype)sharedInstance {
  static MLCApiClient *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [MLCApiClient new];
  });
  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    self.manager.securityPolicy = securityPolicy;
  }
  return self;
}

- (void)performSearch:(NSString *)searchString withCompletion:(void (^)(NSArray<MLCItem *> *))completion {
  NSString *urlPrefix = @"https://api.mercadolibre.com/sites/MLA/search?q=";
  NSString *encodedURL = [[urlPrefix stringByAppendingString:searchString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
  NSURL *queryURL = [NSURL URLWithString:encodedURL];
#ifdef DEBUG
  NSLog(@"Will make request %@", queryURL.absoluteString);
#endif
  NSURLRequest *request = [NSURLRequest requestWithURL:queryURL];
  
  NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:request
                                              uploadProgress:nil
                                            downloadProgress:nil
                                           completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    NSHTTPURLResponse *castedResponse = (NSHTTPURLResponse *)response;
    if (error || castedResponse.statusCode != 200) {
      NSLog(@"Error: %@", error);
    } else {
      NSDictionary *responseDict = (NSDictionary *)responseObject;
      NSArray *fetchedItems = [responseDict objectForKey:kResultsKey];
      NSMutableArray *itemsArray = [NSMutableArray arrayWithCapacity:fetchedItems.count];
      for (NSDictionary *itemDict in fetchedItems) {
        MLCItem *newItem = [[MLCItem alloc] initWithData:itemDict];
        [itemsArray addObject:newItem];
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        completion([itemsArray copy]);
      });
    }
  }];
  [dataTask resume];
}

@end
