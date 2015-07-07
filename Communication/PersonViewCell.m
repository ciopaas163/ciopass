#import "PersonViewCell.h"

@implementation PersonViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initContent];
    }
    return self;
}

- (void)initContent{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_titleLabel];
    
    _field = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    _field.backgroundColor = [UIColor clearColor];
    _field.delegate = self;
    [self.contentView addSubview:_field];
}

- (void)setTitle:(NSString *)title{
    if (![_title isEqualToString:title]) {
        _title = title;
    }
    _titleLabel.text = title;
    
    CGRect rect = [_titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, _titleLabel.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _titleLabel.font} context:nil];//获取宽
    CGRect frame = _titleLabel.frame;
    frame.size.width = rect.size.width;
    _titleLabel.frame = frame;
    
    frame = _field.frame;
    frame.origin.x = _titleLabel.frame.origin.x + _titleLabel.frame.size.width + 10;
    frame.size.width = self.contentView.bounds.size.width - frame.origin.x;
    _field.frame = frame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
