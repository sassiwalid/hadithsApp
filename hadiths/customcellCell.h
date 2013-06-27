//
//  customcellCell.h
//  hadith
//
//  Created by Walid Sassi on 19/06/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customcellCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIButton * down;
@property (nonatomic, retain) IBOutlet UIButton * share;
@property (nonatomic, retain) IBOutlet UIButton * play;
@property (nonatomic, retain) IBOutlet UIImageView * img;

@end
