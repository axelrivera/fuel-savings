//
//  TypeInputViewController.h
//  Fuel Savings
//
//  Created by arn on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TypeInputViewControllerDelegate;

@interface TypeInputViewController : UITableViewController {

}

@property (nonatomic, assign) id <TypeInputViewControllerDelegate> delegate;
@property (nonatomic) NSInteger currentType;

@end

@protocol TypeInputViewControllerDelegate

- (void)typeInputViewControllerDidFinish:(TypeInputViewController *)controller save:(BOOL)save;

@end
