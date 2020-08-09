<!-- Based on https://startbootstrap.com/template-overviews/freelancer -->
<footer class="footer text-center">
  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <ul class="list-inline mb-0">
          <li class="list-inline-item">
            {% assign splitted_email = site.data.contact.email | split: '@' %}
            <a class="btn btn-outline-light btn-social text-center rounded-circle" title="Email" href="mailto:ActivateJavaScriptTooSeeEmail@{{ splitted_email[1] }}" onclick="this.href=this.href.replace(/ActivateJavaScriptTooSeeEmail/,'{{ splitted_email[0] }}')">
              <i class="fas fa-envelope fa-lg"></i>
            </a>
          </li>
          <li class="list-inline-item">
            <a class="btn btn-outline-light btn-social btn-social-github text-center rounded-circle" title="Github" href="{{ site.data.contact.github_url }}" target="_blank">
              <i class="fab fa-github fa-lg"></i>
            </span>
            </a>
          </li>
          <li class="list-inline-item">
            <a class="btn btn-outline-light btn-social btn-social-stack-overflow text-center rounded-circle" title="Stack Overflow" href="{{ site.data.contact.stackoverflow_url }}" target="_blank">
              <i class="fab fa-stack-overflow fa-lg"></i>
            </a>
          </li>
          <li class="list-inline-item">
            <a class="btn btn-outline-light btn-social text-center rounded-circle" title="LinkedIn" href="{{ site.data.contact.linkedin_url }}" target="_blank">
              <i class="fab fa-linkedin fa-lg"></i>
            </a>
          </li>
          <li class="list-inline-item">
            <a class="btn btn-outline-light btn-social text-center rounded-circle" title="Twitter" href="{{ site.data.contact.twitter_url }}" target="_blank">
              <i class="fab fa-twitter fa-lg"></i>
            </a>
          </li>
        </ul>
      </div>
    </div>
  </div>
</footer>
