# Part 2 (k3s + host-based routing)

Goal: deploy 3 web apps in k3s and route by HOST header on IP `192.168.56.110`.

- `app1.com` → app1
- `app2.com` → app2 (3 replicas)
- default (any other host) → app3

## 1) Apply manifests
From the `p2` folder:

./scripts/deploy.sh

This creates:
- namespace `iot-p2`
- 3 deployments + services
- ingress with host rules and default backend

## 2) Test
From your host or another machine, run:

curl -H "Host: app1.com" http://192.168.56.110
curl -H "Host: app2.com" http://192.168.56.110
curl -H "Host: anything-else.com" http://192.168.56.110

If you want browser access, add to your local `/etc/hosts`:

192.168.56.110  app1.com app2.com

Then open:
- http://app1.com
- http://app2.com
- http://192.168.56.110 (will show app3)

## Notes
- This uses Traefik, which is installed by default in k3s.
