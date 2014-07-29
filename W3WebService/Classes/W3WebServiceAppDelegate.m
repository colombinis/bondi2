//
//  W3WebServiceAppDelegate.m
//  W3WebService
//
//  Created by Ravi Dixit on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "W3WebServiceAppDelegate.h"
#import "myView.h"

@implementation W3WebServiceAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    myView *obj = [[myView alloc]initWithNibName:@"myView" bundle:nil];
	[window addSubview:obj.view];
	
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"**************** applicationWillResignActive **************** ");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"****************  applicationDidEnterBackground **************** ");

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"**************** applicationWillEnterForeground **************** ");

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"**************** applicationDidBecomeActive **************** ");

}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"**************** applicationWillTerminate **************** ");

}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"**************** applicationDidReceiveMemoryWarning ****************");

}


- (void)dealloc {
     NSLog(@"**************** dealloc ****************");
    [window release];
    [super dealloc];
}


@end
