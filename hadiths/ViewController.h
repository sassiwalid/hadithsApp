//
//  ViewController.h
//  hadiths
//
//  Created by Walid Sassi on 25/06/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ReaderViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "PICircularProgressView.h"
@class ViewController;
@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ReaderViewControllerDelegate,MBProgressHUDDelegate,UISearchBarDelegate>
{
    NSMutableArray * hadiths;
    NSMutableArray * links;
    NSMutableArray * downs;
     NSMutableArray * matn;
     NSMutableArray * ids;
    UITableView *table;
    MPMoviePlayerController *p;
    AVAudioPlayer *audioPlayer;
     MBProgressHUD *HUD;
    NSString *currenthadiths;
    UIView * lecteur;
    NSTimer *playbackTimer;
    UILabel * hd;
    UISlider *s;
    NSString * link;
    NSString * down;
    NSNumber *filesize;
    NSMutableData *webData;
    NSURLConnection *theConnection;
    NSString *url;
     NSString *nom;
    NSString * language;
    int tentative,row;
    int b;
    UISearchBar *thesearchBar;
	BOOL searching;
	BOOL letUserSelectRow;
    int indexrow;
     sqlite3 *database;
    NSTimer *timer;
    UIImageView * fireBall;
   UIView * about;
    NSIndexPath * index;
  }

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskID;
@property (nonatomic, retain) IBOutlet  UITableView *table;
@property (nonatomic, retain) IBOutlet  PICircularProgressView *v;
@property(nonatomic,retain)IBOutlet UIView * lecteur;
@property(nonatomic,retain)IBOutlet  UILabel * hd;
@property(nonatomic,retain)IBOutlet  UISlider *s;
@property(retain,nonatomic) IBOutlet UIImageView * fireBall;
@property(retain,nonatomic)  NSNumber  *filesize;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (strong, nonatomic) NSMutableArray* filteredlink;
@property (strong, nonatomic) NSMutableArray* filteredid;
@property (strong, nonatomic) NSMutableArray* filteredowns;
@property (strong, nonatomic) NSMutableArray* filteredmatn;
@property (nonatomic, retain) IBOutlet UISearchBar * thesearchBar;
@property (nonatomic, assign) bool isFiltered;
@property (nonatomic, retain)NSMutableArray * hadiths;
@property (nonatomic, retain)NSMutableArray * links;
@property (nonatomic, retain)NSMutableArray * downs;
@property (nonatomic, retain)  IBOutlet UILabel * msgLabel;
@property (nonatomic,retain) IBOutlet UIView * a;
-(IBAction)fermerlecteur:(id)sender;
-(IBAction)play;
-(IBAction)pause;
-(void)searchDatabase:(NSString*)searchTerm;
- (void) getInitialDataToDisplay:(NSString *)dbPath : (NSString *)Lang ;
-(IBAction)changelanguage:(id)sender;
-(IBAction)about;
-(IBAction)back;
-(IBAction)next:(int)t;
-(IBAction)previous;
- (BOOL)connected;
@end
