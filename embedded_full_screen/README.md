# embedded_full_screen

An experimental Flutter web project.

## Getting Started

This experimental app attempts to simulate a full-screen
Flutter web application (when no hostElement is passed)
but by letting the `index.html` own the responsibility of
rendering a full screen `div.fill-screen`, which is then
used as a `hostElement`.

The flutter app is 100% default, the only changes with a
default Flutter web app is the small customization of the
`index.html` to create a `<div>` that fills the whole
screen, and point Flutter to render into that.

This is untested in mobile, for example, it is unknown
what'd happen when a virtual keyboard shows up!
