YEERatingView
=============

A star rating control for the mac.

![alt text](https://raw.githubusercontent.com/YEDev/YEERatingView/master/YEERatingView.gif "Sample")

A little better than most star rating controls, because it does not remove visual information about what your current selection is when you mouse over other stars.

### Usage

```objective-c
@property (nonatomic, weak) YEERatingView *ratingView;

- (void)someMethod {
    YEERatingView *ratingView = YEERatingView.new;
    [self.view addSubview:ratingView];
    self.ratingView = ratingView;

    // later, when we need the rating:

    NSInteger rating = self.ratingView.rating;
    
    // If you need to be notified every time the rating changes, you can just KVO observe the @"rating" key.
}
```
