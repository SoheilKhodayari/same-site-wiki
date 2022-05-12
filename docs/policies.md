---
title: Overview of Policies
parent: SameSite Policies
nav_order: 1
---

# SameSite Wiki

Stable
{: .label .label-green }

## Overview of SameSite Policies


The `SameSite` attribute introduces three pre-defined cookie policies:

- `None`: specifies that cookies are attached to *all* outgoing HTTP requests, including cross-site ones. This means that cookies of the first party should be passed to third party context. This policy corresponds to the default policy before the introduction of the `SameSite` attribute. 

- `Strict`: stipulates that cookies are restricted to the same-site only, i.e., cookies are never attached to any cross-site HTTP request at all.

- `Lax`: enforces a restricted set of contexts where browsers can include cookies in cross-site requests, excluding contexts typically abused in XS attacks. Specifically, when using `Lax`, browsers would attach cookies to same-site requests, and top-level navigation requests (e.g., clicking on an anchor link) with [safe or non-idempotent HTTP methods](https://developer.mozilla.org/en-US/docs/Glossary/Safe/HTTP), like GET, as per [RFC 6265bis](https://tools.ietf.org/html/draft-ietf-httpbis-rfc6265bis-05). However, they will
not include cookies in cross-site requests with unsafe HTTP methods, such as POST. 


**Note:** top-level requests are those that cause a page navigation and change the URL in the browser address bar. This is not the case for requests initiated due to embedded resources, e.g., cross-site `image`s, `iframe`s, `script`s, and `XMLHTTPRequest`s.    



**Example.** Web servers can set a SameSite policy for a cookie by adding the `SameSite` attribute to the [Set-Cookie](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite) HTTP response header:

```
Set-Cookie: 3pc-cookie=value; Secure; SameSite=None
```


**Summary.** Table I summarizes the contexts where the same-site policies apply.


| **None** 	| **Lax**    	| **Strict** 	| **Context**     	|      	| **Example**                      	|
|----------	|------------	|------------	|-----------------	|------	|----------------------------------	|
| ✓       	| ✓         	| -          	| Anchor          	| GET  	| \<a href=url\>                   	|
| ✓       	| ✓         	| -          	| Form            	| GET  	| \<form method=GET action=url \>  	|
| ✓       	| ✓         	| -          	| Link prerender  	| GET  	| \<link rel=prerender href=url \> 	|
| ✓       	| ✓         	| -          	| Link prefetch   	| GET  	| \<link rel=prefetch href=url \>  	|
| ✓       	| ✓         	| -          	| window.open()   	| GET  	| window.open(url)                 	|
| ✓       	| ✓         	| -          	| window.location 	| GET  	| window.location.assign(url)      	|
| ✓       	| ✓     (*) 	| -          	| Form            	| POST 	| \<form method=POST action=url\>  	|
| ✓       	| -          	| -          	| Iframe          	| GET  	| \<iframe src=url\>               	|
| ✓       	| -          	| -          	| Object          	| GET  	| \<object data=url\>              	|
| ✓       	| -          	| -          	| Embed           	| GET  	| \<embed src=url\>                	|
| ✓       	| -          	| -          	| Image           	| GET  	| \<img src=url\>                  	|
| ✓       	| -          	| -          	| Script          	| GET  	| \<script src=url\>               	|
| ✓       	| -          	| -          	| Stylesheet      	| GET  	| \<link rel=stylesheet href=url\> 	|
| ✓       	| ✓     (*) 	| -          	| Ajax Requests   	| Any  	| xmlhttp.open("POST", url)        	|

TABLE I: Contexts where the three `SameSite` policies apply. Symbols ✓ and - show contexts where cookies
are included and not included in cross-site HTTP requests, respectively, and (\*) marks contexts where the `Lax+POST` exceptional policy applies. 



## Default Policy and Lax+POST Exception

Recent versions of modern browsers provide a more secure default for `SameSite` to your cookies. In particular, starting from July 2020, Google Chrome set the new [default policy to Lax](https://www.chromestatus.com/feature/5088147346030592), meaning that when the `SameSite` attribute is missing, the browser will enforce the Lax policy. Other browser vendors adopted<sup>[\[1, 2\]](#references)</sup>, or are planning to adopt the new default policy[\[3\]](#references)</sup>. Previously, the default was that cookies were sent for all requests, corresponding to the `SameSite=None` policy.

The `Lax` policy replaced `None` as the default value to enforce a second level of defense against some classes of [Cross-Site Request Forgery](https://arxiv.org/pdf/1708.08786.pdf) and [XS-Leak](https://publications.cispa.saarland/3329/1/COSI.pdf) attacks.

Unfortunately, enforcing a default Lax policy may break web application functionalities that rely on cross-site communications and cookies. For example, web-based Single Sign-On (SSO) implementations, such as OpenIDConnect or SAML SSO implementations, optimize user experience by avoiding user re-authentication when valid authenticated session cookies are included in the cross-site requests. Such requests are often implemented via POST asynchronous requests or HTML POST forms. The new default Lax policy forbids browsers from sending cookies with these requests, breaking these functionalities. To counter that, Chrome introduced an exception to the Lax policy---called `Lax+POST`---where, for all cookies without the `SameSite` attribute, Chrome applies the None policy only for the first two minutes after the page load. Then, Chrome switches to the Lax policy. Table I lists the contexts covered by `Lax+POST`.

Warning
{: .label .label-yellow }

**Note:** `Lax+POST` exception is purely a temporary solution and will be [removed](https://www.chromium.org/updates/same-site/faq/#q-what-is-the-lax-post-mitigation) in the future.  If you rely on this behavior, you should update these cookies with the `SameSite=None; Secure` to ensure they continue to function in the future.


## Cross-Browser Support

Rather than relying on browsers to apply `SameSite=Lax` automatically, you should explicitly communicate the intended `SameSite` policy for the cookies. This will improve the experience across browsers as not all of them default to Lax yet.

Example:

```
Set-Cookie: 3pc-cookie=value; SameSite=Lax
```

## SameSite=None without Secure

Cookies that are intended for third-party or cross-site contexts must specify `SameSite=None` only together with [`Secure`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies), i.e., third-party cookies are restricted to secure contexts/ HTTPS connections only.

Cookies that fail to do so, i.e., `SameSite=None` cookies missing the `Secure` flag will be [rejected](https://www.chromestatus.com/feature/5633521622188032) by Chrome, so as to mitigate the risk of [pervasive monitoring](https://www.heise.de/netze/rfc/rfcs/rfc7258.shtml)<sup>[\[4\]](#references)</sup>.


## Handling of SameSite=Invalid Policies

An invalid policy is a string that does not match any of the three known policies, such as `SameSite=1`, which are most likely developers’ mistakes.

Invalid policies should be treated as the `None` policy by web browsers according to [RFC 6265bis (§4.1.2.7)](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis-05#section-4.1.2.7). However, as of now, browsers enforcing the new Lax-by-default policy, such as Chrome, would enforce the `Lax` policy for cookies with invalid `SameSite` values. 


## Specifications

| **Specification**                 	| **Title**                                                     	| **Reference**                                                                  	|
|-----------------------------------	|---------------------------------------------------------------	|--------------------------------------------------------------------------------	|
| RFC 6265, section 4.1: Set-Cookie 	| HTTP State Management Mechanism                               	| [Link](https://datatracker.ietf.org/doc/html/rfc6265#section-4.1)              	|
| draft-ietf-httpbis-rfc6265bis-09  	| Cookie Prefixes, Same-Site Cookies, and Strict Secure Cookies 	| [Link](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis-09) 	|


## References

1. Site compatibility-impacting changes coming to Microsoft Edge. [Link](https://docs.microsoft.com/en-us/microsoft-edge/web-platform/site-impacting-changes)

2. Can I use SameSite cookie attribute? [Link](https://caniuse.com/?search=samesite)

3. Gecko Intent to implement: Cookie SameSite=lax by default and SameSite=None only if secure. [Link](https://groups.google.com/forum/#!msg/mozilla.dev.platform/nx2uP0CzA9k/BNVPWDHsAQAJ)

4. H. Tschofenig, S. Farrell, RFC 7258: Pervasive Monitoring Is an Attack. [Link](https://datatracker.ietf.org/doc/html/rfc7258)

