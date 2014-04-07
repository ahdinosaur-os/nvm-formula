{% set installs = salt['pillar.get']('nvm:install', ['0.10']) %}

nvm:
  git.latest:
    - name: git://github.com/creationix/nvm
    - target: /usr/local/nvm
  file.directory:
    - name: /usr/local/nvm
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - mode
    - require:
      - git: nvm
  cmd.run:
    - name: |
        source /usr/local/nvm/nvm.sh;
        {%- for version in installs %}
        nvm install {{ version }};
        {%- endfor %}
    - shell: "/bin/bash"
    - require:
      - file: nvm
      - pkg: nvm_deps

nvm_deps:
  pkg.installed:
    - names:
      - build-essential
      - libssl-dev
      - curl