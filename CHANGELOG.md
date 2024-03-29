# Change Log
All notable changes to this project will be documented in this file.
`BaseClasses` adheres to [Semantic Versioning](http://semver.org/).


## [6.0.0](https://github.com/APUtils/BaseClasses/releases/tag/6.0.0)
Released on 11/18/2021.

#### Added
- Added RoutableLogger for logs
- Label edge cases animation
- Warn about broken opacity animation

#### Changed
- Animate height change with the same text for multiple lanes label

#### Fixed
- Proper scroll for all UIControls


## [5.0.0](https://github.com/APUtils/BaseClasses/releases/tag/5.0.0)
Released on 04/13/2020.

#### Added
- SPM support
- tvOS support

#### Changed
- Added gap between disappear and appear Label animation so they won't overlap
- UIScrollView fixedDescription adjust
- TableViewCell reuseID type change

#### Fixed
- Label animation wasn't triggered when previous animation was with the same text
- Possible crash fix during label animation


## [4.0.0](https://github.com/APUtils/BaseClasses/releases/tag/4.0.0)
Released on 01/03/2020.

#### Added
- Label which uses pulse animation to change content
- `ScreenSideRelativeConstraint` thats adjust its constant depending on screen side size.
- `APPLICATION_EXTENSION_API_ONLY` flag to be safe to use in app extensions.

#### Changed
-  Use top controller for `childForScreenEdgesDeferringSystemGestures` for `NavigationController`

#### Fixed
- `SelfResizableTableView` , `SelfResizeableCollectionView` and `FullSizeCollectionView` now also reacts on `contentInset` changes.
- Added round ups to fix case when content becomes scrollable on fractial sizes for `SelfResizeable` classes.
- Fixed `FullSizeCollectionView` resize bug related to `adjustedContentInset`.
- Fixed system description of `UIScrollView` subclasses adding `contentInset`.


## [3.1.0](https://github.com/APUtils/BaseClasses/releases/tag/3.1.0)
Released on 01/14/2019.

#### Fixed
- SelfResizableTextView better size change animation
- FullSizeCollectionView fix for insets case


## [3.0.0](https://github.com/APUtils/BaseClasses/releases/tag/3.0.0)
Released on 12/30/2018.

#### Added
- Swift 4.2 support
- ScrollView, TableView and CollectionView empty content label and activity indicator that stays in center.
- TableViewCell and CollectionViewCell .reuseId property
- SelfResizableTextView rework to make it scrollable when allowed height is not enough
- TextView .textSideInset
- PassTouchesView


## [2.0.2](https://github.com/APUtils/BaseClasses/releases/tag/2.0.2)
Released on 09/25/2017.

#### Changed
- Now takes into account insets


## [2.0.1](https://github.com/APUtils/BaseClasses/releases/tag/2.0.1)
Released on 09/21/2017.

#### Fixed
- .swift_verion 4.0


## [2.0.0](https://github.com/APUtils/BaseClasses/releases/tag/2.0.0)
Released on 09/21/2017.

Swift 4 migration

#### Added
- SelfResizableTableView
- TextView
- SelfResizableTextView
- LabelLikeTextView

## [1.2.2](https://github.com/APUtils/BaseClasses/releases/tag/1.2.2)
Released on 08/08/2017.

#### Added
- Carthage support

## [1.2.1](https://github.com/APUtils/BaseClasses/releases/tag/1.2.1)
Released on 08/07/2017.

#### Fixed
- Fixed NavigationBar back button click area

## [1.2.0](https://github.com/APUtils/BaseClasses/releases/tag/1.2.0)
Released on 08/07/2017.

#### Added
- NavigationBar class to allow scroll touches
- README usage section
- Example project

#### Fixed
- Fixed access level for some classes

## [1.1.0](https://github.com/APUtils/BaseClasses/releases/tag/1.1.0)
Released on 07/31/2017.

#### Added
- NavigationController to return status bar style from child controllers
- FullSizeCollectionView that resizes cells to fit its size

## [1.0.0](https://github.com/APUtils/BaseClasses/releases/tag/1.0.0)
Released on 07/11/2017.

#### Added
- Initial release of BaseClasses.
  - Added by [Anton Plebanovich](https://github.com/anton-plebanovich).
