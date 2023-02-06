# Prestashop on OpenShift

## Getting started

### Create new project

oc new-project prestashop-openshift

### Install database

Create an ephemeral MySQL database

```
oc new-app mysql MYSQL_USER=prestashop MYSQL_PASSWORD=prestashop MYSQL_DATABASE=prestashop \
    -l app.kubernetes.io/name=mysql \
    -l app.kubernetes.io/version=8.0 \
    -l app.kubernetes.io/component=database \
    -l app.kubernetes.io/part-of=prestashop \
    -l app.openshift.io/runtime=rhel \
    -l app.openshift.io/runtime-version=8
```

### Install Prestashop

```
oc new-app --name prestashop https://github.com/mikkolaakko/prestashop-openshift \
    -l app.kubernetes.io/name=prestashop \
    -l app.kubernetes.io/component=server \
    -l app.kubernetes.io/version=1.7.8.6 \
    -l app.kubernetes.io/part-of=prestashop \
    -l app.openshift.io/runtime=php \
    -l app.openshift.io/runtime-version=7.4.33

oc label deployment/mysql app.kubernetes.io/part-of=prestashop
oc label deployment/prestashop app.kubernetes.io/part-of=prestashop
oc annotate deployment prestashop app.openshift.io/connects-to=mysql
```

### Create a route
```
oc expose service/prestashop --hostname=prestashop.apps.sandbox-m2.ll9k.p1.openshiftapps.com
```

### Open shop fronpage

open http://prestashop.apps.sandbox-m2.ll9k.p1.openshiftapps.com

## Uninstall

Delete all resources matching the specified label constraints
```
oc delete all -l app=prestashop
oc delete all -l app=mysql
```

## TODO

* Delete the /install folder
* Rename the /admin folder (e.g. admin4883u0iim/)
* Update php.ini
* Add environment variables
* Add extensions
* Payment modules


<!--

https://devdocs.prestashop-project.org/8/modules/payment/
http://prestashop.apps.sandbox-m2.ll9k.p1.openshiftapps.com/admin4883u0iim


-->