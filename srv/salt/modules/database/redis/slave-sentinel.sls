include:
  - modules.database.redis.slave

slave-sentinel-conf:
  file.managed:
    - name: {{ pillar['redis_install_dir'] }}/conf/sentinle.conf
    - source: salt://modules/database/redis/files/sentinel.conf.j2
    - template: jinja

sentinel-service:
  file.managed:
    - name: /usr/lib/systemd/system/redis_sentinel.service
    - source: salt://modules/database/redis/files/redis_sentinel.service.j2
    - template: jinja

slave-start-sentinel:
  service.running:
    - name: redis_sentinel.service
    - enable: true
    - reload: true
    - require: 
      - file: sentinel-service
    - watch: 
      - file: slave-sentinel-conf
    
