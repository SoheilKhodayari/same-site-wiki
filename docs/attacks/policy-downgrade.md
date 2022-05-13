---
title: Policy Downgrade
parent: Attacks
nav_order: 6
---

{% include toggle_color.html %}

# SameSite Wiki

Stable
{: .label .label-green }

## SameSite Policy Downgrade

This article lists security risks that attackers can leverage to downgrade SameSite policies (e.g., `Strict` to `Lax` or `None`), ultimately bypassing SameSite protection. Note that SameSite policies can also be bypassed via [Policy Bypass](same-site-wiki/docs/attacks/policy-bass.html) techniques.


### SameSite Cookie Intra-page Inconsistency


When developing web applications, providing support for older web browsers that are incompatible with the SameSite cookie policy is challenging. In such incompatible clients, a cookie marked with a `SameSite` attribute or an unsupported SameSite policy may be rejected and not set, thus breaking the application functionality. As a workaround, developers may set redundant cookies, both with and without the `SameSite` attribute<sup>[\[1, 2 \]](#references)</sup>, or with different `SameSite` policies. However, this can introduce vulnerabilities if not properly applied. 


**Example**. The configuration below shows a vulnerable cookie setting that can be exploited to mount a CSRF attack. In this example, the application sets two duplicate cookies, namely `3pc` and `3pc-legacy`, with `Strict` and no SameSite policy, respectively, and resorts to the `3pc-legacy` if the `3pc` cookie is not included in the request. 

```
// for incompatible clients
Set-cookie: 3pc-legacy=value;

// for newer clients
Set-cookie: 3pc=value; SameSite=Strict;
```

For a victim vising a CSRF attack page using a modern client, the `3pc` cookie is not attached to the cross-origin CSRF request, but the `3pc-legacy` cookie is still automatically attached to the request, both when assuming a client enforcing a default `None` or default `Lax` policy (i.e., using top-level navigation requests), enabling CSRF on server-side.



### SameSite Cookie Inter-Page Inconsistency


This vulnerability occurs when a web application sets two different SameSite cookie policies for the same cookie with the same `Path` attribute across two different web pages. 

**Example**. The configuration below demonstrate a vulnerable cookie setting that can downgrade the SameSite policy, enabling XS attacks. 

```
// GET /account.php \r\n
Set-cookie: 3pc=value; SameSite=Strict; Path=/

// GET /index.php \r\n
Set-cookie: 3pc=value; SameSite=None; Path=/
```

In this example, the application sets `3pc=value; SameSite=Strict; Path=/` when visiting URL<sub>1</sub> and `3pc=value; SameSite=None; Path=/`
when visiting URL<sub>2</sub>, which enables attackers to downgrade the `Strict` policy for this cookie to `None`.
In this example, the bypass happens by issuing a top-level navigation request to URL<sub>2</sub>, which overwrites the cookie with
the `SameSite=None` attribute, relaxing the SameSite policy.



### SameSite Cookie User-Agent Inconsistency 

Header inconsistencies has been the root cause of vulnerabilities in the past<sup>[\[3\]](#references)</sup>. The `SameSite Cookie User-Agent Inconsistency` security risk arises when an application set inconsistent SameSite policies when the HTTP request is submitted via two different user agents. 

For example, a web application may enforce the `Strict` or `Lax` policy for a sensitive cookie when the user is using a desktop browser, but enforce the `None` policy if the user uses a mobile browser (or vice versa). One reason for such inconsistency is that the mobile and the desktop version are two different applications exposing themselves to the public based on the request user-agent. 
In such circumstances, CSRF and COSI attacks are possible provided that the victim uses a user agent with the less stricter SameSite policy to visit the target website.




## Refrences

1. Rowan Merewood, SameSite cookie recipes. [Link](https://web.dev/samesite-cookie-recipes/)

2. SameSite Cookie Attribute explained. [Link](https://cookie-script.com/documentation/samesite-cookie-attribute-explained)

3. A. Mendoza, P. Chinprutthiwong, and G. Gu, Uncovering HTTP Header Inconsistencies and the Impact on Desktop/Mobile Websites. In WWW, 2018. [Link](https://dl.acm.org/doi/fullHtml/10.1145/3178876.3186091)
