//
//  DetailViewCell.m
//  MapTutorial
//
//  Created by ViVID on 9/30/16.
//  Copyright © 2016 ViVID. All rights reserved.
//

#import "DetailViewCell.h"

@implementation DetailViewCell
@synthesize InstructionLab,DistanceLab;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
