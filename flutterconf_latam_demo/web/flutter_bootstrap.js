/**
 * Copyright 2014 The Flutter Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

{{flutter_build_config}}
{{flutter_js}}

let viewIds = [];

function resetUi() {
  viewIds = [];
  grid.replaceChildren();
  document.querySelectorAll('.adder').forEach((e) => e.disabled = false);
  remover.disabled = true;
}

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
  } else {
    removeLastView();
  }
});

async function addView(initialData) {
  // Create a new element, and add a flutter view there...
  let newElement = document.createElement('div');
  newElement.classList.add('cel');
  grid.appendChild(newElement);

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

  viewIds.push(viewId);
  console.log('Added view ID', viewId, initialData);
  // Handle enabling/disabling the remove_last button
  remover.disabled = viewIds.length == 0;
}

async function removeLastView() {
  let viewId = viewIds.pop();

  if (viewId) {
    let viewConfig = (await flutterApp).removeView(viewId);
    console.log('Removed view ID', viewId, viewConfig);
    viewConfig.hostElement.remove();
  }
  // Handle enabling/disabling the remove_last button
  remover.disabled = viewIds.length == 0;
}
