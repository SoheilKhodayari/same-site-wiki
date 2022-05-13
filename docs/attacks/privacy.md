---
title: Privacy
parent: Attacks
nav_order: 4
---

{% include toggle_color.html %}

# SameSite Wiki

Stable
{: .label .label-green }

## Privacy Leaks

This article describes the privacy threats associated with the incorrect use of SameSite cookies. For other threats enabled by [Cross-Site Leaks (XS-Leaks)](https://xsleaks.dev/), please refer to our [XS-Leaks](/same-site-wiki/docs/attacks/xs-leaks) article. 


### Pervasive Monitoring 

Third-party cookies are widely used to track users online, and they often contain sensitive data.
If websites do not set the [`Secure`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#:~:text=A%20cookie%20with%20the%20Secure,cookies%20with%20the%20Secure%20attribute.) attribute for these cookies, a viable threat is [pervasive monitoring](https://datatracker.ietf.org/doc/html/rfc7258) at network level.
To mitigate this issue, Chromium-based browsers [reject](https://www.chromestatus.com/feature/5633521622188032) `SameSite=None` cookies without the `Secure` attribute<sup>[\[1, 2\]](#references)</sup>, but other browsers (e.g., Firefox and Safari) do not.


**Example.** Assume a website *W1* that set a privacy-sensitive cookie with `SameSite=None` and another website *W2* that performs cross-site requests to *W1*. Because of the policy set by *W1*, browsers will include cookies in all requests from *W2* to *W1*. This is the typical setting of third-party cookies widely used for tracking users. [Pervasive network monitoring](https://datatracker.ietf.org/doc/html/rfc7258) is a threat to these scenarios because if cookies are not securely transported (i.e., over TLS), they can reveal sensitive information about user identity. 

For these reasons, browsers like Chrome and Opera reject cookies that do not set the `Secure` flag together with `SameSite=None` policy<sup>[\[2\]](#references)</sup>. However, other browsers such as Firefox and Safari do not reject these cookies<sup>[\[3\]](#references)</sup>, exposing users of these websites to pervasive monitoring attacks.



## References:

1. MDN Web Docs: SameSite cookies. [Link](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite)


2. Chrome Feature: Reject insecure SameSite=None cookies. [Link](https://www.chromestatus.com/feature/5633521622188032)

3. S. Khodayari, and G. Pellegrino, The State of the SameSite: Studying the Usage, Effectiveness, and Adequacy of SameSite Cookies. In IEEE S&P, 2022. [Link](https://www.computer.org/csdl/proceedings-article/sp/2022/131600a312/1wKCekDtj8Y)