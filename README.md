# UICollectionView-SFOpenFolder
UICollectionView+SFOpenFolder,a UICollectionView category,(防苹果系统文件夹展开抽屉效果）like iOS springborad folder expand。

# usage
## import
```
#import "UICollectionView+SFOpenFolder.h"
```

## open

```
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
```

## manual close

```
- (void)sectionTouched:(UIButton*)sender{
    //....
    [self.myCollectionView sf_closeViewWithSelectedIndexPath:^(NSIndexPath *selectedIndexPath) {
          
        }];
    //....
}
```

# demo
## when one row have many column
![](https://raw.githubusercontent.com/shaojiankui/UICollectionView-SFOpenFolder/master/demo.gif)

## when one row have one column
![](https://raw.githubusercontent.com/shaojiankui/UICollectionView-SFOpenFolder/master/demotableview.gif)
