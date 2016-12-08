//
//  AppDelegate.m
//  hadiths
//
//  Created by Walid Sassi on 25/06/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import "AppDelegate.h"
#import "SHKConfiguration.h"
#import "ViewController.h"
#import "myshkconfig.h"
#import "SHKDropbox.h"
#import "SHKGooglePlus.h"
#import "SHKFacebook.h"
#import "EvernoteSDK.h"
#import "SHKBuffer.h"
#import "PocketAPI.h"
@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if(IS_IPHONE_5)
        {
            self.viewController = [[[ViewController alloc] initWithNibName:@"ViewI5" bundle:nil] autorelease];
        }
        else
        {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil] autorelease];
        }
    } else {
        self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil] autorelease];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    DefaultSHKConfigurator *configurator = [[[myshkconfig alloc] init] autorelease];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
   [self copyDatabaseIfNeeded];
    [self.viewController getInitialDataToDisplay:[self getDBPath]:@"ar"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hadithDB.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"hadithDB.sqlite"];
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [SHKFacebook handleDidBecomeActive];
    [[EvernoteSession sharedSession] handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
     [SHKFacebook handleWillTerminate];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url];
    } else if ([scheme isEqualToString:@"com.yourcompany.sharekitdemo"]) {
        return [SHKGooglePlus handleURL:url sourceApplication:sourceApplication annotation:annotation];
    } else if ([scheme hasPrefix:[NSString stringWithFormat:@"db-%@", SHKCONFIG(dropboxAppKey)]]) {
        return [SHKDropbox handleOpenURL:url];
    } else if ([[NSString stringWithFormat:@"en-%@", [[EvernoteSession sharedSession] consumerKey]] isEqualToString:[url scheme]]) {
        return [[EvernoteSession sharedSession] canHandleOpenURL:url];
    } else if ([scheme hasPrefix:[NSString stringWithFormat:@"buffer%@", SHKCONFIG(bufferClientID)]]) {
        return [SHKBuffer handleOpenURL:url];
    } 
    
    
    return YES;
}

@end
