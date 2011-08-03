//
//  TotalViewCell.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TotalViewCell.h"

@implementation TotalViewCell

@synthesize totalView = totalView_;

- (id)initWithTotalType:(TotalViewType)type
{	
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil]) {
		// The height will be ignored
		CGRect tvFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		totalView_ = [[TotalView alloc] initWithFrame:tvFrame type:type];
		totalView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:totalView_];
	}
	return self;
}

- (void)dealloc
{
	[totalView_ release];
	[super dealloc];
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
