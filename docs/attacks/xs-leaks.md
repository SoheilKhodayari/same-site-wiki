---
title: XS-Leaks
parent: Attacks
nav_order: 3
---

{% include toggle_color.html %}

# SameSite Wiki

Stable
{: .label .label-green }

## Cross-Site Information Leakage (XS-Leaks)

Top-level navigation GET requests are not protected by the `Lax`-by-default policy. Attackers can abuse these requests to leak the state of victims in a target website not controlled by the attacker across site origins. The state of a victim at a target website is determined by its status, account and content-related properties. For example, a user may be logged in or logged out, may be the owner of a specific resource (e.g., uploaded video, authored blog post, etc), or have a certain privilege (e.g., admin). 


### Window Properties Leak (Frame Counting)

Attackers can issue a top-level navigation request, and read the number of frames in a target web page using the `length` property of the opened JavaScript window objects. By comparing the frame count, attackers can leak the user state. For example, using this side-channel, it was to possible leak sensitive information about a user and their friends on [Facebook](https://www.imperva.com/blog/facebook-privacy-bug/), or to determine if a user owns a specific profile in Linkedin<sup>[\[1\]](#references)</sup>.


**Example.** The script below demonstrates how to get the number of frames within a cross-origin webpage. 

```javascript
// create a new window
var targetURL = 'https://example-target.com';

// get a reference to the requested WindowProxy
var w = window.open(targetURL);

// wait until page load (i.e., DOMContentLoaded event)
setTimeout(() => {
  // side-channel: the number of iframes
  console.log("The page has %d iframes", w.length);
}, 3000);

```

Read more about this attack [here](https://xsleaks.dev/docs/attacks/frame-counting/) and [here](https://publications.cispa.saarland/3329/1/COSI.pdf).


### postMessage Broadcasts

Similarly to the previous threat, attackers can issue top-level navigation requests using the [window.open()](https://developer.mozilla.org/en-US/docs/Web/API/Window/open) JavaScript API, listen to broadcasted postMessages from the opened web page, and leak the user state by comparing the set of observed messages, as long as these messages are state-dependent. Note that ehe opened webpage can send message back to its opener, e.g., via the `window.opener.postMessage()` API.

**Example.** The script below demonstrates how to access the broadcasted messages from a cross-origin webpage. 

```javascript
// create a new window
var targetURL = 'https://example-target.com';

// get a reference to the requested WindowProxy
var w = window.open(targetURL);

window.addEventListener("message", (evt) => {
  if (evt.origin !== targetURL)
    return;

  /* side-channel: observed messages */
  console.log("captured messages", evt.data)

}, false);

```


Read more about this attack [here](https://xsleaks.dev/docs/attacks/postmessage-broadcasts/) and [here](https://publications.cispa.saarland/3329/1/COSI.pdf).


### Navigations

When an endpoint sets the Content-Disposition: attachment header, it instructs the browser to download the response as an attachment instead of navigating to it. Detecting if this behavior occurred might allow attackers to leak private information if the outcome depends on the state of the victim’s account.

The `Content-Disposition: attachment` HTTP response header instructs web browsers to download the HTTP response as an attachment file instead of navigating to it. Detecting if *navigations* occur might allow attackers to leak sensitive information if they happen in an state-dependent manner depending on the victim's account or state at the target site. 

**Example.** The script below demonstrates the oracle to determine if a navigation has ocurred or not by capturing same-origin policy exceptions via JavaScript. 

```javascript
// create a new window
var targetURL = 'https://example-target.com';

// get a reference to the requested WindowProxy
var w = window.open(targetURL);

// wait for the window to load
setTimeout(() => {
      try {
          // side-channel: if a navigation occurs, the WindowProxy will be cross-origin,
          // so accessing "w.origin" will throw an exception due to SOP
          w.origin;
          parent.console.log('Detected download attempt!');
      } catch(e) {
          parent.console.log('Did not detected any download attempts!');
      }
}, 3000);

```

Read more about this attack [here](https://xsleaks.dev/docs/attacks/frame-counting/).


## Reference

1. A. Sudhodanan, S. Khodayari, and J. Caballero, Cross-Origin State Inference (COSI) Attacks: Leaking Web Site States through XSLeaks, in NDSS 2020. [Link](https://publications.cispa.saarland/3329/1/COSI.pdf)



