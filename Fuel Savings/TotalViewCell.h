//
//  TotalViewCell.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TotalView.h"

@interface TotalViewCell : UITableViewCell

@property (nonatomic, retain) TotalView *totalView;

- (id)initWithTotalType:(TotalViewType)type;
- (void)redisplay;

@end
