{% for name, user in pillar.get('zsh', {}).items() %}
{%- if user == None -%}
{%- set user = {} -%}
{%- endif -%}
{%- set home = user.get('home', "/home/%s" % name) -%}
{%- set installs = user.get('installs', ['0.10']) %}

nvm_{{ name }}:
  git.latest:
    - name: git://github.com/creationix/nvm
    - target: {{ home }}/.nvm
  file.directory:
    - name: {{ home }}/.nvm
    - dir_mode: 755
    - file_mode: 644
    - user: {{ name }}
    - group: {{ name }}
    - recurse:
      - mode
      - user
      - group
    - require:
      - git: nvm_{{ name }}
  cmd.run:
    - name: |
        source {{ home }}/.nvm/nvm.sh;
        {%- for version in installs %}
        nvm install {{ version }};
        {%- endfor %}
    - shell: "/bin/bash"
    - require:
      - file: nvm_{{ name }}
      - pkg: nvm_deps

nvm_deps:
  pkg.installed:
    - names:
      - build-essential
      - libssl-dev
      - curl

{% endfor %}