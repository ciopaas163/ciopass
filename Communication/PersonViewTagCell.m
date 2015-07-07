#import "PersonViewTagCell.h"

@implementation PersonViewTagCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setTagText:(NSString *)tagText{
    if (![_tagText isEqualToString:tagText]) {
        _tagText = tagText;
    }
    for (UIView * subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSString * text = @"已添加标签";
    CGFloat height = 44;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, height)];
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    
    CGFloat x = label.frame.origin.x + label.frame.size.width + 20;
    
    rect = [_tagText boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    if (_tagText.length) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, 0, rect.size.width, 30);
        button.center = CGPointMake(button.center.x, height/2.0);
        [button setTitle:_tagText forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setBackgroundColor:[UIColor clearColor]];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[UIColor redColor] CGColor];
        [button addTarget:self action:@selector(deleteTag) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
}

- (void)deleteTag{//删除选中tag
    [_delegate delegateTag];
}

- (void)setUnselectTagView:(UIView *)unselectTagView{
    if (_unselectTagView != unselectTagView) {
        _unselectTagView = unselectTagView;
    }
    for (UIView * subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_unselectTagView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
