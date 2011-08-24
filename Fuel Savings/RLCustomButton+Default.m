//
//  RLCustomButton+Default.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RLCustomButton+Default.h"

@implementation RLCustomButton (RLCustomButton_Default)

+ (RLCustomButton *)saveAsButton
{
	RLCustomButton *button = [RLCustomButton customButton];
	[button setTitle:@"Save As" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundColor:[UIColor colorWithRed:4.0f/255.0f green:159.0f/255.0f blue:19.0f/255.0f alpha:1.0f]];
	[button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	button.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
	button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	return button;
}

+ (RLCustomButton *)deleteButton
{
	RLCustomButton *button = [RLCustomButton customButton];
	[button setTitle:@"Delete" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundColor:[UIColor colorWithRed:191.0f/255.0f green:35.0f/255.0f blue:33.0f/255.0f alpha:1.0f]];
	[button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	button.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
	button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	return button;
}

+ (RLCustomButton *)deleteAllButton
{
	RLCustomButton *button = [RLCustomButton deleteButton];
	[button setTitle:@"Delete All" forState:UIControlStateNormal];
	return button;
}

+ (RLCustomButton *)resetCar2Button
{
	RLCustomButton *button = [RLCustomButton deleteButton];
	[button setTitle:@"Reset Car 2" forState:UIControlStateNormal];
	return button;
}

+ (RLCustomButton *)selectCarButton
{
	RLCustomButton *button = [RLCustomButton customButton];
	[button setTitle:@"Select Car" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setBackgroundColor:[UIColor colorWithRed:32.0f/255.0f green:74.0f/255.0f blue:135.0f/255.0f alpha:1.0f]];
	[button setTitleShadowColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
	button.titleLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
	button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
	return button;
}

@end
