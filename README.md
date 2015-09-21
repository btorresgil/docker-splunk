# Information

Run multiple Splunk instances for multi-node configuration,
including Searchheads and Indexers.

(Based on xeor/splunk with some modifications)

# Volumes
* `/opt/splunk/var/lib/splunk`: Splunk index storage
* `/license.lic`: Splunk Enterprise license

# Environment variables available
* `SPLUNK_SERVERNAME`: If set, it will become the name of the Splunk instance, and the name of the host for the default input.
* `SPLUNK_ENTERPRISE`: Set to `true` if you want the enterprise 30days trial (default is the free 500MiB/day license). Should become normal enterprise if /license.lic is mounted (see volumes)
* `SPLUNK_PW`: Set to the password you want to use if you are using the enterprise trial. Default to `changeme`
* `SPLUNK_WEB_PATH`: Set the relative path for Splunks web-endpoint. (Example `splunk`) for having Splunk under http://domain/splunk. Useful behind reverse proxies..
* `SPLUNK_SESSION_TIMEOUT`: Timeout for the web-service. Use number and one of smhd, example `7d` for 7 days
* `SPLUNK_SSO`: Must be set to `true` to enable the SSO options
* `SPLUNK_SSO_ALLOW_FROM`: Either set an ip here for the proxy the request is coming from. Or if its a Docker container, you can link it as `proxy` like `--link nginx_reverse:proxy`, and we will detect it.
* `SPLUNK_SSO_REMOTEUSER`: If you want Splunk to be able to do autologin via http-header from eg an intermidiate proxy. Set to eg `USER`. To debug (`http://splunk/debug/sso`). Should enable an extra admin-user as well with the username of the `USER` env. This setting also enables the SSO option in Splunk.
* `SPLUNK_SSO_ADMIN`: username for an extra admin-user that we will add (with password "password"), only use this to get SSO with `SPLUNK_WEB_REMOTEUSER` to work. Its ment for SSO.
* `SPLUNK_ENABLE_VERSION_CHECK`: Enable version update checker that displays at login screen. We disable this as default because it gives us nothing when running as a Docker image..
* `SPLUNK_DEPLOYMENT_SERVER`: The deployment server to set on all non-deployment-server splunk nodes.
* `SPLUNK_SEARCH_PEERS`: A space-separated list of the IP addresses or hostnames of the search peers (indexers).  Clustered indexers are not supported.
