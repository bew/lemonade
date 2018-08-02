
## How to trigger a render from a block?

At least with Lemonbar we can't just render a part of the bar, so we need a way to instruct something that the full bar must be re-rendered (using cache in most places), and sent to the lemonbar process.

A way to do so, is to have a fake widget englobing the bar's content, and when this fake block receives a call saying that it should be put in dirty state, we can notify the renderer that a full redraw is needed.

=> Done!


## How to start/stop the fiber for async content provider of some blocks?

Now that we can update the bar from within the bar, how/when do we start/stop the fiber allowing async content update?

There is also the eventuality that 1 block might be rendered by 1 or more bar renderers, so we can't count on the renderer's stop to alert somehow the content providers to stop.

=> Decouple the block from the content provider

The content providers could have a Pub/Sub pattern, and when:
- 1+ subscribers, start the provider
- 0 subscriber, stop the provider



## How to get rendered when a child is dirty

IMPORTANT: if you have child blocks, you have to add yourself to there `parents` property. Do that only for your direct children.
