---
layout: default
---

<div class="mb-5">
<h1 class="text-center title">My blog</h1>
<hr class="title">
{% unless page.tag == 'all' %}
<h4 class="text-center tag-blogs">
  <span class="badge badge-primary post-tag">{{ page.tag }}</span>
</h4>
{% endunless %}
</div>

{% for post in site.posts %}
  {% if page.tag == 'all' or post.tags contains page.tag %}
  <div class="card border-secondary post-card">
    <div class="card-header bg-secondary border-secondary">
      <h3 class="card-title text-white">
        <a href="{{ post.url | relative_url }}" class="text-white">{{ post.title | escape }}</a>
      </h3>
      <h6 class="card-subtitle mb-2">
        <span class="blog-date">{{ post.date | date_to_long_string }}</span>
        {% for tag in post.tags %}

        <a href="/blog/tag/{{ tag | replace: ' ', '_' }}" class="badge badge-primary post-tag">{{ tag }}</a>

        {% endfor %}
        {% if post.reads %}
        <span class="badge post-tag badge-info">{{post.reads}} reads</span>
        {% endif %}
      </h6>
    </div>
    <div class="card-body">
      {{ post.description | markdownify }}
      <h6 class ="text-center">
        <a href="{{ post.url | relative_url }}">~ Continue reading ~</a>
      </h6>
    </div>
  </div>
{% endif %}
{% endfor %}

{% include license.html %}
