//
//  DetailSummaryViewCell.h
//  Fuel Savings
//
//  Created by Axel Rivera on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailSummaryView.h"

@interface DetailSummaryViewCell : UITableViewCell

@property (nonatomic, retain) DetailSummaryView *summaryView;

- (id)initWithLabels:(NSArray *)labels details:(NSArray *)details reuseIdentifier:(NSString *)reuseIdentifier;
- (void)redisplay;

@end
