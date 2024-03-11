{{flutter_js}}
{{flutter_build_config}}

let viewIds = [];

function resetUi() {
  viewIds = [];
  counter_grid.replaceChildren();
  remove_last_counter.disabled = true;
  add_counter.disabled = false;
}

let flutterApp = new Promise((resolve, reject) => {
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

add_counter.addEventListener('click', async function() {
  // Create a new element, and add a flutter view there...
  let newElement = document.createElement('div');
  newElement.classList.add('counter_cel');
  counter_grid.appendChild(newElement);

  let viewId = (await flutterApp).addView({
    hostElement: newElement,
    initialData: {
      randomInt: Math.floor(Math.random() * 100),
      randomUUID: globalThis.crypto.randomUUID(),
      decimals: [Math.PI, Math.E, Math.SQRT2],
    },
  });

  viewIds.push(viewId);
  console.log('Added view ID', viewId);
  // Handle enabling/disabling the remove_last button
  remove_last_counter.disabled = viewIds.length == 0;
});

remove_last_counter.addEventListener('click', async function() {
  let viewId = viewIds.pop();

  if (viewId) {
    let viewConfig = (await flutterApp).removeView(viewId);
    console.log('Removing view with ID', viewId, 'and config', viewConfig);
    viewConfig.hostElement.remove();
  }
  // Handle enabling/disabling the remove_last button
  remove_last_counter.disabled = viewIds.length == 0;
});
