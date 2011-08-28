//
//  TotalDetailViewCell.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TotalDetailViewCell.h"

@implementation TotalDetailViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
		self.textLabel.font = [UIFont systemFontOfSize:14.0];
		self.textLabel.textColor = [UIColor colorWithRed:0.0 green:128.0/255.0 blue:0.0 alpha:1.0];
		self.textLabel.textAlignment = UITextAlignmentCenter;
		self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
		self.textLabel.numberOfLines = 2;
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	
	// Configure the view for the selected state
}

@end
