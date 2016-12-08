//
//  ViewController.m
//  hadiths
//
//  Created by Walid Sassi on 25/06/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import "ViewController.h"
#import "customcellCell.h"
#import "SHKFacebook.h"
@interface ViewController ()
@end

@implementation ViewController
@synthesize table,lecteur,hd,s,filesize,thesearchBar,filteredTableData,isFiltered,hadiths,links,downs,msgLabel,fireBall,a,filteredid,filteredlink,filteredowns,filteredmatn,v;
- (void)viewDidLoad
{
    [super viewDidLoad];
    down=[[NSString alloc]init];
    link =[[NSString alloc]init];
    language=[[NSString alloc]init];
    index=[[NSIndexPath alloc]init];
    language=@"ar";
    b=0;
    table.tableHeaderView=thesearchBar;
    BOOL deviceIsIPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    if(deviceIsIPad)
    {
    [lecteur setFrame:CGRectMake(0,-340, lecteur.frame.size.width, lecteur.frame.size.height)];
    }
    else
    {
     [lecteur setFrame:CGRectMake(0,-140, lecteur.frame.size.width, lecteur.frame.size.height)];
    }
    s.transform = CGAffineTransformMakeScale(1, 0.75);
   

    [self.view addSubview:lecteur];
	// Do any additional setup after loading the view, typically from a nib.
}
-(IBAction)next:(int)t;
{
    if (indexrow<42)
    {
  link=[links objectAtIndex:indexrow+1];
    down=[downs objectAtIndex:indexrow+1];
    NSLog(@"%@",down);
    [hd setText:[hadiths objectAtIndex:indexrow+1]];
    indexrow++;
        tentative=1;
    }
    
}
-(IBAction)previous;
{
    if (indexrow>0)
    {
        link=[links objectAtIndex:indexrow-1];
        down=[downs objectAtIndex:indexrow-1];
        NSLog(@"%@",down);
        [hd setText:[hadiths objectAtIndex:indexrow-1]];
        indexrow--;
        tentative=1;
    }
}

-(IBAction)about
{
    [UIView beginAnimations:nil context:@"flipTransitionToBack"];
    [UIView setAnimationDuration:1.2];
    
    //note self.view IS the backing view
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    //add the back view view
    [self.view addSubview:a];
    [UIView commitAnimations];
   
}
-(IBAction)back
{
    [a removeFromSuperview];
}

-(void) onTimer {
    int  idNum = (arc4random() % 4)+1;
    NSString * imgIDnum = [[NSString alloc] initWithFormat:@"%d", idNum];
    NSString * imgMain = [NSString stringWithFormat:@"%@%@", imgIDnum, @".jpeg"];
    [imgIDnum release];
    UIImage * daImg = [UIImage imageNamed:imgMain];
    [fireBall setImage:daImg];
}
- ( void ) searchBarTextDidBeginEditing: ( UISearchBar * ) searchBar {
    [ searchBar setShowsCancelButton : YES animated : YES ];
    
}

-(IBAction)changelanguage:(UIButton*)sender
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	NSString * filepath =[documentsDir stringByAppendingPathComponent:@"hadithDB.sqlite"];
    if (sender.tag==1)
    {
        
        [self getInitialDataToDisplay:filepath :@"ar"];
        language=@"ar";
    }
    else
    {
        [self getInitialDataToDisplay:filepath :@"en"];
          language=@"en";
    }
    [table reloadData];
}
- (void) getInitialDataToDisplay:(NSString *)dbPath :(NSString *)lang
{
    hadiths=[[NSMutableArray alloc]init];
    links=[[NSMutableArray alloc]init];
    downs=[[NSMutableArray alloc]init];
    matn=[[NSMutableArray alloc]init];
    ids=[[NSMutableArray alloc]init];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSString *sqlStatement =[NSString stringWithFormat:@"SELECT * FROM hadith_info WHERE lang ='%@'", lang];
        sqlite3_stmt *compileStatement;
        
        if (sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &compileStatement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(compileStatement) == SQLITE_ROW)
            {
                NSString *hadithid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compileStatement, 0)];
                NSString *hadithname = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compileStatement, 1)];
                NSString *hadithlink = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compileStatement, 2)];
                NSString *hadithdown = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compileStatement, 4)];
                NSString *hadithmatn = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compileStatement, 5)];
                [ids addObject:hadithid];
                [hadiths addObject:hadithname];
                [links addObject:hadithlink];
                [downs addObject:hadithdown];
                [matn addObject:hadithmatn];
            }
        }
        
    }
    else
    {
        NSLog(@"error in database");
    }
    
 
}
- ( void )searchBarCancelButtonClicked: ( UISearchBar * ) searchBar
{
    searchBar.text = @"" ;
    [ searchBar setShowsCancelButton : NO animated : YES ];
    [ searchBar resignFirstResponder ];
    self.table.allowsSelection = YES ;
    self.table.scrollEnabled = YES ;
    isFiltered = false;
    [table reloadData];
}
 - ( void ) searchBarSearchButtonClicked: ( UISearchBar * ) searchBar {
     if(searchBar.text.length == 0)
     {
         isFiltered = false;
         [table reloadData];
     }
     else
     {
         isFiltered = true;
         [self searchDatabase:searchBar.text];
         [table resignFirstResponder];
         [self.view endEditing:YES];
     }
 }
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
}
-(void)searchDatabase:(NSString*)searchTerm
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"hadithDB.sqlite"];
    filteredTableData=[[NSMutableArray alloc]init];
    filteredid=[[NSMutableArray alloc]init];
    filteredlink=[[NSMutableArray alloc]init];
    filteredowns=[[NSMutableArray alloc]init];
    filteredmatn=[[NSMutableArray alloc]init];
    NSString *sqlQry = [NSString stringWithFormat:@"SELECT * FROM hadith_info WHERE matn LIKE '%%%@%%'", searchTerm];
    sqlite3_stmt *sqlStatement = NULL;
    if(!(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK))
    {
        NSLog(@"An error has occured.");
        
    }
    else
    {
    if(sqlite3_prepare_v2(database, [sqlQry UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK)
    {
    NSLog(@"Problem with prepare statement: %d", sqlite3_errcode(database));
        
    }
    while (sqlite3_step(sqlStatement)==SQLITE_ROW)
    {
        NSString *Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 1)];
        NSLog(@"This is the filename %@",Name);
        [filteredTableData addObject:Name];
        NSString *id = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 0)];
        NSLog(@"This is the filename id %@",id);
        [filteredid addObject:id];
        NSString *l = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 2)];
        NSLog(@"This is the filename link %@",l);
        [filteredlink addObject:l];
        NSString *d = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement, 4)];
        NSLog(@"This is the filename down %@",d);
        [filteredowns addObject:d];
        NSString *m = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStatement,5)];
        NSLog(@"This is the matn %@",m);
        [filteredmatn addObject:m];
    }
    }
    
    sqlite3_finalize(sqlStatement);
    sqlite3_close(database);
    [table reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    if(self.isFiltered)
        rowCount = filteredTableData.count;
    else
        rowCount = hadiths.count;
    
    return rowCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"customcell";
    
    customcellCell *cell = (customcellCell *)[table dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSArray *nib;
    if (cell == nil)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell-ipad" owner:self options:nil];
        }
        else {
            nib = [[NSBundle mainBundle] loadNibNamed:@"customcellCell" owner:self options:nil];
        }
        
        cell = [nib objectAtIndex:0];
    }
    NSString *piste;
    if(isFiltered)
    {
         piste = [filteredTableData objectAtIndex:indexPath.row];
    }
    else
    {
         piste = [hadiths objectAtIndex:indexPath.row];
    }
    currenthadiths=[hadiths objectAtIndex:indexPath.row];
    cell.nameLabel.text = piste;
    cell.share.tag=indexPath.row;
    cell.play.tag=indexPath.row;
    cell.down.tag=indexPath.row;
    [cell.share addTarget:self action:@selector (share:)  forControlEvents:UIControlEventTouchUpInside];
    [cell.play addTarget:self action:@selector (showplay:)  forControlEvents:UIControlEventTouchUpInside];
    [cell. down addTarget:self action:@selector (exist:)  forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void) exist :(id)sender
{
    UIButton *btn = (UIButton *)sender;
    indexrow = btn.tag;
    if (isFiltered)
    {
    row=[[filteredid objectAtIndex:btn.tag]intValue];
    nom=[filteredTableData objectAtIndex:btn.tag];
    link=[filteredlink objectAtIndex:btn.tag];
    }
    else
    {
    row=[[ids objectAtIndex:btn.tag]intValue];
    nom=[hadiths objectAtIndex:btn.tag];
    link=[links objectAtIndex:btn.tag];
    }
    
            index = [NSIndexPath indexPathWithIndex:indexrow];
    NSLog(@"Selected row is: %d",indexrow);
    
    if (isFiltered)
    {
    if ([[filteredowns objectAtIndex:indexrow]isEqualToString:@"NO" ])
    {
        if (b ==1)
        {
            if ([language isEqualToString:@"ar"])
            {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"إعلام"
                                                              message:@"هناك مقطع يحمل الان "
                                                             delegate:nil
                                                    cancelButtonTitle:@"شكرا"
                                                    otherButtonTitles:nil];
            [message show];
            }
            else
            {
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"about"
                                                                  message:@"there is a download now "
                                                                 delegate:nil
                                                        cancelButtonTitle:@"thank you"
                                                        otherButtonTitles:nil];
                [message show];
            }
        }
         else
        {
        [self showConfirmAlert];
        }
    }
    else
    {
        if ([language isEqualToString:@"ar"])
        {
        UIAlertView *message = [[[UIAlertView alloc] initWithTitle:@"حذف المقطع" message:@"هل تريد فسخ المقطع" delegate:self cancelButtonTitle:@"الغاء" otherButtonTitles:nil] autorelease];
        [message addButtonWithTitle:@"نعم"];
        [message setTag:2];
        [message show];
        }
        else
        {
            UIAlertView *message = [[[UIAlertView alloc] initWithTitle:@"delete track" message:@"do you want delete" delegate:self cancelButtonTitle:@"اNO" otherButtonTitles:nil] autorelease];
            [message addButtonWithTitle:@"YES"];
            [message setTag:2];
            [message show];
        }
        
    }
   
    }
    else
    {
        if ([[downs objectAtIndex:indexrow]isEqualToString:@"NO" ])
        {
            if (b ==1)
            {
                if ([language isEqualToString:@"ar"])
                {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"إعلام"
                                                                      message:@"هناك مقطع يحمل الان "
                                                                     delegate:nil
                                                            cancelButtonTitle:@"شكرا"
                                                            otherButtonTitles:nil];
                    [message show];
                }
                else
                {
                    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"about"
                                                                      message:@"there is a download now "
                                                                     delegate:nil
                                                            cancelButtonTitle:@"thank you"
                                                            otherButtonTitles:nil];
                    [message show];
                }
            }
            else
            {
                [self showConfirmAlert];
            }
        }
        else
        {
            if ([language isEqualToString:@"ar"])
            {
            UIAlertView *message = [[[UIAlertView alloc] initWithTitle:@"حذف المقطع" message:@"هل تريد فسخ المقطع" delegate:self cancelButtonTitle:@"الغاء" otherButtonTitles:nil] autorelease];
            [message addButtonWithTitle:@"نعم"];
            [message setTag:2];
            [message show];
            }
            else
            {
                UIAlertView *message = [[[UIAlertView alloc] initWithTitle:@"delete track" message:@"do you want delete" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil] autorelease];
                [message addButtonWithTitle:@"YES"];
                [message setTag:2];
                [message show];
            }
            
        }
        
    }
    

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
	  if (buttonIndex == 1)
	  {
		[self downloadFileFromURL];
	   }
	   else if (buttonIndex == 0)
	   {
		// No
       }
    }
    else
    {
        if (buttonIndex == 1)
        {
            [self supprimerfichier];
        }
        else if (buttonIndex == 0)
        {
            // No
        }
    }
}
- (void)showConfirmAlert
{
    if ([language isEqualToString:@"ar"])
    {
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"تأكيد"];
	[alert setMessage:@" هل تريد فعلا التحميل?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"لا"];
	[alert addButtonWithTitle:@"نعم"];
    [alert setTag:1];
	[alert show];
    [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] init];
        [alert setTitle:@"confirm"];
        [alert setMessage:@"Do you want download"];
        [alert setDelegate:self];
        [alert addButtonWithTitle:@"No"];
        [alert addButtonWithTitle:@"Yes"];
        [alert setTag:1];
        [alert show];
        [alert release];

    }
}
-(void) setRequestURL:(NSString*) requestURL {
    url = requestURL;
}
-(void) supprimerfichier
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"hadithDB.sqlite"];
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        // Préparation de la requête SQL qui va permettre d’ajouter un score à la BDD
        NSString *sqlStat = [NSString stringWithFormat:@"UPDATE hadith_info SET down ='NO' WHERE nom =='%@'",nom];
        //conversion en char *
        const char *sqlStatement = [sqlStat UTF8String];
        //On utilise sqlite3_exec qui permet très simplement d’exécuter une
        sqlite3_exec(database, sqlStatement,NULL,NULL,NULL);
        
    }
    sqlite3_close(database);
    NSString *newDirectory = [NSString stringWithFormat:@"%@/download/",documentsDir];
    NSString *filePath = nil;
    if ([language isEqualToString:@"ar"])
    {
        filePath = [[NSString alloc]initWithFormat:@"%@%d.mp3",newDirectory,row];
    }
    else
    {
        filePath = [[NSString alloc]initWithFormat:@"%@%den.mp3",newDirectory,row];
    }
    NSLog(@"%@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
     if (isFiltered)
     {
    [filteredowns removeObjectAtIndex:indexrow];
    [filteredowns insertObject:@"NO" atIndex:indexrow];
     }
    else
    {
        [downs removeObjectAtIndex:indexrow];
        [downs insertObject:@"NO" atIndex:indexrow];
    }
    [fileManager removeItemAtPath:filePath  error:nil];
    if ([language isEqualToString:@"ar"])
    {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"إعلام"
                                                      message:@"تم الحذف بنجاح"
                                                     delegate:nil
                                            cancelButtonTitle:@"شكرا"
                                            otherButtonTitles:nil];
    [message show];
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Info"
                                                          message:@"Track deleted"
                                                         delegate:nil
                                                cancelButtonTitle:@"thank you"
                                                otherButtonTitles:nil];
   [message show];
    }
    
}
-(IBAction) downloadFileFromURL {
  
    NSURL *reqURL =  [NSURL URLWithString:link];
    NSLog(@"%@",link);
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:reqURL];
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (theConnection)
    {
        webData = [[NSMutableData data] retain];
        b = 1;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطأ !" message:@"تأكد من ربطك بنت"  delegate:nil cancelButtonTitle:@"شكرا" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
    }
    self.backgroundTaskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        // Cancel the connection
        [theConnection cancel];
    }];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [webData setLength:0];
    self.filesize = [NSNumber numberWithUnsignedInteger:[response expectedContentLength]];
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [webData appendData:data];
     NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:[webData length]];
    float progress = [resourceLength floatValue] / [self.filesize floatValue];
    self.v.progress=progress;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
   
    // Create the new dictionary that will be inserted into the plist.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"hadithDB.sqlite"];
    b=0;
    if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        // Préparation de la requête SQL qui va permettre d’ajouter un score à la BDD
        NSString *sqlStat = [NSString stringWithFormat:@"UPDATE hadith_info SET down ='YES' WHERE nom =='%@'",nom];
        //conversion en char *
        const char *sqlStatement = [sqlStat UTF8String];
        //On utilise sqlite3_exec qui permet très simplement d’exécuter une
        sqlite3_exec(database, sqlStatement,NULL,NULL,NULL); 
         
    }
    sqlite3_close(database);
    NSString *newDirectory = [NSString stringWithFormat:@"%@/download/",documentsDir];
    if (![[NSFileManager defaultManager] fileExistsAtPath:newDirectory]) {
        // Directory does not exist so create it
        [[NSFileManager defaultManager] createDirectoryAtPath:newDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = nil;
    if ([language isEqualToString:@"ar"])
    {
    filePath = [[NSString alloc]initWithFormat:@"%@%d.mp3",newDirectory,row];
    }
    else
    {
        filePath = [[NSString alloc]initWithFormat:@"%@%den.mp3",newDirectory,row];
    }
    NSLog(@"%@",filePath);
    [webData writeToFile:filePath atomically:YES ];
    if (isFiltered)
    {
    [filteredowns removeObjectAtIndex:indexrow];
    [filteredowns insertObject:@"YES" atIndex:indexrow];
    [downs removeObjectAtIndex:[[ids objectAtIndex:indexrow]intValue]];
    [downs insertObject:@"YES" atIndex:[[ids objectAtIndex:indexrow]intValue]];
    }
    else
    {
    [downs removeObjectAtIndex:indexrow];
    [downs insertObject:@"YES" atIndex:indexrow];
    }
    //NSURL *fileURL = [NSURL fileURLWithPath:resourceDocPath];
    NSError *writeError = nil;
    
    // [webData writeToURL: filePath options:0 error:&writeError];
    if( writeError) {
        NSLog(@" Error in writing file %@' : \n %@ ", filePath, writeError );
        return;
    }
    else
    {
        if ([language isEqualToString:@"ar"])
        {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"إعلام"
                                                          message:@"تم التحميل بنجاح"
                                                         delegate:nil
                                                cancelButtonTitle:@"شكرا"
                                                otherButtonTitles:nil];
        [message show];
        }
        else
        {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"info"
                                                              message:@"track downloaded"
                                                             delegate:nil
                                                    cancelButtonTitle:@"thank you"
                                                    otherButtonTitles:nil];
            [message show];

        }
        
             }
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskID];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"تنبيه !" message:@"الربط بالانترنت ضعيف"  delegate:nil cancelButtonTitle:@"شكرا" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskID];
    
}
-(void) showplay :sender
{
    tentative=1;
    UIButton *btn = (UIButton *)sender;
    indexrow = btn.tag;
    NSLog(@"Selected row is: %d",indexrow);
    if (isFiltered)
    {
        currenthadiths=[filteredTableData objectAtIndex:indexrow];
        link=[filteredlink objectAtIndex:btn.tag];
    }
    else
    {
        currenthadiths=[hadiths objectAtIndex:indexrow];
         link=[links objectAtIndex:btn.tag];
    }
    
     down=[downs objectAtIndex:btn.tag];
    NSLog(@"%@",down);
    [hd setText:currenthadiths];
    BOOL deviceIsIPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    CGRect newFrame;
    if(deviceIsIPad)
    {
    newFrame = lecteur.frame;
    newFrame.origin.y += 350;
    }
    else
    {
        newFrame = lecteur.frame;
        newFrame.origin.y += 200;
    }
    [UIView animateWithDuration:1.0
                     animations:^{
                         lecteur.frame = newFrame;
                         
                     }];
    
     timer= [NSTimer scheduledTimerWithTimeInterval:(3) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];

}
-(void)playAudio
{
    
    playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(updateTime)
                                                   userInfo:nil
                                                    repeats:YES];
    
    [p play];
    
    
}
-(void)updateTime
{
    float minutes = floor(p.currentPlaybackTime/60);
    float seconds = p.currentPlaybackTime- (minutes * 60);
    
    float duration_minutes = floor(p.duration/60);
    float duration_seconds =
    p.duration - (duration_minutes * 60);
    
    NSString *timeInfoString = [[NSString alloc]
                                initWithFormat:@"%0.0f.%0.0f / %0.0f.%0.0f",
                                minutes, seconds,
                                duration_minutes, duration_seconds];
    
    msgLabel.text = timeInfoString;
    
    
    s.maximumValue=[p duration];
    s.value=p.currentPlaybackTime;
    if (![self connected]) {
        // not connected
    } else {
        // connected, do some internet stuff
    }

    //[timeInfoString release];
}
-(IBAction)lireprogessivement;
{
    p.currentPlaybackTime =s.value;
    [self playAudio ];
    
}
-(IBAction)pause
{
    p.currentPlaybackTime =s.value;
    [p pause];
}
-(IBAction)play
{

    if ((tentative==1)&&([down isEqualToString:@"NO"]))
    {
        NSURL *urli=[NSURL URLWithString:link];
        NSLog(@"%@",link);
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"جاري التحميل";
        [HUD showWhileExecuting:@selector(prepare) onTarget:self withObject:nil animated:YES];
        p = [[MPMoviePlayerController alloc] initWithContentURL:urli];
        s.value = 0.0;
        s.maximumValue=[p duration];
        tentative=2;
        [self playAudio];
    }
    else
        if ((tentative==1)&&([down isEqualToString:@"YES"])) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
            NSString *documentsDir = [paths objectAtIndex:0];
            NSString *newDirectory = [NSString stringWithFormat:@"%@/download/",documentsDir];
           NSString *locallink=[[NSString alloc]init];
            if ([language isEqualToString:@"ar"])
            {
            locallink= [NSString stringWithFormat:@"%@%d.mp3",newDirectory,indexrow+1];
            }
            else
            {
             locallink= [NSString stringWithFormat:@"%@%den.mp3",newDirectory,indexrow+43];
            }
            NSLog(@"%@",locallink);
            NSURL *u=[NSURL fileURLWithPath:locallink];
            p = [[MPMoviePlayerController alloc] initWithContentURL:u];
            tentative=2;
            [self playAudio];
        }
    else
    {
       [self playAudio];  
    }
    

}
-(void)prepare
{
    sleep(5);
    
}
-(void)viewDidAppear:(BOOL)animated
{
    tentative=1;
    [table reloadData];
}

-(IBAction)fermerlecteur:(id)sender
{
    BOOL deviceIsIPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    if(deviceIsIPad)
    {

    [UIView animateWithDuration:1.0
                     animations:^{
                         [lecteur setFrame:CGRectMake(0,-340, lecteur.frame.size.width, lecteur.frame.size.height)];
                     }];
    }
    else
    {
        [UIView animateWithDuration:1.0
                         animations:^{
                             [lecteur setFrame:CGRectMake(0,-140, lecteur.frame.size.width, lecteur.frame.size.height)];
                         }];
    }
   
}
-(void) share:sender
{
    UIButton *btn = (UIButton *)sender;
   indexrow = btn.tag;
    NSLog(@"Selected row is: %d",indexrow);
    SHKItem *item = nil;
    if (isFiltered)
    {
  item = [SHKItem text:[filteredmatn objectAtIndex:indexrow]];   
    }
    else
    {
   item = [SHKItem text:[matn objectAtIndex:indexrow]];
    }
    // Get the ShareKit action sheet
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    
    // Display the action sheet
    [actionSheet showInView:self.view];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *filePath = nil;
   if (isFiltered)
   {
       if ([language isEqualToString:@"ar"])
            {
   filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[filteredid objectAtIndex:indexPath.row]]ofType:@"pdf" inDirectory:nil];
            }
            else
            {
        filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%dEn",[[filteredid objectAtIndex:indexPath.row]intValue]-42]ofType:@"pdf" inDirectory:nil];
            }
   }
    else
    {
        if ([language isEqualToString:@"ar"])
             {
                 filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",indexPath.row+1]ofType:@"pdf" inDirectory:nil];
             }
             else
             {
               filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%dEn",indexPath.row+1]ofType:@"pdf" inDirectory:nil];
             }
    }
            
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:Nil];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		/*[self.navigationController pushViewController:readerViewController animated:YES];*/
        
#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
		[self presentModalViewController:readerViewController animated:YES];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
        
		[readerViewController release]; // Release the ReaderViewController
	}
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
