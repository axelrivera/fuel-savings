//
//  UnitsViewController.m
//  Fuel Savings
//
//  Created by Axel Rivera on 8/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UnitsViewController.h"

@implementation UnitsViewController

- (id)init
{
	self = [super initWithNibName:@"UnitsViewController" bundle:nil];
	if (self) {
		// initialization code
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.title = @"Units";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
