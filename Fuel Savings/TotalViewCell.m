//
//  TotalViewCell.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/2/11.
//  Copyright 2011 Axel Rivera. All rights reserved.
//

#import "TotalViewCell.h"

@implementation TotalViewCell

@synthesize totalView = totalView_;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		// Initialization Code
	}
	return self;
}

- (void)dealloc
{
	[totalView_ release];
	[super dealloc];
}

- (void)setTotalView:(TotalView *)totalView
{
	[totalView_ removeFromSuperview];
	[totalView_ autorelease];
	
	CGRect tvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
	totalView_ = [totalView retain];
	totalView_.frame = tvFrame;
	totalView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:totalView_];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

- (void)redisplay
{
	[self.totalView setNeedsDisplay];
}

@end
