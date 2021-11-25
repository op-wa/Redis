include:
  - modules.database.redis.install

append-text-redis.conf:
  file.append:
    - name: {{ pillar['redis_install_dir'] }}/conf/redis.conf
    - text: 
      - slaveof {{ pillar['master_ip'] }} {{ pillar['redis_port'] }}
      - masterauth {{ pillar['redis_pass'] }}

stop-redis_server:
  service.dead:
    - name: redis_server.service
    - watch:
      - file: {{ pillar['redis_install_dir'] }}/conf/redis.conf

start-redis_server:
  service.running:
    - name: redis_server.service
    
