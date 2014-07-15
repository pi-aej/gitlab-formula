rvm-pkgs:
  pkg.installed:
    - pkgs:
      - bash
      - coreutils
      - gzip
      - bzip2
      - gawk
      - sed
      - curl
      - git-core
      - subversion

gitlab-ruby:
{% if salt['pillar.get']('gitlab:use_rvm', false) %}
  rvm.installed:
    - name: ruby-{{ salt['pillar.get']('gitlab:rvm_ruby', '2.1.2') }}
    - default: True
    - user: git
    - watch:
      - user: git-user
      - pkg: rvm-pkgs
  gem.installed:
    - user: git
    - ruby: ruby-{{ salt['pillar.get']('gitlab:rvm_ruby', '2.1.2') }}
    - watch:
      - rvm: gitlab
{% else %}
  {% if grains['os_family'] == 'Debian' %}
  pkg.installed:
    - pkgs:
      - ruby
      - ruby-dev
  gem.installed:
    - name: bundler
    - watch:
      - pkg: gitlab-ruby
  {% elif grains['os_family'] == 'RedHat' %}
  pkg.installed:
    - pkgs:
      - ruby193-ruby
      - ruby193-ruby-devel
      - ruby193-rubygem-bundler
  {% endif %}
{% endif %}
