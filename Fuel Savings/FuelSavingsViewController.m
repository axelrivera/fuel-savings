//
//  FuelSavingsViewController.m
//  Fuel Savings
//
//  Created by arn on 6/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FuelSavingsViewController.h"
#import "NewSavingsViewController.h"

@implementation FuelSavingsViewController

- (id)init
{
	self = [super initWithNibName:@"FuelSavingsViewController" bundle:nil];
	if (self) {
		savingsData_ = [SavingsData sharedSavingsData];
	}
	return self;
}

- (id)initWithTabBar
{
	self = [self init];
	if (self) {
		self.title = @"Compare";
		self.navigationItem.title = @"Compare Savings";
		self.tabBarItem.image = [UIImage imageNamed:@"compare_tab.png"];
	}
	return self;
}

- (void)dealloc
{
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
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"New"
																	style:UIBarButtonItemStyleBordered
																   target:self
																   action:@selector(newAction)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	[savingsData_ resetNewCalculation];
	NewSavingsViewController *currentSavingsViewController = [[NewSavingsViewController alloc] init];
	currentSavingsViewController.delegate = self;
	
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

#pragma mark - View Controller Delegates

- (void)newSavingsViewControllerDelegateDidFinish:(NewSavingsViewController *)controller save:(BOOL)save
{
	if (save) {
		savingsData_.currentCalculation = savingsData_.newCalculation;
	}
	[self dismissModalViewControllerAnimated:YES];
}

@end
