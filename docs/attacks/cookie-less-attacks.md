---
title: Cookie-less Attacks
parent: Attacks
nav_order: 7
---

{% include toggle_color.html %}

# SameSite Wiki

Stable
{: .label .label-green }

## Cookies-less XS Attacks


While cookies are one of the most prevalent forms of request authentication, they are not the only one<sup>[\[1\]](#references)</sup>.
SameSite cookies can protect those class of request forgery attacks that perform ambient HTTP request authentication with cookies. Accordingly, other forms of request authentication, such as HTTP authentication, client certificate authentication<sup>[\[2\]](#references)</sup>, or network-based authentication are not protected by SameSite cookies. 



## References


1. X. Likaj, S. Khodayari, and G. Pellegrino, “Where We Stand (or Fall):
An Analysis of CSRF Defenses in Web Frameworks,” in RAID, 2021. [Link](https://soheilkhodayari.github.io/papers/raid21-csrf-defenses.pdf)

2. A. Parsovs, “Practical Issues with TLS Client Certificate Authentication.” in Network and Distributed Systems Security Symposium, 2014. [Link](https://eprint.iacr.org/2013/538.pdf)