//
//  CollectionViewController.h
//  SFOpenFolder
//
//  Created by Jakey on 2017/3/28.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController
- (IBAction)backButtonTouched:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end
