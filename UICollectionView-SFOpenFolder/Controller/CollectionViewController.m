//
//  CollectionViewController.m
//  SFOpenFolder
//
//  Created by Jakey on 2017/3/28.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "CollectionViewHeader.h"
#import "UICollectionView+SFOpenFolder.h"
#import "DetailViewController.h"


@interface CollectionViewController ()
{
    NSMutableArray *_items;
}
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"CollectionViewHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeader"];

    
    _items = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j=0; j<(i+1)*6; j++) {
            [array addObject:[NSString stringWithFormat:@"i%zd j%zd",i,j]];
        }
        NSDictionary *dic =   @{@"items":array,@"expand":@(YES)};
        [_items addObject:dic];
        
    }
    [self.myCollectionView reloadData];
}


- (IBAction)backButtonTouched:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_items count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *item = [_items objectAtIndex:section];
    if (![[item objectForKey:@"expand"] boolValue]) {
        return 0;
    }else{
        return [[item objectForKey:@"items"] count];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CollectionViewCell";
    //    [collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [collectionView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    NSDictionary *item = [_items objectAtIndex:indexPath.row];
    cell.label.text = [NSString stringWithFormat:@"{%zd,%zd}",indexPath.section,indexPath.row];

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frame.size.width, 40);
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = @"CollectionViewHeader";
    CollectionViewHeader *cell = (CollectionViewHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.button.tag = indexPath.section;
    [cell.button addTarget:self action:@selector(sectionTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button setTitle:[@(indexPath.section) description] forState:UIControlStateNormal];
//    [_allHeaders setObject:cell forKey:indexPath];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (collectionView.bounds.size.width - 30) / 4;
    CGFloat height = width;
    return CGSizeMake(width, height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat width = (collectionView.bounds.size.width - 30) / 4;
    NSInteger numberOfCells = collectionView.bounds.size.width / width;
    NSInteger edgeInsets = (collectionView.bounds.size.width - (numberOfCells * width)) / (numberOfCells + 1);
    
    return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
}
- (void)sectionTouched:(UIButton*)sender{
    [self.myCollectionView sf_closeViewWithSelectIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];

    NSMutableDictionary *item = [[_items objectAtIndex:sender.tag] mutableCopy];
    BOOL expand = [[item objectForKey:@"expand"] boolValue];
    [item setObject:@(!expand) forKey:@"expand"];
    [_items replaceObjectAtIndex:sender.tag withObject:item];
    [self.myCollectionView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag]];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView sf_openFolderAtIndexPath:indexPath contentBlock:^UIView *(id item) {
        DetailViewController *detail =  [[DetailViewController alloc] init];
        detail.view.frame = CGRectMake(0, 0, collectionView.frame.size.width, detail.view.frame.size.height);
        return detail.view;
    } beginningBlock:^(SFOpenStatus openStatus) {
        if (openStatus == SFOpenStatusOpening) {
            NSLog(@"begin opening");
        }
        if (openStatus == SFOpenStatusClosing) {
            NSLog(@"begin closing");
        }
        
    } completionBlock:^(SFOpenStatus openStatus) {
        if (openStatus == SFOpenStatusOpened) {
            NSLog(@"completion open");
        }
        if (openStatus == SFOpenStatusClose) {
            NSLog(@"completion  close");
        }
    }];
}
@end
