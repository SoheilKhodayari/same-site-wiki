---
title: CSRF
parent: Attacks
nav_order: 2
---

{% include toggle_color.html %}

# SameSite Wiki

Stable
{: .label .label-green }

## Cross-Site Request Forgery (CSRF)


**Background.** [CSRF](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html) vulnerabilities are a confused deputy security flaw where an attacker
tricks a victim's browser to send an unintentional forged request to a target website, causing a security-relevant change in the web application's persistent storage, without the victim consent or awareness.

CSRF attacks occur because web browsers comply with the [Cookie Same-Origin Policy](https://crypto.stanford.edu/cs142/lectures/10-cookie-security.pdf), *automatically* including session cookies of users in cross-site HTTP requests, regardless of their context-- also known as the [Ambient Authority](https://datatracker.ietf.org/doc/html/draft-ietf-httpbis-rfc6265bis-05#section-8.2) problem.

SameSite cookies can solve *some variants* of CSRF attacks by limiting the set of request contexts where browsers automatically attach cookies. This article enumerates 
CSRF variants that are not protected by SameSite, or variants whose protection can be bypassed to the existence of specific vulnerabilities in the application.


### Replaying State-changing GET 


The new default Lax policy does not prevent the inclusion of cookies in top-level navigational HTTP requests. Therefore, if web applications mis-use [GET requests](https://www.rfc-editor.org/rfc/rfc2616#section-9.3) for security-sensitive state-changing operations, attackers can forge *authenticated*, cross-origin HTTP requests on behalf of victims, e.g., leveraging the [window.open()](https://developer.mozilla.org/en-US/docs/Web/API/Window/open) JavaScript API (see coverage of policies over request contexts in [Table I](/same-site-wiki/docs/policies/overview#overview-of-samesite-policies)).

According to recent empirical measurement studies<sup>[\[1, 2, 3\]](#references)</sup>, at least 10.3% of web applications use GET-based state-changes, rendering CSRF a viable threat against these applications. 


### Forging State-changing POST 

One of the fundamental limitations imposed with the new default Lax policy is that a cross-origin attack page cannot submit cross-origin POST requests to third-party context with the victim cookies attached. However, some applications are vulnerable in the sense that a state-changing POST request can be replayed or forged with a GET request interchangeably. In other words, the vulnerable application still processes the incoming request regardless of the HTTP verb used to submit the request. In this setting, the new default SameSite policy can be bypassed by replaying the request using a top-level navigation GET request.



### Client-side CSRF

Client-side Cross-Site Request Forgery (client-side CSRF) is a new breed of CSRF vulnerabilities affecting modern web applications<sup>[\[4, 5\]](#references)</sup>. In the client-side CSRF, the vulnerable component is the client-side JavaScript program, which allows an attacker to generate arbitrary requests to a CSRF-protected end-point with a valid CSRF token by modifying the program input parameters, e.g., by modifying the end-point to which the client-side code makes an HTTP request to. 


**Note.** Unfortunately, existing mechanisms cannot offer a complete protection against client-side CSRF attacks, e.g., when [synchronizer tokens](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html#synchronizer-token-pattern) or [custom HTTP headers](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html#use-of-custom-request-headers) are used, the JavaScript program will include them in the outgoing requests. Also, if the browser or the web site is using the SameSite policy for cookies, JavaScript web pages, once loaded, can perform preliminar same-site requests to determine whether a pre-established user session exists, circumventing the SameSite policy.


**Example.** The following code snippet demonstrate a simple example of a client-side CSRF vulnerability.

```javascript
(function sendRequest(){
	var requestEndpoint = window.location.hash.substr(1);
	var requestData = {"XSRF_TOKEN": "RANDOM_TOKEN_XYZ"};
	$.ajax({
	    url : requestEndpoint, // attacker-controlled
	    type: "POST",
	    data : requestData,
	    success: function(data, textStatus, jqXHR){ /* ...*/ }
	    error: function (jqXHR, textStatus, errorThrown){ /* ...*/ }
	});
})();
```

In the above example, the attacker can control the endpoint to which a legitimate async HTTP request is sent by changing the [URL hash fragment](https://developer.mozilla.org/en-US/docs/Web/API/Location/hash).



## References

1. S. Calzavara, M. Conti, R. Focardi, A. Rabitti, and G. Tolomei, Mitch: A Machine Learning Approach to the Black-Box Detection of CSRF Vulnerabilities, in IEEE EuroS&P, 2019. [Link](https://ieeexplore.ieee.org/document/8806728)

2.  S. Khodayari, and G. Pellegrino, The State of the SameSite: Studying the Usage, Effectiveness, and Adequacy of SameSite Cookies. In IEEE S&P, 2022. [Link](https://www.computer.org/csdl/proceedings-article/sp/2022/131600a312/1wKCekDtj8Y)

3. Compagna, L., Jonker, H. L., Krochewski, J., Krumnow, B., & Sahin, A preliminary study on the adoption and effectiveness of SameSite cookies as a CSRF defence. In IEEE EuroS&PW, 2021. [Link](https://doi.org/10.1109/eurospw54576.2021.00012)

4. Client-side CSRF, Facebook Whitehat Bug Bounty Program. [Link](https://www.facebook.com/notes/facebook-bug-bounty/client-side-csrf/2056804174333798/)

5. S. Khodayari, and G. Pellegrino, JAW: Studying Client-side CSRF with Hybrid Property Graphs and Declarative Traversals, 30th USENIX Security Symposium, 2021. [Link](https://soheilkhodayari.github.io/papers/usesec21-jaw.pdf)
