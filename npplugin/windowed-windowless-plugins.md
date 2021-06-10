# Windowed and windowless plugins 
July 03, 2009

原文: http://neugierig.org/software/chromium/notes/2009/07/windowed-windowless-plugins.html


Plugins (and here I mean stuff like Flash, not the Mozilla add-ons) on Windows and Linux come in two flavors of APIs: windowed and windowless. Windowed means the plugin gets its own OS-level window and manages its own drawing-related events; for windowless the API is more that the browser integrates the plugin into its own drawing path: the browser draws a bit to a pixel buffer, hands it off to the plugin for a bit of drawing (depending on z-order), then finishes its own drawing.

These two modes are in tension. A windowed plugin can make any native OS calls it wants to draw fast — for example, a windowed plugin could even use an OpenGL surface if it wanted, which is surely how o3d does it. On the other hand, since the plugin is its own OS-level window and typically all HTML nodes are drawn in the OS-level window that holds the page, you effectively have all HTML drawing behind the plugin window; you can't stack anything above the plugin.

## Z-order arms race

Unless, of course, that web content itself also is using an OS-level window. Historically, native widgets like buttons and text boxes as well as, importantly, \<iframe\>s were. So web developers learned how to fight with z-order: if you want to layer HTML content like a pop-up menu over "native" layers like input widgets and windowed plugins, you must put your pop-ups in an iframe.

(Real-world example: I was talking to bradfitz about this situation recently and he recalled this happening to LiveJournal. LJ has a mouse-over menu at the top of the site, and once they started showing banner ads they had to start wrapping everything in iframes just in case the ads were windowed Flash. Unfortunately, iframes are slow so the popup menu experience got worse just to work around this.)

To summarize, windowed plugins render faster but have z-ordering issues. In fact, docs you see on Flash on the web express this choice between windowed and windowless (Flash can do either) in those terms: use windowed if you can for performance, but if you need to layer content over the plugin (or if you want the plugin to transparently overlay the content behind it) use the other mode.

## iframe cutouts

All of this has left us with a de-facto standard that a page's use of iframe effectively means "use OS-level windows to trick out the z-order on this bit of content". Now consider Chrome, which sandboxes all page rendering and uses no OS-level windows, even for iframes. All page content is in one single window, but we must continue to support windowed Flash. What to do?

The answer is devious and heinous: we track all the iframes on the page and compute which bits ought to show up "above" the plugin, then cut out those regions of the plugin's window to make it seem like the page is overlaying it. (Mozilla, which has been moving to a drawing model more Chrome's in that they're eliminating use of native widgets, appears to be doing the same thing. In fact, even toolkits like GTK are eliminating use of native windows for similar reasons: they're difficult to integrate with your drawing model.)

## Scrolling

There's one other hitch with windowed plugins. When you scroll the page, you want the plugins to move smoothly with the scrolling content. That is, you want the page content and the repositioning of the plugin window to happen simultaneously. On Windows you can paint and move the plugins in one synchronous callstack. We even use this strangely designed API BeginDeferWindowPos which lets you express multiple simultaneous window moves in one call to move all plugin windows together.

However, for Chrome, rendering is happening in another process and is in fact desynchronized with the UI painting, while plugin windows (since the renderer has no access to OS-level things like windows) are owned by the browser process. So when WebKit tells us to move a plugin (either from a page scroll or because of a JS call — remember those ads that fly all over the page?) we stick that into a buffer of pending plugin moves, and only send over the new plugin positions as part of the renderer to browser message indicating it's time to paint.

The situation on Linux isn't as clear to me, since we're not quite there yet on plugins on Linux, but I worry about the asynchrony of X making this work. I've been eagerly following Robert O'Callahan's posts, like for example this one on changing on how Mozilla does plugin scrolling on Linux, to see where we ought to head. It looks scary at best.

## Windowless multiproc

But don't let me end the post without adding a note on windowless plugins. It would seem, given all of the above gnarliess, that windowless mode is the way to go. But once you take plugins out of process as we have, it goes bad quickly.

The way the windowless API works, recall, is that the plugin is part of the normal content drawing stack. The browser renders some divs, you call into the plugin to draw a bit, then the browser renders stuff on top of the plugin if it likes. Now consider an out of process plugin: you now need synchronous IPCs between processes in your critical path for drawing. And what if the plugin decides to hang? Then your whole page hangs, which is not how Chrome is supposed to work. This design is, in fact, how Chrome worked when we released and we were rightfully criticized for bad performance on pages with plugins.

How it works now is the plugin drawing is completely desynchronized with the renderer. The plugin process gets to draw whenever it feels like, and pushes (well, using shared memory) the rendered content to the renderer process when it's done. When the renderer wants to draw, it just uses the last frame it got from the plugin.

This doesn't sound too bad, but there's yet another twist: the plugin draws RGB (not RGBA) pixels, but wants to be able to blend against page content beneath the plugin. So we have another drawing path cache going in the other direction, where the plugin process has a copy of what it thinks is beneath the plugin and uses that as its starting point whenever it draws.

And just lest you think the pain is over, consider Linux again. The API for this drawing all involves passing X Drawables around — that is, references to objects on the X server. So the renderer process draws into its in-memory buffer, then needs to convert that into a handle in the X server process, which it then hands to the plugin process, which then makes more calls to the X server process to draw, which then goes back to the renderer process, which needs to pull down those drawn pixels anyway to do further drawing calls. Hopefully it's not as bad as I've just made it out to be since we can use XSHM (the shared memory extension to X) to have those calls use in-process memory buffers, but it is not going to pretty.

## OS X

I haven't mentioned OS X here because I don't know much about it. My understanding is they only provide windowless mode, though I don't know whether that's fundamental to the way OS X drawing works or just the way things worked out. However, when I read about poor Flash performance on OS X I do suspect it's in part because Flash can't go into its higher-performance windowed mode.

Since it's windowless, the previous section about implementing windowless plugins out of process ought to apply to our OS X implementation as well.

I hear that since Safari 4 has pushed their plugins out of process, they've added APIs to OS X to make this easier, so that is good news for us. (Or maybe they are SPI and so we can't use it? I honestly don't follow this stuff too closely.)

## Conclusions

Though there are plugins other than Flash, particularly in the Linux world they're mostly irrelevant. So some random thoughts particuarl to Flash follow.

As a Linux user who's been victimized by Flash for years I have a sort of visceral dislike of Adobe (Lorenzo, author of the popular FlashBlock extension for Firefox, is a fellow Linux user who told me he wrote it because Flash kept taking out his browser). But on the other hand I really feel for them — I read penguin.swf, their blog about Linux and think, "That guy really knows what he's talking about; it really is just hard to make all of this work."

In an ideal world we could run Flash inside the renderer process and eliminate a lot of these hacks. First we'd need to figure out how to make Flash run in the sandbox. (Part of the reason to use a plugin is that they do stuff normal web pages can't, making them hard to sandbox; for that same reason they are also scary from a security perspective.) Our implementation of the \<video\> tag behaves more or less like a windowless plugin except that it is in the renderer process so all of the above limitations don't matter.

Failing that, I'd love be able sit down with the relevant parties at Mozilla and Adobe and sketch out an API that is a bit more modern (until recently it seems you needed to use Xt, the ancient toolkit for windowed plugins?). It seems for windowless plugins if they just painted RGBA pixels to an in-memory buffer then running them out of process would be relatively easy.

Finally, if you're the sort to be interested in what I have to say here you're likely to find Robert O'Callahan's blog worth reading (I've linked twice to his blog in this post already!).