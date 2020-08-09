---
layout: default
permalink: /cv
title: My CV
redirect_from: /resume
redirect_from: /resume/
---

<h1 class="text-center title">{{ page.title | escape }}</h1>
<hr class="title mb-5">

{% include resume/experience.html type='Education' %}

{% include resume/experience.html type='Experience' %}

{% include resume/experience.html type='Honors_&_Awards' %}

{% include resume/contributions.html %}

{% include resume/talks.html %}

{% include resume/experience.html type='Certificates' %}

{% include resume/languages.html %}

<div class="mt-5 mb-1 ml-2">
    <a href="/resume-AnaMariaMartinez.pdf">
      <i class="fas fa-file-pdf"></i>
      Dowload resume in pdf
    </a>
</div>

<script>
function more(event, elem) {
    event.preventDefault();
    var type = $(elem).data("type");
    $('.no-featured-' + type).toggleClass('d-none');
    if($(elem).text() === 'more')
        $(elem).text('less');
    else
        $(elem).text('more');
}
</script>
