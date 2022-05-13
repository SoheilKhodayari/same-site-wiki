---
title: Policy Bypass
parent: Attacks
nav_order: 5
---

{% include toggle_color.html %}

# SameSite Wiki

Stable
{: .label .label-green }

## SameSite Policy Bypass

This article lists threats and techniques that attackers can leverage to bypass SameSite cookies. Note that SameSite policies can also be circumvented via [Policy Downgrades](/same-site-wiki/docs/attacks/policy-downgrade.html) due to inconsistent configuration. 


### Single Sign-On HTTP Redirects Bypass

The [Lax+POST exceptional policy](/same-site-wiki/docs/policies/overview.html#default-policy-and-laxpost-exception) provides a time window of two minutes where `Lax` protection is not enforced, which is counted starting from the time of setting of a cookie. A possible attack consists of installing new cookies using cross-site requests and using the two-minute window to exploit XS vulnerabilities. Fresh cookies could be installed, for example, by abusing Single Sign-On Identity Providers (IdPs) that allow for user auto re-login via HTTP `GET` requests and without requiring user interaction like CAPTCHAs<sup>[\[1\]](#references)</sup>. 

The attack against a target site is the following. First, the attacker convinces a user to visit an attack page. Via the [window.open()](https://developer.mozilla.org/en-US/docs/Web/API/Window/open) API, the page asks the IdP to re-login the user at the target site. As a result of the SSO login, the target site establishes a new authenticated session with the user's browser. Since the cookie is not older than two minutes,
`Lax` protection of the target site is not enforced, enabling the attacker to mount XS attacks. 



## References

1. Renwa, Bypass SameSite Cookies Default to Lax and get CSRF. [Link](https://medium.com/@renwa/bypass-samesite-cookies-default-to-lax-and-get-csrf-343ba09b9f2b)