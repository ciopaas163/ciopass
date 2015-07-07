#import "PersonCell.h"

@implementation PersonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self initContent];
    }
    return self;
}

- (void)initContent{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.contentView.bounds.size.width;
    CGFloat h = 20;
    
    for (int i = 0; i < 4; i++) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:label];
        
        y = label.frame.origin.y + label.frame.size.height;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(x, y - 1, w, 1)];
        line.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:line];
        
        switch (i) {
            case 0:
                _name = label;
                break;
            case 1:
                _phone = label;
                break;
            case 2:
                _telPhone = label;
                break;
            case 3:
                _tagText = label;
                break;
            default:
                break;
        }
    }
}

- (void)setDict:(NSDictionary *)dict{
    if (_dict != dict) {
        _dict = dict;
    }
    NSString * name = [dict objectForKey:NAME];
    NSString * phone = [dict objectForKey:PHONE];
    NSString * telPhone = [dict objectForKey:TELPHONE];
    NSString * tag   = [dict objectForKey:INFOTAG];
    
    _name.text = [NSString stringWithFormat:@"姓名：%@",name];
    _phone.text = [NSString stringWithFormat:@"手机：%@",phone];
    _telPhone.text = [NSString stringWithFormat:@"电话：%@",telPhone];
    _tagText.text = [NSString stringWithFormat:@"标签：%@",tag];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
