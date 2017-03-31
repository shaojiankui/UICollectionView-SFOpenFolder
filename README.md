# UICollectionView-SFOpenFolder
UICollectionView+SFOpenFolder,a UICollectionView category,(仿苹果系统文件夹展开抽屉效果）like iOS springborad folder expand。

# usage
## import
```
#import "UICollectionView+SFOpenFolder.h"
```

## open

```
_detail= [[DetailViewController alloc]init];
[self addChildViewController:_detail];
```


```
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView sf_openFolderAtIndexPath:indexPath contentBlock:^UIView *(id item) {
        _detail.view.frame = CGRectMake(0, 0, collectionView.frame.size.width, _detail.view.frame.size.height);
        return _detail.view;
    } beginningBlock:^(SFOpenStatus openStatus) {
        if (openStatus == SFCollectionOpenStatusOpening) {
            NSLog(@"begin opening");
        }
        if (openStatus == SFCollectionOpenStatusClosing) {
            NSLog(@"begin closing");
        }
        
    } completionBlock:^(SFOpenStatus openStatus) {
        if (openStatus == SFCollectionOpenStatusOpened) {
            NSLog(@"completion open");
        }
        if (openStatus == SFCollectionOpenStatusClose) {
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
