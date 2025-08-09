/**
 * Copyright 2014 The Flutter Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

{{flutter_build_config}}
{{flutter_js}}

/**
 * The flutter app that is rendering each view.
 */
let flutterApp = new Promise((resolve, _) => {
  _flutter.loader.load({
    onEntrypointLoaded: async function(engineInitializer) {
      resetUi();
      let engine = await engineInitializer.initializeEngine({
        multiViewEnabled: true,
      });
      let app = engine.runApp();
      resolve(app);
    }
  });
});

/**
 * Handle button clicks
 */
crud.addEventListener('click', async function(event) {
  const button = event.target;
  if (button.matches('.adder')) {
    const type = button.dataset.viewType;
    let initialData = {
      viewType: type
    };
    if (type === "counter") {
      initialData['randomUUID'] = globalThis.crypto.randomUUID();
    }
    addView(initialData);
  }
});

/**
 * Add a view with "initialData".
 *
 * @see lib/src/js_interop/initial_data.dart
 */
async function addView(initialData) {
  // Create the DOM for the new view from its template.
  let new_window = window_template.content.cloneNode(true);
  // Find the target where we want to inject flutter.
  let target = new_window.querySelector('.flutter');

  // Add the view to Flutter.
  let viewId = (await flutterApp).addView({
    hostElement: target,
    initialData: initialData
  });

  // Attach drag handler
  prepareDrag(new_window);
  // Attach "focus" handler
  prepareZIndex(new_window);
  // Attach close button
  prepareCloseButton(new_window, viewId);

  // Add the window to the desktop
  desktop.appendChild(new_window);
}

/**
 * Attaches the behavior to the "X" button on fl_window that closes viewId.
 */
function prepareCloseButton(fl_window, viewId) {
  let close_button = fl_window.querySelector('.close');
  close_button.addEventListener("click", async (e) => {
    // Remove the view from flutter
    (await flutterApp).removeView(viewId);
    // Then remove the whole window from the DOM
    let container = e.target.closest('.window');
    container.remove();
  });
}

/**
 * Prepares the drag system for fl_window.
 */
function prepareDrag(fl_window) {
  let title_bar = fl_window.querySelector('.title_bar');
  drag.registerElement(title_bar);
}

/**
 * Prepares the Z-Index of fl_window.
 */
function prepareZIndex(fl_window) {
  let window_body = fl_window.querySelector('.window');
  zIndex.registerElement(window_body);
}

/** 
 * (Re)initialize the UI of the app.
 */
function resetUi() {
  desktop.replaceChildren();
  document.querySelectorAll('.adder').forEach((e) => e.disabled = false);
}

/**
 * A class to handle the z-index of our fakey window system.
 */
class ZIndexHandler {
  maxZ = 1;

  constructor() {}

  registerElement(windowHandle) {
    windowHandle.style.zIndex = this.maxZ;
    windowHandle.addEventListener("mousedown", () => {
      windowHandle.style.zIndex = this.maxZ++;
    });
  }
}
let zIndex = new ZIndexHandler();

/**
 * A class to handle the draggability of our fakey window system.
 */
class DragHandler {
  // The difference between the drag cursor and the position of the window.
  offsetX;
  offsetY;
  dragElement = null;
  active = false;
  
  constructor() {
    document.addEventListener("mouseup", this.dragEnd.bind(this), false);
    document.addEventListener("mousemove", this.drag.bind(this), false);
  }

  registerElement(dragHandle) {
    dragHandle.addEventListener("mousedown", this.dragStart.bind(this), false);
  }

  dragStart(e) {
    e.preventDefault();
    let element = e.target.closest('.window');
    let rect = element.getBoundingClientRect();
    this.dragElement = element;
    this.offsetX = e.clientX - rect.x;
    this.offsetY = e.clientY - rect.y;
    this.active = true;
  }

  dragEnd(e) {
    this.dragElement = null;
    this.active = false;
  }

  drag(e) {
    if (this.active) {
      e.preventDefault();

      let currentX = e.clientX - this.offsetX;
      let currentY = e.clientY - this.offsetY;

      this.setTranslate(currentX, currentY, this.dragElement);
    }
  }

  setTranslate(xPos, yPos, el) {
    el.style.transform = "translate3d(" + xPos + "px, " + yPos + "px, 0)";
  }
}
let drag = new DragHandler();
