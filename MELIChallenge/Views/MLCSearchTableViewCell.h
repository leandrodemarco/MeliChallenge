//
//  MLCSearchTableViewCell.h
//  MELIChallenge
//
//  Created by Leandro Demarco Vedelago on 09.03.20.
//  Copyright © 2020 Leandro Demarco Vedelago. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCItem.h"

static NSString *kMLCSearchTableViewCellIdentifier = @"MLCItemCellIdentifier";
@interface MLCSearchTableViewCell : UITableViewCell

- (void)configureWithItem:(MLCItem *)item;

@end
