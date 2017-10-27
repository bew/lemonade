
## How to trigger a render from a block?

At least with Lemonbar we can't just render a part of the bar, so we need a way to instruct something that the full bar must be re-rendered (using cache in most places), and sent to the lemonbar process.

A way to do so, is to have a fake widget englobing the bar's content, and when this fake block receives a call saying that it should be put in dirty state, we can render the bar content and send it to the lemonbar process.
