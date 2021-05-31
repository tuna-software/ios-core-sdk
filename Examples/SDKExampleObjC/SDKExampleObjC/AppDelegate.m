//
//  AppDelegate.m
//  SDKExampleObjC
//
//  Created by Guilherme Rambo on 10/05/21.
//

#import "AppDelegate.h"

@import Tuna;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [TunaSDK configureWithAppToken:@"YOUR-TOKEN-HERE" sandbox:YES];
    
    return YES;
}

@end
