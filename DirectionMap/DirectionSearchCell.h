//
//  DirectionSearchCell.h
//  MapTutorial
//
//  Created by ViVID on 9/26/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionSearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *DirectionImage;
@property (strong, nonatomic) IBOutlet UILabel *TitleLab;
@property (strong, nonatomic) IBOutlet UILabel *Subtitlelab;
@property (strong, nonatomic) IBOutlet UIImageView *IndicateIcon;

@end
