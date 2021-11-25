dep-pkg-redis-install:
  pkg.installed:
    - pkgs:
      - systemd-devel
      - tcl-devel
      - gcc
      - gcc-c++
      - make

unzip-redis:
  archive.extracted:
    - source: salt://modules/database/redis/files/redis-6.2.6.tar.gz
    - name: /usr/src
    - if_missing: /usr/src/redis-6.2.6

redis-install:
  cmd.script:
    - name: salt://modules/database/redis/files/install.sh.j2
    - template: jinja
    - require:
      - archive: unzip-redis

{{ pillar['redis_install_dir'] }}/conf:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true
    - require:
      - cmd: redis-install

{{ pillar['redis_install_dir'] }}/conf/redis.conf:
  file.managed:
    - source: salt://modules/database/redis/files/redis.conf.j2
    - template: jinja
    - require: 
      - file: {{ pillar['redis_install_dir'] }}/conf

/usr/lib/systemd/system/redis_server.service:
  file.managed:
    - source: salt://modules/database/redis/files/redis_server.service.j2
    - template: jinja

redis_server.service:
  service.running:
    - enable: true
    - require:
      - file: /usr/lib/systemd/system/redis_server.service
