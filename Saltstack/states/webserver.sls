install httpd:
  pkg.installed:
    - pkgs:
      - httpd

# Deploy the httpd.conf file
deploy the http.conf file:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://files/httpd.conf

# Deploy the index.html file
deploy the index.html file:
  file.managed:
    - name: /var/www/html/index.html
    - source: salt://files/index.html

# Reload the httpd service
httpd:
  service.running:
    - reload: true
