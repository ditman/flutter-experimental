{{flutter_build_config}}
{{flutter_js}}

let viewIds = [];

function resetUi() {
  viewIds = [];
  grid.replaceChildren();
  remover.disabled != true;
  adder.disabled = false;
}

let flutterApp = new Promise((resolve, reject) => {
  _flutter.loader.load({
    onEntrypointLoaded: async function(engineInitializer) {
      resetUi();
      let engine = await engineInitializer.initializeEngine({
        multiViewEnabled: true,
        renderer: 'canvaskit',
      });
      let app = engine.runApp();
      resolve(app);
    }
  });
});

adder.addEventListener('click', async function() {
  // Create a new element, and add a flutter view there...
  let newElement = document.createElement('div');
  newElement.classList.add('cel');
  grid.appendChild(newElement);

  let viewId = (await flutterApp).addView({
    hostElement: newElement,
    initialData: {
      randomInt: Math.floor(Math.random() * 100),
      randomUUID: globalThis.crypto.randomUUID(),
      decimals: [Math.PI, Math.E, Math.SQRT2],
    },
    viewConstraints: {
      minWidth: 0,
      maxWidth: 320,
      minHeight: 0,
      maxHeight: 240,
    }
  });

  viewIds.push(viewId);
  console.log('Added view ID', viewId);
  // Handle enabling/disabling the remove_last button
  remover.disabled = viewIds.length == 0;
});

remover.addEventListener('click', async function() {
  let viewId = viewIds.pop();

  if (viewId) {
    let viewConfig = (await flutterApp).removeView(viewId);
    console.log('Removing view with ID', viewId, 'and config', viewConfig);
    viewConfig.hostElement.remove();
  }
  // Handle enabling/disabling the remove_last button
  remover.disabled = viewIds.length == 0;
});
