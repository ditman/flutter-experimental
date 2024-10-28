/**
 * Copyright 2014 The Flutter Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

{{flutter_build_config}}
{{flutter_js}}

// A collection of the active view Ids.
let viewIds = [];

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

// Handle button clicks
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
  } else if (button.matches('.remover')) {
    removeLastView();
  }
});

// Adds a view with `initialData`.
async function addView(initialData) {
  // Inject a new container for the view
  let newElement = document.createElement('div');
  newElement.classList.add('cel');
  grid.appendChild(newElement);

  // Add the view to Flutter.
  let viewId = (await flutterApp).addView({
    hostElement: newElement,
    initialData: initialData,
    viewConstraints: {
      minWidth: 0,
      maxWidth: 320,
      minHeight: 0,
      maxHeight: 240,
    }
  });

  // Remember the viewId for later.
  viewIds.push(viewId);
  console.log('Added view ID', viewId, initialData);
  remover.disabled = viewIds.length == 0;
}

// Removes the last view from `viewIds`.
async function removeLastView() {
  let viewId = viewIds.pop();

  if (viewId) {
    let viewConfig = (await flutterApp).removeView(viewId);
    console.log('Removed view ID', viewId, viewConfig);
    viewConfig.hostElement.remove();
  }
  remover.disabled = viewIds.length == 0;
}

// (Re)initialize the UI of the app.
function resetUi() {
  viewIds = [];
  grid.replaceChildren();
  document.querySelectorAll('.adder').forEach((e) => e.disabled = false);
  remover.disabled = true;
}
