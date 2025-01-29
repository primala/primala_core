import 'package:flutter/widgets.dart';

import '../core/models/context_menu.dart';
import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/utils.dart';
import 'context_menu_provider.dart';
import 'context_menu_widget.dart';

class ContextMenuState extends ChangeNotifier {
  final focusScopeNode = FocusScopeNode();

  final overlayController = OverlayPortalController(debugLabel: 'ContextMenu');

  ContextMenuEntry? _focusedEntry;

  ContextMenuItem? _selectedItem;

  bool _isPositionVerified = false;

  AlignmentGeometry _spawnAlignment = AlignmentDirectional.topEnd;

  final Rect? _parentItemRect;

  final bool _isSubmenu;

  final ContextMenu menu;
  final ContextMenuItem? parentItem;
  final VoidCallback? selfClose;
  WidgetBuilder submenuBuilder = (context) => const SizedBox.shrink();

  ContextMenuState({
    required this.menu,
    this.parentItem,
  })  : _parentItemRect = null,
        _isSubmenu = false,
        selfClose = null;

  ContextMenuState.submenu({
    required this.menu,
    required this.selfClose,
    this.parentItem,
    AlignmentGeometry? spawnAlignmen,
    Rect? parentItemRect,
  })  : _spawnAlignment = spawnAlignmen ?? AlignmentDirectional.topEnd,
        _parentItemRect = parentItemRect,
        _isSubmenu = true;

  List<ContextMenuEntry> get entries => menu.entries;
  Offset get position => menu.position ?? Offset.zero;
  double get maxWidth => menu.maxWidth;
  BorderRadiusGeometry? get borderRadius => menu.borderRadius;
  EdgeInsets get padding => menu.padding;
  Clip get clipBehavior => menu.clipBehavior;
  BoxDecoration? get boxDecoration => menu.boxDecoration;
  Map<ShortcutActivator, VoidCallback> get shortcuts => menu.shortcuts;

  ContextMenuEntry? get focusedEntry => _focusedEntry;
  ContextMenuItem? get selectedItem => _selectedItem;
  bool get isPositionVerified => _isPositionVerified;
  bool get isSubmenuOpen => overlayController.isShowing;
  AlignmentGeometry get spawnAlignment => _spawnAlignment;
  Rect? get parentItemRect => _parentItemRect;
  bool get isSubmenu => _isSubmenu;

  static ContextMenuState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ContextMenuProvider>()!
            as ContextMenuProvider?;

    if (provider == null) {
      throw 'No ContextMenuProvider found in context';
    }
    return provider.notifier!;
  }

  void setFocusedEntry(ContextMenuEntry? value) {
    if (value == _focusedEntry) return;
    _focusedEntry = value;
    notifyListeners();
  }

  void setSelectedItem(ContextMenuItem? value) {
    if (value == _selectedItem) return;
    _selectedItem = value;
    notifyListeners();
  }

  void setSpawnAlignment(AlignmentGeometry value) {
    _spawnAlignment = value;
    notifyListeners();
  }

  bool isFocused(ContextMenuEntry entry) => entry == focusedEntry;

  bool isOpened(ContextMenuItem item) => item == selectedItem;

  Offset _calculateSubmenuPosition(
    Rect parentRect,
    AlignmentGeometry? spawnAlignmen,
  ) {
    double left = parentRect.left + parentRect.width;
    double top = parentRect.top;

    left += menu.padding.right;
    top -= menu.padding.top;

    return Offset(left, top);
  }

  void showSubmenu({
    required BuildContext context,
    required ContextMenuItem parent,
  }) {
    closeSubmenu();

    final items = parent.items;
    final submenuParentRect = context.getWidgetBounds();
    if (submenuParentRect == null) return;

    final submenuPosition =
        _calculateSubmenuPosition(submenuParentRect, spawnAlignment);

    submenuBuilder = (BuildContext context) {
      final subMenuState = ContextMenuState.submenu(
        menu: menu.copyWith(
          entries: items,
          position: submenuPosition,
        ),
        spawnAlignmen: spawnAlignment,
        parentItemRect: submenuParentRect,
        selfClose: closeSubmenu,
        parentItem: parent,
      );

      return ContextMenuWidget(menuState: subMenuState);
    };

    overlayController.show();
    setSelectedItem(parent);
  }

  void verifyPosition(BuildContext context) {
    if (isPositionVerified) return;

    focusScopeNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boundaries = calculateContextMenuBoundaries(
        context,
        menu,
        parentItemRect,
        _spawnAlignment,
        _isSubmenu,
      );

      menu.position = boundaries.pos;
      _spawnAlignment = boundaries.alignment;

      notifyListeners();
      _isPositionVerified = true;
      focusScopeNode.nextFocus();
    });
  }

  void closeSubmenu() {
    if (!isSubmenuOpen) return;
    _selectedItem = null;
    overlayController.hide();
    notifyListeners();
  }

  void close() {
    closeSubmenu();
    focusScopeNode.dispose();
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }
}
