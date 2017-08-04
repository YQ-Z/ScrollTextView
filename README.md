# ScrollTextView
Customize the ScrollTextView to scroll in any directio.

![TarBarGif](https://github.com/YQ-Z/ScrollTextView/blob/master/ScrollTextVew.gif)
# Requirements
iOS 8.0 or later

# Example Usage
```
    self.scrollTextView1 = [[TextScrollBarView alloc]initWithFrame:CGRectMake(0, 60, 300,30) textScrollModel:TextScrollFromOutside_Continuous direction:TextScrollMoveLeft];
    [self.scrollTextView1 scrollWithText:@"内容" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15.0f]];
    [self.scrollTextView1 startScroll];
    [self.view addSubview:self.scrollTextView1];
```
```
- (void)viewWillDisappear:(BOOL)animated {
    [self.scrollTextView1 endScroll];
}
```
