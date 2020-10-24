//
//  SplashScreenViewController.h
//  iTask-iPhone
//
//  Created by Denis Arsenault on 12/10/08.
//  Copyright 2008 JDR Management. All rights reserved.
//  
// 1/1/2009 DLA Changed interface from SplashScreenViewController to TaskViewController

#import <UIKit/UIKit.h>


@interface SplashScreenViewController : UIViewController {
	IBOutlet UIActivityIndicatorView *indicator;
	
}

@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@end
