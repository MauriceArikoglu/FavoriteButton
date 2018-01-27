# FaveButton

[![CocoaPods](https://img.shields.io/cocoapods/p/FaveButton.svg)](https://cocoapods.org/pods/FaveButton)
[![CocoaPods](https://img.shields.io/cocoapods/v/FaveButton.svg)](http://cocoapods.org/pods/FaveButton)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/xhamr/fave-button)
[![codebeat badge](https://codebeat.co/badges/580517f8-efc8-4d20-89aa-900531610144)](https://codebeat.co/projects/github-com-xhamr-fave-button)
[![Build Status](https://travis-ci.org/xhamr/fave-button.svg?branch=master)](https://travis-ci.org/xhamr/fave-button)

Favorite Animated Button written in Swift


![preview](https://github.com/xhamr/fave-button/blob/master/fave-button1.gif)


## Requirements

- iOS 8.0+
- Xcode 7.3

## Installation

For manual instalation, drag Source folder into your project.

os use [CocoaPod](https://cocoapods.org) adding this line to you `Podfile`:

```ruby
pod 'FavoriteButton', '~> 3.0.1' Swift 4 (iOS 8.0+, discontinued)

pod 'FavoriteButton', '~> 3.1.4' Swift 4 (iOS 10.0+, in development)

```

## Usage

#### With storyboard or xib files

1) Create a Button that inherits from `FavoriteButton`

2) Add Image for a `Normal` state

3) Set the `IBOutlet` delegate property to a subclass of `FavoriteButtonDelegate`

4) ___Optional___ manipulate porperties to change button settings

```swift
	@IBInspectable public var normalColor:     UIColor
	@IBInspectable public var selectedColor:   UIColor
	@IBInspectable public var dotFirstColor:   UIColor
	@IBInspectable public var dotSecondColor:  UIColor
	@IBInspectable public var circleFromColor: UIColor
	@IBInspectable public var circleToColor:   UIColor
```
 
 5) ___Optional___ respond to delegate methods

 ```swift
 3.1.4 introduces better delegate handling
 	/// Delays the callback until after the animation completes. default is true
    	var delaysDelegate: Bool = true
    	/// Decides if the delegate is called for user interaction only or through setSelected / isSelected also.
    	var firesOnUserInteractionOnly: Bool = true
 ```


 ```swift
	func favoriteButton(faveButton: FavoriteButton, didSelected selected: Bool)    
	func favoriteButtonDotColors(faveButton: FavoriteButton) -> [DotColors]?     
 ```

#### What's new

```swift
3.1.1
	// true per default, fires an UISelectionFeedbackGenerator
    	open var providesHapticFeedback: Bool = true
3.1.4
    	// lets you add an Id to FavoriteButton to identify it uniquely anywhere (in the callback for example)
    	open var faveId: Any?
    
```

#### In Code

```swift
	let faveButton = FavoriteButton(
	    frame: CGRect(x:200, y:200, width: 44, height: 44),
	    faveIconNormal: UIImage(named: "heart")
	)
	faveButton.delegate = self
	view.addSubview(faveButton)
```

```swift
3.1.4 lets you choose whether to animate the selection
	faveButton.setSelected(true, animated: false)
```

## Manipulating dot colors

If you want differents colors for dots like `Twitter’s Heart Animation` use the delegate method for the button you want.

```swift
	func favoriteButtonDotColors(_ faveButton: FavoriteButton) -> [DotColors]? {
		if faveButton == myFaveButton {
			// return dot colors
		}
		return nil
	}
```

in FaveButtonDemo you will find a set of color to cause dots appear like this:

![preview](https://github.com/xhamr/fave-button/blob/master/fave-button2.gif)



## Credits

Forked from [xhamr](https://github.com/xhamr/fave-button)

## Licence

FavoriteButton is still under the MIT license.











