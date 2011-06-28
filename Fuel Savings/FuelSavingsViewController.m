//
//  FuelSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "CurrentSavingsViewController.h"

@interface FuelSavingsViewController (Private)

- (UIView *)topBar;

@end

@implementation FuelSavingsViewController

- (id)init
{
	self = [super initWithNibName:@"FuelSavingsViewController" bundle:nil];
	if (self) {
		// Initialization Code
	}
	return self;
}

- (void)dealloc
{
	[topBarView_ release];
    [super dealloc];
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
	self.title = @"Fuel Savings";
	
	[self.view addSubview:[self topBar]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[topBarView_ release];
	topBarView_ = nil;
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Custom Actions

- (void)newAction
{
	CurrentSavingsViewController *currentSavingsViewController = [[CurrentSavingsViewController alloc] init];
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:currentSavingsViewController];
	
	[currentSavingsViewController release];
	
	[self presentModalViewController:navController animated:YES];
	
	[navController release];
}

- (void)editAction
{
	
}

- (void)saveAction
{
	
}

#pragma mark - Private Methods

- (UIView *)topBar
{
	if (topBarView_ == nil) {
		topBarView_ = [[UIView alloc] initWithFrame: CGRectMake(0.0,
																0.0,
																[UIScreen mainScreen].bounds.size.width,
																44.0)];
		
		topBarView_.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topbar.png"]];
				
		UIButton *newButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		
		[newButton addTarget:self action:@selector(newAction) forControlEvents:UIControlEventTouchDown];
		[newButton setTitle:@"New" forState:UIControlStateNormal];
		newButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		newButton.frame = CGRectMake(5.0, 7.0, 100.0, 30.0);
		
		[topBarView_ addSubview:newButton];
		[newButton release];
		
		UIButton *editButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		
		[editButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchDown];
		[editButton setTitle:@"Edit" forState:UIControlStateNormal];
		editButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		editButton.frame = CGRectMake(110.0, 7.0, 100.0, 30.0);
		
		[topBarView_ addSubview:editButton];
		[editButton release];
		
		UIButton *saveButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		
		[saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
		[saveButton setTitle:@"Save" forState:UIControlStateNormal];
		saveButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
		saveButton.frame = CGRectMake(215.0, 7.0, 100.0, 30.0);
		
		[topBarView_ addSubview:saveButton];
		[saveButton release];
	}
	return topBarView_;
}

@end
