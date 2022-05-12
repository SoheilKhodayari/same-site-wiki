---
title: Overview
nav_order: 1
---

# SameSite Wiki

Stable
{: .label .label-green }

This wiki is meant to introduce readers to the SameSite cookie policy and also serve as a reference guide for experienced researchers and developers using SameSite cookies. While the wiki covers different aspects of SameSite policies, new security risks and threats are always emerging. Improvements and suggestions, whether to add new content or expand existing documentation, are always more than appreciated. 
{: .fs-6 .fw-300 }


[Contribute Now](https://soheilkhodayari.github.io/same-site-wiki/docs/contributions){: .btn .btn-purple .fs-5 .mb-4 .mb-md-0 .mr-2 } [View it on GitHub](https://github.com/SoheilKhodayari/same-site-wiki){: .btn .fs-5 .mb-4 .mb-md-0 }


## Overview

SameSite policies defines the request contexts in which browsers include cookies in HTTP requests, such as same-site and cross-site requests. Leveraging SameSite policies, developers can limit the scope of session cookies to a first-party context to protect their web applications from two important families of cross-site (XS) web attacks, that is, [Cross-Site Leaks](https://xsleaks.dev/) (XS-Leaks) and [Cross-Site Request Forgery](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html) (CSRF), by stripping authentication cookies from cross-site requests the user nor the web application intended to initiate.

Over the past many years, researchers and practitioners have come up with different solutions to enforce SameSite policies, 
such as proxies<sup>[\[1, 2, 3\]](#references)</sup>, browser extentions<sup>[\[4, 5, 6\]](#references)</sup>, or a combination of them<sup>[\[7\]](#references)</sup>. Unfortunately, these solutions require installing additional components, limiting their impact considerably.

In 2016, Google revamped the idea of SameSite policies by proposing and implementing in Chrome a new cookie attribute<sup>[\[8\]](#references)</sup>,
the `SameSite` attribute of the [Set-Cookie](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie/SameSite) HTTP response header, which was proposed as a part of the [RFC 6265bis](https://tools.ietf.org/html/draft-ietf-httpbis-rfc6265bis-05) specification<sup>[\[9\]](#references)</sup>. Today, the `SameSite` cookie attribute is supported by most major browser vendors (see, i.e., [here](https://caniuse.com/?search=samesite)), acting as an important defense-in-depth against XS attacks. 


## XS Attacks

XS attacks are a family of web attacks where attackers lure users into visiting a malicious web page that tricks the user's web browser to send authenticated cross-site HTTP requests to a vulnerable target website. One of the first instances of cross-site attacks is [Cross-Site Request Forgery](https://portswigger.net/web-security/csrf) (CSRF), where attackers leverage cross-site requests to perform security-sensitive, server-side state-changing operations, such as [user credential reset](https://www.acunetix.com/blog/web-security-zone/critical-csrf-vulnerability-facebook/) or [money transfers](https://www.cs.utexas.edu/~shmat/courses/cs378/zeller.pdf), without user's consent or awareness. 


Malicious cross-site requests can also target the users making these requests by leaking sensitive information about user's [login status](https://github.com/RobinLinus/socialmedia-leak)<sup>[\[12, 13\]](#references)</sup>, account type<sup>[\[10\]](#references)</sup>, age range<sup>[\[14\]](#references)</sup>, or user's identity<sup>[\[10, 11\]](#references)</sup>. These attacks are often called cross-site information leakage (XS-Leaks) or Cross-Origin State Inference (COSI) attacks<sup>[\[10\]](#references)</sup>.


CSRF and COSI attacks have a similar two-phases attack pattern: *preparation* and *attack*.
In the preparation step, the attacker prepares a malicious webpage referring to resources from the target site. These can be, for example, a hidden, self-submitting HTML form to reset the user password at the target site or a JavaScript file hosted by the target site. During the attack phase, the user is lured into visiting the attack page. As a result of the included resource, the user's browser sends a cross-site request to the target website, and the browser automatically attaches the user's authenticated session cookies to this request. The target website receives and processes the request. In the case of CSRF, the server will perform the requested operation, e.g., by resetting the user password with an attacker-controlled one. In case of a COSI attack, the [attack page](https://github.com/SoheilKhodayari/Basta-COSI) uses [browser side-channels](https://xsleaks.dev/) to leak sensitive information about the user. For example, consider a cross-origin HTTP request that returns a 200 response code when the user is logged in and a 404 otherwise.



## A Little Bit of History

The main benefit of the `SameSite` attribute is a more stricter default cookie policy, which can disrupt existing websites. To help developers transition to the [new default policy](https://chromestatus.com/feature/5088147346030592), Google introduced three [gradual changes to Chrome](https://www.chromium.org/updates/same-site/), introduced in 2016, 2019, and 2020.

In April 2016, Chrome 51 introduced support for the new `SameSite` cookie attribute<sup>[\[8\]](#references)</sup> without modifying the default policy. Later, in September 2019, Chrome 77 started showing console warning messages for cookies missing the `SameSite` flag. The final step of this transition took place in 2020, with Chrome 80. First, in February 2020, Chrome set [Lax+POST](https://www.chromium.org/updates/same-site/faq/#q-what-is-the-lax-post-mitigation) the new default policy. However, shortly after, Google rolled it back (April 2020) to ease developers' transition to the new policy in light of the COVID-19 pandemic. The Lax-by-default was then restored in July 2020 with [Chrome 84](https://www.chromium.org/updates/same-site/faq/).


## References

1. Alexei Czeskis, Alexander Moshchuk, Tadayoshi Kohno, and Helen J. Wang, Lightweight server support for browser-based CSRF protection. In Proceedings of the International Conference on World Wide Web, 2013. [Link](https://homes.cs.washington.edu/~yoshi/papers/czeskis-arls.pdf).

2. Florian Kerschbaum, Simple cross-site attack prevention. In 3rd
International Conference on Security and Privacy in Communication Networks and the Workshops (SecureComm 2007). IEEE, 464–472. [Link](https://www.researchgate.net/publication/4344810_Simple_cross-site_attack_prevention)

3. Martin Johns and Justus Winter, RequestRodeo: Client side protection against session riding, 2006. [Link](https://www.owasp.org/images/4/42/RequestRodeo-MartinJohns.pdf)

4. Ziqing Mao, Ninghui Li, and Ian Molloy, Defeating Cross-Site Request Forgery Attacks with Browser-Enforced Authenticity Protection (BEAP). In 13th International Conference on Financial Cryptography and Data Security, 2009. [Link](https://dl.acm.org/doi/abs/10.1007/978-3-642-03549-4_15)

5. Philippe De Ryck, Lieven Desmet, Thomas Heyman, Frank Piessens, and Wouter Joosen, CsFire: Transparent Client-Side Mitigation of Malicious CrossDomain Requests. In ESSoS, 2010. [Link](https://link.springer.com/chapter/10.1007/978-3-642-11747-3_2)

6. Philippe De Ryck, Lieven Desmet, Wouter Joosen, and Frank Piessens, Automatic and Precise Client-Side Protection against CSRF Attacks. In ESORICS, 2011. [Link](https://link.springer.com/chapter/10.1007/978-3-642-23822-2_6)

7. Sebastian Lekies, Walter Tighzert, and Martin Johns, Towards stateless, client-side driven Cross-site request forgery protection for Web applications. SAP Research, 2012. [Link](https://subs.emis.de/LNI/Proceedings/Proceedings195/111.pdf)

8. Mike West, Same-site Cookies, 2016. [Link](https://tools.ietf.org/html/draft-west-first-party-cookies-07)

9. Cookies: HTTP State Management Mechanism, 2020. [Link](https://tools.ietf.org/html/draft-ietf-httpbis-rfc6265bis-05)

10. A. Sudhodanan, S. Khodayari, and J. Caballero, Cross-Origin State Inference (COSI) Attacks: Leaking Web Site States through XSLeaks, in NDSS 2020. [Link](https://publications.cispa.saarland/3329/1/COSI.pdf)

11.  C. A. Staicu and M. Pradel, Leaky Images: Targeted Privacy Attacks in the Web, in USENIX Security Symposium, 2019. [Link](https://www.usenix.org/system/files/sec19-staicu.pdf)

12. Mike Cardwell, Abusing HTTP Status Codes to Expose Private Information, 2011. [Link](https://www.grepular.com/Abusing_HTTP_Status_Codes_to_Expose_Private_Information)

13. Yoneuchi, Takashi, Detect the Same-Origin Redirection with a bug in Firefox's CSP Implementation, 2018. [Link](https://diary.shift-js.info/csp-fingerprinting/)

14. T. Van Goethem, W. Joosen, and N. Nikiforakis, The Clock is Still Ticking: Timing Attacks in the Modern Web. In CCS, 2015. [Link](https://dl.acm.org/doi/10.1145/2810103.2813632)
