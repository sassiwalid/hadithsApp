//
//  myshkconfig.m
//  hadiths
//
//  Created by Walid Sassi on 27/06/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import "myshkconfig.h"

@implementation myshkconfig
- (NSString*)facebookAppId {
	return @"169032139913301";
}
- (NSString*)facebookLocalAppId {
	return @"";
}
- (NSString*)appName {
	return @"الاربعون النووية";
}

- (NSString*)appURL {
	return @"http://www.kaiskhyari.net/facebook/";
}
// Read It Later - http://readitlaterlist.com/api/signup/
- (NSString*)readItLaterKey {
	return @"45aT6Vfvg66eWNebybd680gu13pdba3d";
}

// Diigo - http://www.diigo.com/api_keys/new/
-(NSString *)diigoKey {
    return @"f401ddc3546cdf3c";
}
// Twitter - http://dev.twitter.com/apps/new
/*
 Important Twitter settings to get right:
 
 Differences between OAuth and xAuth
 --
 There are two types of authentication provided for Twitter, OAuth and xAuth.  OAuth is the default and will
 present a web view to log the user in.  xAuth presents a native entry form but requires Twitter to add xAuth to your app (you have to request it from them).
 If your app has been approved for xAuth, set SHKTwitterUseXAuth to 1.
 
 Callback URL (important to get right for OAuth users)
 --
 1. Open your application settings at http://dev.twitter.com/apps/
 2. 'Application Type' should be set to BROWSER (not client)
 3. 'Callback URL' should match whatever you enter in SHKTwitterCallbackUrl.  The callback url doesn't have to be an actual existing url.  The user will never get to it because ShareKit intercepts it before the user is redirected.  It just needs to match.
 */

- (NSString*)twitterConsumerKey {
	return @"386454467-1acHbc8ymyHvHarADBiCp55C64TQSKgTii3WTTM";
}

- (NSString*)twitterSecret {
	return @"anftKHpWIquQQH2UFet5KRjWiRxs72tAd1hyJi90";
}
// You need to set this if using OAuth, see note above (xAuth users can skip it)
- (NSString*)twitterCallbackUrl {
	return @"http://www.aldiwan-mobile.com/";
}
// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:0];
}

// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername {
	return @"";
}
// Evernote - http://www.evernote.com/about/developer/api/
/*	You need to set to sandbox until you get approved by evernote
 // Sandbox
 #define SHKEvernoteUserStoreURL    @"https://sandbox.evernote.com/edam/user"
 #define SHKEvernoteNetStoreURLBase @"http://sandbox.evernote.com/edam/note/"
 
 // Or production
 #define SHKEvernoteUserStoreURL    @"https://www.evernote.com/edam/user"
 #define SHKEvernoteNetStoreURLBase @"http://www.evernote.com/edam/note/"
 */

- (NSString*)evernoteUserStoreURL {
	return @"https://sandbox.evernote.com/edam/user";
}

- (NSString*)evernoteNetStoreURLBase {
	return @"http://sandbox.evernote.com/edam/note/";
}

- (NSString*)evernoteConsumerKey {
	return @"vilemkurz";
}

- (NSString*)evernoteSecret {
	return @"e58755227940c41f";
}
// Flickr - http://www.flickr.com/services/apps/create/
/*
 1 - This requires the CFNetwork.framework
 2 - One needs to setup the flickr app as a "web service" on the flickr authentication flow settings, and enter in your app's custom callback URL scheme.
 3 - make sure you define and create the same URL scheme in your apps info.plist. It can be as simple as yourapp://flickr */
- (NSString*)flickrConsumerKey {
    return @"72f05286417fae8da2d7e779f0eb1b2a";
}

- (NSString*)flickrSecretKey {
    return @"b5e731f395031782";
}
// The user defined callback url
- (NSString*)flickrCallbackUrl{
    return @"app://flickr";
}

// Bit.ly for shortening URLs in case you use original SHKTwitter sharer (pre iOS5). If you use iOS 5 builtin framework, the URL will be shortened anyway, these settings are not used in this case. http://bit.ly/account/register - after signup: http://bit.ly/a/your_api_key If you do not enter credentials, URL will be shared unshortened.
- (NSString*)bitLyLogin {
	return @"vilem";
}

- (NSString*)bitLyKey {
	return @"R_466f921d62a0789ac6262b7711be8454";
}

// LinkedIn - https://www.linkedin.com/secure/developer
- (NSString*)linkedInConsumerKey {
	return @"9f8m5vx0yhjf";
}

- (NSString*)linkedInSecret {
	return @"UWGKcBWreMKhwzRG";
}

- (NSString*)linkedInCallbackUrl {
	return @"http://yourdomain.com/callback";
}

- (NSString*)readabilityConsumerKey {
	return @"ctruman";
}

- (NSString*)readabilitySecret {
	return @"RGXDE6wTygKtkwDBHpnjCAyvz2dtrhLD";
}

//Only supports XAuth currently
- (NSNumber*)readabilityUseXAuth {
    return [NSNumber numberWithInt:1];;
}
// Foursquare V2 - https://developer.foursquare.com
- (NSString*)foursquareV2ClientId {
    return @"NFJOGLJBI4C4RSZ3DQGR0W4ED5ZWAAE5QO3FW02Z3LLVZCT4";
}

- (NSString*)foursquareV2RedirectURI {
    return @"app://foursquare";
}
- (NSNumber*)forcePreIOS6FacebookPosting {
	return [NSNumber numberWithBool:YES];
}
- (NSNumber*)forcePreIOS5TwitterAccess {
	return [NSNumber numberWithBool:NO];
}

/*
 UI Configuration : Basic
 ------------------------
 These provide controls for basic UI settings.  For more advanced configuration see below.
 */

- (UIColor*)barTintForView:(UIViewController*)vc {
	
    if ([NSStringFromClass([vc class]) isEqualToString:@"SHKTwitter"])
        return [UIColor colorWithRed:0 green:151.0f/255 blue:222.0f/255 alpha:1];
    
    if ([NSStringFromClass([vc class]) isEqualToString:@"SHKFacebook"])
        return [UIColor colorWithRed:59.0f/255 green:89.0f/255 blue:152.0f/255 alpha:1];
    
    return nil;
}

@end
