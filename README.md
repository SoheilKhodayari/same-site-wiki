<p align="center">
	<a href="//soheilkhodayari.github.io/same-site-wiki/">
		<img align="center" alt="SameSiteWiki" src="assets/logo.png" height="105">
	</a>
</p>

<p align="center">
	<span><b> SameSite Cookies Wiki </b></span>
</p>

<p align="center">
	<a href="//soheilkhodayari.github.io/same-site-wiki/docs/main.html">Website</a> |
	<a href="//github.com/SoheilKhodayari/same-site-wiki/blob/master/docs">Wiki</a> |
	<a href="//github.com/SoheilKhodayari/same-site-wiki/blob/master/README.md#quick-start">Quick Start</a> |
	<a href="//soheilkhodayari.github.io/papers/sp22_samesite_cookies.pdf">Paper</a>
</p>



# 🍪 SameSite Wiki

[![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/) [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=SameSite%20Cookies%20Wiki:%20All%20You%20Need%20to%20Know&url=https://soheilkhodayari.github.io/same-site-wiki/)

A simple wiki with all you need to know about SameSite cookies (but were afraid to ask?). Specific focus on principal concepts, security risks, and correct and secure `SameSite` configurations.

An online version of the Wiki is available at [https://soheilkhodayari.github.io/same-site-wiki/docs/main.html](https://soheilkhodayari.github.io/same-site-wiki/).

This project is licensed under `GNU AFFERO GENERAL PUBLIC LICENSE V3.0`. See [here](LICENSE) for more information.


## 🚀 Quick Start

This repository uses the Jekyll [just-the-docs](https://github.com/just-the-docs/just-the-docs) as a GitHub pages [remote theme](https://blog.github.com/2017-11-29-use-any-theme-with-github-pages/), with the configuration specified in `_config.yaml`:

```
remote_theme: just-the-docs/just-the-docs
color_scheme: "dark"
```


### 💻 Automatic Deployment

The repository uses [Github Actions](https://github.com/features/actions) to automatically build and publish a static version of the SameSite Wiki with [Jekyll](https://jekyllrb.com/) once a commit is merged with the `master` branch (i.e., a Pull Request is accepted).


### 🏭 Local Build

**Docker:** You can build and run this Wiki inside a Docker container with:

```
$ docker-compose up
```

**Host Machine:** alternatively, you can build it inside your host machine with:

```
$ gem install just-the-docs
$ bundle exec jekyll serve
```

For more information, please refer to the official [just-the-docs](https://github.com/just-the-docs/just-the-docs) and [Jekyll](https://jekyllrb.com/) documentations. 



## 🙋 Questions

For any questions, suggestions, feedback or concerns, please [raise an issue in the repository](https://github.com/SoheilKhodayari/same-site-wiki/issues). 
We would be delighted to know if there is any specific behaviour you would like to see documented, but is currently missing from the Wiki. For private issues, you can reach out to me via email.


## 🎃 Contribution and Code Of Conduct

Pull requests are always more than welcomed. Please see the contributor [code of conduct](CODE_OF_CONDUCT.md). 



## 📝 Academic Publication

The contents of this repository has been published as a part of a S&P'22 paper. If you use the SameSite Wiki for academic research, we encourage you to cite the following [paper](https://soheilkhodayari.github.io/papers/sp22_samesite_cookies.pdf):

```
@inproceedings {SKhodayariSP22SameSite,
  author = {Soheil Khodayari and Giancarlo Pellegrino},
  title = {The State of the SameSite: Studying the Usage, Effectiveness and Adequacy of SameSite Cookies},
  booktitle = {Proceedings of the 43rd IEEE Symposium on Security and Privacy},
  year = {2022},
}
```
