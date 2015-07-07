#import "PersonTagBtn.h"

@implementation PersonTagBtn

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(15, 0, self.bounds.size.width - 30, self.bounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
