//
//  DetailSummaryViewCell.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/12/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "DetailSummaryViewCell.h"

@implementation DetailSummaryViewCell

@synthesize summaryView = summaryView_;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
		// Initialization Code
	}
	return self;
}

- (void)dealloc
{
	[summaryView_ release];
	[super dealloc];
}

- (void)setSummaryView:(DetailSummaryView *)summaryView
{
	[summaryView_ removeFromSuperview];
	[summaryView_ autorelease];
	
	CGRect tvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
	summaryView_ = [summaryView retain];
	summaryView_.frame = tvFrame;
	summaryView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:summaryView_];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

- (void)redisplay
{
	[self.summaryView setNeedsDisplay];
}

@end
