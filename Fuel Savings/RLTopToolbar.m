//
//  RLTopToolbar.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RLTopToolbar.h"

@interface RLTopToolbar (Private)

- (void)applyBackground;

@end

@implementation RLTopToolbar

- (id)init
{
	self = [super init];
	if (self) {
		[self applyBackground];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self applyBackground];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)applyBackground
{
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar.png"]];
	self.opaque = NO;
	self.translucent = YES;
}

@end
