import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CoverAppBar extends StatefulWidget {
  const CoverAppBar({
    Key key,
    this.title,
    this.overTitle,
    this.cover,
  }) : super(key: key);

  final Widget title;

  final Widget overTitle;

  final Widget cover;

  static Widget createSettings({
    double toolbarOpacity,
    double minExtent,
    double maxExtent,
    @required double currentExtent,
    @required Widget child,
  }) {
    assert(currentExtent != null);
    return FlexibleSpaceBarSettings(
      toolbarOpacity: toolbarOpacity ?? 1.0,
      minExtent: minExtent ?? currentExtent,
      maxExtent: maxExtent ?? currentExtent,
      currentExtent: currentExtent,
      child: child,
    );
  }

  @override
  _CoverAppBarState createState() => _CoverAppBarState();
}

class _CoverAppBarState extends State<CoverAppBar> {
  MainAxisAlignment _getMainAxisColumnAlignment() {
    final TextDirection textDirection = Directionality.of(context);
    assert(textDirection != null);
    switch (textDirection) {
      case TextDirection.rtl:
        return MainAxisAlignment.end;
      case TextDirection.ltr:
        return MainAxisAlignment.start;
    }
    return null;
  }

  Alignment _getTitleAlignment() {
    final TextDirection textDirection = Directionality.of(context);
    assert(textDirection != null);
    switch (textDirection) {
      case TextDirection.rtl:
        return Alignment.bottomRight;
      case TextDirection.ltr:
        return Alignment.bottomLeft;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final FlexibleSpaceBarSettings settings =
        context.inheritFromWidgetOfExactType(FlexibleSpaceBarSettings);
    assert(settings != null,
        'A CoverAppBar must be wrapped in the widget returned by CoverAppBar.createSettings().');

    final List<Widget> children = <Widget>[];

    final double deltaExtent = settings.maxExtent - settings.minExtent;

    // 0.0 -> Expanded
    // 1.0 -> Collapsed to toolbar
    final double t =
        (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
            .clamp(0.0, 1.0);

    if (widget.title != null) {
      Widget title;
      switch (defaultTargetPlatform) {
        case TargetPlatform.iOS:
          title = widget.title;
          break;
        case TargetPlatform.fuchsia:
        case TargetPlatform.android:
          title = Semantics(
            namesRoute: true,
            child: widget.title,
          );
      }

      final ThemeData theme = Theme.of(context);
      final double opacity = settings.toolbarOpacity;
      if (opacity > 0.0) {
        TextStyle titleStyle = theme.primaryTextTheme.title;
        titleStyle =
            titleStyle.copyWith(color: titleStyle.color.withOpacity(opacity));
        TextStyle overtitleStyle = titleStyle.copyWith(
            fontSize: 12.0, letterSpacing: 0.8, fontWeight: FontWeight.w700);
        final double scaleValue =
            Tween<double>(begin: 1.2, end: 0.95).transform(t);
        final double overtitleBottomMarginSize =
            Tween<double>(begin: 3.0, end: 0.0).transform(t);
        final double bottomMarginSize =
            Tween<double>(begin: 16.0, end: 10.0).transform(t);
        final double leftPaddingSize =
            Tween<double>(begin: 128.0 + 32.0, end: 100.0).transform(t);
        final EdgeInsetsGeometry padding = EdgeInsetsDirectional.only(
          start: leftPaddingSize,
          bottom: bottomMarginSize,
        );
        final Matrix4 scaleTransform = Matrix4.identity()
          ..scale(scaleValue, scaleValue, 1.0);
        final Alignment titleAlignment = _getTitleAlignment();
        children.add(Container(
          padding: padding,
          child: Transform(
            alignment: titleAlignment,
            transform: scaleTransform,
            child: Align(
              alignment: titleAlignment,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: _getMainAxisColumnAlignment(),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefaultTextStyle(
                    style: overtitleStyle,
                    child: widget.overTitle,
                  ),
                  SizedBox(height: overtitleBottomMarginSize),
                  DefaultTextStyle(
                    style: titleStyle,
                    child: title,
                  ),
                ],
              ),
            ),
          ),
        ));
      }

      if (widget.cover != null) {
        final double coverScale =
            Tween<double>(begin: 1.0, end: 42 / 128).transform(t);

        final double coverTopPosition =
            Tween<double>(begin: -64.0, end: 8.0).transform(t);
        final double coverLeftPosition =
            Tween<double>(begin: 16.0, end: 48.0).transform(t);

        final cover = Transform.scale(
          scale: coverScale,
          alignment: Alignment.bottomLeft,
          child: widget.cover,
        );

        children.add(Positioned(
          child: cover,
          left: coverLeftPosition,
          bottom: coverTopPosition,
        ));
      }
    }

    return SafeArea(
      child: Stack(
        children: children,
        overflow: Overflow.visible,
      ),
    );
  }
}
