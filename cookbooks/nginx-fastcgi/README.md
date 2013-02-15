# Description
Create nginx site to run your fastcgi application under nginx front-end

# Requirements
Should work on any platform where nginx is installed. Tested on Ubuntu.

# Limitations
fastcgi standalone server mode is only supported

# DEFINITIONS
``nginx_fastcgi``

This definition can be used to create nginx site to run your fastcgi application under nginx front-end.
 
The definition takes the following parameters:
 
* name: specifies a single path (string) where nginx site config will be installed. No default, this must be specified.
* socket: specifies the port or socket on which the FastCGI-server is listening. No default, this must be specified. 
  Check out http://wiki.nginx.org/HttpFastcgiModule#fastcgi_pass for details.
* static: specifies location of static files (not handled by application, but nginx), is the Array of Hashes or hash with following keys:
   * location
   * root
* servers: specifies all virtual hosts to be included into site config, is an Array of Hashes with following keys:
   * ip
   * server_name
   * ssl
   * ssl_include_path
   * error_page
   * redirect
* cookbook: specifies the cookbook name where template source comes from. By default it will use the cookbook where the definition is used.
* fastcgi_param: specifies additional fastcgi_params to be included into location block
* error_page - specifies custom error pages. Is an Array of Hashes with following keys (check out http://wiki.nginx.org/HttpCoreModule#error_page for details):
 * code
 * handler
* fastcgi_intercept_errors - specify value for fastcgi_intercept_errors, 
check out http://wiki.nginx.org/HttpFastcgiModule#fastcgi_intercept_errors for datails. Default value is false

# Usage cases

## named virtual host, port 80

    nginx_fastcgi '/etc/nginx/sites-available/foo.site.conf' do
        socket '/tmp/application.socket'
        servers [
            {
                :ip => '127.0.0.1',
                :server_name => 'foo.site.x'
            }
        ]
    end

## ssl enabled named virtual host
    
    nginx_fastcgi '/etc/nginx/sites-available/foo.site.conf' do
        socket '/tmp/application.socket'
        servers [
            {
                :server_name => 'bar.site.x',
                :ssl => true,
                :ssl_include_path => 'nginx_ssl_settings.conf'
                
            }
        ]
    end

## setting document root

    nginx_fastcgi '/etc/nginx/sites-available/foo.site.conf' do
        root  '/var/www/MyApp/root'
        socket '/tmp/application.socket'
        servers [
            {
                :server_name => 'foo.site.x',
            }
        ]
    end

## doing http -> https redirect

 # all http traffic get redirected to https host:
    
    nginx_fastcgi '/etc/nginx/sites-available/foo.site.conf' do
        socket '/tmp/application.socket'
        servers [
            {
                :ip => '127.0.0.1',
                :server_name => 'bar.site.x',
                :redirect => 'https'                
            },
            {
                :ip => '127.0.0.1',
                :server_name => 'bar.site.x',
                :ssl => true,
                :ssl_include_path => 'nginx_ssl_settings.conf'
            }
        ]
    end

## handling static files by nginx

    nginx_fastcgi '/etc/nginx/sites-available/foo.site.conf' do
        socket '/tmp/application.socket'
        static(
                :location => 'static/',
                :root => '/var/www/MyApp/root'
        )
        servers [
            {
                :server_name => 'foo.site.x',
            }
        ]
    end

## setup specific fastcgi_params:

    nginx_fastcgi '/etc/nginx/sites-available/foo.site.conf' do
        socket '/tmp/application.socket'
        fastcgi_param  [
            { :name => 'SCRIPT_NAME', :value => "\"\"" },
            { :name => 'PATH_INFO' , :value => '$uri' }
        ]
        servers [
            {
                :server_name => 'foo.site.x',
            }
        ]
    end

## setup error_page, code 500

    nginx_fastcgi '/etc/nginx/sites-available/foo.site.conf' do
        socket '/tmp/application.socket'
        servers [
            {
                :server_name => 'foo.site.x'
            }
        ]
        error_page [
            {
                :code       => 500,
                :handler    => '/500.html'
            }
        ]
    end

# Features
For complete examples of usage see https://github.com/melezhik/cookbooks/tree/master/nginx-fastcgi/features

