library tail;

import "dart:html";

typedef void TailHandler();

class Tail {
  
  Element _ct;
  Element getContainer() => _ct;
  
  Point _nPos = new Point(0.0, 0.0);
  Point _cPos = new Point(0.0, 0.0);
  Point _pPos = new Point(0.0, 0.0);
  num _nScroll = 0.0;
  num _cScroll = 0.0;
  num _pScroll = 0.0;
  
  _canceler(Event evt) { evt.preventDefault(); }
  
  _downHandler(int code) {
    for (Action action in _actions) {
      if (action._codes.contains(code)) {
        if (action._nVal == false) for (TailHandler handler in action._pressedHandlers) handler();
        action._nVal = true;
      }
    }
  }
  
  _upHandler(int code) {
    for (Action action in _actions) {
      if (action._codes.contains(code)) {
        if (action._nVal == true) for (TailHandler handler in action._releasedHandlers) handler();
        action._nVal = false;
      }
    } 
  }
  
  Tail(Element container) {
    container.style.userSelect = "none";
    container.style.userDrag = "none";
    _ct = container;
    _ct.onDragStart.listen(_canceler);
    _ct.onSelectStart.listen(_canceler);
    _ct.onContextMenu.listen(_canceler);
    _ct.onTouchStart.listen(_canceler);
    _ct.onTouchMove.listen(_canceler);
    _ct.onMouseMove.listen(_canceler);
    _ct.onMouseWheel.listen(_canceler);
    _ct.onMouseDown.listen(_canceler);
    _ct.onMouseUp.listen(_canceler);
    _ct.onKeyDown.listen(_canceler);
    _ct.onKeyUp.listen(_canceler);
    _ct.onMouseMove.listen((MouseEvent evt) {
      _nPos = evt.offset;
    });
    _ct.onMouseWheel.listen((WheelEvent evt) {
      _nScroll += evt.deltaY;
    });
    _ct.onMouseDown.listen((MouseEvent evt) {
      _downHandler(evt.button);
    });
    document.body.onMouseUp.listen((MouseEvent evt) {
      _upHandler(evt.button);
    });
    document.body.onKeyDown.listen((KeyboardEvent evt) {
      _downHandler(evt.keyCode);
    });
    document.body.onKeyUp.listen((KeyboardEvent evt) {
      _upHandler(evt.keyCode);
    });
  }
  
  List<Action> _actions = new List<Action>();
  
  void bind(Action action) {
    _actions.add(action);
  }
  
  void bindAll(List<Action> actions) {
    _actions.addAll(actions);
  }
  
  void unbind(Action action) {
    _actions.remove(action);
  }
  
  void unbindAll() {
    _actions.clear();
  }
  
  void update() {
    _pPos = _cPos;
    _cPos = _nPos;
    _pScroll = _cScroll;
    _cScroll = _nScroll;
    _nScroll = 0.0;
    for (Action action in _actions) {
      if (action._nVal) for (TailHandler handler in action._downHandlers) handler();
      else for (TailHandler handler in action._upHandlers) handler();
    }
    for (Action action in _actions) {
      action._pVal = action._cVal;
      action._cVal = action._nVal;
    }
  }
  
  Point getMouse() => _cPos;
  Point getMouseDelta() => _cPos - _pPos;
  num getScrollDelta() => _cScroll -_pScroll;
}

class Action {
  Set<int> _codes = new Set<int>();
  List<TailHandler> _upHandlers = new List<TailHandler>();
  List<TailHandler> _downHandlers = new List<TailHandler>();
  List<TailHandler> _pressedHandlers = new List<TailHandler>();
  List<TailHandler> _releasedHandlers = new List<TailHandler>();
  
  bool _pVal = false;
  bool _cVal = false;
  bool _nVal = false;
  
  Action([List<int> codes]) {
    _codes.addAll(codes);
  }
  
  void bind(int code) {
    _codes.add(code);
  }
  
  void unbind(int code) {
    _codes.remove(code);
    _nVal = false;
  }
  
  void unbindAll() {
    _codes.clear();
    _nVal = false;
  }
  
  bool isUp() => !_cVal;
  bool isDown() => _cVal;
  bool isPressed() => _cVal && !_pVal;
  bool isReleased() => !_cVal && _pVal;
  
  void onUp(TailHandler handler) => _upHandlers.add(handler);
  void onDown(TailHandler handler) => _downHandlers.add(handler);
  void onPressed(TailHandler handler) => _pressedHandlers.add(handler);
  void onReleased(TailHandler handler) => _releasedHandlers.add(handler);
}

//Actions are basically just keybindings / key proxies

abstract class TailCode {
  static const int none = -1;
  static const int leftMouseButton = 0;
  static const int middleMouseButton = 1;
  static const int rightMouseButton = 2;
  
  static const int zero = 48;
  static const int one = 49;
  static const int two = 50;
  static const int three = 51;
  static const int four = 52;
  static const int five = 53;
  static const int six = 54;
  static const int seven = 55;
  static const int eight = 56;
  static const int nine = 57;
  static const int a = 65;
  static const int b = 66;
  static const int c = 67;
  static const int d = 68;
  static const int e = 69;
  static const int f = 70;
  static const int g = 71;
  static const int h = 72;
  static const int i = 73;
  static const int j = 74;
  static const int k = 75;
  static const int l = 76;
  static const int m = 77;
  static const int n = 78;
  static const int o = 79;
  static const int p = 80;
  static const int q = 81;
  static const int r = 82;
  static const int s = 83;
  static const int t = 84;
  static const int u = 85;
  static const int v = 86;
  static const int w = 87;
  static const int x = 88;
  static const int y = 89;
  static const int z = 90;
  static const int left = 37;
  static const int up = 38;
  static const int right = 39;
  static const int down = 40;
  static const int enter = 13;
  static const int space = 32;
  static const int backspace = 8;
  static const int tab = 9;
  static const int delete = 46;
  static const int shift = 16;
  static const int ctrl = 17;
  static const int alt = 18;
  static const int escape = 27;
}