//
//  DetailSummaryViewCell.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailSummaryViewCell.h"

@implementation DetailSummaryViewCell

@synthesize summaryView = summaryView_;

- (id)initWithLabels:(NSArray *)labels details:(NSArray *)details reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect tvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		summaryView_ = [[DetailSummaryView alloc] initWithLabels:labels details:details];
		summaryView_.frame = tvFrame;
		summaryView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:summaryView_];
    }
    return self;
}

- (void)dealloc
{
	[summaryView_ release];
	[super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)redisplay
{
	[self.summaryView setNeedsDisplay];
}

@end
