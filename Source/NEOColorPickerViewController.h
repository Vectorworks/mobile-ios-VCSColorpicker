#import "NEOColorPickerBaseViewController.h"

@interface NEOColorPickerViewController : NEOColorPickerBaseViewController

@property (weak, nonatomic) IBOutlet UIView *simpleColorGrid;
@property (weak, nonatomic) IBOutlet UIButton *buttonHue;
@property (weak, nonatomic) IBOutlet UIButton *buttonAddFavorite;
@property (weak, nonatomic) IBOutlet UIButton *buttonFavorites;
@property (weak, nonatomic) IBOutlet UIButton *buttonHueGrid;
@property (weak, nonatomic) IBOutlet UILabel *selectedColorLabel;
@property (nonatomic, strong) NSString* favoritesTitle;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *centeredView;

- (IBAction)buttonPressHue:(id)sender;
- (IBAction)buttonPressHueGrid:(id)sender;
- (IBAction)buttonPressAddFavorite:(id)sender;
- (IBAction)buttonPressFavorites:(id)sender;


@end
