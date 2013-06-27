//
//  customcellCell.m
//  hadith
//
//  Created by Walid Sassi on 19/06/13.
//  Copyright (c) 2013 Walid Sassi. All rights reserved.
//

#import "customcellCell.h"

@implementation customcellCell
@synthesize nameLabel,down,img ;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    BOOL deviceIsIPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    
    if (selected)
    {
        if(deviceIsIPad) {
            [self.img setImage:[UIImage imageNamed:@"cell-568-sel@2x.png"]];//Image that i want on Selection
        }
        else
        {
            [self.img setImage:[UIImage imageNamed:@"cell-568-sel.png"]];//Image that i want on Selection
        }
    }
    else
    {
        if(deviceIsIPad) {
            [self.img setImage:[UIImage imageNamed:@"cellule@2x.png"]];//Image that i want on Selection
        }
        else
        {
            [self.img setImage:[UIImage imageNamed:@"cellule.png"]];
        }
    }
    //Normal image at background everytime table loads.
    
    // Configure the view for the selected state
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL deviceIsIPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    if(deviceIsIPad) {
        return 122;
    }
    else
    {
        return 61;
    }
}
@end
