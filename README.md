UIAlertController-MZStyle
===========

`UIAlertController-MZStyle` is a category on `UIAlertController` with possibility of customization.

[![](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/1_a.jpg)](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/1_a.png)
[![](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/2_a.jpg)](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/2_a.png)
[![](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/3_a.jpg)](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/3_a.png)
[![](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/4_a.jpg)](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/4_a.png)

[![](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/1_b.jpg)](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/1_b.png)
[![](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/2_b.jpg)](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/2_b.png)
[![](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/3_b.jpg)](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/3_b.png)
[![](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/4_b.jpg)](https://raw.github.com/m1entus/UIAlertController-MZStyle/master/Screens/4_b.png)

# Known Issues

Not work with ActionSheets on iPad.

## Requirements

MZFormSheetPresentationController requires either iOS 8.x and above.

## How To Use

``` objective-c
// Tell UIAlertController that you will use custom style
[UIAlertController mz_applyCustomStyleForAlertControllerClass:[UIAlertController class]];

// Apply Global style

MZAlertControllerStyle *defaultStyle = [UIAlertController mz_sharedStyle];
defaultStyle.blurEffectStyle = UIBlurEffectStyleDark;
defaultStyle.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];

// And thats it...

```

## Contact

[Michal Zaborowski](http://github.com/m1entus)

[Twitter](https://twitter.com/iMientus)
